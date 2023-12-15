% Convert Symbolic Transfer Function to ZPK Transfer Function
% Crystal Nassouri 2009
% Allows for substitution/manipulation that can only be done with syms
% 
% Ex: Gs = syms2tf(G)
% Where G is a symbolic equation and Gs is a zpk transfer function
function[ans,TF] = syms2tf(G)
sizeG = size(G);
for i=1:sizeG(1)
    for j=1:sizeG(2)
        [symNum,symDen] = numden(G(i,j)); %Get num and den of Symbolic TF
        TFnum = sym2poly(symNum);    %Convert Symbolic num to polynomial
        TFden = sym2poly(symDen);    %Convert Symbolic den to polynomial
        TF1 = tf(TFnum,TFden);
        Gs(i,j) = TF1;
        b = cell2mat(TF1.num);
        a = cell2mat(TF1.den);
        [TF2.z,TF2.p,TF2.k] = tf2zpk(b,a);
        TF(i,j) = TF2;
    end
end
ans =Gs;