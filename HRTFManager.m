classdef HRTFManager
	%HRTFMANANGER Summary of this class goes here
	%   Detailed explanation goes here
	
	properties (Constant)
		%25 locations
		azimuths = [-80 -65 -55 -45:5:45 55 65 80];
		%50 locations
		elevations = -45 + 5.625 * (0:49);
	end
	
	methods(Static)
		function [azAngle, left, right, delay] = roundUp(hrir_l, hrir_r, ITD, azAngle)
			%In the positive section make the sound come from the front
			eIndex = 40;
			roundedAngle = 0;
			
			if (azAngle > -100 && azAngle <= 80)
				eIndex = 8;
			end
			
			%Round the azAngle to the nearest possible one
			%-180 - -90
			%eIndex = 40
			if (azAngle <= -175)
				roundedAngle = -5;
			elseif (azAngle <= -170)
				roundedAngle = -10;
			elseif (azAngle <= -165)
				roundedAngle = -15;
			elseif (azAngle <= -160)
				roundedAngle = -20;
			elseif (azAngle <= -155)
				roundedAngle = -25;
			elseif (azAngle <= -150)
				roundedAngle = -30;
			elseif (azAngle <= -145)
				roundedAngle = -35;
			elseif (azAngle <= -140)
				roundedAngle = -40;
			elseif (azAngle <= -135)
				roundedAngle = -45;
			elseif (azAngle <= -125)
				roundedAngle = -55;
			elseif (azAngle <= -115)
				roundedAngle = -65;
			elseif (azAngle <= -100)
				roundedAngle = -80;

			%-90 - 0
			%eIndex = 8
			elseif (azAngle <= -80)
				roundedAngle = -80;
			elseif (azAngle <= -65)
				roundedAngle = -65;
			elseif (azAngle <= -55)
				roundedAngle = -55;
			elseif (azAngle <= -45)
				roundedAngle = -45;
			elseif (azAngle <= -40)
				roundedAngle = -40;
			elseif (azAngle <= -35)
				roundedAngle = -35;
			elseif (azAngle <= -30)
				roundedAngle = -30;
			elseif (azAngle <= -25)
				roundedAngle = -25;
			elseif (azAngle <= -20)
				roundedAngle = -20;
			elseif (azAngle <= -15)
				roundedAngle = -15;
			elseif (azAngle <= -10)
				roundedAngle = -10;
			elseif (azAngle <= -5)
				roundedAngle = -5;
			elseif (azAngle <= 0)
				roundedAngle = 0;

			%0 - 90
			%eIndex = 8
			elseif (azAngle <= 5)
				roundedAngle = 5;
			elseif (azAngle <= 10)
				roundedAngle = 10;
			elseif (azAngle <= 15)
				roundedAngle = 15;
			elseif (azAngle <= 20)
				roundedAngle = 20;
			elseif (azAngle <= 25)
				roundedAngle = 25;
			elseif (azAngle <= 30)
				roundedAngle = 30;
			elseif (azAngle <= 35)
				roundedAngle = 35;
			elseif (azAngle <= 40)
				roundedAngle = 40;
			elseif (azAngle <= 45)
				roundedAngle = 45;
			elseif (azAngle <= 55)
				roundedAngle = 55;
			elseif (azAngle <= 65)
				roundedAngle = 65;
			elseif (azAngle <= 80)
				roundedAngle = 80;

			%90 - 180
			%eIndex = 40
			elseif (azAngle <= 100)
				roundedAngle = 80;
			elseif (azAngle <= 115)
				roundedAngle = 65;
			elseif (azAngle <= 125)
				roundedAngle = 55;
			elseif (azAngle <= 135)
				roundedAngle = 45;
			elseif (azAngle <= 140)
				roundedAngle = 40;
			elseif (azAngle <= 145)
				roundedAngle = 35;
			elseif (azAngle <= 150)
				roundedAngle = 30;
			elseif (azAngle <= 155)
				roundedAngle = 25;
			elseif (azAngle <= 160)
				azAngle = 20;
			elseif (azAngle <= 165)
				roundedAngle = 15;
			elseif (azAngle <= 170)
				roundedAngle = 10;
			elseif (azAngle <= 175)
				roundedAngle = 5;
			elseif (azAngle <= 180)
				roundedAngle = 0;
			end
			
			aIndex = find(HRTFManager.azimuths == roundedAngle,1);
			
			if (azAngle < 0)
				roundedAngle = (-180 - roundedAngle);
			else
				roundedAngle = (180 - roundedAngle);
			end
			
			azAngle = roundedAngle;
			
			%Convolve the sound for that source
			left = squeeze(hrir_l(aIndex, eIndex, :));
			right = squeeze(hrir_r(aIndex, eIndex, :));
			
			delay = ITD(aIndex, eIndex);
		end
		
		function [azAngle, left, right, delay] = roundDown(hrir_l, hrir_r, ITD, azAngle)
			%In the positive section make the sound come from the front
			eIndex = 40;
			
			if (azAngle > -80 && azAngle <= 100)
				eIndex = 8;
			end
			
			%Round the azAngle to the nearest possible one
			%-180 - -90
			%eIndex = 40
			if (azAngle <= -175)
				roundedAngle = 0;
			elseif (azAngle <= -170)
				roundedAngle = -5;
			elseif (azAngle <= -165)
				roundedAngle = -10;
			elseif (azAngle <= -160)
				roundedAngle = -15;
			elseif (azAngle <= -155)
				roundedAngle = -20;
			elseif (azAngle <= -150)
				roundedAngle = -25;
			elseif (azAngle <= -145)
				roundedAngle = -30;
			elseif (azAngle <= -140)
				roundedAngle = -35;
			elseif (azAngle <= -135)
				roundedAngle = -40;
			elseif (azAngle <= -125)
				roundedAngle = -45;
			elseif (azAngle <= -115)
				roundedAngle = -55;
			elseif (azAngle <= -100)
				roundedAngle = -65;
			elseif (azAngle <= -80)
				roundedAngle = -80;
			
			%-90 - 0
			%eIndex = 8
			elseif (azAngle <= -65)
				roundedAngle = -80;
			elseif (azAngle <= -55)
				roundedAngle = -65;
			elseif (azAngle <= -45)
				roundedAngle = -55;
			elseif (azAngle <= -40)
				roundedAngle = -45;
			elseif (azAngle <= -35)
				roundedAngle = -40;
			elseif (azAngle <= -30)
				roundedAngle = -35;
			elseif (azAngle <= -25)
				roundedAngle = -30;
			elseif (azAngle <= -20)
				roundedAngle = -25;
			elseif (azAngle <= -15)
				roundedAngle = -20;
			elseif (azAngle <= -10)
				roundedAngle = -15;
			elseif (azAngle <= -5)
				roundedAngle = -10;
			elseif (azAngle <= 0)
				roundedAngle = -5;
			elseif (azAngle <= 5)
				roundedAngle = 0;
				
			%0 - 90
			%eIndex = 8
			elseif (azAngle <= 10)
				roundedAngle = 5;
			elseif (azAngle <= 15)
				roundedAngle = 10;
			elseif (azAngle <= 20)
				roundedAngle = 15;
			elseif (azAngle <= 25)
				roundedAngle = 20;
			elseif (azAngle <= 30)
				roundedAngle = 25;
			elseif (azAngle <= 35)
				roundedAngle = 30;
			elseif (azAngle <= 40)
				roundedAngle = 35;
			elseif (azAngle <= 45)
				roundedAngle = 40;
			elseif (azAngle <= 55)
				roundedAngle = 45;
			elseif (azAngle <= 65)
				roundedAngle = 55;
			elseif (azAngle <= 80)
				roundedAngle = 65;
			elseif (azAngle <= 100)
				roundedAngle = 80;
				
			%90 - 180
			%eIndex = 40
			elseif (azAngle <= 115)
				roundedAngle = 80;
			elseif (azAngle <= 125)
				roundedAngle = 65;
			elseif (azAngle <= 135)
				roundedAngle = 55;
			elseif (azAngle <= 140)
				roundedAngle = 45;
			elseif (azAngle <= 145)
				roundedAngle = 40;
			elseif (azAngle <= 150)
				roundedAngle = 35;
			elseif (azAngle <= 155)
				roundedAngle = 30;
			elseif (azAngle <= 160)
				roundedAngle = 25;
			elseif (azAngle <= 165)
				roundedAngle = 20;
			elseif (azAngle <= 170)
				roundedAngle = 15;
			elseif (azAngle <= 175)
				roundedAngle = 10;
			elseif (azAngle <= 180)
				roundedAngle = 5;
			end
			
			aIndex = find(HRTFManager.azimuths == roundedAngle,1);
			
			if (azAngle < 0)
				roundedAngle = (-180 - roundedAngle);
			else
				roundedAngle = (180 - roundedAngle);
			end
			
			azAngle = roundedAngle;
				
			%Convolve the sound for that source
			left = squeeze(hrir_l(aIndex, eIndex, :));
			right = squeeze(hrir_r(aIndex, eIndex, :));
			
			delay = ITD(aIndex, eIndex);
		end
		
		function [left, right] = interpolateAngles(angle, angleMin, angleMax, leftMin, rightMin, leftMax, rightMax, delayMin, delayMax)
			lambda = .5;
			
			if (angleMax ~= angleMin)
				lambda = abs(angle-angleMin)/abs(angleMax-angleMin);
			end

			left = (1-lambda)*leftMin + lambda*leftMax;
			right = (1-lambda)*rightMin + lambda*rightMax;

			delay = (1-lambda)*delayMin + lambda*delayMax;
			
			if (angle < 0)
				left = [left' zeros(size(1:abs(delay)))];
				right = [zeros(size(1:abs(delay))) right'];
			else
				left = [zeros(size(1:abs(delay))) left'];
				right = [right' zeros(size(1:abs(delay)))];
			end
		end
		
		function [ left, right ] = getHRTF(plr, soundPos, hrir_l, hrir_r, ITD)
			%Get the vector from the player to the sound pos and
			%normalizes it
			directionVec = soundPos - plr.Position;
			directionVec = normc(directionVec);

			%Calculates the degree angle between the forward vector and the source
			%of the sound
			azAngle = acosd(dot(directionVec, plr.Forward));

			%Make the angle negative if it needs to be
			if (acosd(dot(directionVec, plr.Right)) > 90)
				azAngle = -azAngle;
			end
			
			disp(azAngle);
			
			[angleMax, leftMax, rightMax, delayMax] = HRTFManager.roundUp(hrir_l, hrir_r, ITD, azAngle);
			[angleMin, leftMin, rightMin, delayMin] = HRTFManager.roundDown(hrir_l, hrir_r, ITD, azAngle);
			
			disp(angleMax);
			disp(angleMin);
			
			[left, right] = HRTFManager.interpolateAngles(azAngle, angleMin, angleMax, leftMax, rightMax, leftMin, rightMin, delayMin, delayMax);
			
		end
	end
	
end

