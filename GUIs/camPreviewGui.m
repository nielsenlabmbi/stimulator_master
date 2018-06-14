function varargout = camPreviewGui(varargin)
% CAMPREVIEWGUI MATLAB code for camPreviewGui.fig
%      CAMPREVIEWGUI, by itself, creates a new CAMPREVIEWGUI or raises the existing
%      singleton*.
%
%      H = CAMPREVIEWGUI returns the handle to a new CAMPREVIEWGUI or the handle to
%      the existing singleton*.
%
%      CAMPREVIEWGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAMPREVIEWGUI.M with the given input arguments.
%
%      CAMPREVIEWGUI('Property','Value',...) creates a new CAMPREVIEWGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before camPreviewGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to camPreviewGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help camPreviewGui

% Last Modified by GUIDE v2.5 14-Jun-2018 14:40:58

% Begin initialization code - DO NOT EDIT


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @camPreviewGui_OpeningFcn, ...
                   'gui_OutputFcn',  @camPreviewGui_OutputFcn, ...
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


% --- Executes just before camPreviewGui is made visible.
function handles = camPreviewGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to camPreviewGui (see VARARGIN)

% Choose default command line output for camPreviewGui
handles.output = hObject;

set(gcf,'toolbar','none')
set(handles.sliderHigh,'Enable','off');
set(handles.sliderLow,'Enable','off');

global previewImg GUIhandles
previewImg = handles.previewImg;
axes(handles.acqYN); set(handles.acqYN,'XTick',[],'YTick',[]); axis tight;
x = [0 1 1 0];
y = [0 0 1 1];
patch(x,y,'red');

axes(handles.previewImg); set(handles.previewImg,'XTick',[],'YTick',[]); axis tight;
handles.image = zeros(100);
imshow(handles.image);
handles.oImage = handles.image;

% Update handles structure
guidata(hObject, handles);

if (exist('cam','var'))
    set(handles.openCam,'Enable','Off');
    set(handles.closeCam,'Enable','On');
else
    set(handles.openCam,'Enable','On');
    set(handles.closeCam,'Enable','Off');
end

% Update handles structure
guidata(hObject,handles);

GUIhandles.ISI_NL = handles;

% --- Executes on button press in getPreview.
function getPreview_Callback(hObject, eventdata, handles)
% hObject    handle to getPreview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Initialize camera
global cam
src = getselectedsource(cam);
set(src, 'TriggerMode', 'Off');
triggerconfig(cam,'immediate','none','none');
handles.vidRes = cam.VideoResolution;
handles.nBands = cam.NumberOfBands;

set(handles.sliderHigh,'Enable','off');
set(handles.sliderLow,'Enable','off');

fprintf('Generating preview\n');
axes(handles.previewImg); set(handles.previewImg,'XTick',[],'YTick',[]); axis tight;
handles.hImage = image( zeros(handles.vidRes(2), handles.vidRes(1), handles.nBands) );
preview(cam, handles.hImage);
title('GigE preview');

axes(handles.acqYN); set(handles.acqYN,'XTick',[],'YTick',[]); axis tight;
x = [0 1 1 0];
y = [0 0 1 1];
patch(x,y,'green','parent',handles.acqYN);
    
% Update handles structure
guidata(hObject,handles);

% --- Executes on button press in stopPreview.
function stopPreview_Callback(hObject, eventdata, handles)
% hObject    handle to stopPreview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cam
stoppreview(cam);

axes(handles.acqYN);  set(handles.previewImg,'XTick',[],'YTick',[]); axis tight;
x = [0 1 1 0];
y = [0 0 1 1];
patch(x,y,'red','parent',handles.acqYN);

fprintf('Preview done\n');

% Update handles structure
guidata(hObject,handles);

% --- Executes on button press in getSnapshot.
function getSnapshot_Callback(hObject, eventdata, handles)
% hObject    handle to getSnapshot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cam
handles.image = getsnapshot(cam);
handles.oImage = handles.image;
stoppreview(cam);
cla(handles.previewImg); axes(handles.previewImg);  set(handles.previewImg,'XTick',[],'YTick',[]); axis tight;
image(handles.image);
set(handles.sliderHigh,'Enable','on');
set(handles.sliderLow,'Enable','on');
axes(handles.acqYN);  set(handles.previewImg,'XTick',[],'YTick',[]); axis tight;
x = [0 1 1 0];
y = [0 0 1 1];
patch(x,y,'red','parent',handles.acqYN);

% Update handles structure
guidata(hObject,handles);

% --------------------------------------------------------------------
function SaveSnapshot_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to SaveSnapshot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure; imshow(handles.image);
filemenufcn(gcf,'FileSaveAs')


% --- Executes on button press in closeCam.
function closeCam_Callback(hObject, eventdata, handles)
% hObject    handle to closeCam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cam;

src = getselectedsource(cam);
if(exist('cam', 'var'))
    delete(cam);
    clear cam;
    clear src;
end

set(handles.openCam,'Enable','On');
set(handles.closeCam,'Enable','Off');

% --- Executes on button press in openCam.
function openCam_Callback(hObject, eventdata, handles)
% hObject    handle to openCam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% create camera 
global camInfo cam

cam = videoinput('gige', 1);
src = getselectedsource(cam);
stop(cam);

P = getParamStruct;
framesPerTrigger = ceil(P.predelay*camInfo.Fps); % only image during the pre delay and stim
cam.FrameGrabInterval = 1;          % save every frame
cam.FramesPerTrigger = framesPerTrigger / cam.FrameGrabInterval;
cam.TriggerSelector = 'FrameBurstStart';
triggerconfig(cam,'hardware','DeviceSpecific','DeviceSpecific');
set(cam, 'TriggerFcn', @camTriggered);

% make sure Jumbo Frames are set to 9k in the GigE NIC adapter settings
src.PacketSize = 9000;

%set details of movie acquisition
camInfo.Fps = 15;  % Hz
camInfo.resizeScale = 0.25;  % 0.5;    reduce frame size
set(handles.closeCam,'Enable','On');
set(handles.openCam,'Enable','Off');

% --- Executes on slider movement.
function sliderLow_Callback(hObject, eventdata, handles)
    handles.image = adjustImage(handles);
    image(handles.image,'parent',handles.previewImg);
    set(handles.previewImg,'XTick',[],'YTick',[]); axis tight;
    updateSliders(hObject, handles);
    guidata(hObject, handles);

% --- Executes on slider movement.src = getselectedsource(cam);
function sliderHigh_Callback(hObject, eventdata, handles)
    handles.image = adjustImage(handles);
    image(handles.image,'parent',handles.previewImg);
    set(handles.previewImg,'XTick',[],'YTick',[]);
    updateSliders(hObject, handles);
    guidata(hObject, handles);
    
function sliderHigh_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function sliderLow_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function im = adjustImage(hObject, eventdata, handles)
    gl = get(handles.sliderLow,'Value');
    gh = get(handles.sliderHigh,'Value');
    
    im = handles.image;
    im(:,:,2) = imadjust(handles.oImage(:,:,1),[gl gh],[0 1]);
    im(:,:,1) = im(:,:,2);
    im(:,:,3) = im(:,:,2);

function updateSliders(hObject, handles)
    set(handles.sliderHigh,'Min',get(handles.sliderLow,'Value')+0.01);
    set(handles.sliderLow,'Max',get(handles.sliderHigh,'Value')-0.01);
    guidata(hObject, handles);

% % --------------------------------------------------------------------
% function snapshot_Callback(hObject, eventdata, handles)
% % hObject    handle to snapshot (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% frame = getsnapshot(cam);
% stoppreview(cam);
% cla; delete(findobj(handles.main,'type','uicontextmenu'));
% image(frame);
% 

% % --------------------------------------------------------------------
% function prev_Callback(hObject, eventdata, handles)
% % hObject    handle to prev (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% cla; delete(findobj(handles.main,'type','uicontextmenu'));
% preview(handles.cam, handles.image);
% 
% % --------------------------------------------------------------------
% function ctxt_menu_Callback(hObject, eventdata, handles)
% % hObject    handle to ctxt_menu (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)

% --- Outputs from this function are returned to the command line.
function varargout = camPreviewGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% function CloseRequestFcn(hObject, eventdata, handles)
% % % reconfig and activate the hardware trigger
% triggerconfig(cam, 'hardware', 'DeviceSpecific', 'DeviceSpecific');
% set(src, 'TriggerMode', 'On');
% 
% fprintf('Preview done\n');

function figure1_CloseRequestFcn(hObject,eventdata,handles)
global cam
src = getselectedsource(cam);
if(exist('cam', 'var'))
    delete(cam);
    clear cam;
    clear src;
end