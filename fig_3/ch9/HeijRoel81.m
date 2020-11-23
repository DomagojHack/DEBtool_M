%% fig:HeijRoel81
%% bib:HeijRoel81
%% out:HeijRoel81
%% expected and measured molar yield of dioxygen

data = [0.53 1.261904762 4 0;
	0.59 1.735294118 4 0;
	0.65 1.756756757 4 0;
	0.56 1.435897436 4 0;
	0.54 1.542857143 4 0;
	0.36 1.5         4 0;
	0.43 1.433333333 4 0;
	0.55 0.8461538462 2.133333333 0;
	0.43 0.7543859649 2.133333333 0;
	0.55 0.7746478873 2.133333333 0;
	0.6  0.8450704225 2.133333333 0;
	0.53 0.7571428571 2.133333333 0;
	0.52 0.7536231884 2.133333333 0;
	0.56 1.191489362  2.133333333 0;
	0.51 0.8947368421 2.133333333 0;
	0.57 1.1875       2.133333333 0;
	0.65 1.274509804  2.133333333 0;
	0.53 0.8983050847 2.133333333 0;
	0.54 1.08 4 1;
	0.46 0.92 4 1;
	0.48 0.9795918367 4 1;
	0.5  0.9090909091 4 1;
	0.63 0.9130434783 4 1;
	0.57 0.7215189873 4 1;
	0.57 0.7215189873 4 1;
	0.59 0.6555555556 4 1;
	0.57 0.7702702703 4 1;
	0.5  1            4 1;
	0.43 1.075        4 1;
	0.64 0.8          3 0.5;
	0.52 0.7428571429 3 0.5;
	0.78 0.75         3 0.5;
	0.64 0.7356321839 3 0.5;
	0.4  0.7843137255 3 0.5;
	0.46 0.8363636364 3 0.5;
	0.42 1.05         3 0.5;
	0.51 0.9444444444 3 0.5;
	0.74 0.3854166667 2.666666667 1;
	0.74 0.3410138249 2.666666667 1;
	0.69 0.4539473684 2.666666667 1;
	0.69 0.552        2.666666667 1;
	0.69 0.4893617021 2.666666667 1;
	0.58 0.3945578231 2.666666667 1;
	0.56 0.347826087  2.333333333 1;
	0.68 0.4146341463 2.333333333 1;
	0.62 0.4769230769 2.333333333 1;
	0.52 0.2549019608 2.333333333 1;
	0.33 0.7021276596 2.333333333 1;
	0.5  0.6493506494 2 1;
	0.44 0.4782608696 2 1;
	0.34 0.641509434  2 1;
	0.33 0.3975903614 2 1;
	0.48 0.3404255319 2 1;
	0.49 0.4260869565 2 1;
	0.69 0.4131736527 2 1;
	0.71 0.4251497006 2 1;
	0.39 0.3391304348 2 1;
	0.5  0.4901960784 2 1;
	0.62 0.3604651163 2 1;
	0.68 0.3333333333 2 1;
	0.66 0.4024390244 2 1;
	0.67 0.5877192982 2 1;
	0.59 0.3597560976 2 1;
	0.55 0.275        2 1;
	0.65 0.3963414634 2 1;
	0.8  0.5925925926 2 1;
	0.7  0.3783783784 2 1;
	0.64 0.3786982249 2 1;
	0.54 0.3552631579 2 1;
	0.47 0.4272727273 2 1;
	0.6  0.2643171806 2 1;
	0.46 0.4946236559 2 1;
	0.54 0.3016759777 2 1;
	0.65 0.318627451  2 1;
	0.53 0.3028571429 2 1.166666667;
	0.41 0.2907801418 1.5 1;
	0.37 0.2803030303 1.333333333 1.166666667;
	0.42 0.2818791946 1.5 1.25;
	0.36 0.3 1.5 1.25;
	0.17 0.3269230769 2 2;
	0.09 0.1636363636 1 2];

bac = [ ...
  0.16364  0.15550;
  0.32692  0.32150;
  0.30000  0.37200;
  0.28188  0.30900;
  0.28030  0.36150;
  0.29078  0.44450;
  0.30286  0.36017;
  0.31863  0.31750;
  0.30168  0.43300;
  0.49462  0.51700;
  0.26431  0.37000;
  0.42727  0.50650;
  0.35527  0.43300;
  0.49020  0.47500;
  0.33913  0.59050;
  0.42515  0.25450;
  0.41317  0.27550;
  0.42608  0.48550;
  0.34043  0.49600;
  0.39759  0.65350;
  0.64151  0.64300;
  0.70213  0.73683;
  0.25490  0.53734;
  0.47692  0.43233;
  0.41464  0.36933;
  0.34783  0.49533;
  0.39456  0.55766;
  0.48936  0.44216;
  0.55200  0.44216;
  0.45395  0.44216;
  0.34101  0.38967;
  0.38542  0.38967;
  0.94444  0.96450;
  1.05000  1.05900;
  0.83637  1.01700;
  1.07500  1.04850;
  1.00000  0.97500;
  0.77027  0.90150;
  0.65556  0.88050;
  0.72152  0.90150;
  0.72152  0.90150;
  0.91304  0.83850;
  0.89831  0.97684;
  1.43334  1.54850;
  1.50000  1.62200;
  1.54286  1.43300;
  1.43590  1.41200];

fungi = [ ...
  0.37870  0.32800;
  0.37838  0.26500;
  0.59259  0.16000;
  0.39634  0.31750;
  0.27500  0.42250;
  0.35976  0.38050];

yeast = [ ...
  0.58772  0.29650;
  0.40244  0.30700;
  0.33334  0.28600;
  0.36046  0.34900;
  0.47826  0.53800;
  0.78432  1.08000;
  0.73563  0.82800;
  0.75000  0.68100;
  0.74286  0.95400;
  0.80000  0.82800;
  0.90909  0.97500;
  0.97959  0.99600;
  0.92000  1.01700;
  1.08000  0.93300;
  1.27451  0.85083;
  1.18750  0.93483;
  0.89474  0.99783;
  1.19149  0.94534;
  0.75363  0.98733;
  0.75715  0.97684;
  0.84507  0.90333;
  0.77465  0.95583;
  0.75439  1.08183;
  0.84616  0.95583];

chloro = [ ...
  0.64935  0.47495];       

%% gset term postscript color solid "Times-Roman" 35
%% gset output "HeijRoel81.ps"

plot(bac(:,1), bac(:,2), '.r', fungi(:,1), fungi(:,2), '.g', ...
    yeast(:,1), yeast(:,2), '.b', chloro(:,1), chloro(:,2), '.m', ...
    [0 1.6], [0 1.6], '-k')
legend('bacteria', 'fungi', 'yeast', 'chlorophyte')
xlabel('measured yield, mol O2/C-mol')
ylabel('expected yield, mol O2/C-mol')
