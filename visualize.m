function T = visualize(T, frame)
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

% Draw the current measurements (all BoundingBoxes) in red.
 if isfield(T, 'target')
     %draw q
     %rectangle('Position', T.target.BB_q, 'EdgeColor', 'b');
     %draw p
     rectangle('Position', T.target.BB_p, 'EdgeColor', 'g');
     
 end

drawnow;

% If we're paused, wait (but draw).
 %while (getappdata(gcf, 'paused'))
%  if (getappdata(gcf, 'paused'))
%     drawnow;
%     %[subIm rect]  = imcrop(frame);
%     rect = getrect;
%     subIm  = imcrop(frame, rect);
%     T.target.subIm = im2double(subIm);
%     T.target.subIm = T.target.subIm;
%     %chiamo la funzione train per il calcolo della matrice A
%     T.target.A = train(frame,rect, 15, 15);
%     %T.target.A = [eye(50) zeros(50,175)];
%     %T.target.A = eye(225) ;
%     
%     T.target.q = get_histogram_feature(T.target.subIm, rect, 225);%, i_c, j_c);
%     T.target.BB_q = rect;
%     
%     
%     %leva la pausa dopo il crop
%     setappdata(gcf, 'paused', false);
% 
%  end
return

% This is a callback function that toggles the pause state.
function pauseHandler(a, b, h)
    %se in pausa, con ogni tasto, riparte
    %setappdata(h, 'paused', xor(getappdata(h, 'paused'), true));

return

