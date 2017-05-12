function [ gate_count ] = conclulateGateCount( data,start_index,end_index )
%CONCLULATEPORT Summary of this function goes here
%   Detailed explanation goes here
    gate_count = 0;
    for i = start_index : end_index
        gate_count = gate_count + length(strfind(data{i},'~'));
        gate_count = gate_count + length(strfind(data{i},'|'));
        gate_count = gate_count + length(strfind(data{i},'&'));
        gate_count = gate_count + length(strfind(data{i},'^'));
    end

end

