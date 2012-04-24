    function T = visualize(T, frame)
% VISUALIZE_KALMAN - a visualizer for a Kalman filter tracker.
%
% NOTE: This function is intended to be run as a VISUALIZER in the
% tracking framework.  See documentation for RUN_TRACKER.
%
% VISUALIZE_KALMAN(T, frame) displays the current image in 'frame',
% along with the measurement and current tracker estimate in a
% figure window.
%
% See also: kalman_tracker, run_tracker.

% Initialize the figure and setup pause callback.
if ~isfield(T.visualizer, 'init');
  figure;
  h = gcf;
  set(h, 'KeyPressFcn', {@pauseHandler, h});
  setappdata(h, 'paused', false);
  T.visualizer.init = true;
end

% Display the current frame.
image(frame);

% Draw the current measurement in red.
% if isfield(T.representer, 'BoundingBox')
%   rectangle('Position', T.representer.BoundingBox, 'EdgeColor', 'r');
% end

% Draw the current measurements (all BoundingBoxes) in red.
 if isfield(T, 'target')
     %draw q
     %rectangle('Position', T.target.BB_q, 'EdgeColor', 'r');
     %draw p
     rectangle('Position', T.target.BB_p, 'EdgeColor', 'g');
     
 end

% And the current prediction in green
% if isfield(T.tracker, 'm_k1k1');
%   rectangle('Position', T.tracker.m_k1k1, 'EdgeColor', 'g');
% end
drawnow;

% If we're paused, wait (but draw).
 %while (getappdata(gcf, 'paused'))
 if (getappdata(gcf, 'paused'))
    drawnow;
    %[subIm rect]  = imcrop(frame);
    rect = getrect;
    subIm  = imcrop(frame, rect);
    T.target.subIm = im2double(subIm);
    T.target.subIm = T.target.subIm / 255.0;
    %chiamo la funzione train per il calcolo della matrice A
    T.target.A = train(frame,rect);
    %T.target.A = [eye(50) zeros(50,175)];
    %T.target.A = eye(225) ;
    
%     i_c = round(rect(3)/2 + rect(1));
%     j_c = round(rect(4)/2 + rect(2));
    %calcola istogramma del target, q
    T.target.q = get_histogram_feature(T.target.subIm, rect, 225);%, i_c, j_c);
    
%     T.target.i_c = i_c;
%     T.target.j_c = j_c;
    T.target.BB_q = rect;
    T.target.BB_p = T.target.BB_q;
    
    %leva la pausa dopo il crop
    setappdata(gcf, 'paused', false);

 end
return

% This is a callback function that toggles the pause state.
function pauseHandler(a, b, h)
%se in pausa, con ogni tasto, riparte
setappdata(h, 'paused', xor(getappdata(h, 'paused'), true));

return

