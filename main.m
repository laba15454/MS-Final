function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 16-Jun-2014 22:25:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)
global glassPitch;
glassPitch = 74;
% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
addToolBox

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in playback.
function playback_Callback(hObject, eventdata, handles)
% hObject    handle to playback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[wave fs] = wavread('glass565Hz.wav');
sound(wave,fs);



% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global energy;
energy = 0;
fs = 16000;
y = audiorecorder(fs,8,1);
y.TimerFcn = @evaluate;
y.TimerPeriod = 1;
recordblocking(y,30);
disp('finish');

function evaluate(obj, event)
global glassPitch;
global energy;
period = get(obj,'TimerPeriod');
fs = get(obj,'sampleRate');
wave = getaudiodata(obj);
wave = wave(end-period*fs+1:end);
opt = myPtOptSet;
wObj.signal = wave;
wObj.fs =fs;
f = myPt(wObj,opt,0);
%f = f(~isnan(f));
%f = mode(f);
temp = f(~isnan(f));
temp = mode(temp);
fprintf('f = %f\n',temp);
frameSize=round(opt.frameDuration*fs/1000);
overlap=round(opt.overlapDuration*fs/1000);
frame = enframe(wave,frameSize,overlap);
volume =  frame2volume(frame);
b = findobj(gcf);
textHandle = findall(b,'tag','text1');
fb = abs(f-glassPitch);
energy = energy + sum(volume(fb < 2));
if energy > 5000
    set(textHandle,'String','穘件狹');
end
if energy > 10000
    set(textHandle,'String','瘆窰件狹');
end
%{
for i = 1:length(f)
    fprintf('f = %f\n',f(i));
    if abs(f(i) -glassPitch) < 2
        energy = energy + volume(i);
        if energy > 5000
            set(textHandle,'String','穘件狹');
        end
        if energy > 10000
            set(textHandle,'String','瘆窰件狹');
        end
    end
end
%}
fprintf('energy = %f\n',energy);
