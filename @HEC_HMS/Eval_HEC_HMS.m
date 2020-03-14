function [Metric] = Eval_HEC_HMS(Model, Name_Output, NameEvents_Cal, Qobs)  
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
% Metric			=	
% -------------------------------------------------------------------------
% Output Data
% -------------------------------------------------------------------------
% Name_Output		=
% NameEvents_Cal	=
% Qobs				=
            
%% 
% Output Flow 
Model.Name_Output   = Name_Output;
Model.UserData.Qobs = Qobs;

Model.UserData.NameEvents_Cal = NameEvents_Cal;

% Count Execution
Model.UserData.NumberRunCal = 0;

 %% Range parameters for calibration
if sum( isnan(Model.K) ) > 0
    Model.UserData.ID_K = isnan(Model.K);
end
if sum( isnan(Model.X) ) > 0
    Model.UserData.ID_X         = isnan(Model.X);
end
if sum( isnan(Model.Step) ) > 0
    Model.UserData.ID_Step      = isnan(Model.Step);
end

if sum( isnan(Model.CN) ) > 0
    Model.UserData.ID_CN        = isnan(Model.CN);
end
if sum( isnan(Model.Alpha_Ia) ) > 0
    Model.UserData.ID_Alpha_Ia  = isnan(Model.Alpha_Ia);
end

%% Asignation Parameters
Count = 1;
if isfield(Model.UserData,'ID_K')
    NG = unique( Model.GroupRiver(Model.UserData.ID_K) );
    for i = 1:length(NG)
        id = logical((Model.GroupRiver == NG(i)) .* Model.UserData.ID_K);
        Model.K(id) = Params(Count);   
        Count = Count + 1;
    end
end
if isfield(Model.UserData,'ID_X')
    NG = unique( Model.GroupRiver(Model.UserData.ID_X) );
    for i = 1:length(NG)
        id = logical((Model.GroupRiver == NG(i)) .* Model.UserData.ID_X);
        Model.X(id) = Params(Count);   
        Count = Count + 1;
    end
end
if isfield(Model.UserData,'ID_Step')
    NG = unique( Model.GroupRiver(Model.UserData.ID_Step) );
    for i = 1:length(NG)
        id = logical((Model.GroupRiver == NG(i)) .* Model.UserData.ID_Step);
        Model.Step(id) = Params(Count);   
        Count = Count + 1;
    end
end

if isfield(Model.UserData,'ID_CN')
    NG = unique( Model.GroupBasin(Model.UserData.ID_CN) );
    for i = 1:length(NG)
        id = logical((Model.GroupBasin == NG(i)) .* Model.UserData.ID_CN);
        Model.CN(id) = Params(Count);   
        Count = Count + 1;
    end
end
if isfield(Model.UserData,'ID_Alpha_Ia')
    NG = unique( Model.GroupBasin(Model.UserData.ID_Alpha_Ia) );
    for i = 1:length(NG)
        id = logical((Model.GroupBasin == NG(i)) .* Model.UserData.ID_Alpha_Ia);
        Model.Alpha_Ia(id) = Params(Count);   
        Count = Count + 1;
    end
end

%% Parameters Export Results
A = '';
B = Model.Name_Output;
C = 'FLOW';
D = upper( datestr(Model.Date_Init, 'ddmmmyyyy') );
E = Model.dt_Run_Model_Str;
F = ['RUN:', upper(Model.NameRun)];
PathExport  = fullfile(Model.PathControl, 'RESULTS', Model.NameRun);
Qsim        = NaN(1, length(Model.UserData.NameEvents_Cal));

%% Run by Event Number
for i = 1:length(Model.UserData.NameEvents_Cal)
    % Asigantion Event
    Model.A = Model.UserData.NameEvents_Cal{i};
    NameFile1   = [Model.A,'_Run_',num2str(Model.UserData.NumberRunCal)];
    
    %% Update Gage File
    NewFile = Model.Modify_GageFile;

    % Save New GageFile
    NameFile = fullfile(Model.PathModel, [Model.NameModel,'.gage']);
    ID_File = fopen(NameFile, 'w');
    fprintf(ID_File, NewFile);
    fclose(ID_File);

    %% Run HEC-HMS
    Model.Run_HEC_HMS;

    %% Extract Results     
    [~,~, Results_Sink] = Model.ReadResults;
    
    %% Qsim
    Qsim(i) = Results_Sink;
    
    %% Export Run
    Model.ExportData_DSS(PathExport, NameFile1, A, B, C, D, E, F);
    
end

%% Qobs
Qobs    = Model.UserData.Qobs;

%% Estimate
Metric  = mean(abs(Qobs - Qsim)./Qobs);
end