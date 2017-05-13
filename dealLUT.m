function [ name_node_map,total_node_count,lut_logic_map] = dealLUT( data,start_index,end_index,name_node_map,total_node_count,lut_logic_map)
%CONCLULATEPORT Summary of this function goes here
%   Detailed explanation goes here
    for i = start_index : end_index
        blank = strfind(data{i},' ');
        lut_name = data{i}(1:blank(1)-1);
        logic = data{i}(blank(length(blank))+1 : length(data{i}));
        lut_logic_map(lut_name) = logic;
        index = strfind(logic,'~');
        for j = 1:length(index)
            total_node_count = total_node_count + 1;
            mkey = [[[lut_name,','],num2str(index(j))],',~'];
            name_node_map(mkey) = total_node_count;
        end
        
        index = strfind(logic,'|');
        for j = 1:length(index)
            total_node_count = total_node_count + 1;
            mkey = [[[lut_name,','],num2str(index(j))],',|'];
            name_node_map(mkey) = total_node_count;
        end
        
        index = strfind(logic,'&');
        for j = 1:length(index)
            total_node_count = total_node_count + 1;
            mkey = [[[lut_name,','],num2str(index(j))],',&'];
            name_node_map(mkey) = total_node_count;
        end
        
        index = strfind(logic,'^');
        for j = 1:length(index)
            total_node_count = total_node_count + 1;
            mkey = [[[lut_name,','],num2str(index(j))],',^'];
            name_node_map(mkey) = total_node_count;
        end
    end
    remove(lut_logic_map,'abc');
    remove(name_node_map,'abc');
end

