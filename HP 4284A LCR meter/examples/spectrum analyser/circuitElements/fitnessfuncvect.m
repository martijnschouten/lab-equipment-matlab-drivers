function fitness = fitnessfuncvect(x,circuit,Z,w,pstart)
    p = x.*pstart;
    Zest = eval(circuit);
    rErrori = abs(log10(abs(imag(Zest)))-log10(abs(imag(Z))));
    rErrorr = abs(log10(abs(real(Zest)))-log10(abs(real(Z))));
    fitness = [rErrori,rErrorr];
end
    