function [SigmaM,fpeak] = DisturbanceToManInput(Acl,Bu,K,Kd,Bd,BaseD,IBaseM)
% SigmaM       - peak disturbance to manipulated input singular value
% fpeak        - corresponding frequency
% P            - Closed-loop disturbance to manipulated input MIMO system
% Acl          - Closed-loop state matrix
% Bu           - Manipulated input to state derivative matrix
% K            - State to manipulated input matrix
% Kd           - Disturbance to manipulated input control matrix
% Bd           - Disturbance to state derivative matrix
% BaseD        - Diagonal matrix of disturbance base values
% IBaseM       - Inverse diagonal matrix of manipulated input base values
s              = zpk('s');
n              = length(Acl);
P              = IBaseM*(K*inv(s*eye(n)-Acl)*(Bu*Kd+Bd)+Kd)*BaseD;
sigmaplot(P)
[SigmaM,fpeak] = hinfnorm(P);
end