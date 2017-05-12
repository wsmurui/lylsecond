
%%计算故障的在lut之间的传播概率

global count;

error_info = 1 - zeros(1,length(input)); %%error_info是输入端口是否错误的表示，为1表示正确，为0就是错误
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
error_info(1) = 0;      %这里让第3个输入错误，为0
                        %%%%%这里改输入的初始值，error_info(3) = 0;表示第3个输入错误
                        %%%%%error_info(4) = 0 表示第4个输入错误
error_p = 1;            %误差概率100%，也就是1，误差概率设置
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wrong_inoutID = '';     %错误的端口号，N1，N2或者其他，这里先初始化出来，下面再计算

worng_num = 0;          %错误的数量，因为不知一条路错嘛
final_result = {};      %最终的结果，比如N23，0.4863,意义就是N23的误差为0.4863
for i = 1:length(input)
    if error_info(i) == 0
        wrong_inoutID = input{i};       %找到错误端口了，比如N6
        break;
    end
end
 %%%%%%%%%%%%%%%%%%%%%%%%初始化完成%%%%%%%%%%%%%%%%%%%%%%%%%

for j = 1:length(count.result)
    path_info = count.result{j};            %遍历每一个路信息。
    inputID = path_info(1:findstr(path_info,'-')-1);    %拿到路得输入端口，比如N1，N2
    if strcmp(inputID,wrong_inoutID)        %比较当前路得输入端口是否就是错误的输入端口
        index_jiankuohao = findstr(path_info,'>');      %尖括号的索引
        for k = 1:length(index_jiankuohao)-1            %循环整条路做传播概率计算
            index_douhao = findstr(path_info(index_jiankuohao(k):length(path_info)),',') + index_jiankuohao(k) - 1;    %逗号的索引，对着之前保存的路得信息（count.result）看才看得到
            lut_name = path_info(index_jiankuohao(k)+1:index_douhao-1); %LUT信息
            error_pin = path_info(index_douhao+2:index_jiankuohao(k+1)-2); %输入的事LUT哪个端口
            logi  =''; %初始化逻辑信息
            for jk = 1:length(lut_info)
                index_jiahao = findstr(lut_info{jk},'+');
                if strcmp(lut_info{jk}(1:index_jiahao(1) - 2),lut_name)
                    logi = lut_info{jk}(index_jiahao(length(index_jiahao))+2:length(lut_info{jk})); %拿到逻辑信息
                    break;
                end
            end
            result_p = [];
            for pnum = 1:length(error_p)
                tempzero_p = new_error_function( lut_name,str2num(error_pin),logi,error_p(pnum) );
                result_p = [result_p tempzero_p];
            end
            error_p = result_p;
%             error_p = new_error_function( lut_name,str2num(error_pin),logi,error_p ); %计算经过LUT后的误差概率，调用error_function函数
        end
%         worng_num = worng_num + length(error_p);  %这条路走完了，等到length(error_p)个误差
        output_N = path_info(index_jiankuohao(length(index_jiankuohao))+1:length(path_info)); %最终的输出端口号
        for resultnum = 1:length(error_p)
            worng_num = worng_num + 1;
            final_result{worng_num} = [output_N,',',num2str(error_p(resultnum))];
        end
        error_p = 1;
%         final_result{worng_num} = [output_N,',',num2str(error_p)];  %保存最终结果
    end
end