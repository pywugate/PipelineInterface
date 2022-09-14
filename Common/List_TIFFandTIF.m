function tifflist = List_TIFFandTIF (varargin)
    rootdir  = uigetdir( 'select root folder');
    if isempty(dir(rootdir))
        error('Invalid folder path.')
    end
    s = dir (fullfile(rootdir, '**\*.tif*'));

    switch nargin
        case 0
            exclu ={};
            inclu ={}; 
        case 1
            if contains (inputname(1), 'exclu')
                fprintf ('inputname contains   "exclu" %s \n', contains (inputname(1), 'exclu'))
                exclu = varargin{1};
                inclu ={}; 
            elseif contains (inputname(1), 'inclu')
                fprintf ('inputname contains  "inclu" %s \n', contains (inputname(1), 'inclu'))
                exclu ={};
                inclu = varargin{1};
            else   % ~contains (inputname(1), {'exclu', 'inclu'})
                error("please set input argument: exclusion/inclusion = {'**\*.xxx*'}");
            end
        case 2
            if contains (inputname(1), 'exclu') && contains (inputname(2), 'inclu')
                exclu = varargin{1};
                inclu = varargin{2};
            elseif contains (inputname(2), 'exclu') && contains (inputname(1), 'inclu')
                exclu = varargin{2};
                inclu = varargin{1};
            else
                error("please set input argument: exclusion/inclusion = {'**\*.xxx*'}");
            end
    end
  
    if ~isempty (exclu)
        if ~iscell (exclu)
            error ("Input must be a cell array. example: {'.ext1', 'name1.ext2'}");
        else
            idx = ~contains ({s.name}, exclu);
            s = s(idx);
        end
    end
    if ~isempty(inclu)
        if ~iscell (inclu)
          error ("Input must be a cell array. example: {'.ext1', 'name1.ext2'}");
        else
            idx= contains ({s.name}, inclu);
            s = s(idx);
        end
    end
            
    tifflist = s;
    
    clear rootdir str s idx
end