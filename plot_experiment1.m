clear;

for i = 1:9
    disp(i)
    load(['results' num2str(i) '.mat']);
    totals(i,:) = results;
    sizes(i,1) = a.mem.size;
end
totals(10,:) = RandomAgent().play(3000);
%totals(11,:) = BiasedRandomAgent().play(3000);

% 10xN -> 10xKxN/K -> 10xK -> Kx10
n = 3000;
k = 10;
plot(mean(reshape(totals, 10, k, n/k), 3)');
legend('experiment 1', 'experiment 2', 'experiment 3', 'experiment 4', ...
    'experiment 5', 'experiment 6', 'experiment 7', 'experiment 8', ...
    'experiment 9', 'random');

for i=(1:9)
    figure(i);
    plot(mean(reshape(totals([i 10], :), 2, k, n/k), 3)');
    legend(['experiment ' num2str(i)], 'random');
    ylim([900 1200]);
end

averages = mean(totals(:, (end-(n/k)):end),2);
figure;
bar(averages);
set(gca,'XTickLabel',{'experiment 1', 'experiment 2', 'experiment 3', 'experiment 4', ...
    'experiment 5', 'experiment 6', 'experiment 7', 'experiment 8', ...
    'experiment 9', 'random'});

figure;
bar(sizes);
set(gca,'XTickLabel',{'experiment 1', 'experiment 2', 'experiment 3', 'experiment 4', ...
    'experiment 5', 'experiment 6', 'experiment 7', 'experiment 8', ...
    'experiment 9', 'random'});
