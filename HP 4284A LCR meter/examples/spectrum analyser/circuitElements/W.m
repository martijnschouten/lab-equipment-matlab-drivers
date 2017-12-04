function Z = W(Aw,w)
    Z = Aw./sqrt(w)+Aw./(sqrt(w)*1i);
end