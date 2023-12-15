function [UcOut] = MI_LoopOnePBCD(CO,AX,BWW,K,Xc,X,UcIn,m)
    UcOut = UcIn;
    for i=1:m
        g = CO(i,1);
        if g ~= 0
            UcOut(g) = K.Sym(g)*(Xc(g)-X(g)) - AX(g) - BWW(g);
        end
    end
end