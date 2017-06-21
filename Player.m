classdef Player < handle
	%PLAYER Holds all important user information
	%   Detailed explanation goes here
	
	properties
		Position;
		PosFront;
		PosBack;
		Forward;
		
		FroAndBac;
	end
	
	methods
		%Constructor
		function obj = Player(Position, Forward, FroAndBac)
			obj.Position = Position;
			obj.Forward = normc(Forward);
			obj.FroAndBac = FroAndBac;
			
			obj.PosFront = [0;0];
			obj.PosBack = [0;0];
		end
		
		%Calculates the player position according the coordinates
		function calcPosition(obj, posFront, posBack)
			%Get the front position
			obj.PosFront = [double(posFront{1}); double(posFront{2})]/100;
			
			if (obj.ForAndBac)
				%Get the back position
				obj.PosBack = [double(posBack{1}); double(posBack{2})]/100;
				
				%Calculate the center
				obj.Position = (obj.PosFront + obj.PosBack)/2;
			else
				%If only 1 hedgehog then make that the position
				obj.Position = obj.PosFront;
			end
		end
		
		%Calculates the forward vector
		function calcForward(obj)
			%If there's only 1 hedgehog then do nothing
			if (obj.FroAndBac)
				%Get the vector from back to front and normalize it
				obj.Forward = obj.PosFront - obj.PosBack;
				
				obj.Forward = normc(obj.Forward);
			end
		end
	end
	
end

