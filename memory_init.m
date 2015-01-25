function memory_init(limit, dims)
% MEMORY_INIT Initialize memory.
% Parameters:
%  limit - memory maximum size
%  dims - dimensions of states, e.g. [4 4]
% Returns memory object.
% Memory is kept as four matrices: prestates, actions, rewards and
% poststates.

    global m;
    m.size = 0;
    m.limit = limit;
    m.prestates = zeros([limit dims]);
    m.actions = zeros(limit, 1);
    m.rewards = zeros(limit, 1);
    m.poststates = zeros([limit dims]);
end
