%% effect of increase in v in cum reprod of D. magna at f=1
%% pars from fig_2_10

  z = 1; % zoom factor
  p = [.799; % 1, kap
       .950; % 2, kapR
       .1509; % 3, g
       3.569; % 4, kJ, d^-1
       4.063; % 5, kM, d^-1
       0; % 6, LT, mm
       z*1.6216; % 7, v, mm d^-1 (vol length)
       z^2*.00100; % 8, UHb, mm^2 d (vol length)
       z^2*.0491]; % 9, UHp, mm^2 d^-1 (vol length) 

   [crep, UE0, Lb, Lp, tp] = cum_reprod([0;21], 1, p);
   crep_vector = crep(2); Lb_vector = Lb; Lp_vector = Lp; v_vector = p(7);
   UE0_vector = UE0; tp_vector = tp;
   Lm = p(7)/ p(3)/ p(5); R = reprod_rate(Lm, 1, p); R_vector = R;


   a = 1/1.02; % increment factor for v
   while crep(2) > 1 & p(7) > .1 & p(7) < 10
     p(7) = a * p(7); Lm = Lm * a;
     p(3) = p(3) * a;
     [crep, UE0, Lb, Lp, tp, info] = cum_reprod([0;21], 1, p, Lb);
     crep_vector = [crep_vector; crep(2)];
     Lb_vector = [Lb_vector; Lb];
     Lp_vector = [Lp_vector; Lp];
     UE0_vector = [UE0_vector; UE0];
     v_vector = [v_vector;p(7)];
     tp_vector = [tp_vector; tp];
     R = reprod_rate(Lm, 1, p); R_vector = [R_vector; R];
   end
   n = length(UE0_vector); Lb_vector = Lb_vector(1:n); Lp_vector = Lp_vector(1:n);
   UE0_vector = UE0_vector(1:n); R_vector = R_vector(1:n); v_vector = v_vector(1:n);
   crep_vector = crep_vector(1:n); tp_vector = tp_vector(1:n);
   

   subplot(2,3,1)
   plot(v_vector, crep_vector, 'r')
   xlabel('v')
   ylabel('cum reproduction')
   
   subplot(2,3,2)
   plot(v_vector, Lb_vector,'r')
   xlabel('v')
   ylabel('Lb')

   subplot(2,3,3)
   plot(v_vector, Lp_vector,'r')
   xlabel('v')
   ylabel('Lp')

   subplot(2,3,4)
   plot(v_vector, UE0_vector,'r')
   xlabel('v')
   ylabel('UE0')

   subplot(2,3,5)
   plot(v_vector, tp_vector,'r')
   xlabel('v')
   ylabel('tp')

   subplot(2,3,6)
   plot(v_vector, R_vector,'r')
   xlabel('v')
   ylabel('Rm')