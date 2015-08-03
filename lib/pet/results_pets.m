%% results_pets
% Computes model predictions and handles them

%%
function results_pets(par, metaPar, txtPar, data, auxData, metaData, txtData, weights)
% created 2015/01/17 by Goncalo Marques, 2015/03/21 by Bas Kooijman
% modified 2015/03/30 by Goncalo Marques, 2015/04/01 by Bas Kooijman, 2015/04/14, 2015/04/27, 2015/05/05  by Goncalo Marques, 
% modified 2015/07/30 by Starrlight Augustine, 2015/08/01 by Goncalo Marques

%% Syntax
% <../results_pets.m *results_pets*>(par, metaPar, txtPar, data, auxData, metaData, txtData, weights) 

%% Description
% Computes model predictions and handles them (by plotting, saving or publishing)
%
% Input
% 
% * txtPar: information on the parameters
% * par: structure with parameters of species
% * chem: structure with chemical parameters for species
% * txtData: structure with information on the data
% * data: structure with data for species
% * metaData: structure with information on the entry

%% Remarks
% Depending on <estim_options.html *estim_options*> settings:
% writes to results_my_pet.mat an/or results_my_pet.html, 
% plots to screen

  global pets results_output pseudodata_pets 
  
  % get (mean) relative errors
  weightsMRE = weights;  % define a weights structure with weight 1 for every data point and 0 for the pseudodata 
  for k = 1:length(pets)
    currentPet = ['pet',num2str(k)];
    if isfield(weights.(currentPet), 'psd')
      psdSets = fields(weights.(currentPet).psd);
      for j = 1:length(psdSets)
        weightsMRE.(currentPet).psd.(psdSets{j}) = zeros(length(weightsMRE.(currentPet).psd.(psdSets{j})), 1);
      end
    end
  end
  
  [MRE, RE] = mre_st('predict_pets', par, data, auxData, weightsMRE); % WLS-method
  metaPar.MRE = MRE; metaPar.RE = RE;
  data2plot = data;

  for i = 1:length(pets)
    currentPet = ['pet',num2str(i)];
    st = data2plot.(currentPet); 
    [nm, nst] = fieldnmnst_st(st);
    for j = 1:nst  % replace univariate data by plot data 
      fieldsInCells = textscan(nm{j},'%s','Delimiter','.');
      var = getfield(st, fieldsInCells{1}{:});   % scaler, vector or matrix with data in field nm{i}
      k = size(var, 2);  
      if k == 2 
        dataVec = st.(nm{j})(:,1); 
        xAxis = linspace(min(dataVec), max(dataVec), 100)';
        st.(nm{j}) = xAxis;
        if k >= 3
          yAxis = zeros(length(xAxis), 1);
          yAxis(1) = st.(nm{j})(1,2);
          st.(nm{j})(:,2) = yAxis;
          for l = 3:k
            dataVec = [st.(nm{j})(:,1), st.(nm{j})(:,l)];  
            extraDependentVar = spline1(xAxis, dataVec);
            st.(nm{j})(:,l) = extraDependentVar;
          end
        end
      end
    end
    data2plot.(currentPet) = st;
  end
  
  prdData = predict_pets(par, data2plot, auxData);
  
  for i = 1:length(pets)
    currentPet = ['pet', num2str(i)];
    st = data.(currentPet); 
    [nm, nst] = fieldnmnst_st(st);
    counter = 0;
    for j = 1:nst
      fieldsInCells = textscan(nm{j},'%s','Delimiter','.');
      var = getfield(st, fieldsInCells{1}{:});   % scaler, vector or matrix with data in field nm{i}
      k = size(var, 2);
      if k == 2 
        counter = counter + 1; 
        if exist(['results_', pets{i}, '.m'], 'file')
          feval(['results_', pets{i}], par, metaPar, txtPar, data.(currentPet), txtData.(currentPet));
        else
          if isfield(metaData.(currentPet), 'grp') % branch to start working on grouped graphs
            
            plotColours4AllSets = listOfPlotColours4UpTo13Sets;
            maxGroupColourSize = length(plotColours4AllSets) + 1;
            
            grpSet1st = cellfun(@(v) v(1), metaData.(currentPet).grp.sets);
            if sum(strcmp(grpSet1st, nm{j})) 
              sets2plot = metaData.(currentPet).grp.sets{strcmp(grpSet1st, nm{j})};
              if length(sets2plot) < maxGroupColourSize  % choosing the right set of colours depending on the number of ses to plot
                plotColours = plotColours4AllSets{length(sets2plot) - 1}; 
              else
                plotColours = plotColours4AllSets{4};
              end
              figure;
              hold on;
              set(gca,'Fontsize',12); 
              set(gcf,'PaperPositionMode','manual');
              set(gcf,'PaperUnits','points'); 
              set(gcf,'PaperPosition',[0 0 300 180]);%left bottom width height
              for ii = 1: length(sets2plot)
                xData = st.(sets2plot{ii})(:,1); 
                yData = st.(sets2plot{ii})(:,2);
                xPred = data2plot.(currentPet).(sets2plot{ii})(:,1); 
                yPred = prdData.(currentPet).(sets2plot{ii});
                plot(xPred, yPred, xData, yData, '.', 'Color', plotColours{mod(ii, maxGroupColourSize)}, 'Markersize',20, 'linewidth', 4)
                xlabel([txtData.(currentPet).label.(nm{j}){1}, ', ', txtData.(currentPet).units.(nm{j}){1}]);
                ylabel([txtData.(currentPet).label.(nm{j}){2}, ', ', txtData.(currentPet).units.(nm{j}){2}]);
              end
              title(metaData.(currentPet).grp.caption{strcmp(grpSet1st, nm{j})});
            end
          else
            figure;
            set(gca,'Fontsize',12); 
            set(gcf,'PaperPositionMode','manual');
            set(gcf,'PaperUnits','points'); 
            set(gcf,'PaperPosition',[0 0 300 180]);%left bottom width height
            xData = st.(nm{j})(:,1); 
            yData = st.(nm{j})(:,2);
            xPred = data2plot.(currentPet).(nm{j})(:,1); 
            yPred = prdData.(currentPet).(nm{j});
            plot(xPred, yPred, 'b', xData, yData, '.r', 'Markersize',20, 'linewidth', 4)
            xlabel([txtData.(currentPet).label.(nm{j}){1}, ', ', txtData.(currentPet).units.(nm{j}){1}]);
            ylabel([txtData.(currentPet).label.(nm{j}){2}, ', ', txtData.(currentPet).units.(nm{j}){2}]);
          end
        end
        if results_output == 2  % save graphs to .png
          graphnm = ['results_', pets{i}, '_'];
          if counter < 10
            figure(counter)  
            eval(['print -dpng ', graphnm, '0', num2str(counter),'.png']);
          else
            figure(counter)  
            eval(['print -dpng ', graphnm, num2str(counter), '.png']);
          end
        end
      end
    end 
    if results_output < 2
%       v2struct(par); 
      ci = num2str(i);
      fprintf([pets{i}, ' \n']); % print the species name
      fprintf('COMPLETE = %3.1f \n', metaData.(['pet', ci]).COMPLETE)
      fprintf('MRE = %8.3f \n\n', MRE)
      
      fprintf('\n');
      currentPet = sprintf('pet%d',i);
      printprd_st(data.(currentPet), txtData.(currentPet), prdData.(currentPet), RE);
      
      free = par.free;  
      corePar = rmfield_wtxt(par,'free'); coreTxtPar.units = txtPar.units; coreTxtPar.label = txtPar.label;
      [parFields, nbParFields] = fieldnmnst_st(corePar);
      for j = 1:nbParFields
        if  ~isempty(strfind(parFields{j},'n_')) || ~isempty(strfind(parFields{j},'mu_')) || ~isempty(strfind(parFields{j},'d_'))
          corePar          = rmfield_wtxt(corePar, parFields{j});
          coreTxtPar.units = rmfield_wtxt(coreTxtPar.units, parFields{j});
          coreTxtPar.label = rmfield_wtxt(coreTxtPar.label, parFields{j});
          free  = rmfield_wtxt(free, parFields{j});
        end
      end
      corePar.free = free;
      printpar_st(corePar,coreTxtPar);
      fprintf('\n')
    end
    if results_output > 0
      filenm   = ['results_', pets{i}, '.mat'];
      metaData = metaData.pet1;
      save(filenm, 'par', 'txtPar', 'metaPar', 'metaData');
    end
  end
end

function plotColours4AllSets = listOfPlotColours4UpTo13Sets

  plotColours4AllSets = {{[1, 0, 0], [0, 0, 1]}, ...
                         {[1, 0, 0], [1, 0, 1], [0, 0, 1]}, ...
                         {[1, 0, 0], [1, 0, 1], [0, 0, 1], [0, 0, 0]}, ...
                         {[1, .5, .5], [1, 0, 0], [1, 0, 1], [0, 0, 1], [0, 0, 0]}, ...
                         {[1, .5, .5], [1, 0, 0], [1, 0, 1], [0, 0, 1], [0, 0, .5], [0, 0, 0]}, ...
                         {[1, .75, .75], [1, .5, .5], [1, 0, 0], [1, 0, 1], [0, 0, 1], [0, 0, .5], [0, 0, 0]}, ...
                         {[1, .75, .75], [1, .5, .5], [1, 0, 0], [1, 0, 1], [0, 0, 1], [0, 0, .5], [0, 0, .25], [0, 0, 0]}, ...
                         {[1, .75, .75], [1, .5, .5], [1, 0, 0], [1, 0, 1], [0, 0, 1], [0, 0, .75], [0, 0, .5], [0, 0, .25], [0, 0, 0]}, ...
                         {[1, .75, .75], [1, .5, .5], [1, .25, .25], [1, 0, 0], [1, 0, 1], [0, 0, 1], [0, 0, .75], [0, 0, .5], [0, 0, .25], [0, 0, 0]}, ...
                         {[1, .75, .75], [1, .5, .5], [1, .25, .25], [1, 0, 0], [1, 0, .5], [1, 0, 1], [0, 0, 1], [0, 0, .75], [0, 0, .5], [0, 0, .25], [0, 0, 0]}, ...
                         {[1, .75, .75], [1, .5, .5], [1, .25, .25], [1, 0, 0], [1, 0, .5], [1, 0, 1], [.5, 0, 1],  [0, 0, 1], [0, 0, .75], [0, 0, .5], [0, 0, .25], [0, 0, 0]}, ...
                         {[1, .75, .75], [1, .5, .5], [1, .25, .25], [1, 0, 0], [1, 0, .5], [1, 0, .75], [1, 0, 1], [.5, 0, 1],  [0, 0, 1], [0, 0, .75], [0, 0, .5], [0, 0, .25], [0, 0, 0]}}

end