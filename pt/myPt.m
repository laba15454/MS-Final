function pitch=myPt(wObj, opt, showPlot);
% myPt: My pitch tracking
%
%	Usage:
%		pitch=myPt(wObj, opt, showPlot);
%			opt: options for pitch
%			showPlot: 1 for plotting, 0 for not plotting
%			pitch: result of pitch tracking
%
%	Example:
%		waveFile='­Û´°ÅK¾ô«±¤U¨Ó_¤£¸Ô_0.wav';
%		wObj=waveFile2obj(waveFile);
%		opt=myPtOptSet;
%		showPlot=1;
%		myPt(wObj, opt, showPlot);

%	Roger Jang, 20110531, 20130416

if nargin<1, selfdemo; return; end
if nargin<2, opt=myPtOptSet; end
if nargin<3, showPlot=1; end

if isstr(wObj), wObj=waveFile2obj(wObj); end	% If the give wObj is a file name

y=wObj.signal; fs=wObj.fs;
if size(y,2) >= 2
    y = y(:,1);
end
y=y-mean(y);
frameSize=round(opt.frameDuration*fs/1000);
overlap=round(opt.overlapDuration*fs/1000);
frameMat=enframe(y, frameSize, overlap);
frameNum=size(frameMat, 2);
%========================================
%   default acf + volume threshold
%========================================
%
pitch=zeros(1, frameNum);
pitch2 = zeros(1,frameNum);
for i=1:frameNum
	frame=frameMat(:, i);
	[pitch(i),pdf]=frame2pitch(frame, fs, opt.frame2pitchOpt);
    %
	n1=round(fs/1000);		% pdf(1:n1) will not be used
	n2=round(fs/40);		% pdf(n2:end) will not be used
	pdf2=pdf;
	pdf2(1:n1)=-inf;
	pdf2(n2:end)=-inf;
	[maxValue, maxIndex]=max(pdf2);
    [peak peakIndex] = findpeaks(pdf2);
    if length(peak) == 1
        pitch2(i)=pitch(i);
    else
        [aaa index] = max(peak(~(peak==maxValue)));
        secondMaxIndex = peakIndex(index);
        pitch2(i)=freq2pitch(fs/(secondMaxIndex(1)-1));    

    end
    %
end

volume=frame2volume(frameMat);
volumeTh=max(volume)/10;
pitch0=pitch;
pitch20 = pitch2;

if opt.useVolThreshold
	pitch(volume<volumeTh)=nan;	% Volume-thresholded pitch
    pitch2(volume<volumeTh) = nan;
end

if showPlot
	frameTime=frame2sampleIndex(1:frameNum, frameSize, overlap)/fs;
	subplot(4,1,1);
	plot((1:length(y))/fs, y); set(gca, 'xlim', [-inf inf]);
	title('Waveform');
	subplot(4,1,2);
	plot(frameTime, volume, '.-'); set(gca, 'xlim', [-inf inf]);
	line([0, length(y)/fs], volumeTh*[1, 1], 'color', 'r');
	title('Volume');
	subplot(4,1,3);
		plot(frameTime,	 pitch0, '.-b' , frameTime, pitch, '.-k');
		title('Blue: original pitch, black: volume-thresholded pitch)');
	axis tight;
	xlabel('Time (second)'); ylabel('Semitone');
	axis tight;
	xlabel('Time (second)'); ylabel('Semitone');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
strEval(mObj.example);