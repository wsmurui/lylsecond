function [ p_out ] = calculate_lutoutput( inputzero, logi )
%CALCULATE_LUTOUTPUT 
%根据LUT的6个输入，计算lut输出的01概率
%   此处显示详细说明
    zhan_shuzi = nan(1,100);    %建立一个nan 的数组，作为栈
    top_shuzi = 0;
    zhan_fuhao = [];
%     top_fuhao = 0;
    
    is_qiufan = false;
    count_fan = 0;
    % 根据栈的优选顺序开始计算公式中的传播概率
    for i = 1 :length(logi)
        switch logi(i)
            case '('
%                 top_fuhao = top_fuhao  + 1;
                zhan_fuhao = [zhan_fuhao ,'('];
                count_fan = count_fan + 1;  %有（的情况就入栈
            case ')' 
               % 有）需要出栈
                while true
                    if strcmp(zhan_fuhao(length(zhan_fuhao)),'(')
%                         top_fuhao = top_fuhao - 1 ;
                        zhan_fuhao = zhan_fuhao(1:length(zhan_fuhao)-1);
                        count_fan = count_fan - 1;
                        break;              %再入栈哇
                    elseif strcmp(zhan_fuhao(length(zhan_fuhao)),'|')
                        in_1 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;%看不懂哇？？？
                        in_2 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;
                        resu = 1-(1-in_1)*(1-in_2);
                        top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
                        zhan_fuhao = zhan_fuhao(1:length(zhan_fuhao)-1);
%                         top_fuhao = top_fuhao - 1; 
                    elseif strcmp(zhan_fuhao(length(zhan_fuhao)),'&')
                        in_1 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;
                        in_2 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;
                        resu = in_1* in_2;
                        top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
                        zhan_fuhao = zhan_fuhao(1:length(zhan_fuhao)-1);
                        %与运算
                    elseif strcmp(zhan_fuhao(length(zhan_fuhao)),'^')
                        in_1 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;
                        in_2 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;
                        resu = 1 - (in_1*in_2 + (1-in_1)*(1-in_2));
                        top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
                        zhan_fuhao = zhan_fuhao(1:length(zhan_fuhao)-1);
                        %
                    end
                end
            case {'&','|','^'}
                %没有），不需要出栈的情况
                if count_fan == 0 && top_shuzi>=2
                    if length(zhan_fuhao) >=1
                        in_1 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;%还是看不懂哇
                        in_2 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;
                        if strcmp(zhan_fuhao(length(zhan_fuhao)),'|')
                            resu = 1-(1-in_1)*(1-in_2);
                            top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
                        elseif strcmp(zhan_fuhao(length(zhan_fuhao)),'&')
                            resu = in_1* in_2;
                            top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
                        elseif strcmp(zhan_fuhao(length(zhan_fuhao)),'^')
                            resu = 1 - (in_1*in_2 + (1-in_1)*(1-in_2));
                            top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
                        end
                        zhan_fuhao(length(zhan_fuhao)) = logi(i);
                    end
                else
%                     top_fuhao=top_fuhao + 1;
                    zhan_fuhao = [zhan_fuhao,logi(i)];
                end
            case '~'        %非运算
                is_qiufan = true;
            case {'1','2','3','4','5','6'}
                if is_qiufan
                    top_shuzi = top_shuzi + 1;
                    zhan_shuzi(top_shuzi) = 1-inputzero(str2num(logi(i)));
                    is_qiufan = false;
                else
                    top_shuzi = top_shuzi + 1;
                    zhan_shuzi(top_shuzi) = inputzero(str2num(logi(i)));
                end
        end
    end
    
    if top_shuzi == 2       %栈里面还有两个值哇
        if strcmp(zhan_fuhao(length(zhan_fuhao)),'|')
            in_1 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;
            in_2 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;
            resu = 1-(1-in_1)*(1-in_2);
            top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
        end
        if strcmp(zhan_fuhao(length(zhan_fuhao)),'&')
            in_1 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;
            in_2 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;
            resu = in_1* in_2;
            top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
        end
        if strcmp(zhan_fuhao(length(zhan_fuhao)),'^')
            in_1 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;
            in_2 = zhan_shuzi(top_shuzi); zhan_shuzi(top_shuzi)= nan; top_shuzi = top_shuzi - 1;
            resu = 1 - (in_1*in_2 + (1-in_1)*(1-in_2));
            top_shuzi = top_shuzi + 1; zhan_shuzi(top_shuzi) = resu;
        end
    end
    
    if top_shuzi==0
        p_out = 0;
    else
        p_out = zhan_shuzi(top_shuzi);
    end
    
% %     function [] = pop_and_compare()
% %         zhan_shuzi(1) = 100;
% %     end

end