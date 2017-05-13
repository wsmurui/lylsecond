
fidin=fopen(path,'r');
data = {};
t = 1;

while ~feof(fidin) 
    tline=fgetl(fidin);
    data{t} = tline;      %data就是读入的文件信息，所有信息都在里面
    t = t+ 1;
end

total_node_count = 0;
input_count = 0;
lut_count = 0;
f7mux_count = 0;
f8mux_count = 0;
outmux_count = 0;
gate_count = 0;
ffmux_count = 0;
name_node_map = containers.Map('abc',0);
lut_logic_map = containers.Map('abc','abc');
lut_module_map = containers.Map('abc','abc');


for i = 1:length(data)
    if strfind(data{i},'IOB:Total Number:')
        index = strfind(data{i},'IOB:Total Number:') + length('IOB:Total Number:');
        input_count = str2num(data{i}(index:length(data{i})));
        disp([' IOB 个数： ',int2str(input_count)]);
        [name_node_map total_node_count] = dealIOB(data,i+1,i+input_count,name_node_map,total_node_count);
%         continue;
    end
    if strfind(data{i},'LUT:Total Number:')
        index = strfind(data{i},'LUT:Total Number:') + length('LUT:Total Number:');
        lut_count = str2num(data{i}(index:length(data{i})));
        disp([' LUT 个数： ',int2str(lut_count)]);
        [name_node_map total_node_count lut_logic_map lut_module_map] = dealLUT(data,i+1,i+lut_count,name_node_map,total_node_count,lut_logic_map,lut_module_map);
    end
    if strfind(data{i},'F7MUX:Total Number:')
        index = strfind(data{i},'F7MUX:Total Number:') + length('F7MUX:Total Number:');
        f7mux_count = str2num(data{i}(index:length(data{i})));
        disp([' F7MUX 个数： ',int2str(f7mux_count)]);
        %逻辑不清晰，暂时不处理
    end
    if strfind(data{i},'F8MUX:Total Number:')
        index = strfind(data{i},'F8MUX:Total Number:') + length('F8MUX:Total Number:');
        f8mux_count = str2num(data{i}(index:length(data{i})));
        disp([' F8MUX 个数： ',int2str(f8mux_count)]);
        %逻辑不清晰，暂时不处理
    end
    if strfind(data{i},'OUTMUX:Total Number:')
        index = strfind(data{i},'OUTMUX:Total Number:') + length('OUTMUX:Total Number:');
        outmux_count = str2num(data{i}(index:length(data{i})));
        disp([' OUTMUX 个数： ',int2str(outmux_count)]);
        %逻辑不清晰，暂时不处理
    end
    if strfind(data{i},'FFMUX:Total Number:')
        index = strfind(data{i},'FFMUX:Total Number:') + length('FFMUX:Total Number:');
        ffmux_count = str2num(data{i}(index:length(data{i})));
        disp([' FFMUX 个数： ',int2str(ffmux_count)]);
        %逻辑不清楚，暂时不处理
    end
end