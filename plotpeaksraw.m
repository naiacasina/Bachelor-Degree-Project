% last modification by Naia Ormaza Zulueta on 3 June, 2019
% History:
%   - insertion of the option for multiple plots
%   - title added (specifying number of exp, phase, filter and number of
%   spikes)

% plotpeaksraw.m

clr

% Number of plots - user's choice

[nplots,flag]=number_of_plots();

% Selection du plot : s=1 (plot peaks); s=2 (spectrum); s=3 (both)

[s,v] = listdlg('PromptString','Select the type of plot:',...
    'SelectionMode','single',...
    'ListString',{'Peaks ph. E','Spectrum ph. S2 b/a','Spectrum ph. E b/a', 'Peaks and Spectrum ph. E', 'Plot b/a filtering'});

% All the filtered data and the corresponding Peak data files are loaded
for j=1:nplots,
	
	[Rawfile{j},Rawpath{j}] = uigetfile('*.mat','Select the Raw filtered_GSM_data MAT-file of one electrode');
	if (Rawfile{j} == 0)
		errordlg('Selection Failed - End of Session', 'Error');
		return
    end
	
    if s==1||s==4                                           % Not necessary if only spectrum wanted
        [Ptrainfile{j},Ptrainpath{j}] = uigetfile('*.mat','Select the corresponding Peak_train MAT-file');
        if (Ptrainfile{j} == 0)
            errordlg('Selection Failed - End of Session', 'Error');
            return
        end
    end
end

[fs, starttime, endtime, startend]=uigetRASTERinfo;
    
xtime=(starttime:endtime)'/fs; % [x-scale in sec]

% The data is storaged in matrixes
for jj=1:nplots,

	Rawexp = Rawfile{jj}(1:end-4);
    if s==1||s==4                                               % Not necessary if only spectrum wanted
        Ptrainexppmarker = find(Ptrainfile{jj}=='_');
        Ptrainexp = Ptrainfile{jj}(Ptrainexppmarker(1)+1:end-4)

        % checks if Raw filtered_GSM_data and Peak_train MAT-file corresponds to the same experiment, phase or electrode. 
        if (strcmp (Rawexp,Ptrainexp) == 1)

            load (fullfile(Rawpath{jj},Rawfile{jj}))            % filtered_GSM_data loaded
            load (fullfile(Ptrainpath{jj},Ptrainfile{jj}))      % peak_train & artifact loaded
		
            data_plot(jj,:)= filtered_GSM_data(starttime:endtime);
            peak_plot(jj,:)= peak_train(starttime:endtime);
      
            % Amount of spikes in the selected phase(Ayelen added)
            AmountSpikes(jj) = sum(peak_train>0)
		
        else
	
        errordlg ('Raw filtered_GSM_data and Peak_train MAT-file do not correspond')
	
        end
        
    % SPECTRUM BEFORE AND AFTER
    else
        % DATA AFTER FILTERING
        load (fullfile(Rawpath{jj},Rawfile{jj}))
        data_plot(jj,:)= filtered_GSM_data(starttime:endtime);
        %data_plot(jj,:)= data(starttime:endtime);  juste pour les données
        %d'Ayelen
    end
end

filters = {'BandStop','Wiener','RLS'};

if s==1||s==4 
    AmountSpikes = full(AmountSpikes);     				 %  converts sparse matrix S to full storage organization
end

%-------------------------------- PLOT OF PEAKS PHASE E------------------------------------------
if s==1||s==4
	for m=1:nplots,
		peakposition= find(peak_plot(m,:));
		figure(1)
		subplot(nplots,1,m)
		plot (xtime, data_plot(m,:)), hold on
		plot (xtime(peakposition),data_plot(m,peakposition),'*r'), hold on
		xlabel('Time [sec]','FontSize',18);
		ylabel('Amplitude [uV]','FontSize',18);
		grid on, hold on
		ylim([-80 80])
		Rawfile_char = char(Rawfile{m});
		Rawpath_char = char(Rawpath{m});
		submarker=find(Rawfile_char=='_');
		number = Rawfile_char(1:submarker(1)-1);
		phase = Rawfile_char(submarker(1)+1:submarker(2)-1);
        electrode = Rawfile_char(submarker(2)+1:submarker(2)+2);
		filt_type = Rawpath_char(strfind(char(Rawpath{1}),'_GSMFilteredData')+16);
		% Title automation
		if (Rawpath_char(strfind(char(Rawpath{1}),'_GSMFilteredData')+17)~='\')
			lambda=Rawpath_char((strfind(char(Rawpath{1}),'_GSMFilteredData')+18):(strfind(char(Rawpath{1}),'_GSMFilteredData')+21));
			titulo = strcat(number,'-',phase,' \ Filter type: ',filt_type,' \lambda: ',lambda,' \ Electrode n° :',electrode,' \ Amount Spikes: ',num2str(AmountSpikes(m)));
		else
			titulo = strcat(number,'-',phase,' \ Filter type: ',filt_type,' \ Electrode n° :',electrode,' \ Amount Spikes: ',num2str(AmountSpikes(m)));
		end
		title(titulo,'FontSize',16),hold on
	end
end
%------------------------------------- PLOT OF SPECTRUM ------------------------------------------

if s==2||s==3||s==4
    % AFTER FILTERING
	for mm=1:nplots,
		figure(2)
		x = data_plot(mm,:);
		FT_x = fft(x);				% FT 
		FT_x = FT_x(1:round(length(x)/2)-1);		% Single-sided spectrum
		DF = fs/length(x);							% frequency increment
		freqvec = (0:DF:fs/2-DF);
        fin = size(freqvec);
		subplot(nplots,1,mm)
		plot(freqvec(1:fin(2)-1),abs(FT_x(1:fin(2)-1)).^2/length(x)), hold on;  
		xlabel('f [Hz]','FontSize',18);
		ylabel('|P(f)|','FontSize',18);
		grid on, hold on
		Rawfile_char = char(Rawfile{mm});
		Rawpath_char = char(Rawpath{mm});
		submarker=find(Rawfile_char=='_');
		number = Rawfile_char(1:submarker(1)-1);
		phase = Rawfile_char(submarker(1)+1:submarker(2)-1);
        electrode = Rawfile_char(submarker(2)+1:submarker(2)+2);
		filt_type = Rawpath_char(strfind(char(Rawpath{1}),'_GSMFilteredData')+16);
		% Title automation
		if (Rawpath_char(strfind(char(Rawpath{1}),'_GSMFilteredData')+17)~='\')
			lambda=Rawpath_char((strfind(char(Rawpath{1}),'_GSMFilteredData')+18):(strfind(char(Rawpath{1}),'_GSMFilteredData')+21));
			titulo = strcat('Spectrum of : ',number,'-',phase,' \ After filtering with: ',filters{str2num(filt_type)},' \lambda: ',lambda,' \ Electrode n° :',electrode);
		else
			titulo = strcat('Spectrum of ',number,'-',phase,' \ After filtering with: ',filters{str2num(filt_type)},' \ Electrode n° :',electrode);
		end
		title(titulo,'FontSize',16),hold on
    end	
    % BEFORE FILTERING (change of folder)
    for nn=1,
		figure(3)
        Rawfile_char = char(Rawfile{nn});
        Rawpath_char = char(Rawpath{nn});
        submarker=find(Rawfile_char=='_');
        submarker2 = strfind(char(Rawpath{1}),'\');
        file = Rawfile_char(1:submarker(2)-1);
        raw_data = Rawpath_char(1:submarker2(end-3));
        number = Rawfile_char(1:submarker(1)-1);
        raw_data2 = strcat(raw_data,number,'_Mat_Files\',file);
        electrode = Rawfile_char(submarker(2)+1:submarker(2)+2);
        cd(raw_data2)
        load(strcat(file,'_',electrode));
		x = data(starttime:endtime);
		FT_x = fft(x);				% FT 
		FT_x = FT_x(1:round(length(x)/2)-1);		% Single-sided spectrum
		DF = fs/length(x);							% frequency increment
		freqvec = (0:DF:fs/2-DF);
        fin = size(freqvec);
		subplot(nplots,1,nn)
		plot(freqvec(1:fin(2)-1),abs(FT_x(1:fin(2)-1)).^2/length(x)), hold on;  
		xlabel('f [Hz]','FontSize',18);
		ylabel('|P(f)|','FontSize',18);
		grid on, hold on
		% Title automation
		titulo = strcat('Spectrum of ',file,'\ Before filtering - Electrode n° :',electrode);
		title(titulo,'FontSize',16),hold on
    end
end

%------------------------------------- PLOT BEFORE/AFTER FILTERING ------------------------------------------

if s==5
    % AFTER FILTERING
	for mm=1:nplots,
		figure(4)
		x = data_plot(mm,:);
		subplot(nplots,1,mm)
		plot(x), hold on;  
		xlabel('Time','FontSize',18);
		ylabel('Amplitude [\mu V]','FontSize',18);
		grid on, hold on
		Rawfile_char = char(Rawfile{mm});
		Rawpath_char = char(Rawpath{mm});
		submarker=find(Rawfile_char=='_');
		number = Rawfile_char(1:submarker(1)-1);
		phase = Rawfile_char(submarker(1)+1:submarker(2)-1);
        electrode = Rawfile_char(submarker(2)+1:submarker(2)+2);
		filt_type = Rawpath_char(strfind(char(Rawpath{1}),'_GSMFilteredData')+16);
		% Title automation
		if (Rawpath_char(strfind(char(Rawpath{1}),'_GSMFilteredData')+17)~='\')
			lambda=Rawpath_char((strfind(char(Rawpath{1}),'_GSMFilteredData')+18):(strfind(char(Rawpath{1}),'_GSMFilteredData')+21));
			titulo = strcat('Plot of : ',number,'-',phase,' \ After filtering with: ',filters{str2num(filt_type)},' \lambda: ',lambda,' \ Electrode n° :',electrode);
		else
			titulo = strcat('Plot of ',number,'-',phase,' \ After filtering with: ',filters{str2num(filt_type)},' \ Electrode n° :',electrode);
		end
		title(titulo,'FontSize',16),hold on
    end	
    % BEFORE FILTERING (change of folder)
    for nn=1:nplots,
		figure(5)
        Rawfile_char = char(Rawfile{nn});
        Rawpath_char = char(Rawpath{nn});
        submarker=find(Rawfile_char=='_');
        submarker2 = strfind(char(Rawpath{1}),'\');
        file = Rawfile_char(1:submarker(2)-1);
        raw_data = Rawpath_char(1:submarker2(end-3));
        number = Rawfile_char(1:submarker(1)-1);
        raw_data2 = strcat(raw_data,number,'_Mat_Files\',file);
        electrode = Rawfile_char(submarker(2)+1:submarker(2)+2);
        cd(raw_data2)
        load(strcat(file,'_',electrode));
		x = data(starttime:endtime);
		subplot(nplots,1,nn)
		plot(x), hold on;  
		xlabel('Time','FontSize',18);
		ylabel('Amplitude [\mu V]','FontSize',18);
		grid on, hold on
		% Title automation
		titulo = strcat('Plot of ',file,'\ Before filtering - Electrode n° :',electrode);
		title(titulo,'FontSize',16),hold on
    end
end

EndOfProcessing (Rawpath{1}, 'Successfully accomplished');

clear all