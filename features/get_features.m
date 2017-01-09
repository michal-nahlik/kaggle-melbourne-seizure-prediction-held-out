function [X,FN] = get_features(opts_subject)
%GENERATE_FEATURES Get the features for subject submission files
%   Checks the feature folder first and if no precalculated feature exists
%   it generates one and saves it if the save_features is set to true
    tic    
    % prepare file mask and load directories
    subject_folder = opts_subject.subjectNames{opts_subject.subject_index};
    fprintf('Getting features for submission files of subject %s\n', subject_folder);
    dataDir = [opts_subject.dataDir filesep subject_folder];
    savePath = [opts_subject.featureDir filesep subject_folder];
    
    fileMask = sprintf('new_%d_', opts_subject.subject_index);
    
    if (~isdir(savePath)) && opts_subject.save_features
        mkdir(savePath);
    end
    % read files for the subject based on submission file
    tb = readtable(opts_subject.submissionFile,'Delimiter','comma');
    fileInd = strncmp(tb.File, fileMask,length(fileMask));
    fileNames = tb.File(fileInd);
    
    N = length(fileNames);
    valid = true(N,1);
    X = nan(N, opts_subject.N_channels, opts_subject.N_features);
    % for every file
    for j = 1:N
        fileName = fileNames{j};
        data_file_path = [dataDir filesep fileName];
        feature_file_path = [savePath filesep fileName];
        fprintf('%d / %d - ', j,N);
        % load or generate features
        if exist(feature_file_path, 'file')
            fprintf('Feature file for %s exists, using existing file.\n', fileName);
            f = load(feature_file_path);
            features = f.features;
        else
            fprintf('Feature file for %s does not exist, generating features...\n', fileName);
            d = load(data_file_path);
            features = calculate_features(d, opts_subject);
            
            if opts_subject.save_features
                save([savePath filesep fileName], 'features');
            end  
        end          
        % check whether the file had some real data
        if isempty(features) || sum(features.std_value) == 0
            fprintf('File %s has no data\n', fileName);
            valid(j) = false;
            continue; 
        end
        % transform features into vector
        X(j,:,:) = features_to_vector(features, opts_subject);
    end
    
    X = X(valid,:,:);
    FN = fileNames(valid);
    toc
end

