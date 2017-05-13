for i = 1:length(data)
    if length(strfind(data{i},'LUT-')) > 0 && length(data{i}) < 10
        curlut = data{i};
%         disp(curlut);
    end
    if length(strfind(data{i},'<-')) > 0
        blank = strfind(data{i},' ');
        inputinfo = data{i}(blank(length(blank))+1:length(data{i}));
        port = data{i}(1:2);
        logic = lut_logic_map(curlut);
        
%         disp(inputinfo);disp(port);disp(logic)
        if strcmpi(inputinfo,'null')
            continue;
        end
        s = name_node_map(inputinfo);
        ts = getTs(logic,port,curlut,name_node_map);
        for j = 1:length(ts)
            adj_zeros(s,ts(j)) = 1;
        end
    end
    
    if length(strfind(data{i},'->')) > 0
        blank = strfind(data{i},' ');
        inputinfo = data{i}(blank(length(blank))+1:length(data{i}));
        if strfind(inputinfo,',')
            index = strfind(inputinfo,',');
            if inputinfo(index(1)+1) == 'O'
                mkey = lut_module_map(curlut);
                s = name_node_map(mkey);
                t = name_node_map(inputinfo);
                adj_zeros(s,t) = 1;
            end
        end
    end
    
end