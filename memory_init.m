function m = memory_init(limit, dims)
% MEMORY_INIT Initialize memory.
% Parameters:
%  limit - memory maximum size
%  dims - dimensions of states, e.g. [4 4]
% Returns memory object.
% Memory is kept as four matrices: prestates, actions, rewards and
% poststates.

    m.size = 0;
    m.limit = limit;
    m.prestates = [];
    m.actions = [];
    m.rewards = [];
    m.poststates = [];
end
