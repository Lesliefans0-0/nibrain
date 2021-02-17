clear;clc;
[~,~,raw] = xlsread('BIN_runinfo.xlsx');
sub_nonloc = struct();
ii_sub = 1;
for ii = 1:1:746
    if ~strcmp(raw{ii,3}, 'LOC') && strcmp(raw{ii,5},'category')
%     if length(raw{ii,3}) >= 4 && strcmp(raw{ii,3}(1:4),'CoCo') && strcmp(raw{ii,5},'category')
        sub_nonloc(ii_sub).date = raw{ii,1};
        sub_nonloc(ii_sub).order = raw{ii,2}(5:6);
        sub_nonloc(ii_sub).ses = raw{ii,3};
        ii_sub = ii_sub + 1;
    end
end







