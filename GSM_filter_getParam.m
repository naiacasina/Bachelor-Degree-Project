
% GSM_filter_getParam.m
% Get algorithm parameters from user input
% Modified by Naia Ormaza Zulueta (RLS alg added for s==3)
function [filterParam, flag] = GSM_filter_getParam()
% initialize variables (in case they are not assigned)

[s,v] = listdlg('PromptString','Select a filter:',...
    'SelectionMode','single',...
    'ListString',{'Bandstop filter','Wiener filter', 'RLS filter'});

if s==1,
   % Filtre Bandstop
    
    filterParam = struct('Typefilter',[],'GSMstim',[],'sf',[],'F0',[],'bw',[],'nh',[]);
    flag = 0;
    % user inputs
    PopupPrompt  = {'Stimulation reference electrode',...
        'Sampling frequency [Hz]',...
        'Modulation frequency F0 [Hz]',...
        'Filter bandwidth (divider of F0)',....
        'Maximum number of harmonics'};
    PopupTitle   = 'GSM Filter';
    PopupLines   = 1;
    PopupDefault = {'78','10000','108.5','100','30'};
    %----------------------------------- PARAMETER CONVERSION
    Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault,'on');
    if isempty(Ianswer) % halt condition
        return
    else
        filterParam.Typefilter = s;
        filterParam.GSM_stim = str2double(Ianswer{1,1});
        filterParam.sf = str2double(Ianswer{2,1});
        filterParam.F0 = str2double(Ianswer{3,1});
        filterParam.bw = str2double(Ianswer{4,1});
        filterParam.nh = str2double(Ianswer{5,1});
        flag = 1;
    end
    
elseif s==2,
    % Filtre de type Wiener
    
    filterParam = struct('Typefilter',[],'GSMstim',[],'sf',[],'L',[]);
    flag = 0;
    % user inputs
    PopupPrompt  = {'Reference electrode',...
        'Sampling frequency [Hz]',...        
        'Filter order (integer)' };
    PopupTitle   = 'Wiener Filter';
    PopupLines   = 1;
    PopupDefault = {'78','10000','4'};
    %----------------------------------- PARAMETER CONVERSION
    Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault,'on');
    if isempty(Ianswer) % halt condition
        return
    else
        filterParam.Typefilter = s;
        filterParam.GSM_stim = str2double(Ianswer{1,1});
        filterParam.sf = str2double(Ianswer{2,1});
        filterParam.L = str2double(Ianswer{3,1});
        
        flag = 1;
    end
    
else
    % Filtre RLS
    
    filterParam = struct('Typefilter',[],'GSMstim',[],'sf',[],'L',[],'lambda',[]);
    flag = 0;
    % user inputs
    PopupPrompt  = {'Reference electrode',...
        'Sampling frequency [Hz]',...        
        'Filter order (integer)',...
        'Forgetting factor (0<<lambda<1)'};
    PopupTitle   = 'RLS Filter';
    PopupLines   = 1;
    PopupDefault = {'78','10000','4','1'};
    %----------------------------------- PARAMETER CONVERSION
    Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault,'on');
    if isempty(Ianswer) % halt condition
        return
    else
        filterParam.Typefilter = s;
        filterParam.GSM_stim = str2double(Ianswer{1,1});
        filterParam.sf = str2double(Ianswer{2,1});
        filterParam.L = str2double(Ianswer{3,1});
        filterParam.lambda = str2double(Ianswer{4,1});          % à demander à l'utilisateur?
        
        flag = 1;
    end
end
