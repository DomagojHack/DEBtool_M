%% AmPgui2mydata
% converts structures data and metaData produced by AmPgui, to those produced by mydata_my_pet

%%
function [data, metaData] = AmPgui2mydata(data, metaData)
% created 2020/06/15 by  Bas Kooijman

%% Syntax
% [data, metaData] = <../AmPgui2mydata.m *AmPpostEdit*> (data, metaData)

%% Description
% converts structures data and metaData produced by AmPgui, to those produced by mydata_my_pet
%
% Input: 
%
% * data: structure with data
% * metaData: structure with metaData 

% Output: 
%
% * data: structure with data
% * metaData: structure with metaData 

%% Remark
% <../mydata2AmPgui.html *mydata2AmPgui*> is inverse to AmPgui2mydata

if isfield(data, 'data_0')
  fld = fieldnames(data.data_0); n_fld = length(fld);
  for i = 1:n_fld
    data.(fld{i}) = data.data_0.(fld{i});
  end
  data = rmfield(data, 'data_0');
end
if isfield(data, 'data_1')
  fld = fieldnames(data.data_1); n_fld = length(fld);
  for i = 1:n_fld
    data.(fld{i}) = data.data_1.(fld{i});
  end
  data = rmfield(data, 'data_1');
end
    
if isfield(metaData, 'acknowledgment') & isempty(metaData.acknowledgment)
  metaData = rmfield(metaData, 'acknowledgment');
end
%
if isfield(metaData, 'facts') & isempty(metaData.facts)
  metaData = rmfield(metaData, 'facts');
end 
%
if isfield(metaData, 'discussion') & isempty(metaData.discussion)
  metaData = rmfield(metaData, 'discussion');
end 
%
if isempty(metaData.biblist)
  fprintf('Warning from AmPpostEdit: empty biblist, no bibtimes specified\n');
else
  fld = fieldnames(metaData.biblist); n_fld = length(fld);
  for i = 1:n_fld
     bibStruc = metaData.biblist.(fld{i}); 
     bibfld = fieldnames(bibStruc); n_bibfld = length(bibfld);
     bib = ['@', bibStruc.type, '{', fld{i}, ', '];
     for j = 2:n_bibfld
       if strcmp(bibfld{j},'url')
         bib = [bib, 'howpublished = {\url{', bibStruc.bibfld{j}, '}}, '];
       else
         bib = [bib, bibfld{j}, ' = {', bibStruc.bibfld{j}, '}, '];
       end
     end
     bib(end,end-1) = []; bib = [bib, '}'];
  end
  metaData.biblist.(fld{i}) = bib;
end