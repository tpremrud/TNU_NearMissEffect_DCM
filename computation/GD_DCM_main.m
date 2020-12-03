%% NOTES and TODO
% 
clc
clear
%% TN2020: Gambling Addiction Model Project %%
% ***Description
% ==> This is a proposed dynamic causal model of gambling addiction
% based on fMRI evidence


% Initialization
% Parameters for connectivity ==> has 4 inputs = need 4 nodes
% Node 1: Insula
% Node 2: Ventral Striatum (VStr)
% Node 3: Substantia Nigra (SN)
% Node 4: Superior Colliculus (S.C)
P_HC.A = [-0.1,0,1,0;1,-0.1,1,0;0,0,-0.1,1;0,0,0,-0.1];
P_GA.A = P_HC.A;
P_HC.B = [0,0,1,0;0,0,1,0;0,0,0,0;0,0,0,0];             % WIN
P_HC.C = [0,0,-1,0;0,0,-1,0;0,0,0,0;0,0,0,0];           % Full-miss Loss
P_HC.D = [0,0,0.3,0;0,0,0.3,0;0,0,0,0;0,0,0,0];         % Near-miss Loss
P_GA.B = [0,0,1,0;0,0,1,0;0,0,-.5,0;0,0,0,0];           % WIN
P_GA.C = [0,0,-1,0;0,0,-1,0;0,0,-.5,0;0,0,0,0];         % Full-miss Loss
P_GA.D = [0,0,0.3,0;.5,0,0.3,0;0,0,-.5,0;0,0,0,0];      % Near-miss Loss
P_HC.E = [0,0,0,0;0,0,0,0;0,0,0,0;0,0,0,1];             % Driving Input
P_GA.E = P_HC.E;

disp(P_HC.A)
disp(P_HC.B)
disp(P_HC.C)
disp(P_HC.D)
disp(P_HC.E)

p_hrf.kappa = 0.64;
p_hrf.gamma = 0.32;
p_hrf.tau = 2;
p_hrf.alpha = 0.32;
p_hrf.e0 = 0.4;

% At time t = 0
h0 = [0,1,1,1]';          % Hemodynamic state vector
X0 = [0,0,0,0]';          % Neural state vector

U = create_input;
totalTime = U.iniDur/U.dt;
%% Computation
%Euler Method
[y_HC,h_HC,X_HC] = euler_integrate_dcm(U,P_HC,p_hrf,X0,h0);         
[y_GA,h_GA,X_GA] = euler_integrate_dcm(U,P_GA,p_hrf,X0,h0);         

%% PLOTS
figure(2)           % figure 1 is the inputs
%%%%%%%%%%%%%%%%%
subplot(2,3,1);     % Neural Activity for win case

x = (1:(U.blockAll(3)-U.stimTD)/U.dt);
y1 = X_HC(1,1:(U.blockAll(3)-U.stimTD)/U.dt);
plot(x,y1,'LineWidth',3)
hold on
y2 = X_HC(2,1:(U.blockAll(3)-U.stimTD)/U.dt);
plot(x,y2,'LineWidth',3)
hold on
y3 = X_HC(3,1:(U.blockAll(3)-U.stimTD)/U.dt);
plot(x,y3,'LineWidth',3)
hold on
y4 = X_HC(4,1:(U.blockAll(3)-U.stimTD)/U.dt);
plot(x,y4,'LineWidth',3)
hold on
y5 = X_GA(1,1:(U.blockAll(3)-U.stimTD)/U.dt);
plot(x,y5,'-.','LineWidth',3)
hold on
y6 = X_GA(2,1:(U.blockAll(3)-U.stimTD)/U.dt);
plot(x,y6,'-.','LineWidth',3)
hold on
y7 = X_GA(3,1:(U.blockAll(3)-U.stimTD)/U.dt);
plot(x,y7,'-.','LineWidth',3)
hold on
y8 = X_GA(4,1:(U.blockAll(3)-U.stimTD)/U.dt);
plot(x,y8,'-.','LineWidth',3)
title('Neural Activity WIN (HC = Healthy, GA = Gamblers)','FontSize',24)
legend('Insula_{HC}', 'VStr_{HC}', 'SN_{HC}', 'SC_{HC}','Insula_{GA}', 'VStr_{GA}', 'SN_{GA}', 'SC_{GA}','FontSize',20,'Location','northwest');
xlabel('Time (Milliseconds)')
ylabel('Neural Activity (a.u.)')
ax = gca;
ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;
axis([1 (U.blockAll(3)-U.stimTD)/U.dt 0 10])
%%%%%%%%%%%%%%%
subplot(2,3,2);     % Neural Activity for Full-miss loss case

x = ((U.blockAll(3)-U.stimTD)/U.dt:(U.blockAll(5)-U.stimTD)/U.dt);
y1 = X_HC(1,(U.blockAll(3)-U.stimTD)/U.dt:(U.blockAll(5)-U.stimTD)/U.dt);
plot(x,y1,'LineWidth',3)
hold on
y2 = X_HC(2,(U.blockAll(3)-U.stimTD)/U.dt:(U.blockAll(5)-U.stimTD)/U.dt);
plot(x,y2,'LineWidth',3)
hold on
y3 = X_HC(3,(U.blockAll(3)-U.stimTD)/U.dt:(U.blockAll(5)-U.stimTD)/U.dt);
plot(x,y3,'LineWidth',3)
hold on
y4 = X_HC(4,(U.blockAll(3)-U.stimTD)/U.dt:(U.blockAll(5)-U.stimTD)/U.dt);
plot(x,y4,'LineWidth',3)
hold on
y5 = X_GA(1,(U.blockAll(3)-U.stimTD)/U.dt:(U.blockAll(5)-U.stimTD)/U.dt);
plot(x,y5,'-.','LineWidth',3)
hold on
y6 = X_GA(2,(U.blockAll(3)-U.stimTD)/U.dt:(U.blockAll(5)-U.stimTD)/U.dt);
plot(x,y6,'-.','LineWidth',3)
hold on
y7 = X_GA(3,(U.blockAll(3)-U.stimTD)/U.dt:(U.blockAll(5)-U.stimTD)/U.dt);
plot(x,y7,'-.','LineWidth',3)
hold on
y8 = X_GA(4,(U.blockAll(3)-U.stimTD)/U.dt:(U.blockAll(5)-U.stimTD)/U.dt);
plot(x,y8,'-.','LineWidth',3)
title('Neural Activity LOSS (HC = Healthy, GA = Gamblers)','FontSize',24)
legend('Insula_{HC}', 'VStr_{HC}', 'SN_{HC}', 'SC_{HC}','Insula_{GA}', 'VStr_{GA}', 'SN_{GA}', 'SC_{GA}','FontSize',20,'Location','northwest');
xlabel('Time (Milliseconds)')
ylabel('Neural Activity (a.u.)')
ax = gca;
ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;
axis([(U.blockAll(3)-U.stimTD)/U.dt (U.blockAll(5)-U.stimTD)/U.dt 0 10])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,3,3);     % Neural Activity for Near-miss loss case

x = ((U.blockAll(5)-U.stimTD)/U.dt:totalTime+1);
y1 = X_HC(1,(U.blockAll(5)-U.stimTD)/U.dt:end);
plot(x,y1,'LineWidth',3)
hold on
y2 = X_HC(2,(U.blockAll(5)-U.stimTD)/U.dt:end);
plot(x,y2,'LineWidth',3)
hold on
y3 = X_HC(3,(U.blockAll(5)-U.stimTD)/U.dt:end);
plot(x,y3,'LineWidth',3)
hold on
y4 = X_HC(4,(U.blockAll(5)-U.stimTD)/U.dt:end);
plot(x,y4,'LineWidth',3)
hold on
y5 = X_GA(1,(U.blockAll(5)-U.stimTD)/U.dt:end);
plot(x,y5,'-.','LineWidth',3)
hold on
y6 = X_GA(2,(U.blockAll(5)-U.stimTD)/U.dt:end);
plot(x,y6,'-.','LineWidth',3)
hold on
y7 = X_GA(3,(U.blockAll(5)-U.stimTD)/U.dt:end);
plot(x,y7,'-.','LineWidth',3)
hold on
y8 = X_GA(4,(U.blockAll(5)-U.stimTD)/U.dt:end);
plot(x,y8,'-.','LineWidth',3)
title('Neural Activity NEAR MISS (HC = Healthy, GA = Gamblers)','FontSize',24)
legend('Insula_{HC}', 'VStr_{HC}', 'SN_{HC}', 'SC_{HC}','Insula_{GA}', 'VStr_{GA}', 'SN_{GA}', 'SC_{GA}','FontSize',20);
xlabel('Time (Milliseconds)')
ylabel('Neural Activity (a.u.)')
ax = gca;
ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;
axis([(U.blockAll(5)-U.stimTD)/U.dt totalTime+1 0 10])
%%%%%%%%%%%%% BOLD %%%%%%%%%%%%%%%%%%%
subplot(2,3,4);     % BOLD Signal

x = (1:(U.blockAll(3)-U.stimTD)/U.dt);
y1 = y_HC(1,1:(U.blockAll(3)-U.stimTD)/U.dt);
plot(x,y1,'LineWidth',3)
hold on
y2 = y_HC(2,1:(U.blockAll(3)-U.stimTD)/U.dt);
plot(x,y2,'LineWidth',3)
hold on
y3 = y_HC(3,1:(U.blockAll(3)-U.stimTD)/U.dt);
plot(x,y3,'LineWidth',3)
hold on
y4 = y_HC(4,1:(U.blockAll(3)-U.stimTD)/U.dt);
plot(x,y4,'LineWidth',3)
hold on
y5 = y_GA(1,1:(U.blockAll(3)-U.stimTD)/U.dt);
plot(x,y5,'-.','LineWidth',3)
hold on
y6 = y_GA(2,1:(U.blockAll(3)-U.stimTD)/U.dt);
plot(x,y6,'-.','LineWidth',3)
hold on
y7 = y_GA(3,1:(U.blockAll(3)-U.stimTD)/U.dt);
plot(x,y7,'-.','LineWidth',3)
hold on
y8 = y_GA(4,1:(U.blockAll(3)-U.stimTD)/U.dt);
plot(x,y8,'-.','LineWidth',3)
title('BOLD Signal WIN (HC = Healthy, GA = Gamblers)','FontSize',24)
legend('Insula_{HC}', 'VStr_{HC}', 'SN_{HC}', 'SC_{HC}','Insula_{GA}', 'VStr_{GA}', 'SN_{GA}', 'SC_{GA}','FontSize',20,'Location','northwest');
xlabel('Time (Milliseconds)')
ylabel('BOLD Signal (a.u.)')
ax = gca;
ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;
axis([1 (U.blockAll(3)-U.stimTD)/U.dt -0.02 0.18])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,3,5);     % BOLD Signal for Full-miss Loss case

x = ((U.blockAll(3)-U.stimTD)/U.dt:(U.blockAll(5)-U.stimTD)/U.dt);
y1 = y_HC(1,(U.blockAll(3)-U.stimTD)/U.dt:(U.blockAll(5)-U.stimTD)/U.dt);
plot(x,y1,'LineWidth',3)
hold on
y2 = y_HC(2,(U.blockAll(3)-U.stimTD)/U.dt:(U.blockAll(5)-U.stimTD)/U.dt);
plot(x,y2,'LineWidth',3)
hold on
y3 = y_HC(3,(U.blockAll(3)-U.stimTD)/U.dt:(U.blockAll(5)-U.stimTD)/U.dt);
plot(x,y3,'LineWidth',3)
hold on
y4 = y_HC(4,(U.blockAll(3)-U.stimTD)/U.dt:(U.blockAll(5)-U.stimTD)/U.dt);
plot(x,y4,'LineWidth',3)
hold on
y5 = y_GA(1,(U.blockAll(3)-U.stimTD)/U.dt:(U.blockAll(5)-U.stimTD)/U.dt);
plot(x,y5,'-.','LineWidth',3)
hold on
y6 = y_GA(2,(U.blockAll(3)-U.stimTD)/U.dt:(U.blockAll(5)-U.stimTD)/U.dt);
plot(x,y6,'-.','LineWidth',3)
hold on
y7 = y_GA(3,(U.blockAll(3)-U.stimTD)/U.dt:(U.blockAll(5)-U.stimTD)/U.dt);
plot(x,y7,'-.','LineWidth',3)
hold on
y8 = y_GA(4,(U.blockAll(3)-U.stimTD)/U.dt:(U.blockAll(5)-U.stimTD)/U.dt);
plot(x,y8,'-.','LineWidth',3)
title('BOLD Signal LOSS (HC = Healthy, GA = Gamblers)','FontSize',24)
legend('Insula_{HC}', 'VStr_{HC}', 'SN_{HC}', 'SC_{HC}','Insula_{GA}', 'VStr_{GA}', 'SN_{GA}', 'SC_{GA}','FontSize',20,'Location','northwest');
xlabel('Time (Milliseconds)')
ylabel('BOLD Signal (a.u.)')
ax = gca;
ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;
axis([(U.blockAll(3)-U.stimTD)/U.dt (U.blockAll(5)-U.stimTD)/U.dt -0.02 0.18])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,3,6);     % BOLD Signal for Near-miss Loss case

x = ((U.blockAll(5)-U.stimTD)/U.dt:totalTime+1);
y1 = y_HC(1,(U.blockAll(5)-U.stimTD)/U.dt:end);
plot(x,y1,'LineWidth',3)
hold on
y2 = y_HC(2,(U.blockAll(5)-U.stimTD)/U.dt:end);
plot(x,y2,'LineWidth',3)
hold on
y3 = y_HC(3,(U.blockAll(5)-U.stimTD)/U.dt:end);
plot(x,y3,'LineWidth',3)
hold on
y4 = y_HC(4,(U.blockAll(5)-U.stimTD)/U.dt:end);
plot(x,y4,'LineWidth',3)
hold on
y5 = y_GA(1,(U.blockAll(5)-U.stimTD)/U.dt:end);
plot(x,y5,'-.','LineWidth',3)
hold on
y6 = y_GA(2,(U.blockAll(5)-U.stimTD)/U.dt:end);
plot(x,y6,'-.','LineWidth',3)
hold on
y7 = y_GA(3,(U.blockAll(5)-U.stimTD)/U.dt:end);
plot(x,y7,'-.','LineWidth',3)
hold on
y8 = y_GA(4,(U.blockAll(5)-U.stimTD)/U.dt:end);
plot(x,y8,'-.','LineWidth',3)
title('BOLD Signal NEAR MISS (HC = Healthy, GA = Gamblers)','FontSize',24)
legend('Insula_{HC}', 'VStr_{HC}', 'SN_{HC}', 'SC_{HC}','Insula_{GA}', 'VStr_{GA}', 'SN_{GA}', 'SC_{GA}','FontSize',20);
xlabel('Time (Milliseconds)')
ylabel('BOLD Signal (a.u.)')
ax = gca;
ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;
axis([(U.blockAll(5)-U.stimTD)/U.dt totalTime+1 -0.02 0.18])

