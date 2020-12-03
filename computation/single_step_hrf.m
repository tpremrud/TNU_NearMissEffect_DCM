function dhdt = single_step_hrf(h,x,p_hrf)
%%% Computes update for the hemodynamic model of a single region
% h = h(t) = [s,f,v,q] which is the hemodynamic state vector
% x = x(t) neural state of the region at time t
% p_hrf is a struct containing parameters of the hemodynamic model

%% Initialize hemodynamic states
s = h(1,:);
f = h(2,:);
v = h(3,:);
q = h(4,:);

%% Compute the first derivative of the states
ds = x - p_hrf.kappa*s - p_hrf.gamma*(f-1);
df = s;
dv = (f-v^(1/p_hrf.alpha))/p_hrf.tau;
dq = (f*(1-(1-p_hrf.e0)^(1/f))/p_hrf.e0 - (v^(1/p_hrf.alpha))*q/v)/p_hrf.tau;
dhdt = [ds;df;dv;dq];
end