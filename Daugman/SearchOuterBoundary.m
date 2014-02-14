% 
% Search for the outer (limbus) boundary of the iris, using the result
% for the inner (pupillary) boundary, as well as stadistincs in 
% (Daugman 2004), to reduce the search space.
% Author: J. Rouces
%
function [outer_y outer_x outer_r] = SearchOuterBoundary(imagen, inner_y, inner_x, inner_r)

%fprintf(1,'Searching for outer boundary of the iris \n');

% INTEGRODIFFERENTIAL OPERATOR
maxdispl = round(inner_r*0.15); % very maximum displacement 15% (Daugman 2004)
minrad = round(inner_r/0.8); maxrad = round(inner_r/0.3); %0.1-0.8 (Daugman 2004)
hs = zeros(2*maxdispl,2*maxdispl,maxrad-minrad); % Hough Space (y,x,r)
intreg = [2/6 4/6; 8/6 10/6]*pi; % integration region, avoiding eyelids
%intreg = [1/4 3/4; 5/4 7/4]*pi;
integrationprecision = 0.05; % resolution of the circular integration
angs = [intreg(1,1):integrationprecision:intreg(1,2) intreg(2,1):integrationprecision:intreg(2,2)];
for x = 1:size(hs,2)
    for y = 1:size(hs,1)
        for r = 1:size(hs,3)
            hs(y,x,r) = ContourIntegralCircular(imagen,...
                inner_y-maxdispl+y, inner_x-maxdispl+x, minrad+r, angs);
        end
    end
    %fprintf(1,'column : %d\n',x)
    %fprintf(1,'.');
end
%fprintf(1,'\n');
hspdr = hs-hs(:,:,[1,1:size(hs,3)-1]); % Hough Space Partial Derivative R

% BLURRING
sm = 7; % size of the blurring mask
hspdrs = convn(hspdr,ones(sm,sm,sm),'same');

[maxim indmax] = max(hspdrs(:));
[y,x,r] = ind2sub(size(hspdrs),indmax);
outer_y = inner_y - maxdispl + y;
outer_x = inner_x - maxdispl + x;
outer_r = minrad + r - 1;


