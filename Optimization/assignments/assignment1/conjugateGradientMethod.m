function x_hstry = conjugateGradientMethod(x, x_0, grad_f, alpha_k, beta_k, iter)
    x_prev = x_0;
    x_hstry = [x_0, x];
    % x_n for problem solveing
    isFirst = true;
    for i = 1:iter
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
        x_hstry = [x_hstry, x];
    end
end

