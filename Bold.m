classdef Bold < handle
    properties
        LineWidth      (1,1) double = 2   % Default line width
        AxisLabelSize  (1,1) double = 16  % Default font size for x/y/z labels
        TitleSize      (1,1) double = 18  % Default font size for titles
        TickLabelSize  (1,1) double = 14  % Default font size for axes ticks
    end
    
    methods
        % Constructor with optional Name-Value inputs
        function obj = Bold(varargin)
            p = inputParser;
            addParameter(p, 'LineWidth', obj.LineWidth, @isnumeric);
            addParameter(p, 'AxisLabelSize', obj.AxisLabelSize, @isnumeric);
            addParameter(p, 'TitleSize', obj.TitleSize, @isnumeric);
            addParameter(p, 'TickLabelSize', obj.TickLabelSize, @isnumeric);
            
            parse(p, varargin{:});
            
            % Assign values to the class instance properties
            obj.LineWidth     = p.Results.LineWidth;
            obj.AxisLabelSize = p.Results.AxisLabelSize;
            obj.TitleSize     = p.Results.TitleSize;
            obj.TickLabelSize = p.Results.TickLabelSize;
        end
        
        % The core method to transform the graph
        function old(obj)
            % Target the current active figure
            fig = gcf; 
            
            % 1. Find and bold the basic graphical axes containers
            allAxes = findall(fig, 'Type', 'axes');
            for i = 1:numel(allAxes)
                ax = allAxes(i);
                ax.FontSize = obj.TickLabelSize;
                ax.FontWeight = 'bold'; % Emboldens tick labels & outer bounding box
                
                % Explicitly bold the structural text elements
                ax.Title.FontSize = obj.TitleSize;
                ax.Title.FontWeight = 'bold';
                
                ax.XLabel.FontSize = obj.AxisLabelSize;
                ax.XLabel.FontWeight = 'bold';
                
                ax.YLabel.FontSize = obj.AxisLabelSize;
                ax.YLabel.FontWeight = 'bold';
                
                ax.ZLabel.FontSize = obj.AxisLabelSize;
                ax.ZLabel.FontWeight = 'bold';
            end
            
            % 2. Dynamic discovery of graphical data traces
            % Broadly targets primitive lines, stems, stairs, xline, yline, and chart lines
            typesToBold = {'line', 'stair', 'stem', 'chartline', 'constantline'};
            
            for t = 1:numel(typesToBold)
                foundObjects = findall(fig, 'Type', typesToBold{t});
                for j = 1:numel(foundObjects)
                    item = foundObjects(j);
                    
                    % Safe property modification for objects containing a LineWidth property
                    if isprop(item, 'LineWidth')
                        item.LineWidth = obj.LineWidth;
                    end
                    
                    % Special case for stem objects: also enlarge the baseline and marker points
                    if strcmp(typesToBold{t}, 'stem')
                        if isprop(item, 'MarkerSize') && item.MarkerSize < (obj.LineWidth * 3)
                            item.MarkerSize = obj.LineWidth * 3; 
                        end
                        if isprop(item, 'BaseLine') && isvalid(item.BaseLine)
                            item.BaseLine.LineWidth = max(1.5, obj.LineWidth - 1);
                        end
                    end
                end
            end
            
            % 3. Bold the sgtitle (super title) if it exists
            sgTitleObj = findobj(fig, 'Type', 'text', '-and', 'Tag', 'sgtitle');
            if ~isempty(sgTitleObj)
                sgTitleObj.FontSize = obj.TitleSize; % Set font size
                sgTitleObj.FontWeight = 'bold';     % Set font weight
            end
        end
    end
end
