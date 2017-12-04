function [p,std_p] = EISfit(model,pest,lb,hb,Zmeas,w)
    f = @(x)fitnessfuncvect(x,model,Zmeas',w,pest);
    options = optimoptions(@lsqnonlin,'FunctionTolerance',1e-9,'MaxFunctionEvaluations',100000,'MaxIterations',2000);
    [x,~,residual,~,~,~,J] = lsqnonlin(f,ones(1,length(pest)),lb./pest,hb./pest,options);
    J = full(J);
    p = pest.*x;
    covm = mean(residual.^2)*inv(J.'*J);
    std_x = cov2corr(covm);
    std_p = std_x.*p;
end