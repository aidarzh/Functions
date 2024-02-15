function [F,Fw,Fr] = MI_PBCD2SFB(CO,B1m,Xc,X,W,UcIn,u,n,m,nw)
    s = sym('s');
    uo = u;
    UcSubs = s*zeros(m,1);
    F.Sym = s*zeros(m,n);
    Fw.Sym = s*zeros(m,nw);
    Fr.Sym = s*zeros(m,m);
    for i=1:m
        UcSubs(i) = UcIn(CO(i,1));
        COl = CO(i,:);
        idx = find(COl,1,'last');
        COlnz = COl(1:idx);
        for j=1:(length(COlnz)-1)
            UcSubs(i) = subs(UcSubs(i),Xc(COlnz(j)),UcIn(COlnz(j+1)));
        end
        uo(i) = collect(collect(collect(simplify(UcSubs(i)),X),Xc),W);
        F.Sym(i,:) = simplify(equationsToMatrix(uo(i),X));
        Fw.Sym(i,:) = simplify(equationsToMatrix(uo(i),W));
        Fr.Sym(i,i) = simplify(equationsToMatrix(uo(i),Xc(COlnz(end))));
    end
    F.Sym = simplify(B1m\F.Sym); % = inv(B1m)*F.Sym; See the MID diagram
    Fw.Sym = simplify(B1m\Fw.Sym);
    Fr.Sym = simplify(B1m\Fr.Sym);
end