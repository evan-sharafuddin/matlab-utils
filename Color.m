classdef Color

    properties

        color_values
    
    end

    methods

        function obj = Color()
            obj.color_values = orderedcolors("gem");
        end

        function c = olor(obj, idx, alpha)
            if nargin == 3
                c = [obj.color_values(idx,:) alpha];
            else    
                c = obj.color_values(idx,:);
            end
        end

        function [] = show(obj)
            figure
            imshow( reshape(obj.color_values, 1, [], 3))
        end

    end

end