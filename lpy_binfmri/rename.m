clear;clc;
root_Dir = pwd;
input_pathway = ['F:/Workspace/BIN/BINdatabackup/data/fmri/train'];
cd(input_pathway);

d_sub = dir('sub*');
sub_num = length(d_sub);
sub_del_ary = [];
for ii_sub = 1:1:sub_num
    if length(d_sub(ii_sub).name) ~= 5
        sub_del_ary = [sub_del_ary ii_sub];
    end
end
d_sub(sub_del_ary) = [];
sub_num = length(d_sub);
[sublist{1:sub_num}] = d_sub.name;

for ii = 1:1:sub_num
    
    cd(['./' sublist{ii}]);
    d_sess = dir('sess*');
    sess_num = length(d_sess);
    sess_del_ary = [];
    for ii_sess = 1:1:sess_num
        if length(d_sess(ii_sess).name) ~= 6
            sess_del_ary = [sess_del_ary ii_sess];
        end
    end
    d_sess(sess_del_ary) = [];
    sess_num = length(d_sess);
    [sesslist{1:sess_num}] = d_sess.name;    
    
    
    for jj = 1:1:sess_num
        
        %for runs
        cd(['./' sesslist{jj}]);

        d_run = dir([sublist{ii}(1:5) '_' sesslist{jj} '_run*.mat']);
        run_num = length(d_run);
        run_del_ary = [];
        for ii_run = 1:1:run_num
            if length(d_run(ii_run).name) ~= 5+1+6+1+5+4
                run_del_ary = [run_del_ary ii_run];
            end
        end
        d_run(run_del_ary) = [];
        run_num = length(d_run);
        [runlist{1:run_num}] = d_run.name;
        
        
        for kk = 1:1:run_num
            command = ['rename ' runlist{kk} ' ' runlist{kk}(1:3) '-core' runlist{kk}(4:9) '-ImageNet' runlist{kk}(11:16) '-' runlist{kk}(17:end)];
            system(command);
        end
        
        %for design matrix
        d_design = dir([sublist{ii} '_' sesslist{jj} '_design.mat']);
        command = ['rename ' d_design.name ' ' d_design.name(1:3) '-core' d_design.name(4:9) '-' d_design.name(11:end)];
        system(command);
        
        cd('../')
        command = ['rename ' sesslist{jj} ' ' sesslist{jj}(1:3) '-ImageNet' sesslist{jj}(5:end)];
        system(command);
    end
    cd('../')
    command = ['rename ' sublist{ii} ' ' sublist{ii}(1:3) '-core' sublist{ii}(4:end)];
    system(command);
end



