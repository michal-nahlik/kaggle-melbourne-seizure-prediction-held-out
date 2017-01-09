function [X, XS] = features_to_vector(features,options)
%FEATURE_TO_VECTOR load data for a subject
% returns [X,Y,number of files, file names, features across channels (eigenvalues of channels correlation)] 

    SIGNAL_FEATURES = {'RHO_data_eig','RHO_freq_eig', 'RHO_dyad_eig'};

    N_channels = options.N_channels;
    N_features = options.N_features;

    X = nan(N_channels,N_features);
    XS = nan(48,1);
        
    fields = fieldnames(features);

    feature_matrix = nan(N_channels,N_features);

    for channel = 1:N_channels
        f_vector = [];
        for k = 1:length(fields)
            if ismember(fields{k}, SIGNAL_FEATURES)
               continue; 
            end

            value = squeeze(getfield(features, fields{k}));
            [N,M] = size(value);
            if N == 16
                f_vector = [f_vector,squeeze(value(channel,:))];
            elseif N == 3
                f_vector = [f_vector,squeeze(value(:,channel)')];
            elseif N == 1
                f_vector = [f_vector,squeeze(value(channel))];
            end
        end
        feature_matrix(channel,:) = f_vector;
    end
    
    X = feature_matrix;
    XS = [features.RHO_data_eig, features.RHO_dyad_eig, features.RHO_freq_eig];
    
end

