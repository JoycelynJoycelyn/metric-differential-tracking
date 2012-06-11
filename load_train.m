function T = load_train(frame , obj_box, positive_sample, negative_sample,T)
    T.target.A_min = dlmread([T.fname '_A']);
    T.target.pos_feature_tot = dlmread([T.fname '_Pos_feat_tot']);
    T.target.neg_feature_tot = dlmread([T.fname '_Neg_feat_tot']);
    T.target.offset.pos = dlmread([T.fname '_Pos_off']);
    T.target.offset.neg = dlmread([T.fname '_Neg_off']);
    T.target.offset.neg_rect = dlmread([T.fname '_Neg_off_rect']);
    
    
    %T.target.pos_feature_tot = [ ];
    %T.target.neg_feature_tot = [ ];
     
    %T.target.G = G_vect(T.target.A, pos_feature',neg_feature');
    sample= [T.target.pos_feature_tot; T.target.neg_feature_tot];
    label = [ones(size(T.target.pos_feature_tot,1),1) zeros(size(T.target.pos_feature_tot,1),1); zeros(size(T.target.neg_feature_tot,1),1) ones(size(T.target.neg_feature_tot,1),1)];
    
    [T.target.F T.target.dF] =  nca_obj(T.target.A_min(:), sample, label);
    T.target.F = - T.target.F;
    
    T.target.F
   
    T.target.G = T.target.F;
    %pause();
    dat = [T.target.G; T.frame_number];
    T.target.G_hist = [T.target.G_hist dat];
    
    T.target.A = eye(216);
end

