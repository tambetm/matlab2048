a = RandomAgent();
results(1,:) = a.play(3000);
b = BiasedRandomAgent([0.3 0.2 0.3 0.2]);
results(2,:) = b.play(3000);
c = BiasedRandomAgent([0.7 0.1 0.1 0.1]);
results(3,:) = c.play(3000);
d = BiasedRandomAgent([0.4 0.4 0.1 0.1]);
results(4,:) = d.play(3000);
e = BiasedRandomAgent([0.4 0.1 0.4 0.1]);
results(5,:) = e.play(3000);

bar(mean(results,2));
set(gca,'XTickLabel',{'random', 'weakly biased opposite', ...
    'strongly biased one', 'strongly biased corner', ...
    'strongly biased opposite' });
