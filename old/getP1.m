global count;
p1map = containers.Map;

for i=1:length(input)
    p1map([input{i},',I|']) = count.input_p(i);         %简单情况把设置的input_p(i)的值赋值过去
end

% for i=1:length(input)
%     p1map([input{i},',I|']) = 0.5;        %复杂情况设置每个端口为1的概率为0.5
% end

for i=1:length(count.logidata)
    info = count.logidata{i};       %LUT逻辑连线内容
    if length(findstr(info,'LUT'))~=0
            c_lut = info;       %把有LUT信息的逻辑连线赋给c_lut
    end
    if length(findstr(info,'<-'))~=0        %有<-的段
        if strcmp(info(findstr(info,'-')+2:length(info)),'null')    %输入是null
            lie_axil = str2num(c_lut(findstr(c_lut,'-')+1:length(c_lut)))+1;    %输入信息null这种
            hand_axil = str2num(info(2));   %输入信息链接的LUT的端口数字
            count.lut_input_info(hand_axil,lie_axil) = 0;
            continue;
        end
        if length(findstr(info,'XDL_DUMMY_INT'))~=0 %输入是XDL_DUMMY_INT
            lie_axil = str2num(c_lut(findstr(c_lut,'-')+1:length(c_lut)))+1;        %输入信息
            hand_axil = str2num(info(2));    %输入信息链接的LUT的端口数字
            count.lut_input_info(hand_axil,lie_axil) = 0;
            continue; 
        end
        if length(findstr(info,'Mxor_N380_xo<0>29'))~=0 %输入是Mxor_N380_xo<0>29
            lie_axil = str2num(c_lut(findstr(c_lut,'-')+1:length(c_lut)))+1;        %输入信息
            hand_axil = str2num(info(2));    %输入信息链接的LUT的端口数字
            count.lut_input_info(hand_axil,lie_axil) = 0;
            continue;
        end
        douk = findstr(info,',');    %输入中的','的索引
        mapkey = info(findstr(info,'-') + 2:douk(2)-1);  %N7这这输入信息 键值对的键
        sz_key = cell2mat(keys(p1map));                  %key就是键的意思，这里sz_key是数组（sz）键，就是用一个数组来保存目前存在的所有键  %？？？
        if length(findstr(sz_key,[mapkey,'|']))~=0       %判断目前存在所有键中是否有mapkey，也就是说,比如当前是N7，意思就是查看是否保存有N7为1的概率
            p1 = p1map([mapkey,'|']);
            lie_axil = str2num(c_lut(findstr(c_lut,'-')+1:length(c_lut)))+1;
            hand_axil = str2num(info(2));
            count.lut_input_info(hand_axil,lie_axil) = p1;
        end
    end
end
%初始化输入输出完成，下面根据初始化的LUT输入表求其他LUT表

%检测，当一个LUT的6个口为1的概率都知道了，那么我就要去计算它的输出为1的概率，但是我对每个LUT我都只会计算一次，重复计算没有意义
%所以就用lutis_used_info来保存LUT是否已经计算过了，如果计算过了lutis_used_info对应的那个lut就是置为1，我就不会计算了，当所有的都为1了，那我就计算完了，不会继续循环了。
last = length(find(count.lutis_used_info==1));
while true
    for i = 1:size(count.lut_input_info,2)
        if count.lutis_used_info(i) == 1   %为1了，当前lut计算了不计算了
            continue;                      %跳过下面代码，进入下次循环
        end
        if length(find(count.lut_input_info(:,i)>=0)) == 6   %6个口都有为1的概率了，那么就可以计算了
            count.lutis_used_info(i) = 1;                      % 标注这个LUT用过了
            plus_index = findstr(count.lut_info{i},'+') ;       %找到+的位置。
            logi = count.lut_info{i}(plus_index(length(plus_index))+2:length(count.lut_info{i}));      %找lut的逻辑信息
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            p1_out = calculate_lutoutput( count.lut_input_info(:,i), logi );   %调用calculate_lutoutput函数计算出当前lut的输出为1的概率
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            cu_slice = count.lut_info{i}(plus_index(1)+2:plus_index(2)-2);  %当前的slice
            pin = count.lut_info{i}(plus_index(length(plus_index)-1)+2);       %当前输出端口，A,B,C,D
            p1map([cu_slice,',',pin,'|']) = p1_out;      %键值对，就是说当前slice的某个端口为1的概率知道了，那么就加入当键值对数组中去
            p1map([cu_slice,',',pin,'MUX|']) = p1_out;      %同上，只是键值不一样，上是端口号，这个是MUX
        end
    end

    %这个循环就是便利所有的LUT，因为上一个循环只是求出了Slice+端口号的1概率，但是并不知道这个slice+端口号链接在哪一个LUT上
    %下面这个循环就是遍历每一个LUT的每个输入口是链接在哪个Slice+端口上，在从键值对数组中找是否有这个端口号的概率，有的话这个LUT的这个输入端口的1概率也就知道了
    %就可以再回到上一个循环中再找是否哪个LUT的6个端口的1概率都有了而且没计算的LUT，再进行计算。
    for i=1:length(count.logidata)
        info = count.logidata{i};
        if length(findstr(info,'LUT'))~=0
                c_lut = info;
        end
        if count.lutis_used_info(str2num(c_lut(findstr(c_lut,'-')+1:length(c_lut)))+1) == 1
            continue;
        end
        if length(findstr(info,'<-'))~=0
            douk = findstr(info,',');
            if length(douk) == 0
                continue;
            end
            mapkey = info(findstr(info,'-') + 2:douk(2)-1);
            sz_key = cell2mat(keys(p1map));
            if length(findstr(sz_key,[mapkey,'|']))~=0
                p1 = p1map([mapkey,'|']);
                lie_axil = str2num(c_lut(findstr(c_lut,'-')+1:length(c_lut)))+1;
                hand_axil = str2num(info(2));
                count.lut_input_info(hand_axil,lie_axil) = p1;
            end
        end
    end
    
    %%当每个LUT都计算过了，就停止while true 这个大循环了。
    if length(find(count.lutis_used_info==1))==length(count.lutis_used_info)
        break;
    elseif last == length(find(count.lutis_used_info==1))
        break;
    else 
        last = length(find(count.lutis_used_info==1));
    end
end
%所有LUT表输入口为1的概率已经求出

%求最终输出口为1的概率
for i = 1:length(count.logidata)
    info = count.logidata{i};
    if length(findstr(info,'LUT'))~=0
            c_lut = info;
            continue;
    end
    if length(findstr(info,'->'))~=0 && length(findstr(info,',O,'))~=0
        if count.lutis_used_info(str2num(c_lut(findstr(c_lut,'-')+1:length(c_lut)))+1) == 1
            mykey = info(findstr(info,'>')+3:findstr(info,',')-1);
            index = str2num(c_lut(findstr(c_lut,'-')+1:length(c_lut)))+1;
            plus_index = findstr(count.lut_info{index},'+') ;
            cu_slice = count.lut_info{index}(plus_index(1)+2:plus_index(2)-2);
            pin = count.lut_info{index}(plus_index(length(plus_index)-1)+2);
            sz_key = cell2mat(keys(p1map));
            if length(findstr(sz_key,[cu_slice,',',pin,'|']))~=0
                p1map(mykey) = p1map([cu_slice,',',pin,'|']);
            else
                p1map(mykey) = p1map([cu_slice,',',pin,'MUX|']);
            end
        end
    end
end

for i = 1 : length(output)
    count.output_p(i) = p1map(output{i});
end



