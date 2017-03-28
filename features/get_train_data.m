function [X,Y] = get_train_data(subject, opts_subject)
    tic
    fprintf('Loading data for %s\n', subject);
    % load options and dirs
    N_channels = opts_subject.N_channels;
    N_features = opts_subject.N_features;
    labelFile = opts_subject.labelFile;
    dataDir = opts_subject.dataDir;
    featureDir = opts_subject.featureDir;
    dataDir = [dataDir filesep subject];
    featureDir = [featureDir filesep subject];
    % read the label file into a table and take only safe files
    T = readtable(labelFile,'Delimiter',',');
    safe = logical(T.safe);
    T = T(safe,:);
    % find files based on the number of subject (in subject name)
    C = strsplit(subject, '_');
    subject_id = C{2};
    fileMask = [subject_id '_'];
    x = strncmp(T.image, fileMask,2);
    fileNames = T.image(x);
    numFiles = length(fileNames);
    % load Class of files
    Y = T.class(x);
    % prepare output
    valid = true(numFiles,1);
    X = nan(numFiles,N_channels,N_features);
    XS = nan(numFiles,48);
    % get features for each file
    for j = 1:numFiles
        fileName = fileNames{j};
        data_file_path = fullfile(dataDir, fileName);
        feature_file_path = fullfile(featureDir, fileName);
        
        fprintf('%d / %d - ', j,numFiles);
        if exist(feature_file_path, 'file')
            fprintf('Feature file for %s exists, using existing file.\n', fileName);
            f = load(feature_file_path);
            features = f.features;
        else
            fprintf('Feature file for %s does not exist, generating features...\n', fileName);
            d = load(data_file_path);
            features = calculate_features(d, opts_subject);
            
            if opts_subject.save_features
                save(feature_file_path, 'features');
            end  
        end 
        
        if isempty(features) || sum(features.std_value) == 0
            fprintf('File %s has no data\n', fileName);
            valid(j) = false;
            continue; 
        end
        % transform features into vector
        X(j,:,:) = features_to_vector(features, opts_subject);
    end
    
    X = X(valid,:,:);
    Y = Y(valid);
    toc
end

