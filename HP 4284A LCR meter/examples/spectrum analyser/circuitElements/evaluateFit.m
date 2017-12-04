function fitness = evaluateFit(Zfit,Z)
    [n1,n2] = size(Zfit);
    if n1 > n2
        Zfit = Zfit';
    end
    [n1,n2] = size(Z);
    if n1 > n2
        Z = Z';
    end
    rErrori = abs(log10(abs(imag(Zfit)))-log10(abs(imag(Z))));
    rErrorr = abs(log10(abs(real(Zfit)))-log10(abs(real(Z))));
    fitness = (sum(rErrori)+sum(rErrorr)).^2/(length(rErrori)+length(rErrorr));
end