function ExportData_DSS(Model, PathExport, NameFile1, A, B, C, D, E, F)
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
% 
% -------------------------------------------------------------------------
% Output Data
% -------------------------------------------------------------------------
% PathExport	=
% NameFile1		=
% A				=
% B				=
% C				=
% D				=
% E				=
% F				=

%% Create Folder Export run
mkdir( PathExport )
PathExport = strrep(PathExport,'\','/');

%% Path DSS
PathDSS = fullfile(Model.PathModel, [Model.NameRun,'.dss']);
PathDSS = strrep(PathDSS,'\','/');

% Data_TempCol
%%
Script = [  'from hec.script import *',newline,...
            'from hec.heclib.dss import *',newline,...
            'from hec.script import *',newline,...
            'import java',newline,...
            newline,...
            'dssFile    = HecDss.open("',PathDSS,'")',newline,...
            'Data       = dssFile.get("/',A,'/',B,'/',C,'/',D,'/',E,'/',F,'/','")',newline,...
            'dssFile.done()',newline,...
            newline,...
            'theTable = Tabulate.newTable()',newline,...
            'theTable.setTitle("Gauges_Data")',newline,...
            'theTable.setLocation(5000,5000)',newline,...
            'theTable.addData(Data)',newline,...
            'Data_TempCol   = theTable.getColumn(Data)',newline,...
            'Data_TempWidth = theTable.getColumnWidth(Data_TempCol)',newline,...
            'theTable.setColumnPrecision(Data_TempCol, 2)',newline,...
            'theTable.setColumnWidth(Data_TempCol, Data_TempWidth - 10)',newline,...
            'opts           = TableExportOptions()',newline,...
            'opts.delimiter = ";"',newline,...
            'opts.title     = "Gauges_Data"',newline,...
            'fileName       = "',PathExport,'/',NameFile1,'.txt"',newline,...
            'theTable.showTable()',newline,...
            'theTable.export(fileName, opts)',newline,...
            'theTable.close()'];

        
%% Save New BasinFile    
NameFile = fullfile(Model.PathControl, 'Scripts_Python_MATLAB','Script_ExportData_DSS.py');
ID_File = fopen(NameFile, 'w');
fprintf(ID_File, Script);
fclose(ID_File);

%% Run Code
Status = system(['c: && cd "',Model.Path_HEC_DSS,'" && HEC-DSSVue.exe "',NameFile,'"']);
if Status == 1
    disp('Error import TimeSeries')
    return
else
    disp(' - Ok - Export Time Series ')
end