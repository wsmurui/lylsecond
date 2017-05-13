function [ ts ] = getTs( logic,port,curlut,name_node_map )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
    index = strfind(logic,port);
    ts = nan(1,length(index));
    for i = 1 : length(index)
        if logic(index(i)-1) == '~'
            ts(i) = name_node_map([[[[curlut,','],num2str(index(i)-1)],','],logic(index(i)-1)]);
            continue;
        end
        
        if logic(index(i)+2) == '|' ...
                || logic(index(i)+2) == '^' ...
                || logic(index(i)+2) == '&'
            ts(i) = name_node_map([[[[curlut,','],num2str(index(i)+2)],','],logic(index(i)+2)]);
            continue;
        end
        
        if logic(index(i)-1) == '|' ...
                || logic(index(i)-1) == '^' ...
                || logic(index(i)-1) == '&'
            ts(i) = name_node_map([[[[curlut,','],num2str(index(i)-1)],','],logic(index(i)-1)]);
            continue;
        end
    end
end

