function varargout = IsiAnalysisGui(varargin)
% ISIANALYSISGUI MATLAB code for IsiAnalysisGui.fig
%      ISIANALYSISGUI, by itself, creates a new ISIANALYSISGUI or raises the existing
%      singleton*.
%
%      H = ISIANALYSISGUI returns the handle to a new ISIANALYSISGUI or the handle to
%      the existing singleton*.
%
%      ISIANALYSISGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ISIANALYSISGUI.M with the given input arguments.
%
%      ISIANALYSISGUI('Property','Value',...) creates a new ISIANALYSISGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IsiAnalysisGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IsiAnalysisGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IsiAnalysisGui

% Last Modified by GUIDE v2.5 17-Feb-2017 19:26:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IsiAnalysisGui_OpeningFcn, ...
                   'gui_OutputFcn',  @IsiAnalysisGui_OutputFcn, ...
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


% --- Executes just before IsiAnalysisGui is made visible.
function IsiAnalysisGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IsiAnalysisGui (see VARARGIN)

global Mstate
set(handles.isiRoot,'string',Mstate.isiOnlineRoot)


% Choose default command line output for IsiAnalysisGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes IsiAnalysisGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = IsiAnalysisGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in analysisYes.
function analysisYes_Callback(hObject, eventdata, handles)
% hObject    handle to analysisYes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of analysisYes
global onlineIsiAnalysis

if get(hObject,'Value')==1
    set(handles.analysisNo,'Value',0);
    onlineIsiAnalysis=1;
else
    set(handles.analysisNo,'Value',1);
    onlineIsiAnalysis=0;
end



% --- Executes on button press in analysisNo.
function analysisNo_Callback(hObject, eventdata, handles)
% hObject    handle to analysisNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of analysisNo
global onlineIsiAnalysis

if get(hObject,'Value')==1
    set(handles.analysisYes,'Value',0);
    onlineIsiAnalysis=0;
else
    set(handles.analysisYes,'Value',1);
    onlineIsiAnalysis=1;
end



function isiroot_Callback(hObject, eventdata, handles)
% hObject    handle to isiroot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of isiroot as text
%        str2double(get(hObject,'String')) returns contents of isiroot as a double

global Mstate
Mstate.isiOnlineRoot = get(handles.isiRoot,'string');



% --- Executes during object creation, after setting all properties.
function isiroot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to isiroot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
