function U = create_input

%%%%%%%%%%%
% Creates four different inputs for the gambling addiction model
% with the first one being the driving input pulses, second one being 
% modulatory input block for win situation, third one being modulatory input
% block for full-miss loss situation and the last one being modulatory input
% for near-miss loss situation

U.iniDur = 120;       % Duration for the session
U.dt = 0.1;
U.stimTD = 6;     % Time difference between each input pulses

% Input 1: Driving Input Pulses
endPulse = U.iniDur-3*U.stimTD;
input1 = round(U.stimTD/U.dt : U.stimTD/U.dt : (endPulse)/U.dt);
u1 = zeros(U.iniDur/U.dt, 1);
u1(input1) = 5;

% Input 2: Modulatory Input for Win Situation
blockW = 3*U.stimTD;
u2 = zeros(U.iniDur/U.dt, 1);

% Input 3: Modulatory Input for Full-Miss Loss Situation
blockL = 3*U.stimTD;
u3 = zeros(U.iniDur/U.dt, 1);

% Input 4: Modulatory Input for Near-Miss Loss Situation
blockNM = 3*U.stimTD;
u4 = zeros(U.iniDur/U.dt, 1);

U.blockAll = [2*U.stimTD,
            2*U.stimTD+blockW,
            2*U.stimTD+blockW+2*U.stimTD,
            2*U.stimTD+blockW+2*U.stimTD+blockL,
            2*U.stimTD+blockW+2*U.stimTD+blockL+2*U.stimTD,
            2*U.stimTD+blockW+2*U.stimTD+blockL+2*U.stimTD+blockNM];
  
%% Loop for u2,u3 and u4
totalTime = U.iniDur/U.dt;
breakTime = U.iniDur - (blockW+blockL+blockNM+U.stimTD+endPulse-U.iniDur);

for t = 1:totalTime
    if t*U.dt > U.blockAll(2)
        u2(t) = 0;
    elseif any(~mod(t*U.dt,U.blockAll(1):U.dt:U.blockAll(2))) == 1
        u2(t) = 1;
    end
    if t*U.dt > U.blockAll(4)
        u3(t) = 0;
    elseif any(~mod(t*U.dt,U.blockAll(3):U.dt:U.blockAll(4))) == 1
        u3(t) = 1;
    end
    if t*U.dt > U.blockAll(6)
        u4(t) = 0;
    elseif any(~mod(t*U.dt,U.blockAll(5):U.dt:U.blockAll(6))) == 1
        u4(t) = 1;
    end
end


%% Verification Plot
x = (1:totalTime)*U.dt;
y1 = u1;
plot(x,y1,'Linewidth',3)
hold on
y2 = u2;
plot(x,y2,'LineWidth',3)
hold on
y3 = u3;
plot(x,y3,'LineWidth',3)
hold on
y4 = u4;
plot(x,y4,'LineWidth',3)
title('Driving and Modulation Inputs','FontSize',36)
legend('Drive', 'Win', 'Full-Miss', 'Near-Miss','FontSize',28)
xlabel('Time (Seconds)')
ylabel('BOLD Signal (a.u.)')
ax = gca;
ax.XAxis.FontSize = 30;
ax.YAxis.FontSize = 30;

U.u = [u2,u3,u4,u1]';

end