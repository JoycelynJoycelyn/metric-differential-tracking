# Introduction #

A Matlab implementation of a tracking method that uses a learning method for the metric used. An initially learning phase was implemented. Then, a mean shift tracker with a modified version of the Matusita metric, that uses the output of the learning phase, was implemented.


# How to start it #

Use the _main\_tracker.m_ function with the name of the video in the parameters. When the video starts, use any key to stop it and select the rect region to be tracked. Then, the learning phase will start, and in a variable time the tracker will start.