function dotx = continuousOPC(x_, beta)
% State space eqn of OPC
    dotx = NaN([length(x_), 1]);
    dotx(1) = x_(3);
    dotx(2) = x_(4);
    dotx(3) = U*cos(beta);
    dotx(4) = U*sin(beta);
end

