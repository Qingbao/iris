% 
% Performs contour (circular) integral with
% center x_0,y_0 and radius r, using discrete riemann approach.
% The angs parameter specifies region of the circle
% considering clockwise 0-2pi notation.
% Result not normalized.
% Author: J. Rouces
%
function sum = ContourIntegralCircular(imagen,y_0,x_0,r,angs)

% EXHAUSTIVE EXTENSIVE ALGORITHM
% rc = r^2;
% sum = 0;
% for x = max(1,x_0-r):min(size(imagen,2),x_0+r)
%     for y = max(1,y_0-r):min(size(imagen,1),y_0+r)
%         if abs((x-x_0)^2+(y-y_0)^2-rc)<2
%             sum = sum + imagen(y,x);
%         end
%     end
% end
% sum = sum/r;

% LIGHT ALGORITHM
sum = 0;
for ang = angs
    y = round(y_0-cos(ang)*r);
    x = round(x_0+sin(ang)*r);
    if y<1
        y = 1;
    elseif y>size(imagen,1)
        y = size(imagen,1);
    end
    if x<1
        x = 1;
    elseif x>size(imagen,2)
        x = size(imagen,2);
    end
    sum = sum + imagen(y,x);
end