function features = calculate_features(f, opts)
%CALCULATE_FEATURES Calculates features for given data structure
    dataStruct = f.dataStruct;
    data = dataStruct.data;
    fs = dataStruct.iEEGsamplingRate;
    features = feature_extractor(data,fs, opts);
end

