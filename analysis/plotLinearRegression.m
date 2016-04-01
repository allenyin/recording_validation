function plotLinearRegression(x, y, xl, yl)
% Given x and y, plot their linear regression,
% and add the equation onto the plot
% xl and yl are xlabel and ylabel

    figure;
    plot(x, y, '*');
    xlabel(xl); ylabel(yl);

    bestfit = polyfit(x, y, 1);
    fitline = bestfit(1)*x + bestfit(2);
    hold on;
    plot(x, fitline, 'r');
    hold off;

    if bestfit(2) < 0,
        equation = sprintf('y = %.3fx %.3f', bestfit(1), bestfit(2));
    elseif bestfit(2) > 0,
        equation = sprintf('y = %.3fx + %.3f', bestfit(1), bestfit(2));
    elseif bestfit(2) == 0,
        equation = sprintf('y = %.3fx', bestfit(1));
    end

    text(0.8*max(x), 0.5*max(y), equation);
end

