set(0, 'defaultTextInterpreter', 'latex')

% Part 1

% Exercise E

% Parameters

th1 = 3;
th2 = 1;
sizeQ = 20;

% Creation of Q, GMLE and GMME

[Q, GMLE, GMME] = generate(sizeQ, th1, th2);

% Computation of G

G = 1/(2*th1 - 1);

% Exercise F

% Plotting of histograms and boxplots
figure
	subplot(2, 2, 1)
		histogram(GMLE)
		title('\begin{tabular}{c}Histogram of the MLE\\ of G for n = 20\end{tabular}');
		ylabel('Number of occurences');
	subplot(2, 2, 2)
		histogram(GMME)
		title('\begin{tabular}{c}Histogram of the MME\\ of G for n = 20\end{tabular}');
		ylabel('Number of occurences');
	subplot(2, 2, 3)
		boxplot(GMLE)
		title('\begin{tabular}{c}Boxplot of the MLE\\ of G for n = 20\end{tabular}');
	subplot(2, 2, 4)
		boxplot(GMME)
		title('\begin{tabular}{c}Boxplot of the MME\\ of G for n = 20\end{tabular}');

% Exercise g

% Computation of biases

GMLEbias = mean(GMLE) - G;
GMMEbias = mean(GMME) - G;

% Computation of Variances

varGMLE = var(GMLE);
varGMME = var(GMME);

% Computation of MSE

mse = immse(GMME, GMLE);

% Exercise h

% Calculating estimators with various sample sizes

n = [20, 40, 60, 80, 100, 150, 200, 300, 400, 500];
GMLE = [GMLE, zeros(1000, numel(n)-1)];
GMME = [GMME, zeros(1000, numel(n)-1)];

for i = 2:numel(n)
  [~, GMLE(:, i), GMME(:, i)] = generate(n(i), th1, th2);
end

% Calcultating biases

GMLEbias = mean(GMLE) - G;
GMMEbias = mean(GMME) - G;

% Caculating variances

GMLEvar = var(GMLE);
GMMEvar = var(GMME);

% Calculating MSE

mse = zeros(1, 10);

for i = 1:numel(n)
  mse(i) = immse(GMLE(:, i), GMME(:, i));
end

figure;
  subplot(1, 2, 1)
    stem(n, GMLEbias)
		title('\begin{tabular}{c}Bias of the MLE of G\\ for various sample sizes\end{tabular}')
    xlabel('Sample size n'); ylabel('Bias of the estimator')
  subplot(1, 2, 2)
    stem(n, GMMEbias)
		title('\begin{tabular}{c}Bias of the MME of G\\ for various sample sizes\end{tabular}')
    xlabel('Sample size n'); ylabel('Bias of the esitmator');

figure;
  subplot(1, 2, 1)
    stem(n, GMLEvar)
		title('\begin{tabular}{c}Variance of the MLE of G\\ for various sample sizes\end{tabular}')
    xlabel('Sample size n'); ylabel('Variance of the estimator');
  subplot(1, 2, 2)
    stem(n, GMMEvar)
		title('\begin{tabular}{c}Variance of the MME of G\\ for various sample sizes\end{tabular}')
    xlabel('Sample size n'); ylabel('Variance of the estimator');

figure;
  stem(n, mse)
	title('\begin{tabular}{c}Mean Square Error of the MME and MLE of G\\ for various sample sizes \end{tabular}')
  xlabel('Sample size n'); ylabel('Mean Square Error');

% Exercise i

comp = [sqrt(n(1))*(GMLE(:, 1)-G) sqrt(n(5))*(GMLE(:, 5)-G) sqrt(n(10))*(GMLE(:, 10)-G)];

figure;
	subplot(1, 3, 1);	
		histogram(comp(:, 1));
		ylabel('Occurences for n = 20')
	subplot(1, 3, 2);
		histogram(comp(:, 2));
		ylabel('Occurences for n = 100')
	subplot(1, 3, 3);
		histogram(comp(:, 3));
		ylabel('Occurences for n = 500')
	a = axes;
	t1 = title('Histogram of $\sqrt{n}(\hat{G}_{MLE} - G_{\theta_1^0, \theta_2^0})$ for various sample sizes');
	a.Visible = 'off'
	t1.Visible = 'on'


function [Q, GMLE, GMME] = generate(sizeQ, th1, th2)
  Q = zeros(1000, sizeQ);
  GMLE = zeros(1000, 1);
  GMME = zeros(1000, 1);

  for i = 1:1000
    [Q(i, :), GMLE(i), GMME(i)] = generateSample(sizeQ, th1, th2);
  end
end


% Function generating Q, GMLE and GMME
% 	sizeq decide Q's sample size 

function [Q, GMLE, GMME] = generateSample(sizeQ, th1, th2)
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
