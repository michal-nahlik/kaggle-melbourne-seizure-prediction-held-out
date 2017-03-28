close all; clear;  clc;
%%
addpath('../util');
opts = setupEnv();
opts.labelFile          = 'c:\Temp\Projects\Kaggle\Melbourne\train_and_test_data_labels_safe.csv';
opts.train_folders      = {'train_1','train_2','train_3'};
%% model with specific parameters for every subject
opts.min_parents        = [10,5,5];
opts.min_leafs          = [5,5,5];
%% create model and submission for each subject
for i = 1:3
    subjectName_train = opts.train_folders{i};
    %% load training data
    [data.xTrain,data.yTrain] = get_train_data(subjectName_train,opts); 
    %% prepare options for a subject
    opts_subject = opts;
    opts_subject.subject_index = i;
    opts_subject.min_leaf = opts.min_leafs(i);
    opts_subject.min_parent = opts.min_parents(i);
    %% create model for each channel
    for j = 1:opts_subject.N_channels
        channel_opts = opts_subject;
        channel_opts.channel_index = j;
        train_and_save_dt(data,channel_opts);
    end
    clear data;
end