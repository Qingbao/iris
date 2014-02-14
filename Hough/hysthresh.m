% HYSTHRESH - Hysteresis thresholding
%
% Usage: bw = hysthresh(im, T1, T2)
%
% Arguments:
%             im  - image to be thresholded (assumed to be non-negative)
%             T1  - upper threshold value
%             T2  - lower threshold value
%
% Returns:
%             bw  - the thresholded image (containing values 0 or 1)
%
% Function performs hysteresis thresholding of an image.
% All pixels with values above threshold T1 are marked as edges
% All pixels that are adjacent to points that have been marked as edges
% and with values above threshold T2 are also marked as edges. Eight
% connectivity is used.
%
% It is assumed that the input image is non-negative
%
% Peter Kovesi          December 1996  - Original version
%                       March    2001  - Speed improvements made (~4x)

%
% A stack (implemented as an array) is used to keep track of all the
% indices of pixels that need to be checked.
% Note: For speed the number of conditional tests have been minimised
% This results in the top and bottom edges of the image being considered to
% be connected.  This may cause some stray edges to be propagated further than 
% they should be from the top or bottom.
%


function bw = hysthresh(im, T1, T2)

if (T2 > T1 | T2 < 0 | T1 < 0)  % Check thesholds are sensible
  error('T1 must be >= T2 and both must be >= 0 ');
end

[rows, cols] = size(im);    % Precompute some values for speed and convenience.
rc = rows*cols;
rcmr = rc - rows;
rp1 = rows+1;

bw = im(:);                 % Make image into a column vector
pix = find(bw > T1);        % Find indices of all pixels with value > T1
npix = size(pix,1);         % Find the number of pixels with value > T1

stack = zeros(rows*cols,1); % Create a stack array (that should never
                            % overflow!)

stack(1:npix) = pix;        % Put all the edge points on the stack
stp = npix;                 % set stack pointer
for k = 1:npix
    bw(pix(k)) = -1;        % mark points as edges
end


% Precompute an array, O, of index offset values that correspond to the eight 
% surrounding pixels of any point. Note that the image was transformed into
% a column vector, so if we reshape the image back to a square the indices 
% surrounding a pixel with index, n, will be:
%              n-rows-1   n-1   n+rows-1
%
%               n-rows     n     n+rows
%                     
%              n-rows+1   n+1   n+rows+1

O = [-1, 1, -rows-1, -rows, -rows+1, rows-1, rows, rows+1];

while stp ~= 0            % While the stack is not empty
    v = stack(stp);         % Pop next index off the stack
    stp = stp - 1;
    
    if v > rp1 & v < rcmr   % Prevent us from generating illegal indices
			    % Now look at surrounding pixels to see if they
                            % should be pushed onto the stack to be
                            % processed as well.
       index = O+v;	    % Calculate indices of points around this pixel.	    
       for l = 1:8
	   ind = index(l);
	   if bw(ind) > T2   % if value > T2,
	       stp = stp+1;  % push index onto the stack.
	       stack(stp) = ind;
	       bw(ind) = -1; % mark this as an edge point
	   end
       end
    end
end



bw = (bw == -1);            % Finally zero out anything that was not an edge 
bw = reshape(bw,rows,cols); % and reshape the image
