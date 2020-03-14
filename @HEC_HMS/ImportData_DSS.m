function ImportData_DSS(Model, Data, A, B, C, F)
% -------------------------------------------------------------------------
% Matlab - R2018b 
% -------------------------------------------------------------------------
%                           Informaci�n Basica
%--------------------------------------------------------------------------
% Autor         : Jonathan Nogales Pimentel
% Email         : jonathannogales02@gmail.com
% Componente    : Modelaci�n Hidrologica
% Organizaci�n  : The Nature Conservancy - TNC
% Fecha         : 01- July - 2019
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
% Este c�digo permite descargar la informaci�n de precipitaci�n, temperatura 
% m�nima y m�xima a resoluci�n diaria de los modelos meteorol�gicos globales 
% que modelan el cambio clim�tico (GCM). En total son 21 GCM de los cuales 
% se descarga la informaci�n, tanto para el hist�rico como para los 
% escenarios rcp45 y rcp85 
%
% -------------------------------------------------------------------------
% Input Data
% -------------------------------------------------------------------------
% Data		=
% A			=
% B 		=
% C			=
% F			=
% -------------------------------------------------------------------------
% Output Data
% -------------------------------------------------------------------------
%

% Cathment
Model.B = B;

%% Create Folder Scripts
mkdir( fullfile(Model.PathControl, 'Scripts_Python_MATLAB') )

TimeSeries = ['[', num2str(Data(1),'%.2f')];
for i = 2:length(Data)
    TimeSeries = [TimeSeries,',',num2str(Data(i),'%.2f')];
end

TimeSeries = [TimeSeries,']'];

PathDSS = fullfile(Model.PathModel, [Model.NameModel,'.dss']);
PathDSS = strrep(PathDSS,'\','/');

Script = [  'from hec.script import *',newline,...
            'from hec.heclib.dss import *',newline,...
            'from hec.heclib.util import *',newline,...
            'from hec.io import *',newline,...
            'import java',newline,...
            newline,...
            'myDss          = HecDss.open("',PathDSS,'")',newline,...
            'tsc            = TimeSeriesContainer()',newline,...
            'tsc.fullName   = "/',A,'/',B,'/',C,'/',Model.D,'/',Model.E,'/',F,'/"',newline,...
            'start          = HecTime("',datestr(Model.Date_Init, 'ddmmmyyyy'),'", "',datestr(Model.Date_Init, 'HHMM'),'")',newline,...
            'tsc.interval   = ',num2str(Model.dt_TimeSeries),newline,...
            'Data           = ',TimeSeries,newline,...
            'times          = []',newline,...
            newline,...
            'for value in Data :',newline,...
            '  times.append(start.value())',newline,...
            '  start.add(tsc.interval)',newline,...
            newline,...
            'tsc.times          = times',newline,...
            'tsc.values         = Data',newline,...
            'tsc.numberValues   = len(Data)',newline,...
            'tsc.units          = "MM"',newline,...
            'tsc.type           = "PER-CUM"',newline,...
            'myDss.put(tsc)',newline,...
            newline,...    
            'myDss.close()']; 

%% Save New BasinFile    
NameFile = fullfile(Model.PathControl, 'Scripts_Python_MATLAB','Script_ImportData_DSS.py');
ID_File = fopen(NameFile, 'w');
fprintf(ID_File, Script);
fclose(ID_File);

%% Run Code
tic
Status = system(['c: && cd "',Model.Path_HEC_DSS,'" && HEC-DSSVue.exe "',NameFile,'"']);
if Status == 1
    disp('Error import TimeSeries')
    return
else
    disp([' - Ok - Import Time Series | Time: ', num2str(toc,'%.1f'),' Seg'])
end

end