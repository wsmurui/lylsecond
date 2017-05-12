function [ output_args ] = new_error_function( lutID,error_pin,logi,error_p )
%NEW_ERROR_FUNCTION Summary of this function goes here
%事先判断是否需要分支，如果有分支就送到error fuction里面进行计算
%   Detailed explanation goes here
global count;
    
%%%首先读LUT的逻辑表达式，如果logi =
%%%((~A6&A2)|(A6&((A2&~A5)|A3)))，如果6，2口是输入误差，那么分开计算就有两个误差值，如果5,3口误差输出就只有一个。
    port_num = findstr(logi,num2str(error_pin));
    port_p = nan(1,length(port_num));
    if length(port_num) == 0         %%没找到误差口，输入错误
        disp('输入端口错误，没有参与LUT运算中');
        return;
    end
    
    if length(port_num) == 1        %%只有误差输入只有一个，也就是上面说的5,3口，就可以直接用之前的算法做
        port_p(1) = 2;
        output_args = error_function( lutID,error_pin,logi,error_p,port_p );
        return;
    end
    
    %%%%%%下面代码就是处理多个输入口误差
    ID = lutID(findstr(lutID,'-')+1:length(lutID));  %通过LUT-1，拿到lut的编号
    inputzero = count.lut_input_info(:,str2num(ID)+1);
    p_01 = inputzero(error_pin);       %%之前算出来的01概率
    port_p = zeros(1,length(port_num));  %% 如果输入是6口，那么我就只需要给第一个6口赋值误差，其他6口赋值01概率，然后代入原函数计算就可以了
                                         %要分开计算，我就分别让第二个6口赋值误差，第一个6口正常01概率就可以了。
    pout_error = nan(1,length(port_num));  %用来保存输出误差概率的矩阵
    for i=1:length(port_num)
        port_p(i) = p_01;
    end
    for i=1:length(port_num)    %分别让每个口等于2的循环
        temp_port = port_p;
        temp_port(i) = 2;
        pout_error(i) = error_function( lutID,error_pin,logi,error_p,temp_port ); %代入原函数
    end
    output_args = pout_error;  %输出就是一个误差矩阵了。


end

