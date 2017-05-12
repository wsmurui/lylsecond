fidin=fopen('c7552.txt','r');
% fidin=fopen('c17.txt','r');
data = {};
t = 1;
global count;
count.result ={};
count.num = 1;
while ~feof(fidin) 
    tline=fgetl(fidin);
    data{t} = tline;
    t = t+ 1;
end
iodata={};
for i=1:315
    iodata{i} = data{i+6};
end
logidata = {};
for i=1:3662
    logidata{i} = data{i+787};
end

io_size = length(iodata);
io = {};
for i = 1 : io_size
    info = iodata{i};
    k = findstr(info,'+');
    io{i} = info(k(1)+2:k(2)-2);
end
input = io(1:207);
output = io(208:length(io));

lut_info = {};
for i=1:348
    lut_info{i} = data{i+326};
end

fmux_info = {};
for i=1:5
    fmux_info{i} = data{i+684};
end

outmux_info = {};
for i=1:55
    outmux_info{i} = data{i+714};
end

fmux_logi = {};
for i=1:30
    fmux_logi{i} = data{i+4455};
end

outmux_logi = {};
for i=1:283
    outmux_logi{i} = data{i+4500};
end

count.lut_info = lut_info;
count.fmux_info = fmux_info;
count.outmux_info = outmux_info;
count.outmux_logi = outmux_logi;
count.fmux_logi = fmux_logi;
count.logidata = logidata;
count.lutis_used_info = zeros(1,length(lut_info));
count.lut_input_info = nan(6,length(lut_info));
count.p_out = nan(2,length(output));
count.output_p = nan(1,length(output));
% DPS([input{2},',I'],input{2});
% DPS([input{141},',I'],input{141});
% DPS([input{108},',I'],input{108});
% DPS([input{41},',I'],input{41});
% DPS([input{7},',I'],input{7});

% for i = 1 : length(input)
%     DPS([input{i},',I'],input{i});
% end

% for i=1:length(logidata)
%     
% end

