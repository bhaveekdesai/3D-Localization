classdef Player < handle
	%PLAYER Holds all important user information
	%   Holds the players ID, Position, Front/Back Positions, Forward/Right
	%   vector, and the path
	
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
			
			%If no previous then set it to the current location
			if (obj.prevFront == 0)
				obj.PosFront = posFront;
			else
				%Calculate the distance
				dist = norm(obj.prevFront - obj.PosFront);
				
				%If the distance is smaller than 25 cm don't update
				if (dist > 25)
					%Change the distance to be a range from [0,1] with
					%anything below 50 being 1
					dist = min(50/dist, 1);
				
					%Now interpolate the distances in order to prevent
					%massive leaps in space
					
					%Users will still move when jumps occur int he system
					%but are buffered
					obj.PosFront = dist*posFront + (1-dist)*obj.PosFront;
				end
			end
			
			%See above for the same thing
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
			
			%Add the location to the path
			obj.Path(end+1,:) = obj.Position;
			
			%Check to see that the beacon didn't jump too far
		end
		
		%Calculates the forward vector
		function calcForward(obj)
			%If there's only 1 hedgehog then do nothing
			if (obj.FroAndBac)
				%In this instance the hedgehogs are oriented horizatonally
				%so they form the right
				obj.Right = obj.PosFront - obj.PosBack;
				
				%Normalize it
				obj.Right = normc(obj.Right);
				
				%Calculate forward from the right vector
				obj.Forward = [-obj.Right(2) obj.Right(1)];
			end
		end
	end
	
end

