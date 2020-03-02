function Run_HEC_HMS(Model)  
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

%% Create Script Run-HEC-HMS
Tmp     = Model.PathModel;
Tmp     = strrep(Tmp, filesep,[filesep,filesep]);
Script  = [ 'from hms.model.JythonHms import *',newline,...
            'OpenProject("',Model.NameModel,'", "',Tmp,'")',newline,...
            'Compute("',Model.NameRun,'")',newline,...
            'Exit(1)' ];

%% Save Script File
NameFile    = fullfile(Model.PathModel, 'compute.script');
ID_File     = fopen(NameFile, 'w');
fprintf(ID_File, '%s',Script);
fclose(ID_File);

%% Estimation Lag
% Model.Cal_Lag;
            
%% Create New BasinFile
NewFile = Model.Modify_BasinFile;

% Save New BasinFile
NameFile = fullfile(Model.PathModel, [Model.NameModel,'.basin']);
ID_File = fopen(NameFile, 'w');
fprintf(ID_File, NewFile);
fclose(ID_File);

%% Create New GageFile
NewFile = Modify_GageFile(Model);

% Save New GageFile
NameFile = fullfile(Model.PathModel, [Model.NameModel,'.gage']);
ID_File = fopen(NameFile, 'w');
fprintf(ID_File, NewFile);
fclose(ID_File);
    
%% Run HEC-HMS
tic
Status = system(['c: && cd "',Model.PathHEC_HMS,'" && HEC-HMS.cmd -s "',fullfile(Model.PathModel, 'compute.script'),'"']);
if Status == 1
    disp('----------------------------------------------------------------')
    disp('Error in the run HEC-HMS')
    return
else
    disp('----------------------------------------------------------------')
    disp(['Run Ok - Time: ', num2str(toc,'%.1f'),' Seg'])
end

end