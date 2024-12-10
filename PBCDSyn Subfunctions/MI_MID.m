function [Bux,B1m] = MI_MID(Bu,CO)
    s     = sym('s');
    [~,m] = size(Bu);
    B1m   = s*ones(m,m);
    for i = 1:m
        B1m(i,:) = Bu(CO(i,1),:);
    end
    Bux   = Bu/B1m; % = Bu*inv(B1m); see the MID diagram: inv(B1m) = MID; Bux = B_MID
end
