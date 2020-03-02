classdef HEC_HMS < handle
% -------------------------------------------------------------------------
% Matlab - R2018b 
% -------------------------------------------------------------------------
%                           Informaci�n Basica
%--------------------------------------------------------------------------
% Autor         : Jonathan Nogales Pimentel
% Email         : jonathannogales02@gmail.com
% Componente    : Modelaci�n Hidrologica
% Organizaci�n  : The Nature Conservancy - TNC
% Fecha         : 01- Sept - 2019
%
%--------------------------------------------------------------------------
% Este programa es de uso libre: Usted puede redistribuirlo y/o modificarlo 
% bajo los t�rminos de la licencia publica general GNU. El autor no se hace 
% responsable de los usos que pueda tener.Para mayor informaci�n revisar 
% http://www.gnu.org/licenses/.
%
% -------------------------------------------------------------------------
% Proyecto
%--------------------------------------------------------------------------
% Consultor�a t�cnica para el an�lisis de la cuenca alta y propuesta de 
% medidas de conservaci�n que contribuyan a la resiliencia de la cuenca del
% r�o Juan D�az en ciudad de Panam� para la mitigaci�n del riesgo por 
% inundaci�n
%
% -------------------------------------------------------------------------
% Descripci�n del Codigo
% -------------------------------------------------------------------------
%
% -------------------------------------------------------------------------
% Input Data
% -------------------------------------------------------------------------
% 
% -------------------------------------------------------------------------
% Output Data
% -------------------------------------------------------------------------
%
    properties
        ParSCE
        % dt in minutes Run Model
        dt_Run_Model
        % st in minutes Time Series 
        dt_TimeSeries
        % Name Sink 
        Name_Output = 'PTE_AV_DOMINGO_DIAZ'
    end
    
    % Time Series Parameters
    properties
        A char
        B char
        C char
        D char
        E char
        F char
    end
    
    % Configure Parameters
    properties        
        % Path Model
        PathModel char
        % Path HEC-HMS
        PathHEC_HMS
        % Path HEC DSS
        Path_HEC_DSS
        % Control Path
        PathControl char
        % Name Run
        NameRun
        % Model Name
        NameModel char
        % String dt Run model
        dt_Run_Model_Str
        % String dt Time Series
        dt_TimeSeries_Str        
        % Date Start
        Date_Init datetime
        % Date End
        Date_End datetime
        % Date Start
        Date_Init_Model datetime
        % Date End
        Date_End_Model datetime
        % UserData Parameters Calibration
        UserData
    end

    % Basin Phisic Properties 
    properties        
       % Code
       ID (:,1) double
       % Code
       Area (:,1) double
       % Name
       NameBasin (:,1) cell
       % Slope (%)
       Slope (:,1) double
       % Longest (m)
       Longest (:,1) double
       % Lag (Hours)
       Lag (:,1) double
       % S (mm)
       S (:,1) double
       % Ia (mm)
       Ia (:,1) double
    end

    % River Phisic Properties
    properties
       % Name
       NameRiver (:,1) cell       
    end

    % Parameters for Calibration in the Basin
    properties 
       % CN
       CN (:,1) double
       % Alpha_Ia
       Alpha_Ia (:,1) double
    end

    % Parameters for Calibration in the River
    properties 
       % X
       X (:,1) double
       % K
       K (:,1) double
       % Step
       Step (:,1) double
    end
    
    % Calibration Parameters configure
    properties
        % Group River
        GroupRiver (:,1) double
        % Group Basin
        GroupBasin (:,1) double
    end
    
    %% Configure Model
    methods
       function Model = HEC_HMS( PathModel, PathHEC_HMS, Path_HEC_DSS, PathControl,...
                                 NameModel, NameRun, Date_Init, Date_End, Date_Init_Model, Date_End_Model,...
                                 Code_dt_Run_Model, Code_dt_TimeSeries,...
                                 A, C, F)            
            
            %% Parameters
            Namedt = {  '1MIN','2MIN','3MIN','4MIN','5MIN','6MIN','10MIN',...
                        '12MIN','15MIN','20MIN','30MIN','1HOUR','2HOUR','3HOUR',...
                        '6HOUR','8HOUR','12HOUR' };
                
            Minutes_dt = [1:6 10 12 15 20 30 60 120 180 360 480 720];

            %% Asignation Parameters
            Model.PathModel     = PathModel;
            Model.PathHEC_HMS   = PathHEC_HMS;
            Model.Path_HEC_DSS  = Path_HEC_DSS;
            Model.PathControl   = PathControl;
            Model.NameModel     = NameModel; 
            Model.NameRun       = NameRun;                         
            Model.Date_Init     = Date_Init;
            Model.Date_End      = Date_End;
            Model.Date_Init_Model     = Date_Init_Model;
            Model.Date_End_Model      = Date_End_Model;
            Model.dt_Run_Model  = Minutes_dt(Code_dt_Run_Model);
            Model.dt_TimeSeries = Minutes_dt(Code_dt_TimeSeries);
            Model.dt_Run_Model_Str  = Namedt{Code_dt_Run_Model};
            Model.dt_TimeSeries_Str = Namedt{Code_dt_TimeSeries};                        
            
            %% Pameters Time Series 
            Model.A = A;
            Model.B = '';
            Model.C = C;
            Model.D = upper(['01',datestr( Model.Date_Init, 'mmmyyyy')]);
            Model.E = Model.dt_TimeSeries_Str;
            Model.F = F;
            
            % Path Control File 
            NameFile = fullfile(PathControl,'DATA','HEC_HMS.csv');

            % Initial open 
            ID_File  = fopen( NameFile, 'r');
            Tmp      = strsplit(fgetl(ID_File),',');
            fclose(ID_File);

            %% Load Control File
            ID_File = fopen( NameFile, 'r');
            Tmp = textscan(ID_File, ['%s%s', repmat('%f',1,length(Tmp) - 2)],'Delimiter',',','HeaderLines',1);
            fclose(ID_File);

            % Parameters
            Model.NameBasin  = Tmp{1};
            Model.NameRiver  = Tmp{2};
            Tmp              = cell2mat(Tmp(3:end));
            Model.ID         = Tmp(:,1);
            Model.Area       = Tmp(:,2);
            Model.Slope      = Tmp(:,3);
            Model.Longest    = Tmp(:,4);
            Model.GroupRiver = Tmp(:,5);
            Model.GroupBasin = Tmp(:,6);
            Model.CN         = Tmp(:,7);
            Model.Alpha_Ia   = Tmp(:,8);
            Model.K          = Tmp(:,9);
            Model.X          = Tmp(:,10);
            Model.Step       = Tmp(:,11);                                 
                    
            %% Modify Control File Update Date - Run
            NewFile = Model.Modify_ControlFile;
            
            % Save File 
            NameFile = fullfile(Model.PathModel, [Model.NameRun,'.control']);
            ID_File = fopen(NameFile, 'w');
            fprintf(ID_File, NewFile);
            fclose(ID_File);
            
            %% Create Script Run-HEC-HMS
            Tmp = Model.PathModel;
            Tmp = strrep(Tmp, filesep,[filesep,filesep]);
            Script = ['from hms.model.JythonHms import *',newline,...
            'OpenProject("',Model.NameModel,'", "',Tmp,'")',newline,...
            'Compute("',Model.NameRun,'")',newline,...
            'Exit(1)'];

            % Save Script File
            NameFile = fullfile(Model.PathModel, 'compute.script');
            ID_File = fopen(NameFile, 'w');
            fprintf(ID_File, '%s',Script);
            fclose(ID_File);

       end              
    end
    
    %% Estimate Parameters
    methods
         % Estimation S (mm)
       function Model = Cal_S(Model)
           Model.S = 25.4*((1000./Model.CN) - 10);
       end

       % Estimation Ia
       function Model = Cal_Ia(Model)
           % Estimation S (mm)
           Model.Cal_S;
           Model.Ia = Model.S .* Model.Alpha_Ia;
       end

       % Estimation Lag
       function Model = Cal_Lag(Model)          
           Model.Cal_Ia;
           % meter -> Feet
           Factor_1 = 3.28084;
           % mm -> inches
           Factor_2 = 1/25.4;
           % Factor Hours -> minutes
           Factor_3 = 60;
           % lag (minutes)          
           Model.Lag = Factor_3 * ((Model.Longest*Factor_1).^0.8) .* ((((Model.S*Factor_2) + 1).^0.7)./(1900* sqrt(Model.Slope)));           
       end
    end

    %% Generate File HEC-HMS
    methods
        %% Modify_BasinFile_HEC_HMS
        NewFile = Modify_BasinFile_HEC_HMS(Model)
        
        %% Calibration Model
        [Fig, Params,bestf,allbest,allEvals] = Calibration_HEC_HMS(Model,...
                Name_Output, NameEvents_Cal, Qobs, MaxIter, ComplexSize)  
       
        %% RUN Model HEC-HMS
        [Results_Basin, Results_River] = Run_HEC_HMS(Model)
        
        %% SCE
        [bestx,bestf,allbest,allEvals] = sce(Model,x0,bl,bu,ngs) 

        %% Read Results
        [Results_Basin, Results_River, Results_Sink] = ReadResults(Model)
        
        %% Export DSS
        ExportData_DSS(Model, PathExport, NameFile1, A, B, C, D, E, F)
        
        %% Funtion Object
        Metric = FunObj_Cal_HEC_HMS(Model, Params)
    end
end