function twimshow_PingYen(z, cmap, datasetNames, curImInd)
% modified by Yu-Wei with plotTrace function
%
    link_cmaps = false;
    
    if ~iscell(z), z={z}; end
    
    if ~exist('cmap','var') || isempty(cmap)
         cmap{1}= [];
    elseif ~iscell(cmap)
        cmap= {cmap};
    end
    
    if (numel(cmap)==1), link_cmaps = true; end
    
    for m =1:numel(cmap)
        if isempty(cmap{m})
            cmap{m} = [min(z{m}(:)) max(z{m}(:))];
        end
    end
    
    if ~exist('datasetNames','var'), datasetNames=[]; end;
    % fill in missing names with dataset indecies
    for k=(numel(datasetNames)+1):numel(z); 
        datasetNames{k} = num2str(k);
    end
        
    if ~exist('curImInd','var'), curImInd = 1; end
    prevImInd = 1;
    hImage = [];
    hTitle = [];
    curFrameInd =1;
    SetCurrentImage(curImInd);

    set(gcf, 'WindowKeyPressFcn',@KeyPress_proc);

    function KeyPress_proc(src,evnt)
        switch evnt.Key 
            case{'t'}
                SetCurrentImage(curImInd+1);
            case{'rightarrow'}
                SetCurrentFrame(curFrameInd+1);
            case{'leftarrow'}
                SetCurrentFrame(curFrameInd-1);
            case{'c'}
                imcontrast
            case{'r'}
                impixelregion
            case{'o'} % plot original traces(singal pixel) from multiple movie
                plotTrace(z,0,1)            
            case{'a'} % plot 5*5 'average' traces from multiple movie
                plotTrace(z,1,1)
            case{'g'} % plot 7*7 'gaussian' traces from multiple movie
                plotTrace(z,2,1)
            case{'m'} % plot 5*5 'average' traces from multiple points of the first movie
                plotTrace(z,1,0)
            case{'1','2','3','4','5','6','7','8','9','0'}
                ind=str2double(evnt.Character);
                if ind==0, ind=10; end
                if ind <= numel(z), SetCurrentImage(ind); end
            case{'w'}
                ind=curImInd+1;
                SetCurrentImage(ind);
%                 if ind > numel(z), SetCurrentImage(1); end
            case{'q'}
                ind=curImInd-1;
%                 if ind <=1, ind =1; end
                SetCurrentImage(ind);
%                 if ind <= numel(z), SetCurrentImage(1); end
        end
    end
    function SetCurrentImage(imIndex)
        if imIndex > numel(z), imIndex =1; end
        if imIndex < 1, imIndex = numel(z); end
        prevImInd = curImInd;    
        curImInd = imIndex;
        
        if ~link_cmaps && ~isempty(hImage)
            cmap{prevImInd} = get(gca,'CLim');
            set(gca,'CLim',cmap{curImInd});  
        end
        
        displayimage;
    end
    function SetCurrentFrame(frameInd)
        if frameInd > size(z{curImInd},3) 
            frameInd = 1; 
        elseif frameInd < 1
            frameInd = size(z{curImInd},3); 
        end
        curFrameInd = frameInd;
        displayimage;
    end
    function displayimage
        titleString = sprintf('%s Frame:%d', datasetNames{curImInd},curFrameInd);
        if isempty(hImage)
%             fig1 = uifigure('Position',[580,150,900,800]);
%             pan1 = uipanel('Parent', fig1 'Position',[580,150,900,800]);
%             ax1 = uiaxes('Parent', pan1);

            figure('Position',[580,150,900,800]);
            hImage = imshow(z{curImInd}(:,:,curFrameInd), cmap{curImInd});
            hTitle = title(titleString, 'FontSize', 18);
            return;
        end
        
        set(hImage, 'CData',z{curImInd}(:,:,curFrameInd));
        set(hTitle,'String', titleString);

    end 

    hSB = uicontrol('Parent',gcf,'Position',[60, 25, 500, 20],...
        'Style', 'Slider', 'Tag', 'FrameSlide',...
        'Value',curFrameInd, 'Min', 1 , 'Max', size(z{curImInd},3), ...
        'SliderStep', [1/(size(z{curImInd},3)-1), 1/(size(z{curImInd},3)-1)], 'Callback',{@sldchanged});
    function sldchanged(hSB,eventdata)
        frameInd = floor(get(hSB,'Value'));
        SetCurrentFrame(frameInd);
    end

%%% uislider cannot directly use on figure object;
%%% and uicontrol style slider does not support ValueChangingFcn, 
%%% how can I do it?

%     hSB = uislider('Parent',gcf,'Position',[50, 50, 500, 20],...
%         'Tag', 'FrameSlide', 'Value',curFrameInd,...
%         'Limits', [ 1 , size(z{curImInd},3)], 'ValueChangingFcn',{@sldchanged});
    addlistener(hSB, 'Value', 'PostGet', @sldchanged);
%     function sldchanged(src,eventdata)
%         frameInd = floor(get(src,'Value'));
%         SetCurrentFrame(frameInd);
%     end




    function plotTrace(z,filter,mode)
    numFrames = size(z{1},3);
    [xx yy]=ginput;
    color = {'k','r','b','g','y','c','m','k','r','b','g','y','c','m'};
    m = numel(z);
%     F2 = figure;
    hold on
    for n = 1: numel(xx)
      x = uint16(xx(n));
      y = uint16(yy(n));
       switch filter
          case 0
              switch mode
                  case 0
                    plot(1:numFrames,squeeze(z{k}(y,x,:)),color{n});
                  case 1
                    for k = 1: m         
                    plot(1:numFrames,squeeze(z{k}(y,x,:)),color{k});
                    end
              end
          case 1
              H = fspecial('average',5);            
              switch mode
                  case 0
                      z1{1} = z{1}(y-3:y+3 , x-3:x+3, :);
                      z2{1} = imfilter(z1{1},H);             
                      plot(1:numFrames,squeeze(z2{1}(3,3,:)),color{n});
                  case 1
                      for k = 1: m
                      z1{k} = z{k}(y-3:y+3 , x-3:x+3, :);
                      z2{k} = imfilter(z1{k},H);             
                      plot(1:numFrames,squeeze(z2{k}(3,3,:)),color{k});
                      end
              end
          case 2
              H = fspecial('gaussian',7,1);
              switch mode
                  case 0
                      z1{1} = z{1}(y-5:y+5 , x-5:x+5, :);
                      z2{1} = imfilter(z1{1},H);             
                      plot(1:numFrames,squeeze(z2{1}(5,5,:)),color{n});
                  case 1
                      for k = 1: m
                        z1{k} = z{k}(y-5:y+5 , x-5:x+5, :);
                        z2{k} = imfilter(z1{k},H);             
                        plot(1:numFrames,squeeze(z2{k}(5,5,:)),color{k});
                      end      
              end
       end
    end
    hold off
    end
end