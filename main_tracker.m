function T = main_tracker(fname)%, gamma, tau, radius)

Representer.represent = @track;

% A custom visualizer for the Kalman state.
Visualizer.visualize = @visualize;
Visualizer.paused    = false;

T.representer = Representer;
T.visualizer  = Visualizer;

% And run the tracker on the video.
run_tracker(fname, T);
return
