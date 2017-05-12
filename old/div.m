%% 把文件分成两部分，每部分分别存入元胞数组中，每一行为数组一个元素
function [ part1 ] = div( tline1,tline2,fid)

part1={};%定义一个元胞数组
i=1;
while ~feof(fid)&&tline1<=tline2 % 判断是否为文件末尾 
    
        tline=fgetl(fid); % 从文件读行
        part1{i}=tline;%把该行存入数组中
   tline1= tline1+1;
    i=i+1;
end
%没有关闭文件，需要在外部自己关闭