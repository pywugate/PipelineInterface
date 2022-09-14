function ometifflist=List_OMETIFF
    rootdir  = uigetdir( 'select folder');
    if isempty(dir(rootdir))
        error('Invalid folder path.')
    end
    
    % listing all the '.ome.tiff' files
    ometifflist = dir (fullfile(rootdir, '**\*.ome.tiff'));
    clear rootdir;

end


    