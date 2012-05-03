function T = writeVideo( T )
    if(~isfield(T.outputCreator,'video'))
        T.outputCreator.video = VideoWriter('output.avi',);
        T.outputCreator.video.FrameRate = T.fps;
        open(T.outputCreator.video);
    end
    fr = getframe;
    writeVideo(T.outputCreator.video,fr);

return

