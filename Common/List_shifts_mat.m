function shiftslist = List_shifts_mat (varargin)
%     rootdir  = uigetdir( 'select root folder');

%     if isempty(dir(rootdir))
%         error('Invalid folder path.')
%     end
%     s = dir (fullfile(rootdir, '**\*shifts.mat*'));
            exclu ={};
            inclu ={};
    switch nargin
        case 0
            error("please set input");
%             exclu ={};
%             inclu ={};
%             rootdir  = uigetdir( 'select root folder');
%             if isempty(dir(rootdir))
%                  error('Invalid folder path.')
%             end
%             s = dir (fullfile(rootdir, '**\*shifts.mat*'));
        case 1
            if contains (inputname(1), 'exclu')
%                 fprintf ('inputname contains   "exclu" %s \n', contains (inputname(1), 'exclu'))
                exclu = varargin{1};
%                 inclu ={}; 
            elseif contains (inputname(1), 'inclu')
%                 fprintf ('inputname contains  "inclu" %s \n', contains (inputname(1), 'inclu'))
%                 exclu ={};
                inclu = varargin{1};
            elseif contains(inputname(1), 'c2')
                rootdir = varargin{1};  
                s = dir (fullfile(rootdir, '**\*shifts.mat*'));
%                 exclu ={};
%                 inclu ={};
            else   % ~contains (inputname(1), {'exclu', 'inclu'})
                error("please set input argument: exclusion/inclusion = {'**\*.xxx*'}aaa");
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
            error ("Input must be a cell array. example: {'.xxx', '.yyy'}");
        else
            idx = ~contains ({s.name}, exclu);
            s = s(idx);
        end
    end
    if ~isempty(inclu)
        if ~iscell (inclu)
          error ("Input must be a cell array. example: {'.xxx', '.yyy'}");
        else
            idx= contains ({s.name}, inclu);
            s = s(idx);
        end
    end
            
    shiftslist = s;
    
    clear rootdir str s idx
end