function [Results_Basin, Results_River, Results_Sink] = ReadResults(Model)
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
% Results_Basin
% Results_River
% Results_Sink
%
Results_Basin = cell(33, length(Model.ID));
Results_River = cell(14, length(Model.ID));
Results_Sink  = [];

NameRun = strrep(Model.NameRun,' ','_');
NameFile = fullfile(Model.PathModel,'results',['RUN_',NameRun,'.results']);
ID_File = fopen(NameFile, 'r');
Line    = fgets(ID_File);   
Type = 0;
while ischar(Line)                 
    if contains(Line, 'type="Subbasin">')
        for i = 1:length(Model.NameBasin)
            if contains(Line, Model.NameBasin{i})
               id = i;
            end
        end 
        Type = 1;
    elseif contains(Line,'type="Outflow Minimum"') && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{1,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Outflow Minimum Time"') && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{2,id} = Tmp{6};
    elseif contains(Line,'type="Outflow Maximum"') && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{3,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Outflow Maximum Time"') && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{4,id} = Tmp{6};
    elseif contains(Line,'type="Outflow Volume"') && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{5,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Outflow Depth"' ) && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{6,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Outflow Average"')  && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{7,id} = Tmp{6};
    elseif contains(Line,'type="Direct Flow Minimum"') && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{8,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Direct Flow Minimum Time"') && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{9,id} = Tmp{6};
    elseif contains(Line,'type="Direct Flow Maximum"') && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{10,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Direct Flow Maximum Time"') && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{11,id} = Tmp{6};
    elseif contains(Line,'type="Direct Flow Volume"') && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{12,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Direct Flow Depth"' ) && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{13,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Direct Flow Average"') && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{14,id} = Tmp{6};
    elseif contains(Line,'type="Baseflow Minimum"') && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{15,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Baseflow Minimum Time"') && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{16,id} = Tmp{6};
    elseif contains(Line,'type="Baseflow Maximum"') && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{17,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Baseflow Maximum Time"') && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{18,id} = Tmp{6};
    elseif contains(Line,'type="Baseflow Volume"') && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{19,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Baseflow Depth"' ) && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{20,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Baseflow Average"') && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{21,id} = Tmp{6};
    elseif contains(Line,'type="Precipitation Maximum"') && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{22,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Precipitation Maximum Time"') && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{23,id} = Tmp{6};
    elseif contains(Line,'type="Precipitation Total"' ) && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{24,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Precipitation Volume"') && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{25,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Loss Maximum"' ) && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{26,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Loss Maximum Time"' ) && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{27,id} = Tmp{6};
    elseif contains(Line,'type="Loss Total"' ) && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{28,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Loss Volume"' ) && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{29,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Excess Maximum"' ) && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{30,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Excess Maximum Time"' ) && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{31,id} = Tmp{6};
    elseif contains(Line,'type="Excess Total"' ) && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{32,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Excess Volume"') && (Type == 1)
        Tmp = strsplit(Line, '"');
        Results_Basin{33,id} = str2double(Tmp{6});
        
        
    elseif contains(Line, 'type="Reach"')
        for i = 1:length(Model.NameRiver)
           if contains(Line, Model.NameRiver{i})
               id = i;
           end
        end
        Type = 2;
    elseif contains(Line,'type="Inflow Minimum"') && (Type == 2)
        Tmp = strsplit(Line, '"');
        Results_River{1,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Inflow Minimum Time"') && (Type == 2)
        Tmp = strsplit(Line, '"');
        Results_River{2,id} = Tmp{6};
    elseif contains(Line,'type="Inflow Maximum"') && (Type == 2)
        Tmp = strsplit(Line, '"');
        Results_River{3,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Inflow Maximum Time"') && (Type == 2)
        Tmp = strsplit(Line, '"');
        Results_River{4,id} = Tmp{6};
    elseif contains(Line,'type="Inflow Volume"') && (Type == 2)
        Tmp = strsplit(Line, '"');
        Results_River{5,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Inflow Depth"') && (Type == 2)
        Tmp = strsplit(Line, '"');
        Results_River{6,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Inflow Average"') && (Type == 2)
        Tmp = strsplit(Line, '"');
        Results_River{7,id} = Tmp{6};
    elseif contains(Line,'type="Outflow Minimum"') && (Type == 2)
        Tmp = strsplit(Line, '"');
        Results_River{8,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Outflow Minimum Time"') && (Type == 2)
        Tmp = strsplit(Line, '"');
        Results_River{9,id} = Tmp{6};
    elseif contains(Line,'type="Outflow Maximum"') && (Type == 2)
        Tmp = strsplit(Line, '"');
        Results_River{10,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Outflow Maximum Time"') && (Type == 2)
        Tmp = strsplit(Line, '"');
        Results_River{11,id} = Tmp{6};
    elseif contains(Line,'type="Outflow Volume"') && (Type == 2)
        Tmp = strsplit(Line, '"');
        Results_River{12,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Outflow Depth"') && (Type == 2)
        Tmp = strsplit(Line, '"');
        Results_River{13,id} = str2double(Tmp{6});
    elseif contains(Line,'type="Outflow Average"') && (Type == 2)
        Tmp = strsplit(Line, '"');
        Results_River{14,id} = Tmp{6};
        
        
    elseif contains(Line, 'type="Sink">')
        Type = 3;
    elseif contains(Line,'type="Outflow Maximum"') && (Type == 3)
        Tmp = strsplit(Line, '"');
        Results_Sink = str2double(Tmp{6});
        Type = -1;
    end
    
    Line    = fgets(ID_File);
end
fclose(ID_File);
           
 