function NewFile = Modify_ControlFile(Model)
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

% New File
Tap         = '     ';
NewFile     = sprintf('');
ID_File     = fopen(fullfile(Model.PathModel, [Model.NameRun,'.control']),'r');
Line        = fgets(ID_File);           
while ischar(Line)              
   %% Basin
   if contains(Line, 'Start Date:')
       NewFile = sprintf( [NewFile, Tap,'Start Date: ', datestr(Model.Date_Init_Model,'dd mmmm yyyy'),'\n']);

   elseif contains(Line, 'Start Time:')
       NewFile = sprintf( [NewFile, Tap,'Start Time: ', datestr(Model.Date_Init_Model,'HH:MM'),'\n']);
    
   elseif contains(Line, 'End Date:')
       NewFile = sprintf( [NewFile, Tap,'End Date: ', datestr(Model.Date_End_Model,'dd mmmm yyyy'),'\n']);
       
   elseif contains(Line, 'End Time:')
       NewFile = sprintf( [NewFile, Tap,'End Time: ', datestr(Model.Date_End_Model,'HH:MM'),'\n']);
       
   elseif contains(Line, 'Time Interval:')
       NewFile = sprintf( [NewFile, Tap,'Time Interval: ', num2str(Model.dt_Run_Model),'\n']);
       
   elseif contains(Line, 'Grid Write Interval:')
       NewFile = sprintf( [NewFile, Tap,'Grid Write Interval: ', num2str(Model.dt_Run_Model),'\n']);
   else
       NewFile = sprintf( [NewFile, Line]);  
   end 
   Line = fgets(ID_File);
end