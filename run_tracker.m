
%
function [precision, fps] = run_tracker(video, show_visualization, show_plots)

%path to the videos (you'll be able to choose one with the GUI).
base_path   = 'C:\Users\carrierlxk\Desktop\ECCV2016code';
close all;
addpath('utility');
addpath('model');

% Path to MatConvNet. Please run external/matconvnet/vl_compilenn.m to
% set up the MatConvNet
addpath('external\matconvnet\matlab');
addpath('external/matconvnet/matlab/mex');
addpath('external/matconvnet/matlab/xtest');

% Default settings
if nargin < 1, video = 'choose'; end
if nargin < 2, show_visualization = ~strcmp(video, 'all'); end
if nargin < 3, show_plots = ~strcmp(video, 'all'); end

% Extra area surrounding the target
padding = struct('generic', 1.8, 'large', 1, 'height', 0.4);

lambda = 1e-4;              % Regularization parameter (see Eqn 3 in our paper)
output_sigma_factor = 0.1;  % Spatial bandwidth (proportional to the target size)

interp_factor = 0.01;       % Model learning rate (see Eqn 6a, 6b)
cell_size = 4;              % Spatial cell size
config.kernel_sigma = 1;
config.motion_thresh= 0.32;%0.15; 0.25 
config.appearance_thresh=0.38; %0.38
config.features.hog_orientations = 9;
config.features.cell_size = 4;   % size of hog grid cell		
config.features.window_size = 6; % size of local region for intensity historgram  
config.features.nbins=8; 
global enableGPU;
enableGPU = false;

switch video
    case 'choose',
        % Ask the user for selecting the video, then call self with that video name.
        video = choose_video(base_path);
        if ~isempty(video)
            % Start tracking
            [precision, fps] = run_tracker(video, show_visualization, show_plots);
            
            if nargout == 0,  % Don't output precision as an argument
                clear precision
            end
        end
        
    case 'all',
        %all videos, call self with each video name.
        
        %only keep valid directory names
        dirs = dir(base_path);        videos = {dirs.name};
        videos(strcmp('.', videos) | strcmp('..', videos) | ...
            strcmp('anno', videos) | ~[dirs.isdir]) = [];
        
        % Note: the 'Jogging' sequence has 2 targets, create one entry for each.
        % we could make this more general if multiple targets './top-down/'per video
        % becomes a common occurence.
        
        %=========================================================================
        % Uncomment following scripts if you test on the entire bechmark
        %         videos(strcmpi('Jogging', videos)) = [];
        %         videos(end+1:end+2) = {'Jogging.1', 'Jogging.2'};
        %
        %         videos(strcmpi('Skating2', videos))=[];
        %         videos(end+1:end+2)={'Skating2.1', 'Skating2.2'};
        %=========================================================================
        
        all_precisions = zeros(numel(videos),1);  % to compute averages
        all_fps = zeros(numel(videos),1);
        
        poolobj = gcp;
        
        parfor k = 1:numel(videos)
            if exist([result_path videos{k} '.mat'],'file'), continue; end
            [all_precisions(k), all_fps(k)] = run_tracker(videos{k}, show_visualization, show_plots);
        end
        
        delete(poolobj);
        
        %compute average precision at 20px, and FPS
        mean_precision = mean(all_precisions);
        
        fps = mean(all_fps);
        
        fprintf('\nAverage precision (20px):% 1.3f, Average FPS:% 4.2f\n\n', mean_precision, fps)
        
        if nargout > 0,
            precision = mean_precision;
        end
        
    otherwise
        % We were given the name of a single video to process.
        % get image file names, initial state, and ground truth for evaluation
        [img_files, pos, target_sz, ground_truth, video_path] = load_video_info(base_path, video);
        
        % Call tracker function with all the relevant parameters
%         [positions, time] = tracker_ensemble(video_path, img_files, pos, target_sz, ...
%             padding, lambda, output_sigma_factor, interp_factor, ...
%             cell_size, show_visualization);
           [positions, time] = tracker_ensemble(video_path, img_files, pos, target_sz, ...
            padding, lambda, output_sigma_factor, interp_factor, ...
            cell_size, show_visualization);
        
        % Calculate and show precision plot, as well as frames-per-second
        precisions = precision_plot(positions, ground_truth, video, show_plots);
        fps = numel(img_files) / time;
        
        fprintf('%12s - Precision (20px):% 1.3f, FPS:% 4.2f\n', video, precisions(20), fps)
        
        if nargout > 0,
            %return precisions at a 20 pixels threshold
            precision = precisions(20);
        end
end
end
