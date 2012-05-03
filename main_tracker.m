function T = main_tracker(fname)%, gamma, tau, radius)

Representer.represent = @track;

% A custom visualizer for the Kalman state.
Visualizer.visualize = @visualize;
Visualizer.paused    = false;

<<<<<<< HEAD
OutputCreator.write = @writeVideo;

% Set up the global tracking system.
%T.segmenter   = Segmenter;
%T.recognizer  = Recognizer;
=======
>>>>>>> 8d315118d7b502a7f02fba4aefd3e761e68d3500
T.representer = Representer;
T.visualizer  = Visualizer;
T.outputCreator = OutputCreator;

% And run the tracker on the video.
run_tracker(fname, T);
return
