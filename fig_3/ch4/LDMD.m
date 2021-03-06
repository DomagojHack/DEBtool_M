%% fig:LDMD
%% bib:ZonnKooy89
%% out:wdld,wdmd
%% dry-weight (g) during starvation (d) in Lymnaea stagnalis

%% long-day
tw_ld1 = [ ...
       0 1.743527e+002;
       0 1.540725e+002;
       6 1.021670e+002;
       6 1.000532e+002;
       6 9.793936e+001;
      10 9.924590e+001;
      10 9.818898e+001;
      10 8.579419e+001;
      10 1.009302e+002;
      14 9.314743e+001;
      20 7.391046e+001;
      20 7.141229e+001;
      20 7.035912e+001;
      26 6.294420e+001;
      26 6.006169e+001;
      26 5.439275e+001;
      31 5.984588e+001;
      31 5.813871e+001;
      31 5.149970e+001];

tw_ld2 = [ ...
     0	1.188983e+002;
     0	1.000659e+002;
     6	7.766195e+001;
     6	7.487177e+001;
    10	7.435647e+001;
    10	6.974164e+001;
    10	6.724346e+001;
    14	6.720108e+001;
    14	5.220921e+001;
    14	5.009537e+001;
    20	4.479429e+001;
    20	4.229893e+001;
    20	3.912816e+001;
    26	4.689541e+001;
    26	3.978146e+001;
    26	3.056118e+001;
    31	3.992887e+001;
    31	3.528156e+001;
    31	3.072910e+001;
    31	2.740960e+001];

tw_ld3 = [ ...
       0 5.634127e+001;
       0 5.345501e+001;
       6 3.605396e+001;
       6 3.355578e+001;
       6 3.000444e+001;
      10 3.524759e+001;
      10 3.140706e+001;
      10 2.641071e+001;
      14 2.809220e+001;
      14 2.588227e+001;
      20 2.519321e+001;
      20 2.269128e+001;
      20 2.019686e+001;
      26 1.845463e+001;
      26 1.633704e+001;
      26 1.355061e+001;
      31 1.783047e+001;
      31 1.536455e+001;
      31 1.365738e+001;
      31 1.119146e+001];

tw_ld4 = [ ...
       0 2.251606e+001;
       0 1.867271e+001;
       6 1.904714e+001;
       6 1.760589e+001;
       6 1.549204e+001;
      10 1.362501e+001;
      10 1.218375e+001;
      14 1.060497e+001;
      20 1.202975e+001;
      20 8.858985e+000;
      20 7.129479e+000;
      26 8.838757e+000;
      26 6.059837e+000;
      31 7.492590e+000;
      31 5.785418e+000;
      31 4.173088e+000];

%% mid-day
tw_md = [ ...
  65 0.074100;
  65 0.077400;
  65 0.075400;
  65 0.081900;
  65 0.052500;
  65 0.068800;
  58 0.067900;
  58 0.073300;
  58 0.103700;
  58 0.059100;
  58 0.065200;
  51 0.092400;
  51 0.091200;
  51 0.098000;
  51 0.061100;
  51 0.068700;
  44 0.088000;
  44 0.107300;
  44 0.111100;
  44 0.105000;
  44 0.096900;
  35 0.128700;
  35 0.079100;
  35 0.066500;
  35 0.140000;
  28 0.146000;
  28 0.146100;
  28 0.137800;
  28 0.171600;
  28 0.118600;
  22 0.162000;
  22 0.106200;
  22 0.128400;
  22 0.126400;
  22 0.158300;
  14 0.164500;
  14 0.174900;
  14 0.167200;
  14 0.149800;
  14 0.145200;
   7 0.171400;
   7 0.163300;
   7 0.184000;
   7 0.178200;
   7 0.149000;
   2 0.167400;
   2 0.184800;
   2 0.171000;
   2 0.154300;
   2 0.184700];

nmregr_options('report',0)
p_txt = {'init length 1'; 'init length 2'; 'init length 3'; 'init length 4'; ...
	 'V_m d_Vd'; 'V_m w_Ed [M_Em] e(0)'; 'g k_M'};
p = [.83 1; .74 1; .58 1; .45 1; 80 0; 197 1; .06 1];
p = nmregr('starve_ld', p, tw_ld1, tw_ld2, tw_ld3, tw_ld4);
[cov, cor, sd] = pregr('starve_ld', p, tw_ld1, tw_ld2, tw_ld3, tw_ld4);
printpar(p_txt,p,sd);

t_ld = linspace(0,31,100)';
[w1, w2, w3, w4] = starve_ld(p(:,1), t_ld, t_ld, t_ld, t_ld);

p_txt = {'init weight'; 'rate'};
p = [.18 1; .0018 1];
p = nrregr('starve_md', p, tw_md);
[cov, cor, sd] = pregr('starve_md', p, tw_md);
printpar(p_txt,p,sd);
nmregr_options('report',1)

t_md = [0; 70];
w = starve_md(p(:,1), t_md);

%% gset term postscript color solid 'Times-Roman' 35

subplot(1,2,1);
plot(tw_ld1(:,1), tw_ld1(:,2), '.r', ...
     tw_ld2(:,1), tw_ld2(:,2), '.g', ...
     tw_ld3(:,1), tw_ld3(:,2), '.b', ...
     tw_ld4(:,1), tw_ld4(:,2), '.m', ...
     t_ld, w1, '-r', t_ld, w2, '-g', t_ld, w3, '-b', t_ld, w4, '-m')
title('long day')
xlabel('time, d')
ylabel('dry weight, g')

subplot(1,2,2);
plot(tw_md(:,1), tw_md(:,2), '.r', t_md, w, '-r');
title('mid day')
xlabel('time, d')
ylabel('dry weight, g')
