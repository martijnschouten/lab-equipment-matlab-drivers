function Z = ser(varargin)
    Z = varargin{1};
    for i1 = 2:length(varargin)
        Z = Z+varargin{i1};
    end
end