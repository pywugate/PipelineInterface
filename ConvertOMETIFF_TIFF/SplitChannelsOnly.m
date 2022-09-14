function SplitChannelsOnly(filename, filepath, skipT)
% load ometiff into xyztc structure array and save XYT as single Z and C file
%
% MATLAB Toolbox for BioFormats is necessity, please download the toolbox
% at OME website, install and addPath in MATLAB
% ---------------------------------------
% Another competiter:
% Multipage TIFF stack by YoonOh Tak
% https://www.mathworks.com/matlabcentral/fileexchange/35684-multipage-tiff-stack
% can load data as x-y-tz ( or x-y-zt) faster than bfopen, 
% but not easy to know tz(or zt)
% ---------------------------------------
% IMPORTANT: ome.tiff store data in this order: ZCT
% Plane/frame is labelled before ZTC (but not real data)
% so the label order is PZTC
% go to OME website for more info

% Load the ome.tiff file and get size of X,Y
while ~exist('filename', 'var'), error('file selection fails');end
while ~exist('filepath', 'var'), error ('path selection fails');end    

fullfilepath = strcat(filepath,filename);
OmeTiff = bfopen_vPingYen(fullfilepath);
[sizeY,sizeX] = size(OmeTiff{1,1}{1,1});

% Get size of Z, C, T, P
r = bfGetReader(fullfilepath);
sizeZ = r.getSizeZ();
sizeT = r.getSizeT();
sizeC = r.getSizeC();
sizeP = sizeZ*sizeT*sizeC;         % because total frame/plane = Z*T*C

RAWxyzt = struct;                  % I like using struct array with field name (in MATLAB)

if ~exist('skipT', 'var') || skipT < 0 || sizeZ <2
    skipT = 0;
end
% ---------------------------------------
% Store different colours separately
for c = 1:sizeC                                          
    fields= strcat('colour', num2str(c));
    data = cell([sizeP/sizeC, 1]);
    mergdata = zeros([sizeY sizeX sizeZ], 'uint16');
    
% IMPORTANT!  e.g.  item    C   Z  T  
% Order is CZT,       1     1   1  1
%                     2     1   2  1
% so first frame of   3     1   1  2
% next colour start   4     1   2  2
% after particular    5     2   1  1
% cycle/fold          6     2   2  1
%                     7     2   1  2
%                     8     2   2  2
% so 'fold' is used for next colour
    fold = (c-1)*sizeP/sizeC;               
    for i = 1:sizeP/sizeC
        data{i} = (OmeTiff{1,1}{i+(1*fold),1});
        
        % remainder after divison for Z
        z = rem(i,sizeZ);
        if z == 0
            z = sizeZ;
        end
        mergdata(:,:,z) = data{i};

        % quotient after divison for T
        t = i/sizeZ;
        if fix(t) == t
            RAWxyzt(t).(fields) = mergdata;
        else
        end
    end
end

% decide colour inversion
RawMed = median(mergdata(:,:,1), 'all');
InvMed = median(imcomplement(mergdata(:,:,1)),'all');
InverColour = RawMed > InvMed;

% clear t i z c fold r 
clear data fields mergdata

%% save individual colour(channel) as single file

% do the step for different colours
for c = 1:sizeC 
    fields= strcat('colour', num2str(c));
    clear matdata
    matdata = zeros([sizeY sizeX sizeZ sizeT-skipT], 'uint16');     % for conversion from struct to matrix

    % struct to matrix
    for t = 1 :size(matdata,4)
        matdata(:,:,:,t) = RAWxyzt(t+skipT).(fields);
    end
    % define output name
    colstr = strcat('c', num2str(c)); 
    idx = strfind (filename, '.o');
    output = strcat (colstr, '\', filename(1:idx-1),'_', colstr, '.tiff');
    outputpath = strcat (filepath, output);
    tic;
        
% opts_tiff.append = true;
% opts_tiff.big = true;

    % if your system export ome.tiff with white background and you want
    % black background, use B to convert to black background   
    switch InverColour
            case 0
                bfsave(uint16((matdata)), outputpath, 'XYZTC');              % --- no inversion of colour
%                     saveastiff(uint16(matdata), outputpath, opts_tiff);
            case 1
                bfsave(uint16(imcomplement(matdata)), outputpath,'XYZTC');   % --- do inversion of colour
%                     saveastiff(uint16(imcomplement(matdata)), outputpath, opts_tiff);
    end
    toc;
end

end