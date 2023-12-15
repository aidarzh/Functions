function [SigmaO,fpeak] = DisturbanceToOutput(Acl,Bu,Kd,Bd,C,BaseD,IBaseY)
% SigmaD       - peak disturbance to output singular value
% fpeak        - corresponding frequency
% P            - Closed-loop disturbance to output MIMO system
% Acl          - Closed-loop state matrix
% Bu           - Manipulated input to state derivative matrix
% Kd           - Disturbance to manipulated input control matrix
% Bd           - Disturbance to state derivative matrix
% C            - State to Output matrix
% BaseD        - Diagonal matrix of disturbance base values
% IBaseY       - Inverse diagonal matrix of output base values
s              = zpk('s');
n              = length(Acl);
P              = IBaseY*C*inv(s*eye(n)-Acl)*((Bu*Kd+Bd)*BaseD);
sigmaplot(P)
[SigmaO,fpeak] = hinfnorm(P);
end