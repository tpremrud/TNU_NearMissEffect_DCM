function dxdt = single_step_neural(x,u,P)
%%%%%%%%
% Calculates right hand side of diff eq of bilinear model for neural system
% dynamics.
% x = x(t) is the neural state vector
% u = u(t) is the 2D input vector at time t
% P is a parameter struct with fields A, B and C
dxdt = zeros(size(x));
connect = P.A + u(1)*P.B + u(2)*P.C + u(3)*P.D;
effCon = diag(-0.5*exp(diag(connect))) + (connect - diag(diag(connect)));

dxdt = effCon*x + P.E*u;
end