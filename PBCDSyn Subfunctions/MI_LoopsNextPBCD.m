function [UcOut] = MI_LoopsNextPBCD(CO,A,Bux,BWW,K,Xc,X,UcIn,m)
    s = sym('s');
    UcOut = UcIn;
    for l=2:size(CO,2)
        for i=1:m
            g = CO(i,l);
            if g~=0
                h  = CO(i,l-1);
                Xh = subs(X,X(h),Xc(h));
                Uh = s*ones(m,1);
                for j=1:m
                    g1 = CO(j,1);
                    if g1==h
                        Uh(j) = subs(UcOut(g1),X,Xh);
                    else
                        Uh(j) = subs(UcOut(g1),Xc,X);
                        Uh(j) = subs(Uh(j),X,Xh);
                    end
                end
                Uh = subs(Uh,Xc(h),UcOut(g));
                eq = A(g,:)*subs(X,X(h),UcOut(g)) + Bux(g,:)*Uh +...
                    BWW(g) == K.Sym(g)*(Xc(g)-X(g));
                UcOut(g) = rhs(isolate(eq,UcOut(g)));
            end
        end
    end
end