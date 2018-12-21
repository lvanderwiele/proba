% Partie 1

% Exercise E

% Parameters

th1 = 3;
th2 = 1;
sizeQ = 20;

% Creation of Q, GMLE and GMME

Q = zeros(1000, sizeQ);
GMLE = zeros(1000, 1);
GMME = zeros(1000, 1);

for i = 1:1000
	[Q(i, :), GMLE(i), GMME(i)] = generate(sizeQ, th1, th2);
end

% Computation of G

G = 1/(2*th1 - 1);

% Exercise F

% Plotting of histograms and boxplots
figure
	subplot(2, 2, 1)
		histogram(GMLE)
		title({'Histogram of the MLE', 'of G for n = 20'});
		ylabel('Number of occurences');
	subplot(2, 2, 2)
		histogram(GMME)
		title({'Histogram of the MME', 'of G for n = 20'});
		ylabel('Number of occurences');
	subplot(2, 2, 3)
		boxplot(GMLE)
		title({'Boxplot of the MLE', 'of G for n = 20'});
	subplot(2, 2, 4)
		boxplot(GMME)
		title({'Boxplot of the MME', 'of G for n = 20'});

% Exercise g

% Computation of biases

GMLEbias = mean(GMLE) - G;
GMMEbias = mean(GMME) - G;

% Computation of Variances

varGMLE = var(GMLE);
varGMME = var(GMME);

% Computation of MSE

mse = immse(GMME, GMLE);


% Function generating Q, GMLE and GMME
% 	sizeq decide Q's sample size 
function [Q, GMLE, GMME] = generate(sizeQ, th1, th2)
  t = rand(1, sizeQ);

  Q = th2./((1-t).^(1/th1));

  GMLE = gmle(Q);

  GMME = gmme(Q);
end

% Computation of GMLE
function GMLE = gmle(x)
  GMLE = 1./(2./(log(prod(x))/numel(x) - log(min(x))) - 1);
end

% Computation of GMME
function GMME = gmme(x)
  a = mean(x);
  b = mean(x.^2);
  hatth1 = 1 + sqrt(b/(b-a^2));
  GMME = 1./(2*hatth1 - 1);
end
