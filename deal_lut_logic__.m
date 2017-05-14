adj_zeros = zeros(total_node_count,total_node_count);

mkeys = keys(lut_logic_map);

for i = 1:length(mkeys)
    lutname = mkeys{i};
    logic = lut_logic_map(lutname);
    
    index = strfind(logic,'~');
    for j = 1:length(index)
        mkey = [[[lutname,','],num2str(index(j))],',~'];
        leftindex = index(j)-1;
        rightindex = index(j)+3;
        if logic(leftindex) == '|' || logic(leftindex) == '&' || logic(leftindex) == '^'
            s = name_node_map(mkey);
            t = name_node_map([[[[lutname,','],num2str(leftindex)],','],logic(leftindex)]);
            adj_zeros(s,t) = 1;
        elseif logic(rightindex) == '|' || logic(rightindex) == '&' || logic(rightindex) == '^'
            s = name_node_map(mkey);
            t = name_node_map([[[[lutname,','],num2str(rightindex)],','],logic(rightindex)]);
            adj_zeros(s,t) = 1;
        else
            error('wrong!!!!!!! "deal_lut_logic��û�ҵ����ŵ���һ����" please check it');
        end
    end
    
    index = strfind(logic,'|');
    for j = 1:length(index)
        mkey = [[[lutname,','],num2str(index(j))],',|'];
        [adj_zeros name_node_map] = findNextGate(logic,index(j),adj_zeros,name_node_map,lutname,name_node_map(mkey),lut_module_map);
    end
    index = strfind(logic,'&');
    for j = 1:length(index)
        mkey = [[[lutname,','],num2str(index(j))],',&'];
        [adj_zeros name_node_map] = findNextGate(logic,index(j),adj_zeros,name_node_map,lutname,name_node_map(mkey),lut_module_map);
    end
    index = strfind(logic,'^');
    for j = 1:length(index)
        mkey = [[[lutname,','],num2str(index(j))],',^'];
        [adj_zeros name_node_map] = findNextGate(logic,index(j),adj_zeros,name_node_map,lutname,name_node_map(mkey),lut_module_map);
    end
    
end