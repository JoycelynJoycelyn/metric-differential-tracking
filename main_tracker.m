function T = main_tracker(fname)%, gamma, tau, radius)
T.do_train = 1;

% soglia intersezione esempi positivi e negativi
T.soglia_pos=0.8;
T.soglia_neg=0.3;
% numero di campioni per l'apprendimento
T.num_sample_positivi = 15;
T.num_sample_negativi = 55;
% numero nuovi campioni a ogni frame
T.campioni_pos_track = 5;
T.campioni_neg_track = 15;
% numero totale campioni per controllo di G(A)
T.tot_campioni_pos = 5;
T.tot_campioni_neg = 15;
%soglia per G(A)
T.threshold = 1.0e-2;
%inizializzazione BB

%box lemming
T.target.BB_q = [42  203   60   95];

%T.target.BB_q = [86  319  146.0000   46.0000];
%T.target.BB_q = [110  210  80  70];
%T.target.BB_q = [400   457    65    57];
%T.target.BB_q = [];



%random_offset_permutation = 0 fa prendere sempre gli stessi offset,
%altrimenti effettua una permutazioni degli indici per prendere gli
%offset in maniera casuale tra quelli usati nella fase di train
%
T.random_offset_permutation = 1;
%T.random_offset_permutation = 0;


Representer.represent = @track;

% A custom visualizer for the Kalman state.
Visualizer.visualize = @visualize;
Visualizer.paused    = false;

%<<<<<<< HEAD
OutputCreator.write = @writeVideo;

% Set up the global tracking system.
%T.segmenter   = Segmenter;
%T.recognizer  = Recognizer;
%=======
%>>>>>>> 8d315118d7b502a7f02fba4aefd3e761e68d3500
T.representer = Representer;
T.visualizer  = Visualizer;
T.outputCreator = OutputCreator;

% And run the tracker on the video.
run_tracker(fname, T);
return
