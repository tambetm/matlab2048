function m = memory_add(m, prestate, action, reward, poststate)
% MEMORY_ADD Add one state transition to memory.
% Parameters:
%  m - memory object
%  prestate - state before (matrix)
%  action - action taken in this state
%  reward - observerd reward
%  poststate - state after the action
% Returns new memory object.

    % roll over to first if over limit
    m.size = m.size + 1;
    index = mod(m.size - 1, m.limit) + 1;
    % store state transition in memory at position index
    m.prestates(index, :, :) = prestate;
    m.actions(index) = action;
    m.rewards(index) = reward;
    m.poststates(index, :, :) = poststate;
end
