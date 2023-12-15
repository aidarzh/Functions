function [Bux,B1m] = MI_MID(Bu,CO)
    s     = sym('s');
    [~,m] = size(Bu);
    B1m   = s*ones(m,m);
    for i = 1:m
        B1m(i,:) = Bu(CO(i,1),:);
    end
    Bux   = Bu/B1m;
end