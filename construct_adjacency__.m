node_count = input_count + f7mux_count + f8mux_count + gate_count + ffmux_count;
adj = zeros(node_count,node_count);
name_vector = cell(node_count);