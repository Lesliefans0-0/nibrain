clear;clc;
root_Dir = pwd;
input_pathway = ['F:/Workspace/BIN/BINdatabackup/data/fmri/train'];
output_pathway = ['F:/Workspace/BIN/ciftify'];
cd(input_pathway);

d_sub = dir('sub-core*');
sub_num = length(d_sub);
sub_del_ary = [];
for ii_sub = 1:1:sub_num
    if length(d_sub(ii_sub).name) ~= 10
        sub_del_ary = [sub_del_ary ii_sub];
    end
end
d_sub(sub_del_ary) = [];
sub_num = length(d_sub);
[sublist{1:sub_num}] = d_sub.name;

for ii = 1:sub_num

    cnt_pth = pwd;
    cd(output_pathway);
    cd(cnt_pth);

    cd(['./' sublist{ii}]);
    
    d_sess = dir('ses-*');
    sess_num = length(d_sess);
    sess_del_ary = [];
    for ii_sess = 1:1:sess_num
        if length(d_sess(ii_sess).name) ~= 14
            sess_del_ary = [sess_del_ary ii_sess];
        end
    end
    d_sess(sess_del_ary) = [];
    sess_num = length(d_sess);
    [sesslist{1:sess_num}] = d_sess.name;
    
    for jj = 1:sess_num
        cnt_pth = pwd;
        
        cd(['./' sesslist{jj}]);
        
        d_run = dir([sublist{ii}(1:10) '_' sesslist{jj} '_run*.mat']);
        run_num = length(d_run);
        run_del_ary = [];
        for ii_run = 1:1:run_num
            if length(d_run(ii_run).name) ~= 10 + 1 + 14 + 1 + 6 + 4
                run_del_ary = [run_del_ary ii_run];
            end
        end
        d_run(run_del_ary) = [];
        run_num = length(d_run);
        [sub_sess_runlist{1:run_num}] = d_run.name;
        
        load_name = [sublist{ii} '_' sesslist{jj} '_design.mat'];
        aa = dir(load_name);
        if isempty(aa)
            disp(['Error: The design matrix of ' load_name(1:12) 'is lost']);
        else 
            load(load_name, 'sessStim');
        end
        
        imgType_name = 'none';
        for kk = 1:run_num % read by run
            load(sub_sess_runlist{kk},'trial');
            
            onset = trial(:,6);
            duration = ones(100,1);
            Subj = ones(100,1)*ii;
            Sess = ones(100,1)*jj;
            Run = ones(100,1)*kk;
            Trial = linspace(1,100,100)';
            ImgName = {sessStim{:,kk}}';
            ImgType = imgType_name(ones(100,1),:);
            StimOn_s = trial(:,6);
            StimeOff_s = trial(:,6)+ones(100,1);
            Response =  trial(:,4);
            RT = trial(:,5);
            stim_file = {sessStim{:,kk}}';

            %Can not set the variable names
            T = table(onset,duration,Subj,...
                Sess,Run,Trial,...
                ImgName,ImgType,StimOn_s,...
                StimeOff_s,Response,RT,...
                stim_file);
            
            w_pth = [output_pathway '/' sublist{ii} '/' sesslist{jj} '/func/'];
            w_name = [sub_sess_runlist{kk}(1:25) '_task-object_' sub_sess_runlist{kk}(27:32) '_events.txt'];
%             writetable(T,[w_pth, '/', w_name],'Delimiter','\t');
            command = ['rm ' w_name(1:end-3) 'tsv'];
            disp(command);
            command = ['mv ' w_name ' ' w_name(1:end-3) 'tsv'];
            disp(command);
            
            
        end
        cd('../')
    end
    cd('../')
end
