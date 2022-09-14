function ConvertOMETIFF_TIFF(splitchoice,skipfirst)
    tic;
    %%%%%%%%%%%%%%%%%%%            Selection          %%%%%%%%%%%%%%%%%%%
    ometifflist = List_OMETIFF;
    
     if ~exist('splitchoice', 'var') 
        splitchoice = questdlg('What would you like to do?', 'Choice', ...
	        'Split Channels only','Split Channels and Planes','Cancel','Cancel');
    end
    
    if ~exist('skipfirst', 'var')
        skipfirst = questdlg('Skip First Frame?', 'Choice', ...
	        'Yes','No','Yes');
    end
    switch skipfirst
            case 'Yes'
                skipT = 1;
            case 'No'
        	    skipT = 0;
    end
    clear skipfirst

%%
%%%%%%%%%%%%%%%%%%% Detect,Load,Save individual Z %%%%%%%%%%%%%%%%%%%
    for i= 1:length(ometifflist)
    % for i = convlist
        filename = ometifflist(i).name;
        filepath = strcat(ometifflist(i).folder, '\');
    
        switch splitchoice
            case 'Split Channels only'
                SplitChannelsOnly(filename,filepath,skipT);
            case 'Split Channels and Planes'
        	    SplitChannelsAndPlanes(filename,filepath,skipT);
            case 'Cancel'
                fprintf('Task cancelled\n');
                break
        end
        fprintf("Saving seperated file : %s into corresponding folder \n", filename);
    end
    
    toc;
end
