function LL = compute_log_llh(yData,P,U,sigmaNoise,p_hrf)
% Computes log likelihood given data, yData, an input, set of para
% and a noise lvl

if length(yData(1,:)) ~= length(U.u(1,:))
    error('ERROR: Data dimensions do not agree.');
else
    [yBOLD,~,~] = euler_integrate_dcm(U,P,p_hrf,x0,h0);
    
    yDiff = (yBOLD-yData)';
    yDiff = yDiff(:);           % Make a column vector
    n = length(yDiff);
    
    LL = (-0.5/(sigmaNoise^2))*(yDiff'*yDiff)-n*log(sigmaNoise)-(n/2)*log(2*pi);
end
end