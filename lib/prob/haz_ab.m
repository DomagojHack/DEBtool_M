%% haz_AB
% Computes hazard for 2-mixtures of toxicants

%%
function h = haz_AB(t, x) % specifies hazard rate

  %% Syntax
  % h = <../haz_AB.m *haz_AB*> (t, x)

  %% Description
  % Computes hazard for 2-mixtures of compounds A,B that are substitutable for effects and NEC
  %
  % Input:
  %
  % * t: (n,1)-matrix with times
  % * x: dummy variable that is not used
  %  
  % Output:
  %
  % * h: (n,1)-matrix with hazard rates
  
  %% Remarks
  % Requires global par: (9,1)-matrix with parameters
  
  global par
  
  % unpack par
  cA = par(1); % mM, external conc for compound A
  cB = par(2); % mM, external conc for compound B
  kA = par(3); % 1/d, elimination rate for A
  kB = par(4); % 1/d, elimination rate for B
  BCFA = par(5); % l/C-mol, BCF for A
  BCFB = par(6); % l/C-mol, BCF for B
  Q0 = par(7); % mmol/C-mol, internal NEC
  bA = par(8); % C-mol/mmol.d, killing rate for compound A
  bB = par(9); % C-mol/mmol.d, killing rate for compound B

  QA = cA * BCFA * (1 - exp(-t * kA)); % internal concentration
  QB = cB * BCFB * (1 - exp(-t * kB)); % internal concentration

  hA = bA * max(0, QA - max(0, Q0 - QB)); % hazard for A
  hB=  bB * max(0, QB - max(0, Q0 - QA)); % hazard for B
  h = hA + hB; % total hazard
