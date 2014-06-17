function ptOpt=myPtOptSet
%myPtOptSet: Returns the best parameters for PT

ptOpt.frameDuration=50;		% Duration (in ms) of a frame
ptOpt.overlapDuration=25;	% Duration (in ms) of overlap
ptOpt.useVolThreshold=1;	% Pitch with small volume is set to zero

ptOpt.frame2pitchOpt=frame2pitch('defaultOpt');
% ====== You can change options for frame2pitch
ptOpt.frame2pitchOpt.pdf='acf';
%opt.useParabolicFit=1;

