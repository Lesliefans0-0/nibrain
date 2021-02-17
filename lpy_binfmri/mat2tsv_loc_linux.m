root_Dir = pwd;
input_pathway = ['F:/Workspace/BIN/BINdatabackup/LOCdata'];
output_pathway = ['F:/Workspace/BIN/fMRIData/rawdata'];
cd(input_pathway);

d_sub = dir('sub*');
sub_num = length(d_sub);
[sublist{1:sub_num}] = d_sub.name;
suborder = cell(1,9);
for ii = 1:1:sub_num
    suborder{ii} = d_sub(ii).name(4:5);
end

for ii = 1:sub_num

    cd(['./' sublist{ii} '/fLoc/']);
    cnt_pth = pwd;

    d_run = dir([sublist{ii} '_*_fLoc_1back_run*.mat']);
    run_num = length(d_run);
    run_del_ary = [];
    for ii_run = 1:1:run_num
        if length(d_run(ii_run).name) ~= length(sublist{ii})+1+11+1+14+1+4
            run_del_ary = [run_del_ary ii_run];
        end
    end
    
    d_run(run_del_ary) = [];
    run_num = length(d_run);
    [sub_sess_runlist{1:run_num}] = d_run.name;
    
    for kk = 1:run_num % read by run
        load(sub_sess_runlist{kk},'theSubject','theData');
        
        Subj_name = theSubject.name;
        imgType_name = 'fLoc';
        Sess_name = 'fLoc_1back';

        onset = theSubject.timePerTrial';
        duration = [onset(2:end)-onset(1:end-1);0];
        Subj = Subj_name(ones(600,1),:);
        Sess = Sess_name(ones(600,1),:);
        Run = ones(600,1)*kk;
        Trial = linspace(1,600,600)';
        ImgName = theSubject.trials.img';
        ImgType = imgType_name(ones(600,1),:);
        StimOn_s = theSubject.timePerTrial';
        StimeOff_s = onset+duration;
        Response =  zeros(600,1);
        RT = zeros(600,1);
        stim_file = theSubject.trials.img';
        Img_category = cell(600,1);
        
        for ii_trial = 1:1:600
            xx = theSubject.trials.img{ii_trial};
            coor_x = find(xx=='-');
            if isempty(coor_x)
                Img_category{ii_trial} = 'blank';
            else
                Img_category{ii_trial} = xx(1:coor_x-1);
            end
        end

        %Can not set the variable names
        T = table(onset,duration,Subj,...
            Sess,Run,Trial,...
            ImgName,ImgType,StimOn_s,...
            StimeOff_s,Response,RT,...
            stim_file,Img_category);
        
        nonloc_bool = 0;
        for ii_nloc = 1:1:length(sub_nonloc)
            if strcmp(suborder{ii},sub_nonloc(ii_nloc).order)
                nonloc_bool = 1;
                break;
            end
        end
        
        if nonloc_bool==0
            w_pth = [output_pathway '/' sublist{ii} '/ses-LOC/func/'];
            w_name = ['sub-core' suborder{ii} '_ses-LOC_task-category_run-0' sub_sess_runlist{kk}(end-4) '_events.txt'];
        elseif nonloc_bool==1
            formatOut = 'mm-dd-yy';
            date_cnt_run = datestr(theSubject.date,formatOut);
            date_nonloc = datestr(sub_nonloc(ii_nloc).date,formatOut);
            if strcmp(date_nonloc,date_cnt_run)%那些在其它sess的run
                ses_name = ['ses-' sub_nonloc(ii_nloc).ses];
                w_pth = [output_pathway '/' sublist{ii} '/' ses_name '/func/'];
                if strcmp(ses_name,'CAT')
                    w_name = ['sub-core08_ses-CAT_task-category154_run-0' sub_sess_runlist{kk}(end-4) '_events.txt'];
                else
                    w_name = ['sub-core' suborder{ii} '_' ses_name '_task-category_run-0' sub_sess_runlist{kk}(end-4) '_events.txt'];
                end
            elseif ~strcmp(date_nonloc,date_cnt_run)
                w_pth = [output_pathway '/' sublist{ii} '/ses-LOC/func/'];
                w_name = ['sub-core' suborder{ii} '_ses-LOC_task-category_run-0' sub_sess_runlist{kk}(end-4) '_events.txt'];
            end
        end
        
        cnt_pth = pwd;
        cd(w_pth);  
        writetable(T,[w_pth, '/', w_name],'Delimiter','\t');
        command = ['rm ' w_name(1:end-3) 'tsv'];
        disp(command);
        command = ['mv ' w_name ' ' w_name(1:end-3) 'tsv'];
        disp(command);
        cd(cnt_pth);

    end
    cd('../');
    cd('../');
end
