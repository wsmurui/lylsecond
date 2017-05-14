node_info_cell = cell(1,total_node_count);
mkeys = keys(name_node_map);
for i = 1:length(mkeys)
    index = strfind(mkeys{i},',');
    c = name_node_map(mkeys{i});
    if mkeys{i}(index(1)+1) == 'O' || mkeys{i}(index(1)+1) == 'I'
        node_info_cell{c} = mkeys{i}(index(1)+1);
    end
    if mkeys{i}(index(2)+1) == '&' || mkeys{i}(index(2)+1) == '|' || mkeys{i}(index(2)+1) == '^' || mkeys{i}(index(2)+1) == '~'
        node_info_cell{c} = mkeys{i}(index(2)+1);
    end
end