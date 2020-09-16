% State Space Model - Time Series Analysis
% State Space Setting

Md1 = ssm(@ucm_model);

% processing data
Y = table2array(dataproject);
%Y(:,1) = 100 * log(Y(:,1));
%Y(:,1) = log(Y(:,1));
rowDist = ones(1, length(Y));
Y = mat2cell(Y, rowDist);

% Estimate state space

% param = [k, theta1, theta2 phi1, phi2]
params0 = [0.5 0.5 0.5 1.5 -0.6 0.2 0.2 0.2 0.2 0.2];

Output1 = refine(Mdl,Y,params0);
logL = cell2mat({Output1.LogLikelihood});
[~,maxLogLIndx] = max(logL);
refinedParams0 = Output1(maxLogLIndx).Parameters;

%est.model = estimate(Md1, Y, refinedParams0, 'lb', [-Inf,-Inf,-Inf,-Inf,-Inf,0,0,0,0]);
est.model = estimate(Md1, Y, refinedParams0);

% Smooth state space
[~,~,Output]= smooth(est.model,Y);

T = length(Y);

stateIndx = [5 6]; % State Indices of interest (stochastic trend a cycle)
SmoothedStates = NaN(T,numel(stateIndx));
SmoothedStatesCov = NaN(T,numel(stateIndx));

for t = 1:T
    maxInd1 = size(Output(t).SmoothedStates,1);
		maxInd2 = size(Output(t).SmoothedStatesCov,1);
    mask1 = stateIndx <= maxInd1;
		mask2 = stateIndx <= maxInd2;
    SmoothedStates(t,mask1) = ...
        Output(t).SmoothedStates(stateIndx(mask1),1);
		SmoothedStatesCov(t,mask2) = ...
        diag(Output(t).SmoothedStatesCov(stateIndx(mask2),...
        stateIndx(mask2)));
end

trend_lb = SmoothedStates(:,1) - 1.95*sqrt(SmoothedStatesCov(:,1));
trend_ub = SmoothedStates(:,1) + 1.95*sqrt(SmoothedStatesCov(:,1));
trend_Intervals = [trend_lb trend_ub];

cycle_lb = SmoothedStates(:,2) - 1.95*sqrt(SmoothedStatesCov(:,2));
cycle_ub = SmoothedStates(:,2) + 1.95*sqrt(SmoothedStatesCov(:,2));
cycle_Intervals = [cycle_lb cycle_ub];

figure
plot(1:T,SmoothedStates(:,1),':r',...
		1:T,trend_Intervals,'--b','LineWidth',2);
title('GDP Trend State Values')
xlabel('Period')
ylabel('State Value')
legend({'Smoothed state values',...
    '95% Confidence Intervals'});

figure
plot(1:T,SmoothedStates(:,2),':r',...
		1:T,cycle_Intervals,'--b','LineWidth',2);
title('GDP Cycle')
xlabel('Period')
ylabel('State Value')
legend({'Smoothed state values',...
    '95% Confidence Intervals'});