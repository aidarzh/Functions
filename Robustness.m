function [robust] = Robustness(Acl,Base)
% Acl    - closed-loop state matrix in double format
% Base   - diagonal matrix of state variable base values (OP dependent)
% robust - small-signal sensitivity upper bound of closed-loop eigenvalues 
%          w. r. t. any perturbation in Acl
AclBase  = Base\(Acl*Base);
[V,~]    = eig(AclBase);
n        = length(Base);
robust   = n*cond(V);
end