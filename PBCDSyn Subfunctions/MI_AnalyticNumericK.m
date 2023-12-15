function [Kout] = MI_AnalyticNumericK(Plant,GainCalcMethod,CO,Poles,Omega,n,m,F,Fr,K)
    if GainCalcMethod == "Simple"
        Kout.Sym = Omega;
    elseif GainCalcMethod == "Exact"
        % Evaluate only for n<=3 states, since larger polynomials are
        % unsolvable symbolically
        s        = sym('s');
        Kout.Sym = s*ones(1,n);
        for i=1:m
            CLTF = Plant.Co/(s*eye(n) - Plant.A - Plant.Bu*F.Sym)*Plant.Bu*Fr.Sym(:,i);
            [~,den] = numden(collect(CLTF(i),s)); % Reference-to-Output TF
            den1 = collect(den/subs(den,s,0),s); % Characterisitic equation in standard form
            coefficients = coeffs(den1,s); % Symbolic coefficients of the denominator
            ni = length(coefficients)-1;
            an = sym('a',[1,ni]);
            if ni==1
                an(ni) = collect((den1-1)/s,s);
                Kout.Sym(CO(i,ni))=solve([an(ni)==1/(Omega(CO(i,ni)))],[K.Sym(CO(i,ni))]);
            elseif ni==2
                an(ni) = subs(collect((den1-1)/s,s),s,0);
                an(ni-1) = collect((collect((den1-1)/s,s) - an(ni))/s,s);
                Kan=solve([an(ni-1)==1/(Omega(CO(i,ni-1))*Omega(CO(i,ni))),an(ni)==...
                    (1/Omega(CO(i,ni-1)))+(1/Omega(CO(i,ni)))],[K.Sym(CO(i,ni-1)), K.Sym(CO(i,ni))]);
                Kout.Sym(CO(i,ni-1)) = Kan.(char(K.Sym(CO(i,ni-1))));
                Kout.Sym(CO(i,ni)) = Kan.(char(K.Sym(CO(i,ni))));
            elseif ni==3
                an(ni) = subs(collect((den1-1)/s,s),s,0);
                an(ni-1) = subs((collect((den1-1)/s,s) - an(ni))/s,s,0);
                an(ni-2) = collect(((collect((den1-1)/s,s) - an(ni))/s - an(ni-1))/s,s);
                Kan=solve([an(ni-2)==1/(Omega(CO(i,ni-2))*Omega(CO(i,ni-1))*Omega(CO(i,ni))),an(ni-1)==(1/(Omega(CO(i,ni-2))*...
                    Omega(CO(i,ni-1)))+1/(Omega(CO(i,ni-2))*Omega(CO(i,ni)))+1/(Omega(CO(i,ni-1))*Omega(CO(i,ni)))),an(ni)==...
                    (1/Omega(CO(i,ni-2)) + 1/Omega(CO(i,ni-1)) + 1/Omega(CO(i,ni)))],[K.Sym(CO(i,ni-2)), K.Sym(CO(i,ni-1)), K.Sym(CO(i,ni))]);
                Kout.Sym(CO(i,ni-2)) = Kan.(char(K.Sym(CO(i,ni-2))));
                Kout.Sym(CO(i,ni-1)) = Kan.(char(K.Sym(CO(i,ni-1))));
                Kout.Sym(CO(i,ni)) = Kan.(char(K.Sym(CO(i,ni))));
            end
        end
    end
    
    PolesSorted = ones(1,n);
    for i=1:m
        COl = CO(i,:);
        Polesl = Poles(i,:);
        idx = find(COl,1,'last');
        COlnz = COl(1:idx);
        Poleslnz = Polesl(1:idx);
        for j=1:length(COlnz)
            PolesSorted(COlnz(j)) = Poleslnz(j);
        end
    end
    
    syms_names = fieldnames(Plant.Syms);
    K.Num   = subs(Kout.Sym,Omega,PolesSorted);
    for i1 = 1:length(syms_names)
        symbol = syms_names{i1};
        numeric_value = Plant.Specs.(symbol); % Get the corresponding numeric value
        K.Num  = subs(K.Num, Plant.Syms.(symbol), numeric_value); % Substitute the symbol
    end
    Kout.Num = double(K.Num);
end