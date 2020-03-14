function [Fig, Params,bestf,allbest,allEvals] = Calibration_HEC_HMS(Model, Name_Output, NameEvents_Cal, Qobs, MaxIter, ComplexSize)  
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
            
%% 
% Output Flow 
Model.Name_Output   = Name_Output;
Model.UserData.Qobs = Qobs;

Model.UserData.NameEvents_Cal = NameEvents_Cal;

 %% Range parameters for calibration
% Load Group River
NameFile    = fullfile(Model.PathControl,'DATA','Group_River.csv');
ID_File     = fopen( NameFile, 'r');
Tmp         = cell2mat(textscan(ID_File, repmat('%f',1,7),'Delimiter',',','HeaderLines',1));
fclose(ID_File);

Model.UserData.Param_Min = [];
Model.UserData.Param_Max = [];
if sum( isnan(Model.K) ) > 0
    Model.UserData.ID_K = isnan(Model.K);
    NG = unique( Model.GroupRiver(Model.UserData.ID_K) );
    [id, posi] = ismember(NG, Tmp(:,1));

    Model.UserData.Param_Min = [Model.UserData.Param_Min,...
                                Tmp(posi(id),2)'];
    Model.UserData.Param_Max = [Model.UserData.Param_Max,...
                                Tmp(posi(id),3)'];
end
if sum( isnan(Model.X) ) > 0
    Model.UserData.ID_X         = isnan(Model.X);
    NG = unique( Model.GroupRiver(Model.UserData.ID_X) );
    [id, posi] = ismember(NG, Tmp(:,1));

    Model.UserData.Param_Min = [Model.UserData.Param_Min,...
                                Tmp(posi(id),4)'];
    Model.UserData.Param_Max = [Model.UserData.Param_Max,...
                                Tmp(posi(id),5)'];
end
if sum( isnan(Model.Step) ) > 0
    Model.UserData.ID_Step      = isnan(Model.Step);
    NG = unique( Model.GroupRiver(Model.UserData.ID_Step) );
    [id, posi] = ismember(NG, Tmp(:,1));

    Model.UserData.Param_Min = [Model.UserData.Param_Min,...
                                Tmp(posi(id),6)'];
    Model.UserData.Param_Max = [Model.UserData.Param_Max,...
                                Tmp(posi(id),7)'];
end

% load Group Basin
NameFile    = fullfile(Model.PathControl,'DATA','Group_Basin.csv');
ID_File     = fopen( NameFile, 'r');
Tmp         = cell2mat(textscan(ID_File, repmat('%f',1,5),'Delimiter',',','HeaderLines',1));
fclose(ID_File);

if sum( isnan(Model.CN) ) > 0
    Model.UserData.ID_CN        = isnan(Model.CN);
    NG = unique( Model.GroupBasin(Model.UserData.ID_CN) );
    [id, posi] = ismember(NG, Tmp(:,1));

    Model.UserData.Param_Min = [Model.UserData.Param_Min,...
                                Tmp(posi(id),2)'];
    Model.UserData.Param_Max = [Model.UserData.Param_Max,...
                                Tmp(posi(id),3)'];
end

if sum( isnan(Model.Alpha_Ia) ) > 0
    Model.UserData.ID_Alpha_Ia  = isnan(Model.Alpha_Ia);
    NG = unique( Model.GroupBasin(Model.UserData.ID_Alpha_Ia) );
    [id, posi] = ismember(NG, Tmp(:,1));

    Model.UserData.Param_Min = [Model.UserData.Param_Min,...
                                Tmp(posi(id),4)'];
    Model.UserData.Param_Max = [Model.UserData.Param_Max,...
                                Tmp(posi(id),5)'];
end

%% Parameters SCE
Model.UserData.maxIter      = MaxIter;
Model.UserData.complexSize  = ComplexSize; 

%% Run SCE
[Params,bestf,allbest,allEvals] = Model.sce([],...
                                            Model.UserData.Param_Min,...
                                            Model.UserData.Param_Max,...
                                            Model.UserData.complexSize);


save('Calibration_Joder.mat','Params','bestf','allbest','allEvals')

% load('ki.mat')
% Params = ki;
% load('D:\TNC\Project\Project-Flood-Juan-Diaz-Basin-Panama\PROGRAMMING\RESULTS\Calibration_2.mat')
% Params(1:5) = 0.39;

% load('Params_Cal_1.mat')
% Params = All_Params(52,:);

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

Model.Cal_Lag;

%% Eval Best Parameters
Qsim = NaN(1, length(Model.UserData.NameEvents_Cal));
for i = 1:length(Model.UserData.NameEvents_Cal)
    % Asigantion Event
    Model.A = Model.UserData.NameEvents_Cal{i};
    
    NewFile = Modify_GageFile(Model);

    %% Save New GageFile
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
end

% %% Qobs
Qobs    = Model.UserData.Qobs;

Metric  = mean(abs(Qobs - Qsim)./Qobs);
% Metric = abs(Qobs - Qsim);
% Metric = round(Metric,3);

% %% Plot 
Fig     = figure('color',[1 1 1],'Visible','off');
% T       = [10, 8];
% set(Fig, 'Units', 'Inches', 'PaperPosition', [0, 0, T],'Position',...
% [0, 0, T],'PaperUnits', 'Inches','PaperSize', T,'PaperType','usletter')
% 
% FontLabels = 22;
% FontTick   = 15;
% 
% Limit   = max([max(Qobs); max(Qsim)]);
% x       = [0; Limit];
% plot(x,x,'k','LineWidth',1.5)
% hold on
% scatter(Qobs, Qsim, 25,ColorsF('jasper'),'filled', 'MarkerEdgeColor',ColorsF('jazzberry jam'),'LineWidth',2)
% axis([0 Limit 0 Limit])
% set(gca, 'TickLabelInterpreter','latex','FontSize',FontTick, 'FontWeight','bold', 'linewidth',2)
% xlabel('\bf Caudal Observado $\bf {(m^3/s)}$','interpreter','latex','FontSize',FontLabels, 'FontWeight','bold');
% ylabel('\bf Caudal Simulado $\bf {(m^3/s)}$','interpreter','latex','FontSize',FontLabels, 'FontWeight','bold');
% box off
% 
% saveas(Fig, fullfile('..','RESULTS','Calibration_Tr.jpg'))

end