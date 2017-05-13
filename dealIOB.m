function [ name_node_map,total_node_count ] = dealIOB(data,start_index,end_index,name_node_map,total_node_count)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    for i = start_index : end_index
        total_node_count = total_node_count + 1;
        blank = strfind(data{i},' ');
        designation = data{i}(blank(2)+1 : blank(3)-1);
        slice = data{i}(blank(4)+1 : blank(5)-1);
        io = data{i}(blank(length(blank))+1 : length(data{i}));
        mkey = '';
        if strcmpi(io,'input')
            mkey = [[[designation,','],'I,'],slice];
        elseif strcmpi(io,'output')
            mkey = [[[designation,','],'O,'],slice];
        end
        name_node_map(mkey) = total_node_count;
    end


end

