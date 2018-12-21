close all
clear all
clc

% Computes the PMF, CMF, mean and standard deviation of the Gamma function

disp('Simulation Gamma')

gamPMF = gamcdf(480, 5*(1:70), 3) - gamcdf(480, 5*(1:70)+5, 3); % Computes the PMF

gamCMF = gamPMF;
for i = find(gamPMF, 1):70 % Loops to compute the CMF from the CMF
  gamCMF(i) = gamPMF(i) + gamCMF(i-1);
end
gamCMF(find(gamCMF == 1, 1)+1:end) = 1;

avGam = sum((1:70).*gamPMF) % Computes the average and standard deviation
stdGam = sqrt(sum(((1:70).^2).*gamPMF) - avGam.^2)

figure
  stem(gamPMF)
  title('Probability Mass Function of the screen production')
  xlabel('Number n of produced screens'); ylabel('Probability of producing n screens in 8 hours')

figure
  stem(gamCMF)
  title('Cumulative Mass Function of the screen production')
  xlabel('Number n of produced screens'); ylabel('Probability of producing up to n screens in 8 hours')

% Simulates the process using looping sums of exponential variables stopping when time is out
% Computes the mean, standard deviation, PMF and CMF of the simulation
  
disp('Simulation Exponentielle')

nE = zeros(1e4, 1);
t = 0;
temp = 0;

for i = 1:size(nE, 1) % Simulates ten thousands times the production line
  while t <= 480
    t = t + sum(exprnd(3, [5 1]));

    if t<=480
      nE(i) = nE(i)+1;
    end
  end
  t=0;
end

% Computes the mean and standard deviation of the first hundred, the first thousand and all the simulations
avNE1 = mean(nE(1:100))
avNE2 = mean(nE(1:1000))
avNE3 = mean(nE)

sigNE1 = std(nE(1:100))
sigNE2 = std(nE(1:1000))
sigNE3 = std(nE)

% Computes the PMF of the simulation
nProb = zeros(70, 1);
for i = min(nE):max(nE)
  nProb(i) = numel(find(nE == i))/numel(nE);
end

figure
  stem(1:70, nProb)
  title({'Probability Mass Function', 'of the simulated exponential distribution'})
  xlabel('Number n of produced screens'); ylabel('Probability of producing n screens in 8 hours')

% Computes the CMF of the simulation using its PMF
nCum = nProb;
for i = min(nE):max(nE)
  nCum(i) = nProb(i)+nCum(i-1);
end
nCum(find(nCum == 1, 1)+1:end) = 1;

figure
  stem(1:70, nCum)
  title({'Cumulative Mass Function', 'of the simulated exponential distribution'})
  xlabel('Number n of produced screen'); ylabel('Probability of producing up to n screens in 8 hours')

% Determines the location of the quantile 0.05 and 0.95 using the simulation

iSup05 = find(nCum > 0.05, 1);
iInf05 = iSup05 - 1;
if abs(nCum(iSup05)-0.05) < abs(nCum(iInf05)-0.05)
  i05 = iSup05
else
  i05 = iInf05
end

iSup95 = find(nCum > 0.95, 1);
iInf95 = iSup95 - 1;
if abs(nCum(iSup95)-0.95) < abs(nCum(iInf95)-0.95)
  i95 = iSup95
else
  i95 = iInf95
end

% Simulates the process while factoring the eventuality of breakdowns

nP3 = zeros(1e3, 1);

for i = 1:size(nP3, 1)
    X = rand; % generate randomly a number between 0 et 1
    if X<=0.1 % if breakdown (probability of 10%)
        t = exprnd(180);
        while t <= 480
            t = t + sum(exprnd(3, [5 1]));
            if t<=480
                nP3(i) = nP3(i)+1;
            end
        end
    else % if no breakdown
        while t <= 480
            t = t + sum(exprnd(3, [5 1]));
            if t<=480
                nP3(i) = nP3(i)+1;
            end
        end
    end
    t = 0;
end

bProb = zeros(70, 1);
for i = 0:69
  bProb(i+1) = numel(find(nP3 == i))/numel(nP3);
end

figure
  stem(bProb)
  title({'Probability Mass Function of the screen production', 'with an eventuality of breakdown'})
  xlabel('Number n of screen produced'); ylabel('Probability of producing n screens')

bCum = bProb;
for i = 1:69
  bCum(i+1) = bProb(i+1) + bCum(i);
end

figure
  stem(bCum)
  title({'Cumulative Mass Function of the screen production', 'with an eventuality of breakdown'})
  xlabel('Number n of screen produced'); ylabel('Probability of producing up to n screens')

av = mean(nP3) % mean with risk of breakdown
sigma = std(nP3) % standard deviation with risk of breakdown
