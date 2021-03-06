mkeys = keys(name_node_map);
node_name_map = cell(1,length(mkeys));
for i = 1:length(mkeys)
    if ~isempty(node_name_map{name_node_map(mkeys{i})})
        value = node_name_map{name_node_map(mkeys{i})};
        index = strfind(value,',');
%         if value(index(1)+1) == 'O'
            continue;
%         end
    end
    node_name_map{name_node_map(mkeys{i})} = mkeys{i};
end

for i = 1:length(adj_zeros)
    for j = 1:length(adj_zeros)
        if adj_zeros(i,j) == 1
            disp([[node_name_map{i},'------->'],node_name_map{j}]);
        end
    end
end