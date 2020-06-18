% GSM_Filter_all_elW.m
% last update: Naia Ormaza Zulueta 06/2019 (multiapplication of filters)
% to filter GSM stimulation

function []=GSM_Filter_allW
tic

[filterParam, flag] = GSM_filter_getParam();
pause(0.5);

[experimentFolder, stimulationFolderpath ]=get_vector_GSMstimulationW(filterParam);

cd(experimentFolder);


Folderslist=dirr(experimentFolder);

numFolders= size(Folderslist,1);



 % output folder
outFolder = experimentFolder(1:end-10);
%[saveFolderName, successFlag] = createResultFolderNoUserQuestion(outFolder, 'GSMFilteredData');

if (filterParam.Typefilter==3)
    saveFolderName = [outFolder,'_GSMFilteredData',num2str(filterParam.Typefilter),'_',num2str(filterParam.lambda)];
else
    saveFolderName = [outFolder,'_GSMFilteredData',num2str(filterParam.Typefilter)];
end
saveSubfolderName = [saveFolderName,'\',outFolder(end-12:end),'_Mat_Files'];


% [saveSubfolderName, successFlag2] = createResultFolderNoUserQuestion(saveFolderName, 'Mat_Files');        
% if ~successFlag
%     errordlg('Error creating output folder!','!!Error!!')
%     return
% end

[el_sel, flag] = GSM_el_selection();
		
for i=1:length(el_sel),                     % Conversion num electrode in mea to root file name
	el_sel(i)=GSM_el_conv(el_sel(i));
end
		
pause(0.5);

for	k=2:3, % 2: Pre-exposure phase , 3: Exposure phase
	
	filename=[Folderslist(k,1).name,'\',Folderslist(k,1).name,'_',num2str(filterParam.GSM_stim),'.mat'];
	
	
	load(filename);
	el_ref = data;
	
	if isstruct(Folderslist(k,1).isdir);
		actualFolder=Folderslist(k).name;
		path=fullfile(experimentFolder, actualFolder);
		
		stimulationFolder=strcat('Stimulation_', actualFolder, '.mat');
		stimulationVectorpath=fullfile(stimulationFolderpath,stimulationFolder);      
		
	if exist(stimulationVectorpath)==2
			load (stimulationVectorpath);
			
		else
			vector_GSMstimulation=0;  % stimulation vector do not exist
		end
		
		cd(path)
		numberOfElectrodes = getElectrodesNumber(path);
		files = dirr(path);
		
		messageWaitWind=['Please wait ... analyzing ' Folderslist(k,1).name '    ' 'Folder n. ' num2str(k) ' of ' num2str(numFolders)];
		hww = waitWindow(messageWaitWind);
		
		h = waitbar(0,sprintf('Analyzing directory %d',k));              
		try
			trialOutFolder = fullfile(saveSubfolderName,actualFolder);
			if exist(trialOutFolder,'dir')
				rmdir(trialOutFolder,'s');
			end
			mkdir(trialOutFolder);
		catch
			errordlg(['Error creating ',trialOutFolder],'!!Error!!')
			flag = 0;
			return
		end      
		
		
		for kk=1:length(el_sel), % 4 electrodes: el_ref, low, medium, high
			
			el_sel(kk)
			waitbar(el_sel(kk)/60,h);
			filename = fullfile(actualFolder,files(el_sel(kk)).name);
			load(filename);  
			% from now on data means the data of the electrode kk
			%----------------------------------------------------------------------------------------------------------------
			filtered_GSM_data=GSM_filter_elW(data,vector_GSMstimulation,el_ref, filterParam); % C'est ici qu'est réalisé le filtrage
			% el_ref = electrode référence (artefact) --> x(n)
			% data : données de l'électrode --> d(n)
			% filterParam : paramètres du filtre
			%-----------------------------------------------------------------------------------------------------------------
		
			saveFilename = fullfile(trialOutFolder,files(el_sel(kk)).name);
			try
				save(saveFilename,'filtered_GSM_data');
			catch
				errordlg(['Error saving ',saveFilename],'!!Error!!')
				flag = 0;
				return
			end
		end
		
		clear vector_GSMstimulation;          
	
	end
	
	close all
	cd ..
end	
toc
end
