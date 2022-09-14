%% Load each data

ometifflist = List_OMETIFF;
concatedata = [];

for i= 1:length(ometifflist)
% for i = convlist
    filename = ometifflist(i).name;
    filepath = strcat(ometifflist(i).folder, '\');

    fullfilepath = strcat(filepath,filename);
    OmeTiff = bfopen_vPingYen(fullfilepath);
    [sizeY,sizeX] = size(OmeTiff{1,1}{1,1});

    % Get size of Z, C, T, P
    r = bfGetReader(fullfilepath);
    sizeZ = r.getSizeZ();
    sizeT = r.getSizeT();
    sizeC = r.getSizeC();
    sizeP = sizeZ*sizeT*sizeC;         % because total frame/plane = Z*T*C
    
    data = zeros([sizeY sizeX sizeZ], 'uint16');
    
    for z =1:sizeZ
        data(:,:,z) = (OmeTiff{1,1}{z,1});    
    end
    
    if i==1
        concatedata = data;
    else
        concatedata = cat(3,concatedata,data);
    end
        
end

%% save merged data  
data_type = 'uint16';
opts_tiff.append = true;
opts_tiff.big = true;
% concatefile = 
outputpath = strcat ('Concate\', 'concatefile.tiff');
outputfile = strcat (filepath, outputpath);

saveastiff(cast(concatedata,data_type),outputfile,opts_tiff);

