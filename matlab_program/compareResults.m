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

% Last Modified by GUIDE v2.5 27-Dec-2015 16:13:54

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

% UIWAIT makes compareResults wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Make save panel unvisible until coparision is done
set(handles.save_panel, 'Visible', 'off');
set(handles.error_button, 'Enable', 'off');

% Update handles structure
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


% Wait until user choose proper file
while 1
    [fileName, pathName] = uigetfile('.txt', 'Choose file with data');
    % Get extension of the choosen file
    [~,~,ext] = fileparts([pathName, fileName]);
    % Return error if file is not with response
    if isempty(strfind(fileName, '_response')) | strcmp(ext, '.txt') == 0
        uiwait(msgbox('File with data must be ''*_response.txt', 'Error', 'error'));
    else
        handles.file = [pathName, fileName];
        % Set path of choosen file in edit box
        set(handles.chooseFile_edit, 'String', handles.file);
        % Get file name without extension
        [~,handles.testName,~] = fileparts(handles.file);
        % Get test name from file name
        idx = strfind(handles.testName, '_response')-1;
        handles.testName = handles.testName(1:idx);
        break;
    end
end

% Update handles structure
guidata(hObject, handles);


function chooseFile_edit_Callback(hObject, eventdata, handles)
% hObject    handle to chooseFile_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of chooseFile_edit as text
%        str2double(get(hObject,'String')) returns contents of chooseFile_edit as a double

% Get path written in the field
handles.file = get(hObject, 'String');
% Get test name from the file name
[~,handles.testName,~] = fileparts(handles.file);
idx = strfind(handles.testName, '_response')-1;
handles.testName = handles.testName(1:idx);
% Update handles structure
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

% Get tie, impulse and step response from .txt file
[handles.t,handles.g,handles.h] = getDataFromFile(handles.file);

% Load file with transfer function to str_tf variable
try
    str_tf = [handles.testName '_tf.mat'];
    handles.tran_fun = load(str_tf);
    handles.tf_available = 1;
catch
    uiwait(msgbox('Transfer function for this test is unavailable. Only plot for computed data will be showed.'));
    handles.tf_available = 0;
end

% Plot on left figure - impulse response
axes(handles.impulse_plot);
% Plot impulse response from data from file
plot(handles.t,handles.g,'b');
grid on;
hold on;
% Plot impulse response basing on transfer function of object
if handles.tf_available
    plot(handles.t, impulse(handles.tran_fun.transfer_fun,handles.t),'r');
end
hold off;
xlabel('time');
ylabel('y');
title('Impulse response');
if handles.tf_available
    legend('Computed response', 'Reference response');
else
    legend('Computed response');
end
% Locate the legend below and outside the plot
lh=findall(gcf,'tag','legend');
set(lh,'location','southoutside');

% Plot on the right figure - step response
axes(handles.step_plot);
% Plot step response from data from file
plot(handles.t,handles.h,'b');
grid on;
hold on;
% Plot step response basing on transfer function of the object
if handles.tf_available
    plot(handles.t, step(handles.tran_fun.transfer_fun,handles.t),'r');
end
hold off;
xlabel('time');
ylabel('y');
title('Step response');
if handles.tf_available
    legend('Computed response', 'Reference response');
else
    legend('Computed response');
end
% Locate the legend below and outside the plot
lh=findall(gcf,'tag','legend');
set(lh,'location','southoutside');

% Make save panel visible and set it saving as .fig by default
set(handles.save_panel, 'Visible', 'on');
set(handles.figSave_radio, 'Value', 1);
% Make error button enabled
if handles.tf_available
    set(handles.error_button, 'Enable', 'on');
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in figSave_radio.
function figSave_radio_Callback(hObject, eventdata, handles)
% hObject    handle to figSave_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of figSave_radio

% Set fig format and unset png when radio button changed
set(handles.figSave_radio, 'Value', 1);
set(handles.pngSave_radio, 'Value', 0);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pngSave_radio.
function pngSave_radio_Callback(hObject, eventdata, handles)
% hObject    handle to pngSave_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pngSave_radio

% Set png format and unset fig when radio button changed
set(handles.pngSave_radio, 'Value', 1);
set(handles.figSave_radio, 'Value', 0);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get the format from radio buttons
if get(handles.figSave_radio, 'Value') == 1
    format = 'fig';
elseif get(handles.pngSave_radio, 'Value') == 1
    format = 'png';
else
    error('Unexpected format for saving figures.');
end

% Open additional window with impulse response figure (the same as in main
% gui) to save it to file
fh = figure('Name', [handles.testName, ' - Impulse response'], 'NumberTitle', 'off', 'Units', 'normalized','Position', [1.1, 0.3, 0.4, 0.7]);
plot(handles.t,handles.g,'b');
grid on;
hold on;
plot(handles.t, impulse(handles.tran_fun.transfer_fun,handles.t),'r');
hold off;
xlabel('time');
ylabel('y');
title('Impulse response');
legend('Computed response', 'Reference response');
lh=findall(gcf,'tag','legend');
set(lh,'location','southoutside');
% Save the figure
saveas(fh, [handles.testName, '_impulse'],format);
close(fh);

% Open additional window with step response figure (the same as in main
% gui) to save it to file
fh = figure('Name', [handles.testName, ' - Step response'], 'NumberTitle', 'off', 'Units', 'normalized','Position', [1.1, 0.3, 0.4, 0.7]);
plot(handles.t,handles.h,'b');
grid on;
hold on;
plot(handles.t, step(handles.tran_fun.transfer_fun,handles.t),'r');
hold off;
xlabel('time');
ylabel('y');
title('Step response');
legend('Computed response', 'Reference response');
lh=findall(gcf,'tag','legend');
set(lh,'location','southoutside');
% Save the figure
saveas(fh, [handles.testName, '_step'],format);
close(fh);


% --- Executes on button press in error_button.
function error_button_Callback(hObject, eventdata, handles)
% hObject    handle to error_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Create new figure
fh = figure('Name', 'Difference between reference and computed results',...
    'NumberTitle', 'off');

% Calculate impulse and step errors
handles.error_impulse = impulse(handles.tran_fun.transfer_fun,handles.t) - handles.g;
handles.error_step = step(handles.tran_fun.transfer_fun,handles.t) - handles.h;
% Make first sample of impulse response equal to reference because it will
% always differ and make plot of error hard to read
handles.error_impulse(1) = 0;

% Plot of impulse error
subplot(1,2,1);
plot(handles.t, handles.error_impulse);
title('Impulse error');
xlabel('t');
ylabel('y');
grid on
% Plot of step error
subplot(1,2,2);
plot(handles.t, handles.error_step);
title('Step error');
xlabel('t');
ylabel('y');
grid on

handles.error_sum_impulse = sum(handles.error_impulse.^2);
handles.error_sum_step = sum(handles.error_step.^2);

msgbox(['Integral of quadratic error for impulse: ', num2str(handles.error_sum_impulse),...
    '. Integral of quadratic error for step: ', num2str(handles.error_sum_step)]);
