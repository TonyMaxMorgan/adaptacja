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

% Last Modified by GUIDE v2.5 17-Dec-2015 14:36:32

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

handles.name = '';
handles.sampleTime = 0.01;
handles.duration = 10;
handles.num = [];
handles.den = [];
handles.control = 1;
% handles.noise = 0;

assignin('base', 'Ts', handles.sampleTime);
assignin('base', 'num', handles.num);
assignin('base', 'den', handles.den);
switch handles.control
    case 1
        % Ramp
        assignin('base', 'k_ramp', 1);
        assignin('base', 'k_sine', 0);
        assignin('base', 'k_triangle', 0);
        assignin('base', 'k_variant', 0);
    case 2
        % Sine
        assignin('base', 'k_sine', 1);
        assignin('base', 'k_ramp', 0);
        assignin('base', 'k_triangle', 0);
        assignin('base', 'k_variant', 0);
    case 3
        % Triangle
        assignin('base', 'k_triangle', 1);
        assignin('base', 'k_ramp', 0);
        assignin('base', 'k_sine', 0);
        assignin('base', 'k_variant', 0);
    case 4
        % Triangle
        assignin('base', 'k_variant', 1);
        assignin('base', 'k_ramp', 0);
        assignin('base', 'k_sine', 0);
        assignin('base', 'k_triangle', 0);
    otherwise
        % None
        assignin('base', 'k_triangle', 0);
        assignin('base', 'k_ramp', 0);
        assignin('base', 'k_sine', 0);
        assignin('base', 'k_variant', 0);
end

set(handles.ramp_panel, 'Visible', 'on');
set(handles.sine_panel, 'Visible', 'off');
set(handles.triangle_panel, 'Visible', 'off');
set(handles.variant_panel, 'Visible', 'off');

assignin('base', 'k_noise', 0);
assignin('base', 'A_noise', 0.01);
set(handles.a_noise_edit, 'Enable', 'off');

assignin('base', 'slope_ramp', 0.1);
assignin('base', 'A_sine', 1);
assignin('base', 'f_sine', 1);
assignin('base', 'f_triangle', 1);
assignin('base', 'A_triangle', 1);
assignin('base', 'const_variant', 5);
assignin('base', 'A_variant', 1);

set(handles.sine_panel, 'Parent', handles.control_panel);
set(handles.sine_panel, 'Position', get(handles.ramp_panel, 'Position'));
set(handles.triangle_panel, 'Parent', handles.control_panel);
set(handles.triangle_panel, 'Position', get(handles.ramp_panel, 'Position'));
set(handles.variant_panel, 'Parent', handles.control_panel);
set(handles.variant_panel, 'Position', get(handles.ramp_panel, 'Position'));

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

handles.name = get(handles.name_edit, 'String');
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

handles.sampleTime = str2double(get(handles.sample_edit, 'String'));
assignin('base', 'Ts', handles.sampleTime);
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

handles.duration = str2double(get(handles.duration_edit, 'String'));
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

handles.num = get(handles.num_edit, 'String');
temp = strsplit(handles.num, ' ');
temp = strrep(temp, '[', '');
temp = strrep(temp, ']', '');
temp = str2double(temp);
while temp(1) == 0
    temp = temp(2:end);
end
handles.num = temp;
assignin('base', 'num', handles.num);
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

handles.den = get(handles.den_edit, 'String');
temp = strsplit(handles.den, ' ');
temp = strrep(temp, '[', '');
temp = strrep(temp, ']', '');
temp = str2double(temp);
while temp(1) == 0
    temp = temp(2:end);
end
handles.den = temp;
assignin('base', 'den', handles.den);
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

handles.control = get(handles.control_popup, 'Value');

switch handles.control
    case 1
        % Ramp
        assignin('base', 'k_ramp', 1);
        assignin('base', 'k_sine', 0);
        assignin('base', 'k_triangle', 0);
        assignin('base', 'k_variant', 0);
        set(handles.ramp_panel, 'Visible', 'on');
        set(handles.sine_panel, 'Visible', 'off');
        set(handles.triangle_panel, 'Visible', 'off');
        set(handles.variant_panel, 'Visible', 'off');
    case 2
        % Sine
        assignin('base', 'k_sine', 1);
        assignin('base', 'k_ramp', 0);
        assignin('base', 'k_triangle', 0);
        assignin('base', 'k_variant', 0);
        set(handles.ramp_panel, 'Visible', 'off');
        set(handles.triangle_panel, 'Visible', 'off');
        set(handles.variant_panel, 'Visible', 'off');
        set(handles.sine_panel, 'Visible', 'on');
    case 3
        % Triangle
        assignin('base', 'k_triangle', 1);
        assignin('base', 'k_ramp', 0);
        assignin('base', 'k_sine', 0);
        assignin('base', 'k_variant', 0);
        set(handles.ramp_panel, 'Visible', 'off');
        set(handles.sine_panel, 'Visible', 'off');
        set(handles.triangle_panel, 'Visible', 'on');
        set(handles.variant_panel, 'Visible', 'off');
    case 4
        % Triangle
        assignin('base', 'k_triangle', 0);
        assignin('base', 'k_ramp', 0);
        assignin('base', 'k_sine', 0);
        assignin('base', 'k_variant', 1);
        set(handles.ramp_panel, 'Visible', 'off');
        set(handles.sine_panel, 'Visible', 'off');
        set(handles.triangle_panel, 'Visible', 'off');
        set(handles.variant_panel, 'Visible', 'on');
    otherwise
        % None
        assignin('base', 'k_triangle', 0);
        assignin('base', 'k_ramp', 0);
        assignin('base', 'k_sine', 0);
        assignin('base', 'k_variant', 0);
        set(handles.triangle_panel, 'Visible', 'off');
        set(handles.ramp_panel, 'Visible', 'off');
        set(handles.sine_panel, 'Visible', 'off');
        set(handles.variant_panel, 'Visible', 'off');
end

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

assignin('base', 'slope_ramp', str2double(get(handles.slope_edit, 'String')));
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

assignin('base', 'f_triangle', str2double(get(handles.f_triangle_edit, 'String')));
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

assignin('base', 'A_sine', str2double(get(handles.a_sine_edit, 'String')));
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

assignin('base', 'f_sine', str2double(get(handles.f_sine_edit, 'String')));
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

if length(handles.den) <= length(handles.num)
    msgbox('Numerator of transfer function has to have less elements thsn denominator.');
else
    
    simOut = sim('generate_model.slx', 'StopTime', num2str(handles.duration));
    u_struct = get(simOut, 'u');
    y_struct = get(simOut, 'y');
    handles.u = u_struct.signals.values;
    handles.y = y_struct.signals.values;
    if u_struct.time ~= y_struct.time
        error('Time vectors for u and y are not the same.');
    else
        handles.time = y_struct.time;
    end

    axes(handles.axes1);
    plot(handles.time, handles.u);
    hold on;
    grid on;
    plot(handles.time, handles.y);
    hold off;
    xlabel('time');
    ylabel('u, y');
    title('Control and response');
    legend('control', 'response');
    lh=findall(gcf,'tag','legend');
    set(lh,'location','southoutside');

end
    
guidata(hObject, handles);


% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if length(handles.den) <= length(handles.num)
    msgbox('Numerator of transfer function has to have less elements thsn denominator.');
else

    transfer_fun = tf(handles.num, handles.den);
    tfName = [handles.name '_tf.mat'];
    save(tfName, 'transfer_fun');

    simOut = sim('generate_model.slx', 'StopTime', num2str(handles.duration));
    % assignin('base','sim_out', simOut);
    u_struct = get(simOut, 'u');
    y_struct = get(simOut, 'y');
    handles.u = u_struct.signals.values;
    handles.y = y_struct.signals.values;
    if u_struct.time ~= y_struct.time
        error('Time vectors for u and y are not the same.');
    else
        handles.time = y_struct.time;
    end

    fileName = [handles.name '_data.txt'];
    fileID = fopen(fileName, 'w');
    fprintf(fileID,'%f %f %f\n',[handles.time handles.u handles.y]');
    fclose(fileID);

    axes(handles.axes1);
    plot(handles.time, handles.u);
    hold on;
    grid on;
    plot(handles.time, handles.y);
    hold off;
    xlabel('time');
    ylabel('u, y');
    title('Control and response');
    legend('control', 'response');
    lh=findall(gcf,'tag','legend');
    set(lh,'location','southoutside');

    msgbox(['Simulation completed and data written to file ''' fileName '''']);

end
    
guidata(hObject, handles);


% --- Executes on button press in noise_checkbox.
function noise_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to noise_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of noise_checkbox

if get(handles.noise_checkbox, 'Value') == 0
    set(handles.a_noise_edit, 'Enable', 'off');
    assignin('base', 'k_noise', 0);
elseif get(handles.noise_checkbox, 'Value') == 1
    set(handles.a_noise_edit, 'Enable', 'on');
    assignin('base', 'k_noise', 1);
end
guidata(hObject, handles);



function a_noise_edit_Callback(hObject, eventdata, handles)
% hObject    handle to a_noise_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a_noise_edit as text
%        str2double(get(hObject,'String')) returns contents of a_noise_edit as a double

assignin('base', 'A_noise', str2double(get(handles.a_noise_edit, 'String')));
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

assignin('base', 'A_triangle', str2double(get(handles.a_triangle_edit, 'String')));
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

assignin('base', 'const_variant', str2double(get(handles.sp_variant_edit, 'String')));
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

assignin('base', 'A_variant', str2double(get(handles.power_variant_edit, 'String')));
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
