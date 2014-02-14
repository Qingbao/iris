% ADJGAMMA - Adjusts image gamma.
%
% function g = adjgamma(im, g)
%
% Arguments:
%            im     - image to be processed.
%            g      - image gamma value.
%                     Values in the range 0-1 enhance contrast of bright
%                     regions, values > 1 enhance contrast in dark
%                     regions. 

% Author: Peter Kovesi
% Department of Computer Science & Software Engineering
% The University of Western Australia
% pk@cs.uwa.edu.au     www.cs.uwa.edu.au/~pk
% July 2001

function newim = adjgamma(im, g)

    if g <= 0
	error('Gamma value must be > 0');
    end

    if isa(im,'uint8');
	newim = double(im);
    else 
	newim = im;
    end
    	
    % rescale range 0-1
    newim = newim-min(min(newim));
    newim = newim./max(max(newim));
    
    newim =  newim.^(1/g);   % Apply gamma function


