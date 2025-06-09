close all; clear all; clc;

% Determine  by using the steepest descent method. Use  as an initial guess.
grad_f = @(x) [8*x(1)-4*x(2)+1, 6*x(2)-4*x(1)]';

x_0 = [-1,0]';
grad_f(x_0);

k = [0.01, 0.1, 1, 10];

text_in_loop = "x_1 with k = %4.4f is [%4.4f, %4.4f]' \n";
for step = k
    x_1 = x_0 - step*grad_f(x_0);
    fprintf(text_in_loop, step, x_1(1), x_1(2));
end

fprintf("Choosing k = 0.05");
fprintf("\n\n");
k = 0.05;
x_1 = x_0 - k*grad_f(x_0);

A = [8, -4; -4, 6];
b = [1; 0];
C = 0;
% where x is 2x1 vector.
fcn_f = @(x) ((x'*A*x)/2 + b'*x + C);
%% Steepest descent method
steepestDescentHistory = x_0;
x_prev = x_0;
for i = 1:2
    x = x_prev - k*grad_f(x_prev);
    x_prev = x;
    steepestDescentHistory = [steepestDescentHistory, x];
end

steepestDescentValues = [];
for i = steepestDescentHistory
    steepestDescentValues = [steepestDescentValues, fcn_f(i)];
end
steepestDescentMethod = x;


%% Conjugate gradient method
alpha_k = @(x_k, d_k) -((x_k'*A + b') * d_k)/(d_k'*A*d_k);
% With Fletcher & Reeves algorithm 
beta_k = @(g, g_prev) (g'*g)/(g_prev'*g_prev);

x_prev = x_0;
conjugatgeGradientHistory = x_0;
x = x_1;
% x_2 for problem solveing
isFirst = true;
for i = 1:2
    if isFirst
        isFirst = false;
        g_prev = -grad_f(x_prev);
        d_prev = -g_prev;
    end
    g = grad_f(x);
    beta = beta_k(g, g_prev);
    d = -g + beta*d_prev;
    alpha = alpha_k(x, d);
    x = x_prev + alpha*d;
    g_prev = g;
    d_prev = d;
    x_prev = x;
    conjugatgeGradientHistory = [conjugatgeGradientHistory, x];
end

conjugateGradientValues = [];
for i = conjugatgeGradientHistory
    conjugateGradientValues = [conjugateGradientValues, fcn_f(i)];
end
conjugateGradientMethod = x;

%% The result of two algorithms
steepest_descent_method_result = "The result of steepest descent method is %4.4f.\n";
conjugate_gradient_method_result = "The result of conjugate gradient method is %4.4f.\n";
fprintf(steepest_descent_method_result, fcn_f(steepestDescentMethod));
fprintf(conjugate_gradient_method_result, fcn_f(conjugateGradientMethod));
fprintf("\n\n");

% The numerical minimum point
x_min = A\[-1; 0];
f_min = fcn_f(x_min);

x1_range = linspace(-1, 1, 100);
x2_range = linspace(-1, 1, 100);
[X1, X2] = meshgrid(x1_range, x2_range);

Z = arrayfun(@(x1, x2) fcn_f([x1; x2]), X1, X2);

surfaceFig = figure;
surf(X1, X2, Z, 'EdgeColor', 'none', 'FaceAlpha', 0.5);
xlabel('x_1');
ylabel('x_2');
zlabel('f(x)');
title("Surface Plot of f(x) = 4x_1^2 + 3x_2^2 - 4x_1x_2 + x1");
% colorbar;
hold on;
plot3(x_min(1), x_min(2), f_min, 'ro', 'MarkerSize', 5, 'LineWidth', 1);
text(x_min(1), x_min(2), f_min, sprintf('  Min: (%.3f, %.3f)', x_min(1), x_min(2)), 'Color', 'r', 'FontSize', 8);
steepest = plot3(steepestDescentHistory(1,:), steepestDescentHistory(2,:), steepestDescentValues, 'r.--', 'LineWidth', 1);
conjugate = plot3(conjugatgeGradientHistory(1,:), conjugatgeGradientHistory(2,:), conjugateGradientValues, 'b.--', 'LineWidth', 1);
plot3(steepestDescentHistory(1, end), steepestDescentHistory(2, end), steepestDescentValues(end), 'ro', 'MarkerSize', 5, 'LineWidth', 1);
text(steepestDescentHistory(1, end)+0.02, steepestDescentHistory(2, end)-0.02, steepestDescentValues(end), sprintf('x_2: (%.3f, %.3f)', steepestDescentHistory(1, end), steepestDescentHistory(2, end)), 'Color', 'r', 'FontSize', 8);
plot3(conjugatgeGradientHistory(1, end), conjugatgeGradientHistory(2, end), conjugateGradientValues(end), 'bo', 'MarkerSize', 5, 'LineWidth', 1);
text(conjugatgeGradientHistory(1, end)+0.02, conjugatgeGradientHistory(2, end)-0.02, conjugateGradientValues(end), sprintf('x_2: (%.3f, %.3f)', conjugatgeGradientHistory(1, end), conjugatgeGradientHistory(2, end)), 'Color', 'b', 'FontSize', 8);
legend([steepest, conjugate], {"Steepest Descent", "Conjugate Gradient"}, 'Location', 'best');
view([-766.70 69.86]);

