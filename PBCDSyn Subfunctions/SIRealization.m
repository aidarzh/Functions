%% Single-Input Realization
% This function determines the cascading order of the SI PBCDSyn in case it 
% was not provided. SVD analysis is used for this purpose as per Dissertation. 
% Realization accepts 1 input parameter - the Plant structure, and outputs 
% 1 parameter - CascadeOrder matrix for PBCDSyn subsequent use. To keep the 
% rest of the code intact, the CascadeOrder determination is added as a 
% separate function. The input parameter is:
% 
% Plant - a structure that contains symbolic A,B,C,D of the small-signal 
% plant, Specs structure with numeric parameters used, and .Syms structure
% with all symbolic variables used. Note that for small-signal plant, C,D 
% are such that the output contains only variables to be controlled 
% (not the generalized plant version). Only the Plant.Specs substructure is
% used in this function, namely the numeric evaluations of matrices.
%
% The output parameter is: CascadeOrder - row vector that contains 
% information on the cascaded order of the states for control. For example,
% in a two-state one-input plant, CascadeOrder = [2 1] means state x2 is 
% controlled first, followed by state x1.
function [CascadeOrder] = SIRealization(Plant)
    A  = Plant.Specs.Apu;
    Bu = Plant.Specs.Bupu;
    n  = size(Plant.Apu,1);
    CascadeOrder = ones(1,n);
    
    Bl = Bu;
    Al = A;
    order = 1:n;
    for i = 1:(n-1)
        [U,~,~] = svd(Bl);
        Uinv    = inv(U);
        [~,phi]   = max(abs(Uinv(1,:)));
        Ibar = order(phi);
        CascadeOrder(i) = Ibar;
        
        aIbarIbar = Al(phi,phi);
        bIbar = Bl(phi);
        al = Al(:,phi);
        al(phi) = [];
        Bl(phi) = [];

        aIbar = Al(phi,:);
        aIbarS = aIbar;
        aIbarS(phi) = [];
        
        Al(phi,:) = [];
        Al(:,phi) = [];
        order(phi) = [];
        Al = Al + Bl*(-aIbarS/bIbar);
        Bl = Bl*(-aIbarIbar/bIbar) + al;
    end
    CascadeOrder(n) = order;
end