classdef TimerManager
	%TIMERMANAGER Summary of this class goes here
	%   Detailed explanation goes here
	
	properties
		LocalMan;
		Player;
		
		t;
	end
	
	methods
		function obj = Timermanager(localMan, plr)
			obj.LocalMan = localMan;
			obj.Player = plr;
			
			
		end
	end
	
end

