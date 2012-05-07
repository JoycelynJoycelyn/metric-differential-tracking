function T = run_tracker(fname, T)
vr = videoReader(fname);

T.time         = 0;
T.frame_number = 0;
T.fps          = getfield(get(vr), 'FrameRate');
T.num_frames   = getfield(get(vr), 'NumberOfFrames');

while nextFrame(vr)
  
  T.frame_number = T.frame_number + 1;
  frame = getFrame(vr);
  
  if T.frame_number == 2
      %T.target.BB_q = [ 58 256   25   25 ];
      T.target.BB_q = [ 30 30 25 25 ];
      %T.target.BB_q
      T.target.BB_p = T.target.BB_q;
      T.target.subIm = im2double(imcrop(frame, T.target.BB_q));
      rectangle('Position', T.target.BB_q, 'EdgeColor', 'b');
      drawnow;
      pause(10);
      T = train(frame,T.target.BB_q, 15, 15, T);
      T.target.q = get_histogram_feature(T.target.subIm, T.target.BB_q, 225);
      
      T.target.pos_feature_tot = [];
      T.target.neg_feature_tot = [];
          
  end
  
  if isfield(T, 'representer')
    T = T.representer.represent(T, frame);
  end
    
   if isfield(T, 'visualizer')
     T = T.visualizer.visualize(T, frame);
   end
   
   if isfield(T,'outputCreator')
     T = T.outputCreator.write(T);
   end
  T.time = T.time + 1/T.fps

end
close(T.outputCreator.video);
return
