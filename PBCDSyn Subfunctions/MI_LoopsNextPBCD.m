function [UcOut] = MI_LoopsNextPBCD(CO,A,Bux,BWW,K,Xc,X,UcIn,m)
    s = sym('s');
    UcOut = UcIn;
    % This "for" loop iterates through all the remaining (excluding first) 
    % cascaded loops as per CO.
    for l=2:size(CO,2)
        % This "for" loop iterates through all the states that need to be
        % controlled at this cascading level as per CO.
        for i=1:m
            % g - index of state to be controlled next (AFE: g=3 for vdc).
            g = CO(i,l);
            if g~=0
                % h - index of the state preceeding g in CO, which is going
                % to be used as manipulated input for g regulation (AFE:
                % h=1 for igd state, which will manipulate vdc).
                h  = CO(i,l-1);
                % Xh - state vector but with h-th state changed to its
                % command value (AFE: Xh = [igd*; igq; vdc] for h=1).
                Xh = subs(X,X(h),Xc(h));
                % This "for" loop iterates through Uh vector. 
                % Uh - vector of MID-ed and 1-st order PBCD-ed manipulated
                % inputs (AFE: Uh = [mcd;mcq]), evaluated at different Xh
                % to capture the effect of man. inputs on outer states
                % given inner state regulation (AFE: effect of mcd(igd*), 
                % mcq(igd*) on vdc provided igd* regulation. igd* and not 
                % igq* is because igd, not igq, is used to manipulate vdc.
                % The effect of igq is simply cancelled by SFBD).
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
                % Here, Xh in Uh is substituted by UcOut(g) to connect the
                % reference of the inner loop with the output of the outer
                % loop controller. For AFE, igd* is substituted by the
                % output of vdc regulator.
                Uh = subs(Uh,Xc(h),UcOut(g));
                % Once the effect of inner regulated state UcOut(g) and of
                % man. inputs Uh(UcOut(g)) is accounted for, one can
                % analytically derive UcOut(g). For AFE, the effects of
                % igd, mcd, mcq, and igq on vdc, substitution of igd*
                % (UcOut(3)) into all these leads to igd*, mcd(igd*),
                % mcq(igd*), and igq on vdc. From here, igd* can be found.
                % The same is valid even for further outer cascaded loops.
                eq = A(g,:)*subs(X,X(h),UcOut(g)) + Bux(g,:)*Uh +...
                    BWW(g) == K.Sym(g)*(Xc(g)-X(g));
                UcOut(g) = rhs(isolate(eq,UcOut(g)));
            end
        end
    end
end