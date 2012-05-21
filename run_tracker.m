function T = run_tracker(fname, T)
vr = videoReader(fname);

%rng('default');
T.time         = 0;
T.frame_number = 0;
T.fps          = getfield(get(vr), 'FrameRate');
T.num_frames   = getfield(get(vr), 'NumberOfFrames');

while nextFrame(vr)
  subplot('Position',[0.1 0.35 0.85 0.6]);
  T.frame_number = T.frame_number + 1;
  frame = getFrame(vr);
  image(frame);
  
  if T.frame_number == 1
      %T.target.BB_q = [ 58 255   25   25 ];
      T.target.pos_feature_tot = [];
      T.target.neg_feature_tot = [];
      %T.target.BB_q = [ 31 31 24 24 ];
      if (isempty(T.target.BB_q)) 
        T.target.BB_q = getrect;
      end
      T.target.BB_q
      T.target.BB_q(3) = ceil(T.target.BB_q(3));
      T.target.BB_q(4) = ceil(T.target.BB_q(4));
      T.target.BB_q
      %pause();
      %T.target.BB_q
      T.target.BB_p = T.target.BB_q;
      T.target.subIm = im2double(imcrop(frame, T.target.BB_q));
      rectangle('Position', T.target.BB_q, 'EdgeColor', 'b');
      drawnow;
      %pause(10);
      T.target.K = get_K(T.target.subIm);
      T.target.J = get_J(T.target.subIm);
      T.target.q = get_histogram_feature(T, T.target.subIm, 225);
      T.target.G_hist = [];
      T = train(frame,T.target.BB_q, T.num_sample_positivi,T.num_sample_negativi, T);
          
  end
  
  if isfield(T, 'representer')
    T = T.representer.represent(T, frame);
  end 
    
%   if isfield(T, 'visualizer')
%     T = T.visualizer.visualize(T, frame);
%   end
   
  if isfield(T,'outputCreator')
    T = T.outputCreator.write(T);
  end 
   
  T.time = T.time + 1/T.fps

end
close(T.outputCreator.video);
return
