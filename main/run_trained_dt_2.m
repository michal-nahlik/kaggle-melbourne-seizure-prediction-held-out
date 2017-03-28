%% Load the trained models and create submission
close all; clear;  clc;
%%
addpath('../util');
opts = setupEnv();
%%
model = @load_and_run_dt;
%%
%for i = 1:3
    %% prepare options for a subject
    opts_subject = opts;
    opts_subject.subject_index = 2;
    %% load files for given submission files and calculate features
    [data.xTest, data.FN_test] = get_features(opts_subject);
    %% create submission for subject
    create_submission(model,data,opts_subject)
%end