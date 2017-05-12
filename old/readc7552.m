clc
clear;
close all;
log_flag = 0;               % 逻辑资源标识
cnt_flag = 0;               % 逻辑连线标识
lut_flag = 0;               % 表示在LUT-的下面
ovf_flag = 0;               % 读完文件的标识

lut_cnt = 0;                % LUT 数目
lut = {348,2};               %定义存储LUT信息的元胞数组
fid = fopen('c7552.txt','r');

while ~feof(fid)            %判断是否为文件末尾
    tline = fgetl(fid);         %读行
    
    if log_flag == 0
        if strcmp(tline, '////   本设计中用到的逻辑资源如下所示  ') == 1
            log_flag = 1;           %从“////   本设计中用到的逻辑资源如下所示 ”之后设置log_flag=1
        end
    else
        if strcmp(tline(1:4), 'LUT-') == 1
            lut_cnt = lut_cnt + 1;          %lut计数
             
            % Read the logical data here!!!
            lut{lut_cnt,1}=tline            %把tline的值依次存入到lut{}这个元胞数组的第一列
            
            continue;           %跳出本次循环，继续运行while
        end
    end     % 从log_flag=0到连续的LUT-结束，也就是文件的671行吧
    
    if cnt_flag == 0
        if strcmp(tline, '////   本设计中资源的逻辑连线如下所示  ') == 1
            log_flag = 0;
            lut_cnt = 0;
            cnt_flag = 1;
        end
    elseif lut_flag == 0
        if strcmp(tline(1:4), 'LUT-') == 1
            lut_flag = 1;
            lut_cnt = lut_cnt + 1;
        end
  elseif lut_flag == 1
        while ~feof(fid)
            if strcmp(tline(1:3), 'LUT') == 1
                lut_cnt = lut_cnt + 1;
                break;
            elseif strcmp(tline(1:3), 'END') == 1
                ovf_flag = 1;
                return;
            end
            
            % Read the connection data here!!!
            tline
            
            tline = fgetl(fid);
        end
    end     % if cnt_flag == 0
end