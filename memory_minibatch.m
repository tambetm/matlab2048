function batch = memory_minibatch(minibatch_size)
% MEMORY_MINIBATCH Return minibatch from memory.
% Parameters:
%  m - memory object
%  minibatch_size - size of the minibatch
% Returns minibatch struct, containing four matrices: prestates, actions,
% rewards and poststates.

    global m;
    % find minibatch_size random indexes of memory
    indexes = randperm(min(m.size, m.limit), minibatch_size);
    % return values of those cells
    batch.prestates = m.prestates(indexes, :, :);
    batch.actions = m.actions(indexes);
    batch.rewards = m.rewards(indexes);
    batch.poststates = m.poststates(indexes, :, :);
end
