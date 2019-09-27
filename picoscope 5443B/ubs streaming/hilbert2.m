function out = hilbert2(in,bins)
   n = length(in);
   n2 = floor(n/bins);
   out = zeros(n,1);
   for i1 = 1:bins-1
       use = (i1-1)*n2+1:i1*n2;
       out(use) = imag(hilbert(in(use)));
   end
   out((bins-1)*n2+1:end) = imag(hilbert(in((bins-1)*n2+1:end)));
end