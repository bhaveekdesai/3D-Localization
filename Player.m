classdef Player < handle
	%PLAYER Holds all important user information
	%   Detailed explanation goes here
	
	properties
		ID = 0;
		
		Position;
		
		prevFront = 0;
		prevBack = 0;
		
		PosFront;
		PosBack;
		
		Forward;
		Right;
		
		FroAndBac;
		
		Path;
	end
	
	methods
		%Constructor
		function obj = Player(Position, Forward, FroAndBac)
			obj.Position = Position;
			obj.FroAndBac = FroAndBac;
			
			obj.Forward = normc(Forward);
			obj.Right = [obj.Forward(2) -obj.Forward(1)];
			
			obj.PosFront = [0;0];
			obj.PosBack = [0;0];
		end
		
		%Calculates the player position according the coordinates
		function calcPosition(obj, posFront, posBack)
			%Get the front position
			posFront = [double(posFront{1}); double(posFront{2})]/1;
			
			if (obj.prevFront == 0)
				obj.PosFront = posFront;
			else
				dist = norm(obj.prevFront - obj.PosFront);
				
				if (dist > 25)
					dist = min(50/dist, 1);
				
					obj.PosFront = dist*posFront + (1-dist)*obj.PosFront;
				end
			end
			
			
			if (obj.FroAndBac)
				%Get the back position
				posBack = [double(posBack{1}); double(posBack{2})]/1;
				
				if (obj.prevFront == 0)
					obj.PosBack = posBack;
				else
					dist = norm(obj.prevBack - obj.PosBack);

					if (dist > 25)
						dist = min(50/dist, 1);
					
						obj.PosBack = dist*posBack + (1-dist)*obj.PosBack;
					end
				end
				
				%Calculate the center
				obj.Position = (obj.PosFront + obj.PosBack)/2;
			else
				%If only 1 hedgehog then make that the position
				obj.Position = obj.PosFront;
			end
			
			obj.Path(end+1,:) = obj.Position;
			
			%Check to see that the beacon didn't jump too far
		end
		
		%Calculates the forward vector
		function calcForward(obj)
			%If there's only 1 hedgehog then do nothing
			if (obj.FroAndBac)
				%Get the vector from back to front and normalize it
				obj.Right = obj.PosFront - obj.PosBack;
				
				obj.Right = normc(obj.Right);
				
				obj.Forward = [-obj.Right(2) obj.Right(1)];
			end
		end
	end
	
end

