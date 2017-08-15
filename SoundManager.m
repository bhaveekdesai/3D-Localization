classdef SoundManager < handle
	%SOUNDMANAGER Controls the playing of audio
	%   Is responsible to hold all the sounds in the environment, create
	%   the sounds every frame, and then play those sounds
	
	properties
		%Holds all the sounds that will be played and the audioPlayer
		Sounds = {};
		Plr;
		FilePlayer;
		
		rate;
		Stop = false;
		
		%Contains the sound that total sound that will be played this tic
		SoundToPlay = [];
		
		%Holds two previous tics of sound in order to convolve to the right
		%size
		prevSig;
		currSig;
		
		%This can be deleted, not sure without testing
		%25 locations
		azimuths = [-80 -65 -55 -45:5:45 55 65 80];
		%50 locations
		elevations = -45 + 5.625 * (0:49);
	end
	
	methods
		%Constructor
		function obj = SoundManager(Player, rate)
			obj.Plr = Player;
			obj.rate = rate;
		end
		
		%Creates FilePlayer to play the sound
		function createFP(obj)
			obj.FilePlayer = dsp.AudioPlayer('QueueDuration', 0, 'BufferSizeSource', 'Property', 'BufferSize', obj.rate, 'SampleRate', obj.Sounds{1}.FileReader.SampleRate);
		end
		
		%Sets up the sounds after the are created
		function setupEnvironment(obj)
			%Creates a file reader for each sound
			for i = 1:length(obj.Sounds);
				createFR(obj.Sounds{i});
			end
			
			%Creates the total audioPlayer
			createFP(obj);
			
			%Sets up previous signals size
			obj.prevSig = zeros(length(obj.Sounds), obj.rate);
			obj.currSig = zeros(length(obj.Sounds), obj.rate);
		end
		
		%Goes through each sound and calculates it's sound matrix and then
		%adds it to the SoundToPlay matrix
		function prepareSound(obj, hrir_l, hrir_r, ITD)
			%Set up variables and refresh the SoundToPlay
			wav_left = [];
			wav_right = [];
			obj.SoundToPlay = [];
			
			%Go through each sound
			for i = 1:length(obj.Sounds)
				%Skip certain sounds for debugging
				if (obj.Sounds{i}.Active == false)
					continue;
				end
				
				%Take a step even if we are gonna drop it
				%to keep music in sync
				sig = getStep(obj.Sounds{i});
				sig = sig(:,1);

				%CONSIDER MOVING!!!!
				%Preprocessing
				%Check distance and skip if too far
				%If it's close enough calculate the effect on the sound
				dist = obj.Plr.Position - obj.Sounds{i}.Position;
				
				dist = sqrt(dist(1)*dist(1) + dist(2)*dist(2));

				if (dist > 300)
					continue;
				end

				%Shift and scale the distance for sound 
				dist = (dist-30)/30;
				
				%Stops division by 0
				if (dist < 1)
					dist = 1;
				end
				
				%Sound intensity attentuation
				dist = dist*dist;%*dist;
				
				%PREPROCESSING STOP
				
				%Currently not working
				%[left, right] = HRTFManager.getHRTF(obj.Plr, obj.Sounds{i}.Position, hrir_l, hrir_r, ITD);
				
				%
				%Get the azimuth angle and elevation index
				[azAngle, eIndex] = FindAngle(obj.Plr, obj.Sounds{i}.Position);
				%Get the correct index for a
				aIndex = find(obj.azimuths == azAngle,1);
				
				%Convolve the sound for that source
				left = squeeze(hrir_l(aIndex, eIndex, :));
				right = squeeze(hrir_r(aIndex, eIndex, :));

				%Determine the inter aural time delay
				delay = ITD(aIndex, eIndex);

				%Apply the delay
				if (aIndex < 13)
					left = [left' zeros(size(1:abs(delay)))];
					right = [zeros(size(1:abs(delay))) right'];
				else
					left = [zeros(size(1:abs(delay))) left'];
					right = [right' zeros(size(1:abs(delay)))];
				end
				%

				%Determine how much of each side you need to the perfect
				%size output of the convolution
				%The bare minimum of prev1 and sig
				sizeNeeded = length(left) - 1;
				sizeNeeded = sizeNeeded/2;
				sizeLeft = 0;
				sizeRight = 0;

				%Round properlly
				if (mod(sizeNeeded,2) == 0)
					sizeLeft = sizeNeeded;
					sizeRight = sizeNeeded;
				else
					sizeLeft = ceil(sizeNeeded);
					sizeRight = floor(sizeNeeded);
				end

				%Grab the end of the oldest tic and the first parts of the
				%newest tic and concatonate them with the current tic
				prevNibble = obj.prevSig(i,:);
				prevNibble = prevNibble(end - sizeLeft + 1:end);
				nextNibble = sig';
				nextNibble = nextNibble(1: sizeRight);

				newSig = horzcat(prevNibble, obj.currSig(i,:));
				newSig = horzcat(newSig, nextNibble);

				%Convolve the bloated tic without padding the edges
				wav_left = conv(newSig,left', 'valid');
				wav_right = conv(newSig, right', 'valid');
				
				%Pass down the tics of sound
				obj.prevSig(i, :) = obj.currSig(i, :);
				obj.currSig(i, :) = sig';
				
				%CONSIDER MOVING!!!
				%Post Processing
				%Apply the distance decay
				wav_left = wav_left/(dist);
				wav_right = wav_right/(dist);
				%POST PROCESSING STOP
				
				%Make sure soundToPlay is populated atleast once
				if (size(obj.SoundToPlay) ~= [0,0])
					obj.SoundToPlay(:,1) =  obj.SoundToPlay(:,1) + wav_left';
					obj.SoundToPlay(:,2) =  obj.SoundToPlay(:,2) + wav_right';
				else
					obj.SoundToPlay(:,1) =  wav_left';
					obj.SoundToPlay(:,2) =  wav_right';
				end
			end

			%If all the sounds are skipped then make a dummy sound to play
			%silence
			if (size(obj.SoundToPlay) == [0,0])
				obj.SoundToPlay = zeros(2,2);
			end
		end
		
		%Plays the current step in SountToPlay
		function playSound(obj)
			step(obj.FilePlayer, obj.SoundToPlay);
		end
	end
	
end

