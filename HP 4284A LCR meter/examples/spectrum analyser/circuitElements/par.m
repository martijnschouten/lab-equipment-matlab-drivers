function Z = par(varargin)
    Z = varargin{1};
    [~,n1] = size(varargin);
    for i1 = 2:n1
        Z = Z.*varargin{i1}./(Z+varargin{i1});
    end
end