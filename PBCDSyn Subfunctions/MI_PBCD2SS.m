function [Ac,Bc,Cc,Dc] = MI_PBCD2SS(m,n,nw,CO,F,Fw,Fr,K,Ki,Kout,Plant,Opts,Poles)
    % Controller order determination --------------------------------------
    s = sym('s');
    ni = m;
    if Opts.Integrator == "False"
        ni = 0;
    end
    
    % Integrator gains calculation ----------------------------------------
    for i=1:m
        Polesl = Poles(i,:);
        idx = find(Polesl,1,'last');
        Ki.Num(i) = 0.1*(Polesl(idx))^2;
    end
    
    % Controller State Space Representation -------------------------------
    % Ac
    Ac.Sym = s*zeros(ni);
    Ac.Num = zeros(ni);
    
    % Bc
    Bc.Sym = [s*zeros(ni,(n+nw)), s*eye(ni)/s];
    Bc.Num = [zeros(ni,(n+nw)), eye(ni)];
    for i=1:ni
        COl = CO(i,:);
        idx = find(COl,1,'last');
        COlLast = COl(idx);
        Bc.Sym(i,COlLast) = -1;
        Bc.Num(i,COlLast) = -1;
    end
    
    % Cc
    Cc.Sym = s*zeros(m,ni);
    for i=1:ni
        COl = CO(i,:);
        idx = find(COl,1,'last');
        COlLast = COl(idx);
        Cc.Sym(i,i) = (Fr.Sym(i,i)/K.Sym(COlLast))*Ki.Sym(i);
    end
    Cc.Num = subs(Cc.Sym,[K.Sym Ki.Sym],[Kout.Num Ki.Num]);
    syms_names = fieldnames(Plant.Syms);
    for i = 1:length(syms_names)
        symbol = syms_names{i};
        numeric_value = Plant.Specs.(symbol); % Get the corresponding numeric value
        Cc.Num = subs(Cc.Num, Plant.Syms.(symbol), numeric_value); % Substitute the symbol
    end
    Cc.Num = double(Cc.Num);
    
    % Dc
    Dc.Sym = [F.Sym Fw.Sym Fr.Sym];
    Dc.Num = [F.Num Fw.Num Fr.Num];
end