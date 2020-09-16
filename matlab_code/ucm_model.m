% param = [k, theta1, theta2 phi1, phi2]
function [A, B, C, D, Mean0, Cov0, StateType] = ucm_model(params)
    
    k = params(1);
    theta1 = params(2);
    theta2 = params(3);
    phi1 = params(4);
    phi2 = params(5);
    %vare1 = exp(params(6)); %positive variance constraint
    %vare2 = params(7);
    varu1 = exp(params(6));
    varu2 = exp(params(7));
    varu3 = exp(params(8));
    varu4 = exp(params(9));
    varu5 = exp(params(10));
    
    I = [1 0 0 0 -1 -1 0 0 0 0; 0 0 0 0 1 0 0 0 0 1;
         0 0 0 0 0 1 0 0 0 0; 0 1 0 0 0 0 0 0 0 0; 0 0 1 0 0 0 0 0 0 0;
         0 0 0 1 0 0 0 0 0 0; 0 0 0 0 0 0 1 0 0 0; 0 0 0 0 0 0 0 1 0 0; 0 0 0 0 0 0 0 0 1 0; 0 0 0 0 0 0 0 0 0 1];
    L = [0 0 0 0 0 0 0 0 0 0; 0 0 0 0 1 0 0 0 0 0;
        0 0 0 0 0 phi1 phi2 0 0 0; 1 0 0 0 0 0 0 0 0 0; 0 1 0 0 0 0 0 0 0 0;
        0 0 1 0 0 0 0 0 0 0; 0 0 0 0 0 1 0 0 0 0; 0 0 0 0 0 0 0 1 0 0; 0 0 0 0 0 0 0 0 1 0; 0 0 0 0 0 0 0 0 0 1];
    M = [0 0 0 0 0; sqrt(varu1) 0 0 0 0; 0 0 0 sqrt(varu2) 0; 0 0 0 0 0; 0 0 0 0 0; 0 0 0 0 0; 0 0 0 0 0; 
        0 sqrt(varu3) 0 0 0; 0 0 sqrt(varu4) 0 0; 0 0 0 0 sqrt(varu5)];
    
    %A1 =  {inv(I)*L};
    A1 =  {I\L};
    
    %B1 = {inv(I)*M};
    B1 = {I\M};
    
    C1 = {[1 1 1 1 0 0 0 0 0 0; 0 0 0 0 0 k 0 0 1 0;
         0 0 0 0 0 theta1 theta2 1 0 0]};
    C2 = {[1 0 0 0 0 0 0 0 0 0;
         0 0 0 0 0 k 0 0 1 0;
         0 0 0 0 0 theta1 theta2 1 0 0]};
    
    D1 = {[0 0 0;0 1 0;0 0 1]}; % change sqrt for "1"
    %D1 = {[0 0 0;0 sqrt(vare1) 0;0 0 sqrt(vare2)]};
    
    A = [repmat(A1, 201, 1)];
    B = [repmat(B1, 201, 1)];
    C =  [repmat(C1, 120, 1); repmat(C2, 81,1)];
    D = [repmat(D1, 201,1)];
    
    %Mean0 = [0 0 0 0 0 0 0 0 0]; 
    %Cov0 = [1000 0 0 0 0 0 0 0 0;0 1000 0 0 0 0 0 0 0;0 0 1000 0 0 0 0 0 0;0 0 0 1000 0 0 0 0 0;0 0 0 0 1000 0 0 0 0;
    %0 0 0 0 0 1 0 0 0;0 0 0 0 0 0 1 0 0;0 0 0 0 0 0 0 1000 0;0 0 0 0 0 0 0 0 1000];
    Mean0 = []; %let software infer Mean0
    Cov0 = []; %let software infer Cov0
    StateType = [2 2 2 2 2 0 0 2 2 2];
    
end 

