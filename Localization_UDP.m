% three arguments for localization udp connection:
% 1. serever ip(the terminal which running the dashboard
% 2. udp listening port, this can be manualy configured in Dashboard Menu:
%       File -> Parameters. After setting the listening port, restart the
%       dashboard.
% 3. The address/ID of the mobile beacon, currently in our LAB the mobile
% beacon ID is 26. This can be configured in dashboard
clear;
% connection parameters
ip = '127.0.0.1';
% ip = '192.168.86.122';
port = 18888;

% profiling parameters
rounds = 500;
count = rounds;
interval = 0.1;
rate = 11050;
%44100 - 1
%11050 - 0.25

FrontAndBack = false;
debugSound = true;
maze = false;

%Get HRTF from files
hrtf = 'CIPIC_58_HRTF.mat';
%uigetfile(pwd, 'Please select the hrtf you would like to use');
load(deblank(sprintf('%s', hrtf)));

%CHANGE
%Winner vairable
global win;
win = false;

localMan = 0;

if (~debugSound)
	localMan = LocalizationManager(26, 27);
	
	%{	
	% add python scripts folder to path, in the repository, the default
	% location of the python scripts locates at '[project_root]/py_scripts'
		PyPath = py.sys.path;
		if PyPath.count('.') == 0
		   insert(PyPath,int32(0),'.');
		end
		PyModule = py.sys.modules;
		if isa(PyModule.get('udpclient'),'py.NoneType')
			py.importlib.import_module('udpclient');
		end

		%Beacon IDs
		mBIdFront = 26;
		mBIdBack = 27;

		%Open the connection for each beacon
		connFront = py.udpclient.udp_factory(ip,uint16(port),uint16(mBIdFront));
		connBack = py.udpclient.udp_factory(ip,uint16(port),uint16(mBIdBack));
	%}
end

Sounds = {};

%For Maze it goes Left, Right, Up, Down
Sounds{1} = Sound3D('3D_Oboe.wav', [0;0], rate, 1000, true);
Sounds{2} = Sound3D('3D_Clarinet.wav', [5;0], rate, 1000, true);
Sounds{3} = Sound3D('3D_Flute.wav', [0;5], rate, 1000, true);
Sounds{4} = Sound3D('3D_Bassoon.wav', [5;5], rate, 1000, true);
Sounds{5} = Sound3D('MiddleC.wav', [10;10], rate, 1000, false);
Sounds{6} = Sound3D('RumbleStrip.wav', [0;0], rate, 1000, false);

soundsToIgnore = [true, true, true, true, false, false];

%Sound Manager
soundMan = SoundManager(Sounds, rate, soundsToIgnore);

%MOVE
%Size of wall buffer for certain effects
cellBufferMin = 1/4;
cellBufferMax = 1 - cellBufferMin;

%FIGURE SOMETHING OUT
%Set up Globals
global coordsFront;
global coordsBack;
global playerPos;

global fracLeft;
global fracBott;
global CellWalls;

%REPLACE
%Dummy values
playerPos = [2.5;2.5];
fracLeft = 0.5;
fracBott = 0.5;
CellWalls = [false, false, false, false];

%Default player direction is forward
forward = [0; 1];

%Set Up Player
plr = Player(playerPos, forward, FrontAndBack);

%Set up timer
%The timer just updates the coordinates every interval
t = 0;

if (~debugSound)
%Start maze UI and everything it does
	maze_UI();

	%Decide if you want to use a single or 2 hedgehogs
	if (FrontAndBack == false)
		%Timer for just front
		t = timer('TimerFcn', 'global coordsFront; coordsFront = connFront.request_position();','ExecutionMode','FixedRate','Period', interval);
	else
		%Timer for front and back
		t = timer('TimerFcn', 'global coordsFront; global coordsBack; coordsFront = connFront.request_position();coordsBack = connBack.request_position();','ExecutionMode','FixedRate','Period', interval);
	end
	start(t);
end

%Keep going until the user won (By reaching the exit cell)
while (~win)	
	if (~debugSound)
		calcPosition(plr, coordsFront, coordsBack);
		calcForward(plr);
		
		playerPos = plr.Position;
	end
	
	%MOVE THIS
	%--------------------------------------------------------------------
	if (maze)
		%Set up sound locations		
		soundMan.Sounds{1}.Position = plr.Position + [-1; 0];
		soundMan.Sounds{2}.Position = plr.Position + [1; 0];
		soundMan.Sounds{3}.Position = plr.Position + [0; 1];
		soundMan.Sounds{4}.Position = plr.Position + [0; -1];
		
		soundMan.Sounds{6}.Position = plr.Position;

		%Set up to know how loud the rumble should be as player's approach it
		%and where it's coming from
		nearEdge = false;
		distEdgeX = 1;
		distEdgeY = 1;

		%Check left and right edges and move the sound to that location
		%Also checks distance to make sound more intense

		%If user is near the left/right edge, check if there's a wall.
		%If there's a wall then player a rumble sound in that area
		%Then save the player's distance from the edge [0,1]
			%0 is at the edge and 1 is 1/6 in the cube

		if (fracLeft < cellBufferMin)
			if (CellWalls(1))
				soundMan.Sounds{6}.Position = soundMan.Sounds{6}.Position + [-1; 0];
			end

			distEdgeX = fracLeft/(cellBufferMin);
			nearEdge = true;

		elseif (fracLeft > cellBufferMax)
			if (CellWalls(2))
				soundMan.Sounds{6}.Position = soundMan.Sounds{6}.Position + [1; 0];
			end

			distEdgeX = (1-fracLeft)/(cellBufferMin);
			nearEdge = true;
		end

		%If user is near the bottom/top edge, check if there's a wall.
		%If there's a wall then player a rumble sound in that area
		%Then save the player's distance from the edge [0,1]
			%0 is at the edge and 1 is 1/6 in the cube
		if (fracBott < cellBufferMin)
			if(CellWalls(4))
				soundMan.Sounds{6}.Position = soundMan.Sounds{6}.Position + [0; -1];
			end

			distEdgeY = fracBott/(cellBufferMin);
			nearEdge = true;

		elseif (fracBott > cellBufferMax)
			if (CellWalls(3))
				soundMan.Sounds{6}.Position = soundMan.Sounds{6}.Position + [0; 1];
			end

			distEdgeY = (1-fracBott)/(cellBufferMin);
			nearEdge = true;
		end

		%Now I want the intensity of the sound to increase as I
		%get to the closer of the two distances to base the rumble sound on
		distEdge = min(distEdgeX, distEdgeY);
	end
	%---------------------------------------------------------------
	
	%[1:4] refers to the cardinal sound directions [West, East, North, South]
	%[5] is the location of the exit
	%[6] is the location of the rumble sound
	%{
	for i = 1:length(soundMan.Sounds)
		
		%Take a step even if we are gonna drop it
		%to keep music in sync
		sig = getStep(soundMan.Sounds{i});
		sig = sig(:,1);
		
		if (maze)
			%if we're doing a cardinal sound and there's a wall in the way
			%don't play it

			%Allow a sound to play if on the opposite side of as a wall to
			%guide players towards the center
			if (i < 5)
				if (CellWalls(i) == true)
					if (i == 1 && fracLeft <= cellBufferMax)
						continue;
					elseif (i == 2 && fracLeft >= cellBufferMin)
						continue;
					elseif (i == 3 && fracBott >= cellBufferMin)
						continue;
					elseif (i == 4 && fracBott <= cellBufferMax)
						continue;
					end
				end

			%Sound location is always played so no if statement to control it
			%The rumble strip should only play when near an edge
			elseif (i == 6)
				if (~nearEdge)
					%FileReaderRumble = dsp.AudioFileReader('RumbleStrip.wav', 'SamplesPerFrame', rate, 'PlayCount', 500);
					continue;
				end
			end
		end
		
		%Get the azimuth angle and elevation index
		[azAngle, eIndex] = FindAngle(playerPos, forward, soundMan.Sounds{i}.Position);
		%Get the correct index for a
		aIndex = find(azimuths == azAngle,1);
		
		%Convolve the sound for that source
		left = squeeze(hrir_l(aIndex, eIndex, :));
		right = squeeze(hrir_r(aIndex, eIndex, :));

		delay = ITD(aIndex, eIndex);

		if (aIndex < 13)
			left = [left' zeros(size(1:abs(delay)))];
			right = [zeros(size(1:abs(delay))) right'];
		else
			left = [zeros(size(1:abs(delay))) left'];
			right = [right' zeros(size(1:abs(delay)))];
		end
		
		%The bare minimum of prev1 and sig
		sizeNeeded = length(left) - 1;
		sizeNeeded = sizeNeeded/2;
		sizeLeft = 0;
		sizeRight = 0;
		
		if (mod(sizeNeeded,2) == 0)
			sizeLeft = sizeNeeded;
			sizeRight = sizeNeeded;
		else
			sizeLeft = ceil(sizeNeeded);
			sizeRight = floor(sizeNeeded);
		end
		
		prevNibble = prevSig(i,:);
		prevNibble = prevNibble(end - sizeLeft + 1:end);
		nextNibble = sig';
		nextNibble = nextNibble(1: sizeRight);
		
		newSig = horzcat(prevNibble, currSig(i,:));
		newSig = horzcat(newSig, nextNibble);
		
		wav_left = conv(newSig,left', 'valid');
		wav_right = conv(newSig, right', 'valid');
		
		prevSig(i, :) = currSig(i, :);
		currSig(i, :) = sig';
		
		prev = wav_left;
		
		if (maze)
			%For West/East sounds
			if (i == 1 || i == 2)
				%Weaken the East Weast sounds as you approach the upper or
				%lower border
				%This is to stop people from walking on top of walls
				wav_left = wav_left * distEdgeY;
				wav_right = wav_right * distEdgeY;

				%If near an edge and there's a wall on the opposite side play
				%towards the wall until you reach the center of the cell
				if (i == 1 && fracLeft > cellBufferMax && CellWalls(i) == true)
					wav_left = wav_left * (1-distEdgeX);
					wav_right = wav_right * (1-distEdgeX);
				elseif (i == 2 && fracLeft < cellBufferMin && CellWalls(i) == true)
					wav_left = wav_left * (1-distEdgeX);
					wav_right = wav_right * (1-distEdgeX);
				end

			%Same ideas as above
			%For North/South sounds
			elseif (i == 3 || i == 4)
				wav_left = wav_left * distEdgeX;
				wav_right = wav_right * distEdgeX;

				if (i == 3 && fracBott < cellBufferMin && CellWalls(i) == true)
					wav_left = wav_left * (1-distEdgeY);
					wav_right = wav_right * (1-distEdgeY);
				elseif (i == 4 && fracBott > cellBufferMax && CellWalls(i) == true)
					wav_left = wav_left * (1-distEdgeY);
					wav_right = wav_right * (1-distEdgeY);
				end

			%For rumble strip sounds
			%Rumble strips get louder as you get close to an edge
			elseif (i == 6)
				wav_left = wav_left * (1-distEdge);
				wav_right = wav_right * (1-distEdge);
			end
		end
		
		%Make sure soundToPlay is populated atleast once
		if (size(soundToPlay) ~= [0,0])
			soundToPlay(:,1) =  soundToPlay(:,1) + wav_left';
			soundToPlay(:,2) =  soundToPlay(:,2) + wav_right';
		else
			soundToPlay(:,1) =  wav_left';
			soundToPlay(:,2) =  wav_right';
		end
	end
	
	if (size(soundToPlay) == [0,0])
		soundToPlay = zeros(2,2);
	end
	%}
	
	prepareSound(soundMan, plr.Position, forward, hrir_l, hrir_r, ITD, maze);
	
	%Play that sound
	playSound(soundMan);
end

%Clean up
connFront.close();
connBack.close();

stop(t);
delete(t);