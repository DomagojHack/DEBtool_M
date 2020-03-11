%% get_cpm
% get cohort trajectories

%%
function [tXN, tXW, info] = get_cpm(model, par, tT, tJX, x_0, V_X, n_R, t_R)
% created 2020/03/03 by Bob Kooi & Bas Kooijman
  
%% Syntax
% [tXN, tXW, info] = <../get_cpm.m *get_cpm*> (model, par, tT, tJX, x_0, n_R, t_R)
  
%% Description
% integrates cohorts with synchronized reproduction events, called by cpm, 
%
% variables to be integrated, packed in Xvars:
%  X: mol/vol or mol/surface, food density
%    for each cohort:
%  q: 1/d^2, aging acceleration
%  h_a: 1/d, hazard for aging
%  L: cm, struc length
%  L_max: cm, struc length before start shrinking
%  E: J/cm^3, reserve density [E]
%  E_R: J, reprod buffer
%  E_H: J, maturity
%  N: #, number of individuals in cohort
%
% number of current cohorts n_c = (length(Xvars) - 1)/8
% n_c increases for 1 till some max value, determined by number of oldest cohort < 1e-4, which depends on ageing and other hazards  
%
% Input:
%
% * model: character-string with name of model
% * par: structure with parameter values
% * tT: (nT,2)-array with time and temperature in Kelvin; time scaled between 0 (= start) and 1 (= end of cycle)
% * tJX: (nX,2)-array with time and food supply; time scaled between 0 (= start) and 1 (= end of cycle)
% * x_0: scalar with scaled initial food density 
% * V_X: scalar with volume of reactor
% * n_R: scalar with number of reproduction events to be simulated
% * t_R: scalar with time period between reproduction events 
%
% Output:
%
% * tXN: (n,m)-array with times, food density and number of individuals in the various cohorts
% * tXW: (n,m)-array with times, food density and total wet weights of the various cohorts
% * info: bolean with failure (0) of success (1)

  options = odeset('Events',@puberty, 'AbsTol',1e-9, 'RelTol',1e-9);
  info = 1;
  
  % unpack par and compute compound pars
  vars_pull(par); vars_pull(parscomp_st(par));  
  
  % temperature correction
  par_T = T_A;
  if exist('T_L','var') && exist('T_AL','var')
    par_T = [T_A; T_L; T_AL];
  end
  if exist('T_L','var') && exist('T_AL','var') && exist('T_H','var') && exist('T_AH','var')
    par_T = [T_A; T_L; T_H; T_AL; T_AH]; 
  end
  % % unscale knots for temperature, and convert to temp correction factors
  if length(tT) == 1
     tTC = tempcorr(tT, T_ref, par_T);
  else
     tTC = [tT(:,1) * t_R, tempcorr(tT(:,2), T_ref, par_T)]; % uTemperature Correction factor
  end
  % unscale knots for food density in supply flux
  if length(tJX) > 1
    tJX(:,1) = tJX(:,1) * t_R; % unscale tJX
  end
  
  % initial reserve and states at birth appended to par
  switch model
    case {'stf','stx'}        
      [S_b, q_b, h_Ab, tau_b, tau_0b, u_E0, l_b] = get_Sb_foetus([g k v_Hb h_a s_G h_B0b 0]); 
    otherwise
      [S_b, q_b, h_Ab, tau_b, tau_0b, u_E0, l_b] = get_Sb([g k v_Hb h_a s_G h_B0b 0]);
  end
  E_0 = g * E_m * L_m^3 * u_E0;
  if length(tTC)==1
    aT_b = tau_b/ k_M/ tTC; 
  else
    aT_b = tau_b/ k_M/ spline1(0, tTC); 
  end
  L_b = l_b * L_m; 
  
  if t_R < aT_b
    fprintf('Warning from get_cpm: age at birth is larger than reproduction interval\n');
    info = 0; tXN = []; tXW = []; return
  end
  
  % initial states with number of cohorts n_c = 1;
  X_0 = x_0 * K; % unscale initial food density
  Xvars_0 = [X_0; 0; 0; L_b; L_b; E_m; 0; E_Hb; 1]; % X q h L L_max [E] E_R E_H N
  tXN = [0, X_0, 1]; tXW = [0, X_0, E_0/ mu_E * w_E/ d_E];% initialise output
  
  for i = 1:n_R
    switch model
      case 'std'
        par_std = {tTC, tJX, V_X, h_D, h_J, q_b, h_Ab, h_B0b, h_Bbp, h_Bpi, h_a, s_G, thin, S_b, aT_b, L_b, L_m, E_Hb, E_Hp, E_m, k_J, k_JX, v, g, p_M, p_Am, J_X_Am, K, kap, kap_G, del_X};
        [t, Xvars] = ode45(@dcpm_std, [0; aT_b; t_R], Xvars_0, options, par_std{:});
      case 'stf'
        [t, Xvars] = ode45(@dcpm_stf, [0; aT_b; t_R], Xvars_0, options, par, tTC, tX);
      case 'stx'
        [t, Xvars] = ode45(@dcpm_stx, [0; aT_b; t_R], Xvars_0, options, par, tTC, tX);
      case 'ssj'
        [t, Xvars] = ode45(@dcpm_ssj, [0; aT_b; t_R], Xvars_0, options, par, tTC, tX);
      case 'sbp'
        [t, Xvars] = ode45(@dcpm_sbp, [0; aT_b; t_R], Xvars_0, options, par, tTC, tX);
      case 'abj'
        [t, Xvars] = ode45(@dcpm_abj, [0; aT_b; t_R], Xvars_0, options, par, tTC, tX);
      case 'asj'
        [t, Xvars] = ode45(@dcpm_asj, [0; aT_b; t_R], Xvars_0, options, par, tTC, tX);
      case 'abp'
        [t, Xvars] = ode45(@dcpm_abp, [0; aT_b; t_R], Xvars_0, options, par, tTC, tX);
      case 'hep'
        [t, Xvars] = ode45(@dcpm_hep, [0; aT_b; t_R], Xvars_0, options, par, tTC, tX);
      case 'hex'
        [t, Xvars] = ode45(@dcpm_hex, [0; aT_b; t_R], Xvars_0, options, par, tTC, tX);
    end
    [t, Xvars_0, tXN, tXW] = cohorts(t(end), Xvars(end,:), tXN, tXW, t_R, E_0, kap_R, L_b, E_m, E_Hb, mu_E, w_E, d_E); % catenate output and possibly insert new cohort
    [i, (length(Xvars_0)-1)/8]
  end
end


function [t, Xvars_0, tXN, tXW] = cohorts(t, Xvars, tXN, tXW, t_R, E_0, kap_R, L_b, E_m, E_Hb, mu_E, w_E, d_E)
  t = tXN(end,1) + t_R; Xvars_t = Xvars(end,:); % last value of t, Xvars
  [X, q, h_A, L, L_max, E, E_R, E_H, N] = cpm_unpack(Xvars_t);

  % reproduction event
  dN = kap_R * sum(N .* floor(E_R/ E_0)); % #, number of new eggs
  E_R = mod(E_R, E_0); % reduce reprod buffer to fractions of eggs
    
  % build new initial state vectors and append to output
  q = [0; q]; h_A = [0; h_A]; L = [L_b; L]; L_max = [L_b; L_max]; E = [E_m; E]; E_R = [0; E_R]; E_H = [E_Hb; E_H]; N = [dN; N]; 
  % most values for cogort 0 will be overwritten in dget_mod
  W = N .* L.^3 .* (1 + E/ mu_E * w_E/ d_E) + E_R/ mu_E * w_E/ d_E; % g, wet weights
  if N(end) > 1e-4 % add new youngest cohort
    tXN = [[tXN, zeros(size(tXN,1),1)]; [t, X, N']]; % append to output
    tXW = [[tXW, zeros(size(tXW,1),1)]; [t, X, W']]; % append to output
  else % add new youngest cohort and remove oldest
    q(end)=[]; h_A(end)=[]; L(end)=[]; L_max(end)=[]; E(end)=[]; E_R(end)=[]; E_H(end)=[]; N(end)=[]; W(end)=[];
    tXN = [tXN; [t, X, N']]; % append to output
    tXW = [tXW; [t, X, W']]; % append to output
  end
  Xvars_0 = max(0,[X; q; h_A; L; L_max; E; E_R; E_H; N]); % pack state vars
end

function [value,isterminal,direction] = puberty(t, Xvars, tTC, tJX, V_X, h_D, h_J, q_b, h_Ab, h_B0b, h_Bbp, h_Bpi, h_a, s_G, thin, S_b, aT_b, L_b, L_m, E_Hb, E_Hp, E_m, k_M, k_J, k_JX, v, g, p_M, p_Am, J_X_Am, K, kap, kap_G, del_X)
  n_c = (length(Xvars) - 1)/ 8; % #, number of cohorts
  E_H = Xvars(1+4*n_c+(1:n_c)); % J, maturities, cf cpm_unpack
  value = min(abs(E_H - E_Hp)); % trigger 
  isterminal = 0;  % continue after event
  direction  = []; % get all the zeros
end

