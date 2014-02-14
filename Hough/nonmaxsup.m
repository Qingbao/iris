% NONMAXSUP
%
% Usage:
%          im = nonmaxsup(inimage, orient, radius);
%
% Function for performing non-maxima suppression on an image using an
% orientation image.  It is assumed that the orientation image gives 
% feature normal orientation angles in degrees (0-180).
%
% input:
%   inimage - image to be non-maxima suppressed.
% 
%   orient  - image containing feature normal orientation angles in degrees
%             (0-180), angles positive anti-clockwise.
% 
%   radius  - distance in pixel units to be looked at on each side of each
%             pixel when determining whether it is a local maxima or not.
%             (Suggested value about 1.2 - 1.5)
%
% Note: This function is slow (1 - 2 mins to process a 256x256 image).  It uses
% bilinear interpolation to estimate intensity values at ideal, real-valued pixel 
% locations on each side of pixels to determine if they are local maxima.
%
% Peter Kovesi     pk@cs.uwa.edu.au
% Department of Computer Science
% The University of Western Australia
%
% December 1996

function im = nonmaxsup(inimage, orient, radius)

if size(inimage) ~= size(orient)
  error('image and orientation image are of different sizes');
end

if radius < 1
  error('radius must be >= 1');
end

[rows,cols] = size(inimage);
im = zeros(rows,cols);        % Preallocate memory for output image for speed
iradius = ceil(radius);

% Precalculate x and y offsets relative to centre pixel for each orientation angle 

angle = [0:180].*pi/180;    % Array of angles in 1 degree increments (but in radians).
xoff = radius*cos(angle);   % x and y offset of points at specified radius and angle
yoff = radius*sin(angle);   % from each reference position.

hfrac = xoff - floor(xoff); % Fractional offset of xoff relative to integer location
vfrac = yoff - floor(yoff); % Fractional offset of yoff relative to integer location

orient = fix(orient)+1;     % Orientations start at 0 degrees but arrays start
                            % with index 1.

% Now run through the image interpolating grey values on each side
% of the centre pixel to be used for the non-maximal suppression.

for row = (iradius+1):(rows - iradius)
  for col = (iradius+1):(cols - iradius) 

    or = orient(row,col);   % Index into precomputed arrays

    x = col + xoff(or);     % x, y location on one side of the point in question
    y = row - yoff(or);

    fx = floor(x);          % Get integer pixel locations that surround location x,y
    cx = ceil(x);
    fy = floor(y);
    cy = ceil(y);
    tl = inimage(fy,fx);    % Value at top left integer pixel location.
    tr = inimage(fy,cx);    % top right
    bl = inimage(cy,fx);    % bottom left
    br = inimage(cy,cx);    % bottom right

    upperavg = tl + hfrac(or) * (tr - tl);  % Now use bilinear interpolation to
    loweravg = bl + hfrac(or) * (br - bl);  % estimate value at x,y
    v1 = upperavg + vfrac(or) * (loweravg - upperavg);

  if inimage(row, col) > v1 % We need to check the value on the other side...

    x = col - xoff(or);     % x, y location on the `other side' of the point in question
    y = row + yoff(or);

    fx = floor(x);
    cx = ceil(x);
    fy = floor(y);
    cy = ceil(y);
    tl = inimage(fy,fx);    % Value at top left integer pixel location.
    tr = inimage(fy,cx);    % top right
    bl = inimage(cy,fx);    % bottom left
    br = inimage(cy,cx);    % bottom right
    upperavg = tl + hfrac(or) * (tr - tl);
    loweravg = bl + hfrac(or) * (br - bl);
    v2 = upperavg + vfrac(or) * (loweravg - upperavg);

    if inimage(row,col) > v2            % This is a local maximum.
      im(row, col) = inimage(row, col); % Record value in the output image.
    end

   end
  end
end


