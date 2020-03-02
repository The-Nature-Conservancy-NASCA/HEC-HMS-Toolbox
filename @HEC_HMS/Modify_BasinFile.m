function NewFile = Modify_BasinFile(Model)
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
ID_File     = fopen(fullfile(Model.PathModel, [Model.NameModel,'.basin']),'r');
Line        = fgets(ID_File);           
while ischar(Line)              
   %% Basin
   if contains(Line, 'Subbasin')
       for i = 1:length(Model.NameBasin)
           if contains(Line, Model.NameBasin{i})
               id = i;
           end
       end  
       NewFile = sprintf( [NewFile, Line]);

   elseif contains(Line, 'Curve Number')
       NewFile = sprintf( [NewFile, Tap,'Curve Number: ', num2str(Model.CN(id),'%0.2f'),'\n']);

   elseif contains(Line, 'Initial Abstraction')
       NewFile = sprintf( [NewFile, Tap,'Initial Abstraction: ', num2str(Model.Ia(id),'%0.2f'),'\n']);

   elseif contains(Line, 'Lag')
       NewFile = sprintf( [NewFile, Tap,'Lag: ', num2str(Model.Lag(id),'%0.2f'),'\n']);
       
   elseif contains(Line, 'Area')
       NewFile = sprintf( [NewFile, Tap,'Area: ', num2str(Model.Area(id),'%0.5f'),'\n']);

   elseif contains(Line, 'Reach')
       for i = 1:length(Model.NameRiver)
           if contains(Line, Model.NameRiver{i})
               id = i;
           end
       end 
       NewFile = sprintf( [NewFile, Line]);

   elseif contains(Line, 'Muskingum K')
        NewFile = sprintf( [NewFile, Tap,'Muskingum K: ', num2str(Model.K(id),'%0.4f'),'\n']);

   elseif contains(Line, 'Muskingum x')
       NewFile = sprintf( [NewFile, Tap,'Muskingum x: ', num2str(Model.X(id),'%0.2f'),'\n']);

   elseif contains(Line, 'Muskingum Steps')
       NewFile = sprintf( [NewFile, Tap,'Muskingum Steps: ', num2str(Model.Step(id),'%d'),'\n']);

   else
       NewFile = sprintf( [NewFile, Line]);  

   end 
   Line = fgets(ID_File);
end

fclose(ID_File);

end