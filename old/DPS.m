function [] = DPS(c_input,path)
global count;
%DPS 
%深度优先算法 


%   此处显示详细说明

    for i = 1:length(count.logidata)    
        info = count.logidata{i};
        if length(findstr(info,'LUT'))~=0
            c_lut = info;
            c_slice_info = count.lut_info{str2num(c_lut(findstr(c_lut,'-')+1:length(c_lut)))+1};
            c_slice_k = findstr(c_slice_info,'+');
            c_slice = c_slice_info(c_slice_k(1)+2:c_slice_k(2)-2);
        end
        if length(findstr(path,[c_lut,',']))>=1
            continue;
        end
        k_in = findstr(info,c_input);
        if length(k_in)~=0 && info(k_in(1)+length(c_input)) == ','
%         if length(k_in)~=0 && info(k_in(1)+length(c_input)) == ','
            k_if = findstr(info,'<-');
            if length(k_if)~=0
                port = info(1:2);
                for jj = i:length(count.logidata) 
                    if length(findstr(count.logidata{jj},'LUT'))~=0
                        break;
                    end
                    if length(findstr(count.logidata{jj},'->'))~=0
                        f_start = findstr(count.logidata{jj},'>');
                        f_end = findstr(count.logidata{jj},',');
                        if length(f_end) == 0
                            end_point = count.logidata{jj}(f_start+3:length(count.logidata{jj}));
                            if length(findstr(end_point,'pin'))==0
%                                 count.result{count.num} = [path,'->',c_lut,',',port,'->',end_point];
%                                 count.num = count.num + 1;
                                if length(findstr(end_point,'OUTMUX'))==0
                                    for kk=1:length(count.fmux_info)
                                        k_fmux = findstr(count.fmux_info{kk},c_slice);
                                        if length(k_fmux)~=0 && count.fmux_info{kk}(k_fmux(1)+length(c_slice)+1) == '+'
                                            c_f7mux = count.fmux_info{kk}(1:7);
                                            break;
                                        end
                                    end
                                    if port(1) == 'A' || port(1) == 'B'
                                        end_point = 'AOUTMUX';
                                    else 
                                        end_point = 'COUTMUX';
                                    end
                                    for kk=1:length(count.outmux_info)
                                        k_outmux = findstr(count.outmux_info{kk},c_slice);
                                        k_ouportmux = findstr(count.outmux_info{kk},end_point);
                                        if length(k_outmux)~=0 && count.outmux_info{kk}(k_outmux(1)+length(c_slice)+1) == '+' && length(k_ouportmux)~=0
                                            c_outmux = count.outmux_info{kk}(1:findstr(count.outmux_info{kk},'+')-2);
                                            break;
                                        end
                                    end
                                    if port(1) == 'A' || port(1) == 'C'
                                        outmux_seek( c_outmux ,[path,'->',c_lut,',',port,'->',c_f7mux,',1->',c_outmux]);
                                        DPS([c_slice,',',end_point(1),'MUX'] ,[path,'->',c_lut,',',port,'->',c_f7mux,',1->',c_outmux]);
                                    else
                                        outmux_seek( c_outmux ,[path,'->',c_lut,',',port,'->',c_f7mux,',0->',c_outmux]);
                                        DPS([c_slice,',',end_point(1),'MUX'] ,[path,'->',c_lut,',',port,'->',c_f7mux,',0->',c_outmux]);
                                    end
                                    
                                else
                                    for kk=1:length(count.outmux_info)
                                        k_outmux = findstr(count.outmux_info{kk},c_slice);
                                        k_ouportmux = findstr(count.outmux_info{kk},end_point);
                                        if length(k_outmux)~=0 && count.outmux_info{kk}(k_outmux(1)+length(c_slice)+1) == '+' && length(k_ouportmux)~=0
                                            c_outmux = count.outmux_info{kk}(1:findstr(count.outmux_info{kk},'+')-2);
                                            break;
                                        end
                                    end
                                    outmux_seek( c_outmux ,[path,'->',c_lut,',',port,'->',c_outmux]);
                                    DPS([c_slice,',',end_point(1),'MUX'] ,[path,'->',c_lut,',',port,'->',c_outmux]);
                                end
                            else
                                DPS([c_slice,',',end_point(1)],[path,'->',c_lut,',',port]);
                            end
                        else
                            if strcmp(count.logidata{jj}(f_end(1)+1:f_end(2)-1),'O')
                                count.result{count.num} = [path,'->',c_lut,',',port,'->',count.logidata{jj}(f_start+3:f_end-1)];
                                count.num = count.num + 1;
                            end
                        end
                    end
                end
            end
        end
    end
    
end

