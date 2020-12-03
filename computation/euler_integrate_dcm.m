function [y,h,x] = euler_integrate_dcm(U,P,p_hrf,x0,h0)
%%% Emulates a simple Euler integrator
u = [U.u(1,:);U.u(2,:);U.u(3,:);U.u(4,:)];
totalTime = U.iniDur/U.dt; % s 
y0 = [0;0;0;0];

x = [x0,];
h = [h0,];
y = [y0,];
num_states = size(x,1);

for i = 1:num_states
    for t = 1:totalTime
        dxdt = single_step_neural(x(:,t),u(:,t),P);
        dhdt = single_step_hrf(h(:,t),x(i,t),p_hrf);
        x(:,t+1) = x(:,t) + dxdt*U.dt;
        h(:,t+1) = h(:,t) + dhdt*U.dt;
        y(i,t+1) = compute_bold_signal(h(:,t+1),p_hrf);
    end
end

end