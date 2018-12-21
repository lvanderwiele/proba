th1 = 3;
th2 = 1;
sizeQ = 20;

Q = zeros(1000, sizeQ);
GMLE = zeros(1000, 1);
GMME = zeros(1000, 1);

for i = 1:1000
	[Q(i, :), GMLE(i), GMME(i)] = generate(sizeQ, h1, th2);
end

G = 1/(2*th1 - 1);

GMLEbias = mean(GMLE) - G;
GMMEbias = mean(GMME) - G;

varGMLE = var(GMLE);
varGMME = var(GMME);
mse = immse(GMME, GMLE);

function [Q, GMLE, GMME] = generate(sizeQ, th1, th2)
  t = rand(1, sizeQ);

  Q = th2./((1-t).^(1/th1));

  GMLE = gmle(Q);

  GMME = gmme(Q);
end

function GMLE = gmle(x)
  GMLE = 1./(2./(log(prod(x))/numel(x) - log(min(x))) - 1);
end

function GMME = gmme(x)
  a = mean(x);
  b = mean(x.^2);
  hatth1 = 1 + sqrt(b/(b-a^2));
  GMME = 1./(2*hatth1 - 1);
end
