function [  ] = outmux_seek( outmux ,path)
global count;
    for i=1:length(count.outmux_logi)
        if strcmp(count.outmux_logi{i},outmux)
            a_start = i;
            break;
        end
    end
    for i=a_start+1:length(count.outmux_logi)
        if length(findstr(count.outmux_logi{i},'OUTMUX'))~=0
            break;
        end
        if length(findstr(count.outmux_logi{i},',O,'))~=0
            count.result{count.num} = [path,'->',count.outmux_logi{i}(findstr(count.outmux_logi{i},'>')+3:findstr(count.outmux_logi{i},',')-1)];
            count.num = count.num + 1;
        end
    end
end

