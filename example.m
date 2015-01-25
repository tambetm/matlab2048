clear;

n = 1000;
tic;
results(1,:) = NNAgent(0.05, 0.9, 0.01, 0, [256 256], 32).play(n);
results(2,:) = NNAgent(0.1, 0.9, 0.01, 0, [256 256], 32).play(n);
results(3,:) = NNAgent(0.01, 0.9, 0.01, 0, [256 256], 32).play(n);
results(4,:) = NNAgent(0.05, 0.9, 0.001, 0, [256 256], 32).play(n);
results(5,:) = NNAgent(0.05, 0.9, 0.01, 0.9, [256 256], 32).play(n);
results(6,:) = NNAgent(0.05, 0.9, 0.01, 0, [256], 32).play(n);
results(7,:) = NNAgent(0.05, 0.9, 0.01, 0, [100 100], 32).play(n);
results(8,:) = NNAgent(0.05, 0.9, 0.01, 0, [512 512], 32).play(n);
results(9,:) = NNAgent(0.05, 0.9, 0.01, 0, [256 256], 128).play(n);
results(10,:) = RandomAgent().play(n);
toc

% 10xN -> 10xKxN/K -> 10xK -> Kx10
k = 10;
plot(mean(reshape(results, 10, k, n/k), 3)');
legend('experiment 1', 'experiment 2', 'experiment 3', 'experiment 4', ...
    'experiment 5', 'experiment 6', 'experiment 7', 'experiment 8', ...
    'experiment 9', 'random');

for i=(1:10)
    figure(i);
    plot(mean(reshape(results([i 10], :), 2, k, n/k), 3)');
    legend(['experiment ' num2str(i)], 'random');
end
