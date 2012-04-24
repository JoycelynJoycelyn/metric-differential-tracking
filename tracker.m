function T = tracker(fname, gamma, tau, radius)
% KALMAN_TRACKER - A zero-order Kalman filter tracker.
%
% KALMAN_TRACKER(fname, g, tau, r) runs the tracker on video
% specified by fname, with background subtraction parameters g, tau
% and radius.
%
% Inputs:
%  fname   - filename of video to process.
%  gamma   - gamma parameter for background subtraction.
%  tau     - tau parameter for backgroun subtraction.
%  radius  - radius for closing in background subtraction.

% Initialize background model parameters
Segmenter.gamma   = gamma;
Segmenter.tau     = tau;
Segmenter.radius  = radius;
Segmenter.segment = @background_subtractor;

% Recognizer and representer is a simple blob finder.
% Recognizer.recognize = @find_blob;
% Representer.represent = @filter_blobs;
% 
% % The tracker module.
% Tracker.H          = eye(6);        % System model , remain the identity
% Tracker.Q          = 0.5 * eye(6);  % System noise
% Tracker.F          = eye(6);        % Measurement model
% Tracker.R          = 5 * eye(6);    % Measurement noise
% Tracker.innovation = 0;
% Tracker.track      = @kalman_step;
% % The tracke module for Particle filter
% %Tracker.A          = eye(6);
% %Tracker.track      = @particle_step;
% 
% 
% % A custom visualizer for the Kalman state.
% Visualizer.visualize = @visualize_kalman;
% Visualizer.paused    = false;
% 
% % Set up the global tracking system.
%---------------------------------------------------------------
%interessa al momento solo il segmenter, poi si aggiunge anche il tracker
T.segmenter   = Segmenter;
vr = videoReader(fname);

T.time         = 0;
T.frame_number = 0;
T.fps          = getfield(get(vr), 'FrameRate');
T.num_frames   = getfield(get(vr), 'NumberOfFrames');

while nextFrame(vr)
  T.frame_number = T.frame_number + 1;
  frame = getFrame(vr);

  if isfield(T, 'segmenter')
    T = T.segmenter.segment(T, frame);
  end
  
    T.time = T.time + 1/T.fps
    
    
end

%---------------------------------------------------------------
% T.recognizer  = Recognizer;
% T.representer = Representer;
% T.tracker     = Tracker;
% T.visualizer  = Visualizer;
% 
% % And run the tracker on the video.
% run_tracker(fname, T);
return
