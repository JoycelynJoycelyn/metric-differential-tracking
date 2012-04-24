function T = mean_track(T, frame)
% FILTER_BLOBS - simple representer of targets as largest foreground bounding box.
%
% NOTE: This function is intended to be run as a REPRESENTER in the
% tracking framework.  See documentation for RUN_TRACKER.
%
% FILTER_BLOBS(T, frame) will represent the measurement for the
% frame in image 'frame' as the bounding box of the largest
% detected blob in the foreground of the frame.
%
% Parameters used from T.recognizer:
%  T.recognizer.blobs - the blobs detected in the foreground of frame.
% 
% Inputs:
%  T     - tracker state structure.
%  frame - image to process.
% 
% See also: run_tracker

% Make sure at least one blob was recognized
%if sum(sum(T.recognizer.blobs))
  % Extract the BoundingBox and Area of all blobs
%   R = regionprops(T.recognizer.blobs, 'BoundingBox', 'Area');
%   Rb = regionprops(T.recognizer.blobs, 'BoundingBox');
%   
  % And only keep the biggest one
  %[I, IX] = max([R.Area]);
  %T.representer.BoundingBox = R(IX(size(IX,2))).BoundingBox;
  
  %save all buonding boxes
%  T.representer.BoundingBoxes = Rb;
  
  %calculate all candidate histograms and the distances if there is already
  %a q (i.e. a target to track)
  if isfield(T,'target')

      %calcolo della distribuzione p (candidate distribution)
      subIm = imcrop(frame, T.target.BB_p);

      T.target.subIm = im2double(subIm);
      T.target.subIm = T.target.subIm / 255.0;
      T.target.p = get_histogram_feature(T.target.subIm, T.target.BB_p, 225);%, T.target.i_c, T.target.j_c);


      %optimal displacement to calculate (delta_c)
      T.target.dc = get_dc(T);
      T.target.dc
      %update centre and bounding box
      %T.target.i_c = T.target.i_c + T.target.dc(1);
      %T.target.j_c = T.target.j_c + T.target.dc(2);
      T.target.BB_p(1) = T.target.BB_p(1) - T.target.dc(1);
      T.target.BB_p(2) = T.target.BB_p(2) - T.target.dc(2);
  
  end

%end
return