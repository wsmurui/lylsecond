% 对c499的读取

clc;
clear;
fidin=fopen('work3.txt','r');
data = {};
t = 1;

%count是全局变量，也就是每一个m文件包括函数里面都能使用它的数据。其中保存的数据你可以运用完了点开看，其中最重要的数据就是路径信息。
global count;
count.result ={};   %路径信息的保存地方。
count.num = 1;      %num的值表示一共多少条路
while ~feof(fidin) 
    tline=fgetl(fidin);
    data{t} = tline;      %data就是读入的文件信息，所有信息都在里面
    t = t+ 1;
end
iodata={};

for i=1:4                %IO信息，1:6是io口的数量，不同的电路io口数量不一样，从data文件里找有多少io口，从哪里开始这些信息来设置索引。
    iodata{i} = data{i+6};
end
logidata = {};              %逻辑连线
for i=1:9                %同上
    logidata{i} = data{i+69};  %这是加198是因为ligidata信息是从data中的第199行开始的。
end

io_size = length(iodata);
io = {};
for i = 1 : io_size
    info = iodata{i};
    k = findstr(info,'+');
    io{i} = info(k(1)+2:k(2)-2);
end
input = io(1:3);            %输入io编号
output = io(4:length(io));          %输出io编号

lut_info = {};
for i=1:1
    lut_info{i} = data{i+15};
end

fmux_info = {};
% for i=1:5
%     fmux_info{i} = data{i+684};
% end

outmux_info = {};
% for i=1:55
%     outmux_info{i} = data{i+714};
% end

fmux_logi = {};
% for i=1:30
%     fmux_logi{i} = data{i+4455};
% end

outmux_logi = {};
% for i=1:283
%     outmux_logi{i} = data{i+4500};
% end

count.lut_info = lut_info;      %LUT逻辑信息
count.fmux_info = fmux_info;
count.outmux_info = outmux_info;
count.outmux_logi = outmux_logi;
count.fmux_logi = fmux_logi;
count.logidata = logidata;          %LUT逻辑连线

% lutis_used_info = zeros(1,length(lut_info));
% lut_input_info = nan(6,length(lut_info));

count.lutis_used_info = zeros(1,length(lut_info));
count.lut_input_info = nan(6,length(lut_info));     %初始值为nan的数组（矩阵），6是LUT的6个输入口
count.output_p = nan(1,length(output));         

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
count.input_p = [0.6 0.3 0.5];          %每个输入为1的概率，如果你要改变各个输入口初始为1的概率就在这里改，因为
                                                %这个电路是5个输入口，我就在这里设置了5个初始值，按顺序分别对应每个口。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1 : length(input)
    DPS([input{i},',I'],input{i});          %在input{i}后面加',I',拼接字符串
end
