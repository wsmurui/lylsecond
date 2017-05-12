function [ output_args ] = error_function( lutID,error_pin,logi,error_p,port_p )

%根据LUT表达式求LUT的误差传播概率

    global count;
    
    index_port = 1;
    
    %拿到LUT的输入信息
    ID = lutID(findstr(lutID,'-')+1:length(lutID));  %通过LUT-1，拿到lut的编号
    inputzero = count.lut_input_info(:,str2num(ID)+1); %lut_input_info是上一步求到lut输入端6个口为1的概率
%     inputzero(error_pin) = 2;      %error是误差输入的端口号，比如，lut有6个口，这里我就让误差从4口进去，我就让4口为1的概率为2，这样我就知道了
                                    %当我检测到2的时候，就说明这个是误差输入，因为概率不能大于1嘛
    
    zhan_shuzi = nan(1,100);    %建立一个nan 的数组，作为数值的栈，保存等待计算的数值
    top_shuzi = 0;              %数值栈的索引，当新加一个数值的时候top_shuzhi就加一，减少一个时，就减一，保存zhan_shuzi（top_shuzi）得到的是最新加入的数值
    zhan_fuhao = [];            %运算符号，保存运算符号
%     top_fuhao = 0;
    
    is_qiufan = false;          %检测到~非门时，就要对数值进行求反
    count_fan = 0;              %保存反括号（的数量，当符号栈中存在（时候就不进行运算，只有当count_fan=0时，才进行先后运算
    % 根据栈的优选顺序开始计算公式中的传播概率
    for i = 1 :length(logi)  %循环遍历逻辑表达时的每一个符号
        switch logi(i)
            case '('    %当是反括号直接如果，count_fan加1，说明当前符号栈中有count_fan个（括号了
%                 top_fuhao = top_fuhao  + 1;
                zhan_fuhao = [zhan_fuhao ,'('];
                count_fan = count_fan + 1;  %有（的情况就入栈
            case ')'    %当是正括号可以计算了，依次弹出符号栈顶的元素计算，直到顶端是（就停止
               % 有）需要出栈
                while true
                    if strcmp(zhan_fuhao(length(zhan_fuhao)),'(')   %如果是（，弹出（就可以停止了，count_fan减1,
%                         top_fuhao = top_fuhao - 1 ;
                        zhan_fuhao = zhan_fuhao(1:length(zhan_fuhao)-1);
                        count_fan = count_fan - 1;
                        break;              %再入栈哇  %break是停止while true大循环，不继续弹出符号了
                    elseif strcmp(zhan_fuhao(length(zhan_fuhao)),'|')   %进行或运算
                        in_1 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;%看不懂哇？？？ %弹出数值栈顶端数值，索引减1
                        in_2 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;       %同上，这里弹出两个数，一个in_1,一个in_2，两个数才能做运算嘛
                        if in_1 ~=2 && in_2 ~=2     %当两个数值都小于2，也就是说不是计算误差传播概率，直接计算为一的概率
                            resu = 1-(1-in_1)*(1-in_2);
                            top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
                            zhan_fuhao = zhan_fuhao(1:length(zhan_fuhao)-1);
                        elseif in_1 == 2 && in_2 ~=2    %当其中一个数值为2时，也就是说计算误差传播概率
                            error_p = error_p * (1 - in_2);     %误差概率计算
                            resu = 2;               %让结果等于2直接压入数值栈中，表示这个的结果是计算误差传播
                            top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
                            zhan_fuhao = zhan_fuhao(1:length(zhan_fuhao)-1);
                        else            %另外一个为2的情况
                            error_p = error_p * (1 - in_1);
                            resu = 2;
                            top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
                            zhan_fuhao = zhan_fuhao(1:length(zhan_fuhao)-1);
                        end
%                         top_fuhao = top_fuhao - 1; 
                    elseif strcmp(zhan_fuhao(length(zhan_fuhao)),'&')  %同上，只是计算与门
                        in_1 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;
                        in_2 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;
                        if in_1 ~=2 && in_2 ~=2
                            resu = in_1* in_2;
                            top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
                            zhan_fuhao = zhan_fuhao(1:length(zhan_fuhao)-1);
                        elseif in_1 == 2 && in_2 ~=2
                            error_p = error_p * in_2;
                            resu = 2;
                            top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
                            zhan_fuhao = zhan_fuhao(1:length(zhan_fuhao)-1);
                        else
                            error_p = error_p * in_1;
                            resu = 2;
                            top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
                            zhan_fuhao = zhan_fuhao(1:length(zhan_fuhao)-1);
                        end
                        %与运算
                    elseif strcmp(zhan_fuhao(length(zhan_fuhao)),'^')  %同上计算非门
                        in_1 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;
                        in_2 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;
                        if in_1 ~=2 && in_2 ~=2
                            resu = 1 - (in_1*in_2 + (1-in_1)*(1-in_2));
                            top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
                            zhan_fuhao = zhan_fuhao(1:length(zhan_fuhao)-1);
                        elseif in_1 == 2 && in_2 ~=2
                            resu = 2;
                            top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
                            zhan_fuhao = zhan_fuhao(1:length(zhan_fuhao)-1);
                        else
                            resu = 2;
                            top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
                            zhan_fuhao = zhan_fuhao(1:length(zhan_fuhao)-1);
                        end
                        %
                    end
                end
            case {'&','|','^'}
                %没有），不需要出栈的情况
                if count_fan == 0 && top_shuzi>=2  %运算符，只有当符号栈中没有（，就是count_fan=0，并且数值栈中有两个数值才能运用
                    if length(zhan_fuhao) >=1
                        in_1 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;%还是看不懂哇
                        in_2 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;
                        if strcmp(zhan_fuhao(length(zhan_fuhao)),'|')
                            if in_1 ~=2 && in_2 ~=2
                                resu = 1-(1-in_1)*(1-in_2);
                                top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
                            elseif in_1 == 2 && in_2 ~=2
                                error_p = error_p * (1-in_2);
                                resu = 2;
                                top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
                            else
                                error_p = error_p * (1-in_1);
                                resu = 2;
                                top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
                            end
                        elseif strcmp(zhan_fuhao(length(zhan_fuhao)),'&')
                            if in_1 ~=2 && in_2 ~=2
                                resu = in_1* in_2;
                                top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
                            elseif in_1 == 2 && in_2 ~=2
                                error_p = error_p * in_2;
                                resu = 2;
                                top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
                            else
                                error_p = error_p * in_1;
                                resu = 2;
                                top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
                            end
                        elseif strcmp(zhan_fuhao(length(zhan_fuhao)),'^')
                            if in_1 ~=2 && in_2 ~=2
                                resu = 1 - (in_1*in_2 + (1-in_1)*(1-in_2));
                                top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
                            else
                                resu = 2;
                                top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
                            end
                        end
                        zhan_fuhao(length(zhan_fuhao)) = logi(i);
                    end
                else
%                     top_fuhao=top_fuhao + 1;
                    zhan_fuhao = [zhan_fuhao,logi(i)];
                end
            case '~'        %非运算
                is_qiufan = true;
            case {'1','2','3','4','5','6'}  %数值来了直接入数值栈
                if str2num(logi(i)) == error_pin
                    thisnum = port_p(index_port);
                    index_port = index_port + 1;
                    top_shuzi = top_shuzi + 1;
                    if is_qiufan
                        if thisnum==2
                            zhan_shuzi(top_shuzi) = 2;
                        else
                            zhan_shuzi(top_shuzi) = 1-thisnum; 
                        end
                        is_qiufan = false;
                    else
                        zhan_shuzi(top_shuzi) = thisnum;
                    end
                else
                    if is_qiufan   %是否要求反
                        if inputzero(str2num(logi(i))) ~=2   %如果不等于2，就直接入栈
                            top_shuzi = top_shuzi + 1;
                            zhan_shuzi(top_shuzi) = 1-inputzero(str2num(logi(i)));
                        else
                            top_shuzi = top_shuzi + 1;  %如果等于2，表示误差，就直接2入栈
                            zhan_shuzi(top_shuzi) = 2;
                        end
                        is_qiufan = false;
                    else
                        top_shuzi = top_shuzi + 1;
                        zhan_shuzi(top_shuzi) = inputzero(str2num(logi(i)));
                    end
                end
        end
    end
    
    if top_shuzi == 2       %栈里面还有两个值哇  %对最后可能栈里面还有数没被运算，再运算一次。
        if strcmp(zhan_fuhao(length(zhan_fuhao)),'|')
            in_1 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;
            in_2 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;
            if in_1 ~=2 && in_2 ~=2
                resu = 1-(1-in_1)*(1-in_2);
                top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
            elseif in_1 == 2 && in_2 ~=2
                error_p = error_p * (1 - in_2);
                resu = 2;
                top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
            else
                error_p = error_p * (1 - in_1);
                resu = 2;
                top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
            end
        end
        if strcmp(zhan_fuhao(length(zhan_fuhao)),'&')
            in_1 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;
            in_2 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;
            if in_1 ~=2 && in_2 ~=2
                resu = in_1* in_2;
                top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
            elseif in_1 == 2 && in_2 ~=2
                error_p = error_p * in_2;
                resu = 2;
                top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
            else
                error_p = error_p * in_1;
                resu = 2;
                top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
            end
        end
        if strcmp(zhan_fuhao(length(zhan_fuhao)),'^')
            in_1 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;
            in_2 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;
            if in_1 ~=2 && in_2 ~=2
                resu = 1 - (in_1*in_2 + (1-in_1)*(1-in_2));
                top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
            else
                resu = 2;
                top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
            end
        end
    end
    
%     if top_shuzi==0
%         p_out = 0;
%     else
%         p_out = zhan_shuzi(top_shuzi);
%     end
    output_args = error_p;  %最终结果输出去，误差概率

end

