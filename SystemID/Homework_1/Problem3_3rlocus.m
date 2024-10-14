model_order = 1:1:6;                % The order of model
idx = 0;
Data = load("Prob3.mat");

for input_order = model_order
    for output_order = model_order
        idx = idx + 1;
        figure(idx);
        discrete_sys_rlocus(Data, input_order, output_order);
        title = "rlocus_input_" + num2str(input_order) + "_output_" + num2str(output_order);
        pngname = "Problem3_root_locus/" + title + ".png";
        print(pngname, "-dpng", "-r500");
    end
end

%% Functions
function Phi = regressor_matrix(data, input_order, output_order)
    % Data와 input order, output order의 차수를 받아 regressor matrix Phi를 도출
    % data에는 input u, output y가 무조건 존재해야함
    if ~isfield(data, 'y') || ~isfield(data, 'u')
        error("Input data must contain y and u");
    end
    % Data field 확인 절차
    if length(data.y) < output_order || length(data.u) < input_order
        error("Insufficient data points in y, u");
    end
    % Data 길이 확인
    order = max(input_order, output_order);
    Phi = zeros([length(data.y)-order, input_order+output_order]);
    idx = 0;
    for i = order+1 : length(data.u)
        idx = idx + 1;
        Phi(idx, :) = [flip(data.y(i-output_order:i-1)'), flip(data.u(i - input_order:i-1)')];
    end
end

function [theta, A_q, B_q] = least_square(data, input_order, output_order)
    Phi = regressor_matrix(data, input_order, output_order);
    order = max(input_order, output_order);
    Output = data.y(order+1:end);
    theta = inv(Phi'*Phi) * Phi'*Output;
    A_q = theta(1:output_order)';
    B_q = theta(output_order+1:input_order+output_order)';
end

function discrete_sys_rlocus(data, input_order, output_order)
    [theta, A_q, B_q] = least_square(data, input_order, output_order);
    A_q = [1, -A_q];
    B_q = [0, B_q];
    sys = tf(B_q, A_q, 0.1, 'Variable', 'z^-1');
    rlocus(sys);
    axis equal;
end