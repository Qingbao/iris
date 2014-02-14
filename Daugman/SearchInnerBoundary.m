% 
% Search for the inner (pupillary) boundary of the iris.
% Author: J. Rouces
%
function [inner_y inner_x inner_r] = SearchInnerBoundary(imagen)

%fprintf(1,'Searching for inner boundary of the iris \n');

% INTEGRODIFFERENTIAL OPERATOR COARSE (jump-level precision)
Y = size(imagen,1);
X = size(imagen,2);
sect = X/4; % SECTor. Width of the external margin for which search is excluded
minrad = 10;
maxrad = sect*0.8;
jump = 4; % precision of the coarse search, in pixels
hs = zeros(...
    floor((Y-2*sect)/jump),...
    floor((X-2*sect)/jump),...
    floor((maxrad-minrad)/jump)); % Hough Space (y,x,r)
integrationprecision = 1; % resolution of the circular integration
angs = 0:integrationprecision:(2*pi);
for x = 1:size(hs,2)
    for y = 1:size(hs,1)
        for r = 1:size(hs,3)
            hs(y,x,r) = ContourIntegralCircular(imagen,...
                sect+y*jump, sect+x*jump, minrad+r*jump, angs);
        end
    end
    %fprintf(1,'column : %d\n',x);
    %fprintf(1,'.');
end
%fprintf(1,'\n');
hspdr = hs-hs(:,:,[1,1:size(hs,3)-1]); % Hough Space Partial Derivative R

% BLURRING
sm = 3; % size of the blurring mask
hspdrs = convn(hspdr,ones(sm,sm,sm),'same');

[maxim indmax] = max(hspdrs(:));
[y,x,r] = ind2sub(size(hspdrs),indmax);
inner_y = sect + (y)*jump;
inner_x = sect + (x)*jump;
inner_r = minrad + (r-1)*jump;


% INTEGRODIFFERENTIAL OPERATOR FINE (pixel-level precision)
%jump = jump*2;
hs = zeros(jump*2,jump*2,jump*2); % Hough Space (y,x,r)
integrationprecision = 0.1; % resolution of the circular integration
angs = 0:integrationprecision:(2*pi);
for x = 1:size(hs,2)
    for y = 1:size(hs,1)
        for r = 1:size(hs,3)
            hs(y,x,r) = ContourIntegralCircular(imagen,...
                inner_y-jump+y, inner_x-jump+x, inner_r-jump+r, angs);
        end
    end
    %fprintf(1,'column : %d\n',x);
    fprintf(1,'.');
end
fprintf(1,'\n');
hspdr = hs-hs(:,:,[1,1:size(hs,3)-1]); % Hough Space Partial Derivative R

% BLURRING
sm = 3; % size of the blurring mask
hspdrs = convn(hspdr,ones(sm,sm,sm),'same');

[maxim indmax] = max(hspdrs(:));
[y,x,r] = ind2sub(size(hspdrs),indmax);
inner_y = inner_y-jump+y;
inner_x = inner_x-jump+x;
inner_r = inner_r-jump+r-1;







% hs = zeros(Y-2*sect,X-2*sect,sect-minrad); % Hough Space (y,x,r)
% jump = 1;
% for x = 1:jump:size(hs,2)
%     for y = 1:jump:size(hs,1)
%         for r = 1:jump:size(hs,3)
%             hs(y,x,r) = ContourIntegralCircular(imagen,...
%                 y+sect, x+sect, minrad+r, 0.5);
%         end
%         %fprintf(1,'+ \n')
%     end
%     fprintf(1,'column : %d\n',x)
% end
% hspdr = hs-hs(:,:,[1,1:size(hs,3)-1]); % Hough Space Partial Derivative R
% toc
% 
% % BLURRING
% tic
% hspdrs = convn(hspdr,ones(3,3,3),'same');
% toc
% 
% [maxim indmax] = max(hspdrs(:));
% [y,x,r] = ind2sub(size(hspdrs),indmax);
% inner_y = sect + y
% inner_x = sect + x
% inner_r = minrad + r










%sigma = 2;
%[gaussX, gaussY, gaussZ] = meshgrid(-sigma:sigma,-sigma:sigma,-sigma:sigma);
%mu = [0 0 0];
%sd = eye(3)*(sigma-1);
%gauss = mvnpdf([gaussX(:) gaussY(:) gaussZ(:)],mu,sd);
%gauss = reshape(gauss,length(gaussX),length(gaussY), length(gaussZ));
%mesh(gauss);


