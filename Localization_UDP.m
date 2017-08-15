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
rate = 44100;

%Calculate rate based on the interval length you require
rate = rate*interval;
%44100 -- 1 s
%11050 -- 0.25 s
%4410 -- .1 s

%Option to only use a single hedgehog and use default to forward facing
FrontAndBack = true;
%Option to use a virtual space and not need to set up the localization
%system
debugSound = false;

if (debugSound)
	FrontAndBack = false;
end

%Get HRTF from files
hrtf = 'CIPIC_58_HRTF.mat';
%uigetfile(pwd, 'Please select the hrtf you would like to use');
load(deblank(sprintf('%s', hrtf)));

localMan = 0;

connFront = 0;
connBack = 0;


if (~debugSound)
	%localMan = LocalizationManager(ip, port, 26, 27);
	
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

	%Beacon Ids
		%First beacon is always 0,0
	beacons = [14, 12, 13, 70];
	conns = {};
	beaconPositions = zeros(length(beacons), 2);
	farthestDistance = 0;
	farthestBeacon = 0;
	
	%Hedgehog IDs
	mBIdFront = 26;
	mBIdBack = 27;
	
	%For each beacon
	for i = 1:length(beacons)
		%Open the connection
		conns{i} = py.udpclient.udp_factory(ip,uint16(port),uint16(beacons(i)));
		
		%Get the beacon position
		temp = conns{i}.request_position();
		beaconPositions(i, :) = [double(temp{1}); double(temp{2})]/1;
		
		%Close the connection
		conns{i}.close();
		
		%Determine the distance from the first beacon
		distance = beaconPositions(i, :) - beaconPositions(1,:);
		distance = norm(distance);
		
		disp(distance);
		
		%Keep the farthest beacon
		if (farthestDistance <= distance)
			farthestBeacon = i;
			farthestDistance = distance;
		end
		
	end

	%Open the connection for each hedgehog
	connFront = py.udpclient.udp_factory(ip,uint16(port),uint16(mBIdFront));
	connBack = py.udpclient.udp_factory(ip,uint16(port),uint16(mBIdBack));
end

%If using a virtual environment create its size
if (debugSound)
	beaconPositions(1,:) = [500;320];
	farthestBeacon = 1;
end

%Set up Variables
coordsFront = 0;
coordsBack = 0;
playerPos = [250;170];

%Default player direction is forward
forward = [0; 1];

%Set Up Player
plr = Player(playerPos, forward, FrontAndBack);

%Sound Manager
soundMan = SoundManager(plr, rate);

%Start the menu
menu = Menu(beaconPositions(farthestBeacon, 1),beaconPositions(farthestBeacon, 2), soundMan);

%Set up the environmental factors
setupEnvironment(soundMan);

%Start the total time timer
totalTime = tic;

%Keep going until the user stops the program
while (soundMan.Stop == false)
	%If using a real environment update the user's location
	if (~debugSound)
		coordsFront = connFront.request_position();
		
		if(FrontAndBack)
			coordsBack = connBack.request_position();
		end
		
		%Set the position
		calcPosition(plr, coordsFront, coordsBack);
		%Determine the forward vector
		calcForward(plr);
		
		playerPos = plr.Position;
	end
	
	%Prepare the total sound environment for the current sound frame
	prepareSound(soundMan, hrir_l, hrir_r, ITD);
	
	%Play that sound
	playSound(soundMan);
	
	%Have a quick pause in order to allow users to use the menu
	pause(interval/5);
end

%Set Up User Struct
userData.ID = plr.ID;
userData.Interval = interval;
userData.TimeSpent = toc(totalTime);
userData.Path = plr.Path;

disp(userData.TimeSpent);

%Set up file Name
timeNow = datetime('now');
fileName = strcat('Sessions\', 'Subject_', int2str(userData.ID),'_', datestr(timeNow, 'mmmm_dd_yyyy_HH_MM_AM'), '.mat');

%Save all player data
save(fileName, 'userData');

%Clean up
connFront.close();
connBack.close();
