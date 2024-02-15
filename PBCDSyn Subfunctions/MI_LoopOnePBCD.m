function [UcOut] = MI_LoopOnePBCD(CO,AX,BWW,K,Xc,X,UcIn,m)
% This function takes the MID-ed plant, checks which states of
% this decoupled plant are to be controlled first through which
% (MID-ed) manipulated inputs, and applies PBCD on the first
% set of states using the MID-ed plant.
    UcOut = UcIn;
    for i=1:m
        g = CO(i,1);
        if g ~= 0
            % Here, UcOut is a vector of size m, which contains analytic
            % equtions for the MID-ed manipultated inputs after applying
            % PBCD to the first controlled states MID-ed plant.
            % Check the LoopOnePBCD diagram for the AFE example.
            UcOut(g) = K.Sym(g)*(Xc(g)-X(g)) - AX(g) - BWW(g);
        end
    end
end