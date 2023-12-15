function [F,Fw,Fr] = MI_NumericF(Plant,FSym,FwSym,FrSym,Kout,K)
    F.Num   = subs(FSym.Sym,K.Sym,Kout.Num);
    Fw.Num  = subs(FwSym.Sym,K.Sym,Kout.Num);
    Fr.Num  = subs(FrSym.Sym,K.Sym,Kout.Num);
    syms_names = fieldnames(Plant.Syms);
    for i = 1:length(syms_names)
        symbol = syms_names{i};
        numeric_value = Plant.Specs.(symbol); % Get the corresponding numeric value
        F.Num  = subs(F.Num, Plant.Syms.(symbol), numeric_value); % Substitute the symbol
        Fw.Num = subs(Fw.Num, Plant.Syms.(symbol), numeric_value); % Substitute the symbol
        Fr.Num = subs(Fr.Num, Plant.Syms.(symbol), numeric_value); % Substitute the symbol
    end
    F.Num  = double(F.Num);
    Fw.Num = double(Fw.Num);
    Fr.Num = double(Fr.Num);
end