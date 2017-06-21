classdef LocalizationManager < handles
	%UNTITLED Summary of this class goes here
	%   Detailed explanation goes here
	
	properties
		BeaconIDs = [];
		Conns = {};
	end
	
	methods
		function obj = LocalizationManager(varargin)
			PyPath = py.sys.path;
			if PyPath.count('.') == 0
			   insert(PyPath,int32(0),'.');
			end
			PyModule = py.sys.modules;
			if isa(PyModule.get('udpclient'),'py.NoneType')
				py.importlib.import_module('udpclient');
			end
			
			for i = 1:nargin
				obj.BeaconIds(i) = varargin(i);
				obj.Conns{i} = py.udpclient.udp_factory(ip,uint16(port),uint16(obj.BeaconIds(i)));
			end
		end
	end
	
end

