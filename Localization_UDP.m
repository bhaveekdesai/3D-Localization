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

rate = rate*interval;
%44100 - 1
%11050 - 0.25
%4410 - .1

FrontAndBack = true;
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
	
	for i = 1:length(beacons)
		%Open the connect
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
		
		if (farthestDistance <= distance)
			farthestBeacon = i;
			farthestDistance = distance;
		end
		
	end

	%Open the connection for each beacon
	connFront = py.udpclient.udp_factory(ip,uint16(port),uint16(mBIdFront));
	connBack = py.udpclient.udp_factory(ip,uint16(port),uint16(mBIdBack));
end

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

menu = Menu(beaconPositions(farthestBeacon, 1),beaconPositions(farthestBeacon, 2), soundMan);

setupEnvironment(soundMan);

totalTime = tic;

%Keep going until the user won (By reaching the exit cell)
while (soundMan.Stop == false)
	loopTime = tic;
	
	if (~debugSound)
		coordsFront = connFront.request_position();
		
		if(FrontAndBack)
			coordsBack = connBack.request_position();
		end
		
		calcPosition(plr, coordsFront, coordsBack);
		calcForward(plr);
		
		playerPos = plr.Position;
	end
	
	prepareSound(soundMan, hrir_l, hrir_r, ITD);
	
	%Play that sound
	playSound(soundMan);
	
	%disp(toc(loopTime));
	
	%Allow the sound to play
	pause(interval/5);
	
	%Sleep to be more precise
	%java.lang.Thread.sleep(max(interval - 20*toc(loopTime),0)*1000);
	
	%disp(toc(loopTime));
end

%SSet Up User Struct
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
