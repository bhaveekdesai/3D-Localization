function [ azAngle, eIndex ] = FindAngle( playerPos, playerFor, soundPos)
%FINDANGLE Gets the rounded angles of azimuth and elevation
%   Takes player pos and direction and calulcates what precise angle the
%   hrtf should play from

%Need to change this to interpolation cause right now it's very ham fisted

	%Get the vector from the player to the sound pos and
	%normalizes it
    directionVec = soundPos - playerPos;
	directionVec = normc(directionVec);
	
	playerRight = [playerFor(2) -playerFor(1)];

	%Calculates the degree angle between the forward vector and the source
	%of the sound
	azAngle = acosd(dot(directionVec, playerFor));
	
	%Make the angle negative if it needs to be
	if (acosd(dot(directionVec, playerRight)) > 90)
		azAngle = -azAngle;
	end
	
	%In the positive section make the sound come from the front
	if (azAngle > -90 && azAngle < 90)
		eIndex = 9;
		
		%Round the angles to the nearest possible angle
		if (azAngle < -72.5)
			azAngle = -80;
		elseif (azAngle < -60)
			azAngle = -65;
		elseif (azAngle < -50)
			azAngle = -55;
		elseif (azAngle < -42.5)
			azAngle = -45;
		elseif (azAngle < -37.5)
			azAngle = -40;
		elseif (azAngle < -32.5)
			azAngle = -35;
		elseif (azAngle < -27.5)
			azAngle = -30;
		elseif (azAngle < -22.5)
			azAngle = -25;
		elseif (azAngle < -17.5)
			azAngle = -20;
		elseif (azAngle < -12.5)
			azAngle = -15;
		elseif (azAngle < -7.5)
			azAngle = -10;
		elseif (azAngle < -2.5)
			azAngle = -5;
		elseif (azAngle < 2.5)
			azAngle = 0;
		elseif (azAngle < 7.5)
			azAngle = 5;
		elseif (azAngle < 12.5)
			azAngle = 10;
		elseif (azAngle < 17.5)
			azAngle = 15;
		elseif (azAngle < 22.5)
			azAngle = 20;
		elseif (azAngle < 27.5)
			azAngle = 25;
		elseif (azAngle < 32.5)
			azAngle = 30;
		elseif (azAngle < 37.5)
			azAngle = 35;
		elseif (azAngle < 42.5)
			azAngle = 40;
		elseif (azAngle < 50)
			azAngle = 45;
		elseif (azAngle < 60)
			azAngle = 55;
		elseif (azAngle < 72.5)
			azAngle = 65;
		elseif (azAngle < 90)
			azAngle = 80;
		end
	else 
		
		%If the azAngle is behind, have the elevation make it so the sound
		%goes all the way around
		eIndex = 49;
		
		%Round the azAngle to the nearest possible one
		if (azAngle < -177.5)
			azAngle = 0;
		elseif (azAngle < -172.5)
			azAngle = -5;
		elseif (azAngle < -167.5)
			azAngle = -10;
		elseif (azAngle < -162.5)
			azAngle = -15;
		elseif (azAngle < -157.5)
			azAngle = -20;
		elseif (azAngle < -152.5)
			azAngle = -25;
		elseif (azAngle < -147.5)
			azAngle = -30;
		elseif (azAngle < -142.5)
			azAngle = -35;
		elseif (azAngle < -137.5)
			azAngle = -40;
		elseif (azAngle < -132.5)
			azAngle = -45;
		elseif (azAngle < -120)
			azAngle = -55;
		elseif (azAngle < -110)
			azAngle = -65;
		elseif (azAngle <= -90)
			azAngle = -80;
		end
		
		if (azAngle > 177.5)
			azAngle = 0;
		elseif (azAngle > 172.5)
			azAngle = 5;
		elseif (azAngle > 167.5)
			azAngle = 10;
		elseif (azAngle > 162.5)
			azAngle = 15;
		elseif (azAngle > 157.5)
			azAngle = 20;
		elseif (azAngle > 152.5)
			azAngle = 25;
		elseif (azAngle > 147.5)
			azAngle = 30;
		elseif (azAngle > 142.5)
			azAngle = 35;
		elseif (azAngle > 137.5)
			azAngle = 40;
		elseif (azAngle > 132.5)
			azAngle = 45;
		elseif (azAngle > 120)
			azAngle = 55;
		elseif (azAngle > 110)
			azAngle = 65;
		elseif (azAngle >= 90)
			azAngle = 80;
		end
	end
end

