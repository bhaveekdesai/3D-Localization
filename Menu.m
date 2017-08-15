function varargout = Menu(varargin)
%MENU M-file for Menu.fig
%      MENU, by itself, creates a new MENU or raises the existing
%      singleton*.
%
%      H = MENU returns the handle to a new MENU or the handle to
%      the existing singleton*.
%
%      MENU('Property','Value',...) creates a new MENU using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to Menu_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      MENU('CALLBACK') and MENU('CALLBACK',hObject,...) call the
%      local function named CALLBACK in MENU.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Menu

% Last Modified by GUIDE v2.5 03-Jul-2017 11:18:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Menu_OpeningFcn, ...
                   'gui_OutputFcn',  @Menu_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before Menu is made visible.
function Menu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

if (nargin > 4)
	set(handles.Environment, 'Position', [360 20 varargin{1}+17 varargin{2}+30]);
	
	set(handles.Background, 'Position', [200 300 380+handles.Environment.Position(3) 40+handles.Environment.Position(4)]);
	
	set(handles.Start, 'Position', [20 varargin{2} 150 50]);
	set(handles.Reset, 'Position', [190 varargin{2} 150 50]);
	
	set(handles.SoundControls, 'Position', [20 varargin{2}-230 320 225]);
	
	handles.SoundMan = varargin{3};
	
	handles.SoundBoxes = {1};
	
	handles.Active = 0;
	
	k = dir('Sounds/*.wav');
	handles.filenames = {k.name}';
	handles.FileChoose.String = handles.filenames;
	
	%Hard Coded
	
	%General
	soundNumber = length(handles.SoundMan.Sounds)+1;
	handles.SoundMan.Sounds{soundNumber} = Sound3D('Sounds/General_James_ODonnell.wav', [70; 0], handles.SoundMan.rate, 1000, true);

	newSound = uicontrol('Style', 'text' ,'Parent', handles.Environment);
	newSound.FontSize = 8;
	newSound.ForegroundColor = [1 1 1];
	newSound.String = int2str(soundNumber);
	newSound.Position = [70 0 14 14];
	newSound.BackgroundColor = [0 0 1];
	handles.SoundBoxes{soundNumber} = newSound;

	handles.SoundChoose.String{soundNumber} = soundNumber;

	handles.LocX.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(1);
	handles.LocY.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(2);
	
	%Baseball
	soundNumber = length(handles.SoundMan.Sounds)+1;
	handles.SoundMan.Sounds{soundNumber} = Sound3D('Sounds/BaseballSong.wav', [90; 0], handles.SoundMan.rate, 1000, true);

	newSound = uicontrol('Style', 'text' ,'Parent', handles.Environment);
	newSound.FontSize = 8;
	newSound.ForegroundColor = [1 1 1];
	newSound.String = int2str(soundNumber);
	newSound.Position = [90 0 14 14];
	newSound.BackgroundColor = [0 0 1];
	handles.SoundBoxes{soundNumber} = newSound;

	handles.SoundChoose.String{soundNumber} = soundNumber;

	handles.LocX.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(1);
	handles.LocY.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(2);
	
	%Softball
	soundNumber = length(handles.SoundMan.Sounds)+1;
	handles.SoundMan.Sounds{soundNumber} = Sound3D('Sounds/Softball_Charles_DeTore.wav', [220; 0], handles.SoundMan.rate, 1000, true);

	newSound = uicontrol('Style', 'text' ,'Parent', handles.Environment);
	newSound.FontSize = 8;
	newSound.ForegroundColor = [1 1 1];
	newSound.String = int2str(soundNumber);
	newSound.Position = [220 0 14 14];
	newSound.BackgroundColor = [0 0 1];
	handles.SoundBoxes{soundNumber} = newSound;

	handles.SoundChoose.String{soundNumber} = soundNumber;

	handles.LocX.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(1);
	handles.LocY.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(2);
	
	%Volleyball
	soundNumber = length(handles.SoundMan.Sounds)+1;
	handles.SoundMan.Sounds{soundNumber} = Sound3D('Sounds/Volleyball.wav', [410; 0], handles.SoundMan.rate, 1000, true);

	newSound = uicontrol('Style', 'text' ,'Parent', handles.Environment);
	newSound.FontSize = 8;
	newSound.ForegroundColor = [1 1 1];
	newSound.String = int2str(soundNumber);
	newSound.Position = [410 0 14 14];
	newSound.BackgroundColor = [0 0 1];
	handles.SoundBoxes{soundNumber} = newSound;

	handles.SoundChoose.String{soundNumber} = soundNumber;

	handles.LocX.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(1);
	handles.LocY.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(2);
	
	%Bowling
	soundNumber = length(handles.SoundMan.Sounds)+1;
	handles.SoundMan.Sounds{soundNumber} = Sound3D('Sounds/BowlingPins.wav', [530; 0], handles.SoundMan.rate, 1000, true);

	newSound = uicontrol('Style', 'text' ,'Parent', handles.Environment);
	newSound.FontSize = 8;
	newSound.ForegroundColor = [1 1 1];
	newSound.String = int2str(soundNumber);
	newSound.Position = [530 0 14 14];
	newSound.BackgroundColor = [0 0 1];
	handles.SoundBoxes{soundNumber} = newSound;

	handles.SoundChoose.String{soundNumber} = soundNumber;

	handles.LocX.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(1);
	handles.LocY.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(2);
	
	%Track
	soundNumber = length(handles.SoundMan.Sounds)+1;
	handles.SoundMan.Sounds{soundNumber} = Sound3D('Sounds/Track_Bob_Zumbado.wav', [695; 0], handles.SoundMan.rate, 1000, true);

	newSound = uicontrol('Style', 'text' ,'Parent', handles.Environment);
	newSound.FontSize = 8;
	newSound.ForegroundColor = [1 1 1];
	newSound.String = int2str(soundNumber);
	newSound.Position = [695 0 14 14];
	newSound.BackgroundColor = [0 0 1];
	handles.SoundBoxes{soundNumber} = newSound;

	handles.SoundChoose.String{soundNumber} = soundNumber;

	handles.LocX.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(1);
	handles.LocY.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(2);
	
	%Fishing
	soundNumber = length(handles.SoundMan.Sounds)+1;
	handles.SoundMan.Sounds{soundNumber} = Sound3D('Sounds/FishingFeedingFrenzy.wav', [910; 0], handles.SoundMan.rate, 1000, true);

	newSound = uicontrol('Style', 'text' ,'Parent', handles.Environment);
	newSound.FontSize = 8;
	newSound.ForegroundColor = [1 1 1];
	newSound.String = int2str(soundNumber);
	newSound.Position = [910 0 14 14];
	newSound.BackgroundColor = [0 0 1];
	handles.SoundBoxes{soundNumber} = newSound;

	handles.SoundChoose.String{soundNumber} = soundNumber;

	handles.LocX.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(1);
	handles.LocY.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(2);
	
	%Swimming/Cayuco
	soundNumber = length(handles.SoundMan.Sounds)+1;
	handles.SoundMan.Sounds{soundNumber} = Sound3D('Sounds/RowingBoat.wav', [925; 150], handles.SoundMan.rate, 1000, true);

	newSound = uicontrol('Style', 'text' ,'Parent', handles.Environment);
	newSound.FontSize = 8;
	newSound.ForegroundColor = [1 1 1];
	newSound.String = int2str(soundNumber);
	newSound.Position = [925 150 14 14];
	newSound.BackgroundColor = [0 0 1];
	handles.SoundBoxes{soundNumber} = newSound;

	handles.SoundChoose.String{soundNumber} = soundNumber;

	handles.LocX.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(1);
	handles.LocY.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(2);
end

% Choose default command line output for Menu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Menu wait for user response (see UIRESUME)
uiwait(handles.Background);


% --- Outputs from this function are returned to the command line.
function varargout = Menu_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Start.
function Start_Callback(hObject, eventdata, handles)
% hObject    handle to Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.Background);

% --- Executes on button press in Reset.
function Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.SoundMan.Sounds = {};

for i = 1:length(handles.SoundBoxes)
	delete(handles.SoundBoxes{i});
end
handles.SoundChoose.String = {'Sound Number', '0'};
handles.SoundBoxes = {1};

guidata(hObject, handles);
drawnow;

% --------------------------------------------------------------------
function Environment_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Environment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get mouse coords and convert them into panel space
coords = get(gcf, 'CurrentPoint');
coords = [(coords(1)-7)-360; (coords(2)-7)-20];

%Create the sound in put it into worldspace
soundNumber = length(handles.SoundMan.Sounds)+1;
handles.SoundMan.Sounds{soundNumber} = Sound3D('Sounds/RunningConcrete.wav', coords, handles.SoundMan.rate, 1000, true);

%Set Up the new Sound Box
newSound = uicontrol('Style', 'text' ,'Parent', handles.Environment);
newSound.FontSize = 8;
newSound.ForegroundColor = [1 1 1];
newSound.String = int2str(soundNumber);
newSound.Position = [coords(1) coords(2) 14 14];
newSound.BackgroundColor = [0 0 1];
handles.SoundBoxes{soundNumber} = newSound;

handles.SoundChoose.String{soundNumber} = soundNumber;

handles.LocX.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(1);
handles.LocY.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(2);

guidata(hObject, handles);

%Update the screen
drawnow;


% --- Executes on button press in UpArror.
function UpArror_Callback(hObject, eventdata, handles)
% hObject    handle to UpArror (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (length(handles.SoundMan.Sounds) ~= 0)
	handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position + [0; 10];
	handles.SoundBoxes{handles.SoundChoose.Value}.Position = handles.SoundBoxes{handles.SoundChoose.Value}.Position + [0 10 0 0];
	
	handles.LocX.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(1);
	handles.LocY.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(2);
	
	guidata(hObject, handles);
	drawnow;
end

% --- Executes on button press in RightArrow.
function RightArrow_Callback(hObject, eventdata, handles)
% hObject    handle to RightArrow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (length(handles.SoundMan.Sounds) ~= 0)
	handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position + [10; 0];
	handles.SoundBoxes{handles.SoundChoose.Value}.Position = handles.SoundBoxes{handles.SoundChoose.Value}.Position + [10 0 0 0];
	
	handles.LocX.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(1);
	handles.LocY.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(2);
	
	guidata(hObject, handles);
	drawnow;
end
	
% --- Executes on button press in LeftArrow.
function LeftArrow_Callback(hObject, eventdata, handles)
% hObject    handle to LeftArrow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (length(handles.SoundMan.Sounds) ~= 0)
	handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position + [-10; 0];
	handles.SoundBoxes{handles.SoundChoose.Value}.Position = handles.SoundBoxes{handles.SoundChoose.Value}.Position + [-10 0 0 0];
	
	handles.LocX.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(1);
	handles.LocY.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(2);
	
	guidata(hObject, handles);
	drawnow;
end

% --- Executes on button press in DownArrow.
function DownArrow_Callback(hObject, eventdata, handles)
% hObject    handle to DownArrow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (length(handles.SoundMan.Sounds) ~= 0)
	handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position + [0; -10];
	handles.SoundBoxes{handles.SoundChoose.Value}.Position = handles.SoundBoxes{handles.SoundChoose.Value}.Position + [0 -10 0 0];
	
	handles.LocX.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(1);
	handles.LocY.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(2);
	
	guidata(hObject, handles);
	drawnow;
end

% --- Executes on selection change in SoundChoose.
function SoundChoose_Callback(hObject, eventdata, handles)
% hObject    handle to SoundChoose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SoundChoose contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SoundChoose
handles.LocX.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(1);
handles.LocY.String = handles.SoundMan.Sounds{handles.SoundChoose.Value}.Position(2);

% --- Executes during object creation, after setting all properties.
function SoundChoose_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SoundChoose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in FileChoose.
function FileChoose_Callback(hObject, eventdata, handles)
% hObject    handle to FileChoose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FileChoose contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FileChoose

% --- Executes during object creation, after setting all properties.
function FileChoose_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileChoose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveSoundFile.
function SaveSoundFile_Callback(hObject, eventdata, handles)
% hObject    handle to SaveSoundFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (length(handles.SoundMan.Sounds) ~= 0)
	handles.SoundMan.Sounds{handles.SoundChoose.Value}.SoundFile = horzcat('Sounds/', handles.FileChoose.String{handles.FileChoose.Value});
	
	guidata(hObject, handles);
end

% --- Executes when user attempts to close Background.
function Background_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to Background (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.SoundMan.Stop = true;
disp('Stopping');
guidata(hObject, handles);
% Hint: delete(hObject) closes the figure
delete(hObject);

function SubjectID_Callback(hObject, eventdata, handles)
% hObject    handle to SubjectID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SubjectID as text
%        str2double(get(hObject,'String')) returns contents of SubjectID as a double
handles.SoundMan.Plr.ID = str2double(get(hObject,'String'));
disp(handles.SoundMan.Plr.ID);

% --- Executes during object creation, after setting all properties.
function SubjectID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SubjectID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
