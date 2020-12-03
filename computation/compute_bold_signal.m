function y = compute_bold_signal(h,p_hrf)
%%% uses v and q (from h) to compute the BOLD signal change y
% In this case, we use parameter values for 3 Tesla case

%% Initialize variables
eps = 0.47;     % Only parameter that is estimated and multiplied with 
                % a log-normal parameter
V0 = 0.04;
E0 = p_hrf.e0;
v0 = 80.6;      % s^-1
r0 = 110;       % s^-1
TE = 0.035;     % s

k1 = 4.3*v0*E0*TE;
k2 = eps*r0*E0*TE;
k3 = 1-eps;

v = h(3,:);
q = h(4,:);

%% Computation
y = V0*(k1*(1-q)+k2*(1-(q/v))+k3*(1-v));
end