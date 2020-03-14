function NewFile = Modify_GageFile(Model)
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
% NewFile		=

% New File
Tap         = '       ';
NewFile     = sprintf('');
ID_File     = fopen(fullfile(Model.PathModel, [Model.NameModel,'.gage']),'r');
Line        = fgets(ID_File);           
while ischar(Line)              
   %% Basin
   if contains(Line, 'Gage:')
       for i = 1:length(Model.NameBasin)
           if contains(Line, Model.NameBasin{i})
               id = i;
           end
       end  
       NewFile = sprintf( [NewFile, Line]);
   
   elseif contains(Line, 'Data Source Type:')
       NewFile = sprintf( [NewFile, '     ','Data Source Type: External DSS','\n']);
       
   elseif contains(Line, 'DSS Pathname:')
       Model.B = Model.NameBasin{id};
       NewFile = sprintf( [NewFile, Tap,'DSS Pathname: /',Model.A,'/',Model.B,'/',Model.C,'/',Model.D,'/',Model.E,'/',Model.F,'/','\n']);

   elseif contains(Line, 'Start Time:')
       NewFile = sprintf( [NewFile, Tap,'Start Time: ', datestr(Model.Date_Init,'dd mmmm yyyy, HH:MM'),'\n']);

   elseif contains(Line, 'End Time:')
       NewFile = sprintf( [NewFile, Tap,'End Time: ', datestr(Model.Date_End,'dd mmmm yyyy, HH:MM'),'\n']);
       
   else
       NewFile = sprintf( [NewFile, Line]);  

   end 
   Line = fgets(ID_File);
end

fclose(ID_File);

end