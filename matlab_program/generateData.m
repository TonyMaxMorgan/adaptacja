function varargout = generateData(varargin)
% GENERATEDATA MATLAB code for generateData.fig
%      GENERATEDATA, by itself, creates a new GENERATEDATA or raises the existing
%      singleton*.
%
%      H = GENERATEDATA returns the handle to a new GENERATEDATA or the handle to
%      the existing singleton*.
%
%      GENERATEDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GENERATEDATA.M with the given input arguments.
%
%      GENERATEDATA('Property','Value',...) creates a new GENERATEDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before generateData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to generateData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help generateData

% Last Modified by GUIDE v2.5 23-Dec-2015 22:36:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @generateData_OpeningFcn, ...
                   'gui_OutputFcn',  @generateData_OutputFcn, ...
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


% --- Executes just before generateData is made visible.
function generateData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to generateData (see VARARGIN)

% Choose default command line output for generateData
handles.output = hObject;

% UIWAIT makes generateData wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Set initial values of some parameters - name of the test, sample time,
% duration, transfer function and type of control: 1 - step, 2 - ramp, 3 -
% sine, 4 - triangle and 5 - variant (see documentation)
handles.name = '';
handles.sampleTime = 0.01;
handles.duration = 10;
handles.num = [];
handles.den = [];
handles.control = 1;

% Save sample time and transfer function to workspace (to make model see
% their values)
assignin('base', 'Ts', handles.sampleTime);
assignin('base', 'num', handles.num);
assignin('base', 'den', handles.den);

% Save parameters conected with type of control to workspace - set which
% type should be used in model generate_model.slx
switch handles.control
    case 1
        % Step
        assignin('base', 'k_step', 1);
        assignin('base', 'k_ramp', 0);
        assignin('base', 'k_sine', 0);
        assignin('base', 'k_triangle', 0);
        assignin('base', 'k_variant', 0);
    case 2
        % Ramp
        assignin('base', 'k_step', 0);
        assignin('base', 'k_ramp', 1);
        assignin('base', 'k_sine', 0);
        assignin('base', 'k_triangle', 0);
        assignin('base', 'k_variant', 0);
    case 3
        % Sine
        assignin('base', 'k_step', 0);
        assignin('base', 'k_sine', 1);
        assignin('base', 'k_ramp', 0);
        assignin('base', 'k_triangle', 0);
        assignin('base', 'k_variant', 0);
    case 4
        % Triangle
        assignin('base', 'k_step', 0);
        assignin('base', 'k_triangle', 1);
        assignin('base', 'k_ramp', 0);
        assignin('base', 'k_sine', 0);
        assignin('base', 'k_variant', 0);
    case 5
        % Variant
        assignin('base', 'k_step', 0);
        assignin('base', 'k_variant', 1);
        assignin('base', 'k_ramp', 0);
        assignin('base', 'k_sine', 0);
        assignin('base', 'k_triangle', 0);
    otherwise
        % None
        assignin('base', 'k_step', 0);
        assignin('base', 'k_triangle', 0);
        assignin('base', 'k_ramp', 0);
        assignin('base', 'k_sine', 0);
        assignin('base', 'k_variant', 0);
end

% Set control type step (1) set and visible, other panels are invisible
% (panels overlap each other and one of them need to be visible)
set(handles.step_panel, 'Visible', 'on');
set(handles.ramp_panel, 'Visible', 'off');
set(handles.sine_panel, 'Visible', 'off');
set(handles.triangle_panel, 'Visible', 'off');
set(handles.variant_panel, 'Visible', 'off');

% Set initial values of parameters regarding noise (white noise) - power of
% noise can be set
assignin('base', 'k_noise', 0);
assignin('base', 'A_noise', 0.01);
set(handles.a_noise_edit, 'Enable', 'off');

% Set initial values of different types of control
% Step - value
assignin('base', 'A_step', 1);
% Ramp - slope
assignin('base', 'slope_ramp', 0.1);
% Sine - amplitude and frequency
assignin('base', 'A_sine', 1);
assignin('base', 'f_sine', 1);
% Triangle function - amplitude and frequency
assignin('base', 'f_triangle', 1);
assignin('base', 'A_triangle', 1);
% Variant - set point (constant value) and power of changes of this value
% (function value will never differ from set point more that 'A_variant'
% value
assignin('base', 'const_variant', 5);
assignin('base', 'A_variant', 1);

% Set position of panels regarding different types of control to step panel
% position to be sure they are in the same place (parent setting is because
% guide sets parent to step_panel)
set(handles.ramp_panel, 'Parent', handles.control_panel);
set(handles.ramp_panel, 'Position', get(handles.step_panel, 'Position'));
set(handles.sine_panel, 'Parent', handles.control_panel);
set(handles.sine_panel, 'Position', get(handles.step_panel, 'Position'));
set(handles.triangle_panel, 'Parent', handles.control_panel);
set(handles.triangle_panel, 'Position', get(handles.step_panel, 'Position'));
set(handles.variant_panel, 'Parent', handles.control_panel);
set(handles.variant_panel, 'Position', get(handles.step_panel, 'Position'));

% Make plot checkboxes set by default
set(handles.plot_control_checkbox, 'Value', 1);
set(handles.plot_response_checkbox, 'Value', 1);

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = generateData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function name_edit_Callback(hObject, eventdata, handles)
% hObject    handle to name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of name_edit as text
%        str2double(get(hObject,'String')) returns contents of name_edit as a double

% Save name of test written in name_edit cell
handles.name = get(handles.name_edit, 'String');
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function name_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sample_edit_Callback(hObject, eventdata, handles)
% hObject    handle to sample_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sample_edit as text
%        str2double(get(hObject,'String')) returns contents of sample_edit as a double

% Save sample time set in sample_edit cell to variable and to workspace
% changing it from string to number
handles.sampleTime = str2double(get(handles.sample_edit, 'String'));
assignin('base', 'Ts', handles.sampleTime);
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function sample_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sample_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function duration_edit_Callback(hObject, eventdata, handles)
% hObject    handle to duration_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of duration_edit as text
%        str2double(get(hObject,'String')) returns contents of duration_edit as a double

% Save duration of test to variable changing it from string to double
handles.duration = str2double(get(handles.duration_edit, 'String'));
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function duration_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to duration_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function num_edit_Callback(hObject, eventdata, handles)
% hObject    handle to num_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_edit as text
%        str2double(get(hObject,'String')) returns contents of num_edit as a double

% Function to enter numerator of continuous transfer function

% Get string with entered values (in MATLAB format, can me with [] and
% without)
handles.num = get(handles.num_edit, 'String');
% Split the string to separate all values
temp = strsplit(handles.num, ' ');
% Delete []
temp = strrep(temp, '[', '');
temp = strrep(temp, ']', '');
% Change string to double for each value in entered string
temp = str2double(temp);
% Delete all zeros at the beginning of the vector - not relevant
while temp(1) == 0
    temp = temp(2:end);
end
% Set num parameter and save it to workspace
handles.num = temp;
assignin('base', 'num', handles.num);
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function num_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function den_edit_Callback(hObject, eventdata, handles)
% hObject    handle to den_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of den_edit as text
%        str2double(get(hObject,'String')) returns contents of den_edit as a double

% Function to enter denominator of continuous transfer function

% Get string entered in the cell (in MATLAB format - can be entered with []
% brackets or without)
handles.den = get(handles.den_edit, 'String');
% Split the string to get all values separated
temp = strsplit(handles.den, ' ');
% Delete [] brackets
temp = strrep(temp, '[', '');
temp = strrep(temp, ']', '');
% Change string to double for each value in vector
temp = str2double(temp);
% Delete all zeros at the beginning of the vector (not relevant)
while temp(1) == 0
    temp = temp(2:end);
end
% Save computed values to variable and to workspace
handles.den = temp;
assignin('base', 'den', handles.den);
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function den_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to den_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in control_popup.
function control_popup_Callback(hObject, eventdata, handles)
% hObject    handle to control_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns control_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from control_popup

% Get value of control type from popup menu (1 - step, 2 - ramp, 3 - sine,
% 4 - triangle, 5 - variant)
handles.control = get(handles.control_popup, 'Value');

% Set model parameters and panels visibility for entered control type
switch handles.control
    case 1
        % Step
        assignin('base', 'k_step', 1);
        assignin('base', 'k_ramp', 0);
        assignin('base', 'k_sine', 0);
        assignin('base', 'k_triangle', 0);
        assignin('base', 'k_variant', 0);
        set(handles.step_panel, 'Visible', 'on');
        set(handles.ramp_panel, 'Visible', 'off');
        set(handles.sine_panel, 'Visible', 'off');
        set(handles.triangle_panel, 'Visible', 'off');
        set(handles.variant_panel, 'Visible', 'off');
    case 2
        % Ramp
        assignin('base', 'k_step', 0);
        assignin('base', 'k_ramp', 1);
        assignin('base', 'k_sine', 0);
        assignin('base', 'k_triangle', 0);
        assignin('base', 'k_variant', 0);
        set(handles.ramp_panel, 'Visible', 'on');
        set(handles.step_panel, 'Visible', 'off');
        set(handles.sine_panel, 'Visible', 'off');
        set(handles.triangle_panel, 'Visible', 'off');
        set(handles.variant_panel, 'Visible', 'off');
    case 3
        % Sine
        assignin('base', 'k_sine', 1);
        assignin('base', 'k_step', 0);
        assignin('base', 'k_ramp', 0);
        assignin('base', 'k_triangle', 0);
        assignin('base', 'k_variant', 0);
        set(handles.step_panel, 'Visible', 'off');
        set(handles.ramp_panel, 'Visible', 'off');
        set(handles.triangle_panel, 'Visible', 'off');
        set(handles.variant_panel, 'Visible', 'off');
        set(handles.sine_panel, 'Visible', 'on');
    case 4
        % Triangle
        assignin('base', 'k_triangle', 1);
        assignin('base', 'k_step', 0);
        assignin('base', 'k_ramp', 0);
        assignin('base', 'k_sine', 0);
        assignin('base', 'k_variant', 0);
        set(handles.step_panel, 'Visible', 'off');
        set(handles.ramp_panel, 'Visible', 'off');
        set(handles.sine_panel, 'Visible', 'off');
        set(handles.triangle_panel, 'Visible', 'on');
        set(handles.variant_panel, 'Visible', 'off');
    case 5
        % Variant
        assignin('base', 'k_triangle', 0);
        assignin('base', 'k_step', 0);
        assignin('base', 'k_ramp', 0);
        assignin('base', 'k_sine', 0);
        assignin('base', 'k_variant', 1);
        set(handles.step_panel, 'Visible', 'off');
        set(handles.ramp_panel, 'Visible', 'off');
        set(handles.sine_panel, 'Visible', 'off');
        set(handles.triangle_panel, 'Visible', 'off');
        set(handles.variant_panel, 'Visible', 'on');
    otherwise
        % None
        assignin('base', 'k_triangle', 0);
        assignin('base', 'k_step', 0);
        assignin('base', 'k_ramp', 0);
        assignin('base', 'k_sine', 0);
        assignin('base', 'k_variant', 0);
        set(handles.step_panel, 'Visible', 'off');
        set(handles.triangle_panel, 'Visible', 'off');
        set(handles.ramp_panel, 'Visible', 'off');
        set(handles.sine_panel, 'Visible', 'off');
        set(handles.variant_panel, 'Visible', 'off');
end

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function control_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to control_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function slope_edit_Callback(hObject, eventdata, handles)
% hObject    handle to slope_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of slope_edit as text
%        str2double(get(hObject,'String')) returns contents of slope_edit as a double

% Save value of slope (ramp) to workspace changing it from string to number
assignin('base', 'slope_ramp', str2double(get(handles.slope_edit, 'String')));
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slope_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slope_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f_triangle_edit_Callback(hObject, eventdata, handles)
% hObject    handle to f_triangle_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_triangle_edit as text
%        str2double(get(hObject,'String')) returns contents of f_triangle_edit as a double

% Save value of triangle frequency to workspace changing it from string to
% double
assignin('base', 'f_triangle', str2double(get(handles.f_triangle_edit, 'String')));
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function f_triangle_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_triangle_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function a_sine_edit_Callback(hObject, eventdata, handles)
% hObject    handle to a_sine_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a_sine_edit as text
%        str2double(get(hObject,'String')) returns contents of a_sine_edit as a double

% Save value of sine amplitude changing it from string to double
assignin('base', 'A_sine', str2double(get(handles.a_sine_edit, 'String')));
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function a_sine_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a_sine_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function f_sine_edit_Callback(hObject, eventdata, handles)
% hObject    handle to f_sine_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_sine_edit as text
%        str2double(get(hObject,'String')) returns contents of f_sine_edit as a double

% Save valuse of sine frequency changing it from string to double
assignin('base', 'f_sine', str2double(get(handles.f_sine_edit, 'String')));
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function f_sine_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_sine_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in generate_button.
function generate_button_Callback(hObject, eventdata, handles)
% hObject    handle to generate_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Function to simulate model with set parameters and plot set control and
% simulated responce. No data is saved to file so there is posibility to
% change settings if results are not satisfing

% Return error if numerator of transfer function has more elements than
% denominator (or the same number) - no computations will be done unless
% transfer function is corrected
if length(handles.den) <= length(handles.num)
    msgbox('Numerator of transfer function has to have less elements than denominator.');
else
    % Simulate generate_model.slx model with duration set in 'duration'
    % cell
    simOut = sim('generate_model.slx', 'StopTime', num2str(handles.duration));
    % Extract time, control and response from data saved from simulation
    u_struct = get(simOut, 'u');
    y_struct = get(simOut, 'y');
    handles.u = u_struct.signals.values;
    handles.y = y_struct.signals.values;
    % Return error when time vectors for control and response are not
    % equal
    if u_struct.time ~= y_struct.time
        error('Time vectors for u and y are not the same.');
    else
        handles.time = y_struct.time;
    end

    % Plot on the figure
    axes(handles.axes1);
    % Plot control
    if get(handles.plot_control_checkbox, 'Value') == 1
        plot(handles.time, handles.u, 'b');
        if get(handles.plot_response_checkbox, 'Value') == 1
            hold on;
        else
            hold off;
        end
        grid on;
    end
    % Plot response
    if get(handles.plot_response_checkbox, 'Value') == 1
        plot(handles.time, handles.y, 'r');
        grid on;
        hold off;
    end
    xlabel('time');
    if get(handles.plot_control_checkbox, 'Value') == 1 && ...
            get(handles.plot_response_checkbox, 'Value') == 1
        ylabel('u, y');
        title('Control and response');
        legend('control', 'response');
    elseif get(handles.plot_control_checkbox, 'Value') == 1
        ylabel('u');
        title('Control');
        legend('control');
    elseif get(handles.plot_response_checkbox, 'Value') == 1
        ylabel('y');
        title('Response');
        legend('response');
    else
        ylabel('');
        title('');
        legend('');
    end
    % Locate legend outside the plot and below the plot
    lh=findall(gcf,'tag','legend');
    set(lh,'location','southoutside');
end
    
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Function do the same as generate_button_Callback but it will also save
% data to *_data.txt file - it will have three columns with following
% vectors: time, control, response

% Return error it number of elements in numerator is greater or the same as
% in denominator vector
if length(handles.den) <= length(handles.num)
    msgbox('Numerator of transfer function has to have less elements than denominator.');
else
    % Save transfer function to *_tf.mat file - it will be needed to
    % compare results with reference characteristics computed by MATLAB
    transfer_fun = tf(handles.num, handles.den);
    tfName = [handles.name '_tf.mat'];
    save(tfName, 'transfer_fun');
    
    % Run simulation with duration set in 'duration' cell
    simOut = sim('generate_model.slx', 'StopTime', num2str(handles.duration));
    % Extract time, control and response vectors from data get from
    % simulation
    u_struct = get(simOut, 'u');
    y_struct = get(simOut, 'y');
    handles.u = u_struct.signals.values;
    handles.y = y_struct.signals.values;
    % Return error if time for control is not equal to time for response
    if u_struct.time ~= y_struct.time
        error('Time vectors for u and y are not the same.');
    else
        handles.time = y_struct.time;
    end
    
    % Save data to *_data.txt file
    fileName = [handles.name '_data.txt'];
    fileID = fopen(fileName, 'w');
    fprintf(fileID,'%f %f %f\n',[handles.time handles.u handles.y]');
    fclose(fileID);

    % Plot on the figure
    axes(handles.axes1);
    % Plot control
    if get(handles.plot_control_checkbox, 'Value') == 1
        plot(handles.time, handles.u, 'b');
        if get(handles.plot_response_checkbox, 'Value') == 1
            hold on;
        else
            hold off;
        end
        grid on;
    end
    % Plot response
    if get(handles.plot_response_checkbox, 'Value') == 1
        plot(handles.time, handles.y, 'r');
        grid on;
        hold off;
    end
    xlabel('time');
    if get(handles.plot_control_checkbox, 'Value') == 1 && ...
            get(handles.plot_response_checkbox, 'Value') == 1
        ylabel('u, y');
        title('Control and response');
        legend('control', 'response');
    elseif get(handles.plot_control_checkbox, 'Value') == 1
        ylabel('u');
        title('Control');
        legend('control');
    elseif get(handles.plot_response_checkbox, 'Value') == 1
        ylabel('y');
        title('Response');
        legend('response');
    else
        ylabel('');
        title('');
        legend('');
    end
    % Locate legend outside the plot and below the plot
    lh=findall(gcf,'tag','legend');
    set(lh,'location','southoutside');

    % Display message that simulation was completed and saved results to
    % file
    msgbox(['Simulation completed and data written to file ''' fileName '''']);

end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in noise_checkbox.
function noise_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to noise_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of noise_checkbox

% Set noise parameter and make cell with its power enabled or disabled
if get(handles.noise_checkbox, 'Value') == 0
    set(handles.a_noise_edit, 'Enable', 'off');
    assignin('base', 'k_noise', 0);
elseif get(handles.noise_checkbox, 'Value') == 1
    set(handles.a_noise_edit, 'Enable', 'on');
    assignin('base', 'k_noise', 1);
end
% Update handles structure
guidata(hObject, handles);


function a_noise_edit_Callback(hObject, eventdata, handles)
% hObject    handle to a_noise_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a_noise_edit as text
%        str2double(get(hObject,'String')) returns contents of a_noise_edit as a double

% Save power of noise to workspace changing it from string to double
assignin('base', 'A_noise', str2double(get(handles.a_noise_edit, 'String')));
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function a_noise_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a_noise_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function a_triangle_edit_Callback(hObject, eventdata, handles)
% hObject    handle to a_triangle_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a_triangle_edit as text
%        str2double(get(hObject,'String')) returns contents of a_triangle_edit as a double

% Save triangle amplitude to workspace changing it from string to double
assignin('base', 'A_triangle', str2double(get(handles.a_triangle_edit, 'String')));
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function a_triangle_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a_triangle_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function sp_variant_edit_Callback(hObject, eventdata, handles)
% hObject    handle to sp_variant_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sp_variant_edit as text
%        str2double(get(hObject,'String')) returns contents of sp_variant_edit as a double

% Save set point of variant control to workspace changing it from string to
% double
assignin('base', 'const_variant', str2double(get(handles.sp_variant_edit, 'String')));
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sp_variant_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sp_variant_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function power_variant_edit_Callback(hObject, eventdata, handles)
% hObject    handle to power_variant_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of power_variant_edit as text
%        str2double(get(hObject,'String')) returns contents of power_variant_edit as a double

% Save power of variant control to workspace changing it from string to
% double
assignin('base', 'A_variant', str2double(get(handles.power_variant_edit, 'String')));
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function power_variant_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to power_variant_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over name_edit.
function name_edit_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Make default value of 'name' field disappear after clicking on it
set(handles.name_edit, 'Enable', 'on');
set(handles.name_edit, 'String', '');
% Update handles structure
guidata(hObject, handles);



% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over num_edit.
function num_edit_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to num_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Make default value of 'num' field disappear after clicking on it
set(handles.num_edit, 'Enable', 'on');
set(handles.num_edit, 'String', '');
% Update handles structure
guidata(hObject, handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over den_edit.
function den_edit_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to den_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Make default value of 'den' field disappear after clicking on it
set(handles.den_edit, 'Enable', 'on');
set(handles.den_edit, 'String', '');
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in compute_button.
function compute_button_Callback(hObject, eventdata, handles)
% hObject    handle to compute_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Display window to choose file as long as user choose proper one (with
% _data at the end
while 1
    [fileName, pathName] = uigetfile('.txt', 'Choose file with data');
    pathName = [pathName, fileName];
    [~,testName,ext] = fileparts(pathName);
    % Return error if user choose wrong file
    if isempty(strfind(testName, '_data')) | strcmp(ext, '.txt') == 0
        uiwait(msgbox('File with data must be ''*_data.txt', 'Error', 'error'));
    else
        break;
    end
end    

% Run program that computes impulse and step responses - it will write
% results to *_response.txt file
system(['adaptacja.exe ' pathName]);

% Display message about finishing coputation
msgbox(['Computation done and saved to file ''' strrep(fileName, '_data', '_response') '''']);


function a_step_edit_Callback(hObject, eventdata, handles)
% hObject    handle to a_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a_step_edit as text
%        str2double(get(hObject,'String')) returns contents of a_step_edit as a double

% Save value of step control to workspace changing it from string to double
assignin('base', 'A_step', str2double(get(handles.a_step_edit, 'String')));
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function a_step_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot_control_checkbox.
function plot_control_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to plot_control_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_control_checkbox


% --- Executes on button press in plot_response_checkbox.
function plot_response_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to plot_response_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_response_checkbox
