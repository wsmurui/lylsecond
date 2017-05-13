function [ adj_zeros ] = findNextGate( logic,curindex,adj_zeros,name_node_map,lutname,curnode )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    leftindex = curindex - 1;
    leftcount = 0;
    rightindex = curindex + 1;
    rightcount = 0;
    while(leftindex > 0)
        if logic(leftindex) == ')'
            leftcount = leftcount - 1;
        elseif logic(leftindex) == '('
            leftcount = leftcount + 1;
        end
        if leftcount == 1
            break;
        end
        if leftcount == 0 && (logic(leftindex) == '&' || logic(leftindex) == '|' || logic(leftindex) == '^')
            leftindex = leftindex + 1;
            break;
        end
        leftindex = leftindex - 1;
    end
    
    while(rightindex <= length(logic))
        if logic(rightindex) == '('
            rightcount = rightcount - 1;
        elseif logic(rightindex) == ')'
            rightcount = rightcount + 1;
        end
        if rightcount == 1
            break;
        end
        rightindex = rightindex + 1;
    end
    
    if leftindex == 1
        disp('输出口');
    elseif leftcount == 0 && (logic(leftindex-1) == '|' || logic(leftindex-1) == '&' || logic(leftindex-1) == '^')
        s = curnode;
        t = name_node_map([[[[lutname,','],num2str(leftindex - 1)],','],logic(leftindex - 1)]);
        adj_zeros(s,t) = 1;
    elseif logic(rightindex+1) == '|' || logic(rightindex+1) == '&' || logic(rightindex+1) == '^'
        s = curnode;
        t = name_node_map([[[[lutname,','],num2str(rightindex+1)],','],logic(rightindex+1)]);
        adj_zeros(s,t) = 1;
    elseif logic(leftindex-1) == '|' || logic(leftindex-1) == '&' || logic(leftindex-1) == '^'
        s = curnode;
        t = name_node_map([[[[lutname,','],num2str(leftindex - 1)],','],logic(leftindex - 1)]);
        adj_zeros(s,t) = 1;
    else
        error('wrong!!!!!!! "findNextGate 出现错误" please check it');
    end

end

