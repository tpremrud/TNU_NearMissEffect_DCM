expDuration = 80;
U.dt = 0.1;
stimTimeDiff = 7;

ind1 = round(stimTimeDiff/U.dt:stimTimeDiff/U.dt:(expDuration - 2*stimTimeDiff)/U.dt);
u1 = zeros(expDuration/U.dt,1);
u1(ind1) = 5;

blockLength = 30;
nBlocks = floor(expDuration/2/blockLength);
ind2 = repmat((1:nBlocks)*round(blockLength/U.dt),round(blockLength/U.dt),1);
u2 = zeros(expDuration/U.dt, 1);
u2(ind2) = 1;
uuu = [u1,u2]';