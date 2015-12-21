function varargout = compareResults(varargin)
% COMPARERESULTS MATLAB code for compareResults.fig
%      COMPARERESULTS, by itself, creates a new COMPARERESULTS or raises the existing
%      singleton*.
%
%      H = COMPARERESULTS returns the handle to a new COMPARERESULTS or the handle to
%      the existing singleton*.
%
%      COMPARERESULTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMPARERESULTS.M with the given input arguments.
%
%      COMPARERESULTS('Property','Value',...) creates a new COMPARERESULTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before compareResults_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to compareResults_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help compareResults

% Last Modified by GUIDE v2.5 03-Dec-2015 21:39:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @compareResults_OpeningFcn, ...
                   'gui_OutputFcn',  @compareResults_OutputFcn, ...
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


% --- Executes just before compareResults is made visible.
function compareResults_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to compareResults (see VARARGIN)

% Choose default command line output for compareResults
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes compareResults wait for user response (see UIRESUME)
% uiwait(handles.figure1);

set(handles.save_panel, 'Visible', 'off');

guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = compareResults_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in chooseFile_button.
function chooseFile_button_Callback(hObject, eventdata, handles)
% hObject    handle to chooseFile_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fileName, pathName] = uigetfile('.txt', 'Choose file with data');

if pathName ~= 0
    handles.file = [pathName, fileName];
    set(handles.chooseFile_edit, 'String', handles.file);
    [~,handles.testName,~] = fileparts(handles.file);
    idx = strfind(handles.testName, '_response')-1;
    handles.testName = handles.testName(1:idx);
end

% Update handles structure
guidata(hObject, handles);


function chooseFile_edit_Callback(hObject, eventdata, handles)
% hObject    handle to chooseFile_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of chooseFile_edit as text
%        str2double(get(hObject,'String')) returns contents of chooseFile_edit as a double

handles.file = get(hObject, 'String');
[~,handles.testName,~] = fileparts(handles.file);
idx = strfind(handles.testName, '_response')-1;
handles.testName = handles.testName(1:idx);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function chooseFile_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chooseFile_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in compare_button.
function compare_button_Callback(hObject, eventdata, handles)
% hObject    handle to compare_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles.t,handles.g,handles.h] = getDataFromFile(handles.file);

str_tf = [handles.testName '_tf.mat'];
handles.tran_fun = load(str_tf);

axes(handles.impulse_plot);
plot(handles.t,handles.g,'b');
grid on;
hold on;
plot(handles.t, impulse(handles.tran_fun.transfer_fun,handles.t),'r');
xlabel('time');
ylabel('y');
title('Impulse response');
legend('Computed response', 'Reference response');
lh=findall(gcf,'tag','legend');
set(lh,'location','southoutside');

axes(handles.step_plot);
plot(handles.t,handles.h,'b');
grid on;
hold on;
plot(handles.t, step(handles.tran_fun.transfer_fun,handles.t),'r');
xlabel('time');
ylabel('y');
title('Step response');
legend('Computed response', 'Reference response');
lh=findall(gcf,'tag','legend');
set(lh,'location','southoutside');

set(handles.save_panel, 'Visible', 'on');
set(handles.figSave_radio, 'Value', 1);

guidata(hObject, handles);


% --- Executes on button press in figSave_radio.
function figSave_radio_Callback(hObject, eventdata, handles)
% hObject    handle to figSave_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of figSave_radio

set(handles.figSave_radio, 'Value', 1);
set(handles.pngSave_radio, 'Value', 0);

guidata(hObject, handles);


% --- Executes on button press in pngSave_radio.
function pngSave_radio_Callback(hObject, eventdata, handles)
% hObject    handle to pngSave_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pngSave_radio

set(handles.pngSave_radio, 'Value', 1);
set(handles.figSave_radio, 'Value', 0);

guidata(hObject, handles);


% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.figSave_radio, 'Value') == 1
    format = 'fig';
elseif get(handles.pngSave_radio, 'Value') == 1
    format = 'png';
else
    error('Unexpected format for saving figures.');
end



fh = figure('Name', [handles.testName, ' - Impulse response'], 'NumberTitle', 'off', 'Units', 'normalized','Position', [1.1, 0.3, 0.4, 0.7]);
plot(handles.t,handles.g,'b');
grid on;
hold on;
plot(handles.t, impulse(handles.tran_fun.transfer_fun,handles.t),'r');
xlabel('time');
ylabel('y');
title('Impulse response');
legend('Computed response', 'Reference response');
lh=findall(gcf,'tag','legend');
set(lh,'location','southoutside');
saveas(fh, [handles.testName, '_impulse'],format);
close(fh);

fh = figure('Name', [handles.testName, ' - Step response'], 'NumberTitle', 'off', 'Units', 'normalized','Position', [1.1, 0.3, 0.4, 0.7]);
plot(handles.t,handles.h,'b');
grid on;
hold on;
plot(handles.t, step(handles.tran_fun.transfer_fun,handles.t),'r');
xlabel('time');
ylabel('y');
title('Step response');
legend('Computed response', 'Reference response');
lh=findall(gcf,'tag','legend');
set(lh,'location','southoutside');
saveas(fh, [handles.testName, '_step'],format);
close(fh);


