classdef Sound3D < handle
	%SOUND3D Sound class to hold all data about sounds in the environment
	%   Detailed explanation goes here
	
	properties
		SoundFile;				%Name of the sound file
		Position = [0;0];		%Location of sound in 2D space
		SampleRate;				%Sample rate of the sound
		PlayCount;				%How many times the sound will be repeated
		FileReader;				%FileReader to be read and used
		Active;					%Bool to determine if sound should play or not
	end
	
	methods
		%Constructor
		function obj = Sound3D(SoundFile, Position, SampleRate, PlayCount, Active)
			obj.SoundFile = SoundFile;
			obj.Position = Position;
			obj.SampleRate = SampleRate;
			obj.PlayCount = PlayCount;
			obj.Active = Active;
		end
		
		%Creates and stores its own fileReader
		function createFR(obj)
			obj.FileReader = dsp.AudioFileReader(obj.SoundFile, 'SamplesPerFrame', obj.SampleRate, 'PlayCount', obj.PlayCount);
		end
		
		%Produces the next step of sound
		function nextStep = getStep(obj)
			nextStep = step(obj.FileReader);
		end
	end
	
end

