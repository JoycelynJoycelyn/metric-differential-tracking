function g = gD( f, scale, ox, oy )
% gD - Gaussian (Derivative) Convolution
% usage: out = gD(im, scale, ox, oy)
%
% inputs:
%  im    - image to convolve with Gaussian derivative kernel.
%  scale - the scale (sigma) of the Gaussian to use.
%  ox    - order of differentiation in the x direction.
%  oy    - order of differentiation in the y direction.
        K = ceil( 3 * scale );
        x = -K:K;
        Gs = exp( - x.^2 / (2*scale^2) );
        Gs = Gs / sum(Gs);
        Gsx = gDerivative( oy, x, Gs, scale );
        Gsy = gDerivative( ox, x, Gs, scale );
        g = convSepBrd( f, Gsx, Gsy );
return

function r = gDerivative( order, x, Gs, scale )
    switch order
      case 0
        r = Gs;
      case 1
        r = -x/(scale^2) .* Gs;
      case 2
        r = (x.^2-scale^2)/(scale^4) .* Gs;
      otherwise
        error('only derivatives up to second order are supported');
    end
return
