%%
load 'E:\QZdata\rest_rawdata\REST_prepro\Raw_prepro_data\Multilayer_Network_Signals\index.mat'
load 'E:\QZdata\rest_rawdata\REST_prepro\Raw_prepro_data\Multilayer_Network_Signals\network_index.mat'

network_index(find(network_index==0))=[];%without uncertain
% N = find(network_index==0);
N1 = find(network_index==1);%13-46;255
N2 = find(network_index==2)%47-60
N3 = find(network_index==3)%61-73
N4 = find(network_index==4)%74-131:137,139
N5 = find(network_index==5)%133-136;221;
N6 = find(network_index==6)%138;235-242
N7 = find(network_index==7)%142-173
N8 = find(network_index==8)%174-202
N9 = find(network_index==9)%203-220
N10 = find(network_index==10)%222-234
N11 = find(network_index==11)%243-246
N12 = find(network_index==12)%251-263
Net_all(1:12,1) = {N1,N2,N3,N4,N5,N6,N7,N8,N9,N10,N11,N12};
clear ('N1','N2','N3','N4','N5','N6','N7','N8','N9','N10','N11','N12')

Pro_MA = threshold_MA(:,:,find(index==1));
New_MA = threshold_MA(:,:,find(index==3));

figure,set(gcf,'color','white')
subplot(1,2,1)
imagesc(mean(Pro_MA,3)/151),colorbar,colormap(jet),title('Pro'),hold on
subplot(1,2,2)
imagesc(mean(New_MA,3)/151),colorbar,colormap(jet),title('New')

% 替代方法
t=tiledlayout(1,3),set(gcf,'color','white')
nexttile,imagesc(mean(Pro_MA,3)/151),title('Pro')
set(gca,'FontName','Times New Roman','FontWeight','bold','Fontsize',10)

ax=nexttile(2),imagesc(mean(New_MA,3)/151)
colorbar('Location', 'westoutside'),colormap(jet),title('Control')
set(ax,'ytick',[])
set(gca,'FontName','Times New Roman','FontWeight','bold','Fontsize',10)
t.TileSpacing = 'compact'

nexttile(3)
bar([IN;RE;FLE;PRO],1),box off,legend({'Pro','Control'})
xticklabels({'Inregration','Recruitment','Switching','Promiscuity'})
set(gca,'FontName','Times New Roman','FontWeight','bold','Fontsize',10)
set(gca,'linewidth',1.5)
xtickangle(45),yticks([0 0.2 0.4 0.6])
t.TileSpacing = 'compact'
t.Padding = 'compact'
%% global level
load('Parameters100.mat')
% Flex 

[h1 p1 ci t1] = ttest2(mean(Inte(:,find(index==1)),1),mean(Inte(:,find(index==3)),1))
[h2 p2 ci t2] = ttest2(mean(Recru(:,find(index==1)),1),mean(Inte(:,find(index==3)),1))%pro lillietest==1
[h3 p3 ci t3] = ttest2(mean(Flex(:,find(index==1)),1),mean(Inte(:,find(index==3)),1))
[h2 p2 ci t2] = ttest2(mean(Promis(:,find(index==1)),1),mean(Inte(:,find(index==3)),1))

IN=[mean(mean(Inte(:,find(index==1)))),mean(mean(Inte(:,find(index==3))))];
RE=[mean(mean(Recru(:,find(index==1)))),mean(mean(Recru(:,find(index==3))))];
FLE=[mean(mean(Flex(:,find(index==1)))),mean(mean(Flex(:,find(index==3))))];
PRO=[mean(mean(Promis(:,find(index==1)))),mean(mean(Promis(:,find(index==3))))];

%% network-level
Net{2,1} = 'Inte';Net{3,1} = 'Recru';Net{4,1} = 'Flex';Net{5,1} = 'Promis';
Net(1,[2:3:35]) = {'Sensory','Daizhuang','Tingjue','DMN','MEMORY','fuce-attention','visual','e-ding','saliance','subcortex','cerebellum','dorsal-attention'};

for num_net = 2:3:35;
    
        Net{2,num_net} = mean(Inte(Net_all{(num_net+1)/3},find(index==1)),1);%pro
        Net{2,num_net+1} = mean(Inte(Net_all{(num_net+1)/3},find(index==2)),1);%amature
        Net{2,num_net+2} = mean(Inte(Net_all{(num_net+1)/3},find(index==3)),1);%control
        
        Net{3,num_net} = mean(Recru(Net_all{(num_net+1)/3},find(index==1)),1);%pro
        Net{3,num_net+1} = mean(Recru(Net_all{(num_net+1)/3},find(index==2)),1);%amature
        Net{3,num_net+2} = mean(Recru(Net_all{(num_net+1)/3},find(index==3)),1);%control
        
        Net{4,num_net} = mean(Flex(Net_all{(num_net+1)/3},find(index==1)),1);%pro
        Net{4,num_net+1} = mean(Flex(Net_all{(num_net+1)/3},find(index==2)),1);%amature
        Net{4,num_net+2} = mean(Flex(Net_all{(num_net+1)/3},find(index==3)),1);%control
        
        Net{5,num_net} = mean(Promis(Net_all{(num_net+1)/3},find(index==1)),1);%pro
        Net{5,num_net+1} = mean(Promis(Net_all{(num_net+1)/3},find(index==2)),1);%amature
        Net{5,num_net+2} = mean(Promis(Net_all{(num_net+1)/3},find(index==3)),1);%control 
end


pro_inte=cell2mat(Net(2,[2:3:37])');
new_inte=cell2mat(Net(2,[4:3:37])');
[H PP CI] = ttest2(pro_inte',new_inte');
find(PP<0.05/12)
FDR_P = fdr_code(PP);
find(FDR_P<0.05)
clear FDR PP H CI

pro_Recu=cell2mat(Net(3,[2:3:37])');
new_Recu=cell2mat(Net(3,[4:3:37])');
[H PP CI] = ttest2(pro_Recu',new_Recu');
find(PP<0.05/12)
FDR_P = fdr_code(PP);
find(FDR_P<0.05)
clear FDR PP H CI

pro_inte=cell2mat(Net(4,[2:3:37])');
new_inte=cell2mat(Net(4,[4:3:37])');
[H PP CI] = ttest2(pro_inte',new_inte');
find(PP<0.05/12)
FDR_P = fdr_code(PP);
find(FDR_P<0.05)
clear FDR PP H CI

pro_inte=cell2mat(Net(5,[2:3:37])');
new_inte=cell2mat(Net(5,[4:3:37])');
[H PP CI] = ttest2(pro_inte',new_inte');
find(PP<0.05/12)
FDR_P = fdr_code(PP);
find(FDR_P<0.05)
clear FDR PP H CI




%% node-level
N=3;P=1;
Pro = Inte(:,find(index==P));
Control = Inte(:,find(index==N));
[H PP CI State] = ttest2(Pro',Control');
FDR_P = fdr_code(PP);
find(FDR_P<0.05)

Pro = Recru(:,find(index==P));
Control = Recru(:,find(index==N));
[H PP CI State] = ttest2(Pro',Control');
FDR_P = fdr_code(PP);
find(FDR_P<0.05)

Pro = Flex(:,find(index==P));
Control = Flex(:,find(index==N));
[H PP CI State] = ttest2(Pro',Control');
FDR_P = fdr_code(PP);
find(FDR_P<0.05)

Pro = Promis(:,find(index==P));
Control = Promis(:,find(index==N));
[H PP CI State] = ttest2(Pro',Control');
FDR_P = fdr_code(PP);
find(FDR_P<0.05)

% 画图
PF=mean(Pro,2);
F=PF(find(PP<0.005))

NF=mean(Control,2);
F2=NF(find(PP<0.005))

t=tiledlayout(1,3),set(gcf,'color','white')

nexttile,bar([F,F2]),box off,xticklabels({'Pro','New'})
t=title('Promiscuity'),set(t,'FontWeight','bold')
set(gca,'linewidth',1.5,'Fontname','Times New Roman','FontWeight',...
    'bold','FontSize',12),legend({'Postcentral-L','Occipitial-Sup-R'})
t.TileSpacing = 'compact'


%%
for i=1:12
    T(i,1)=length(Net_all{i,1});
    
end
%% module intergration with the another one

threshold_MA=threshold_MA/151;
for subj = 1:55;
    A = threshold_MA(:,:,subj);
    C = mat2cell(A,T,T);
    
    for i=1:12
        for j=1:12
            if i==j
                hang(i,j,subj)=0;
            else
                AA=C([i,j],[i,j]);
                AAA=cell2mat(AA);
                label=[ones(size(AA{1},1),1);ones(size(AA{2},1),1)*2];
                hang(i,j,subj)=nanmean(integration(AAA,label));
            end
        end
        
    end
    
end

Nlabel = {'1-Sensory','2-Cingulo-opercular','3-Auditory','4-Default-mode','5-Memory-retrieval','6-Ventral-attention',...
    '7-Visual','8-Fronto-parietal','9-Saliance','10-Subcortial','11-Cerebellar','12-Dorsal-atention'};

figure,set(gcf,'color','white')
% nanmean(hang(:,:,find(index==1)),3)
subplot(2,1,1),imagesc(nanmean(hang(:,:,find(index==1)),3))
colorbar,colormap(jet),caxis([0 0.5]),title('Pro')
subplot(2,1,2),imagesc(nanmean(hang(:,:,find(index==3)),3))
colorbar,colormap(jet),caxis([0 0.5]),title('Control')
% 替代画图
t=tiledlayout(1,3),set(gcf,'color','white')
nexttile,imagesc(nanmean(hang(:,:,find(index==1)),3))
title('Pro','position',[6 14],'Fontname','New Times Roman','FontWeight','bold')
xticks([1:12]),yticks([1:12])
% C=colorbar('northoutside')
colormap(jet),caxis([0 0.3])
set(gca,'Fontname','New Times Roman','FontWeight','bold')


nexttile,imagesc(nanmean(hang(:,:,find(index==3)),3))
% C=colorbar('northoutside')
colormap(jet),caxis([0 0.3])
title('Control','position',[6 14],'Fontname','New Times Roman','FontWeight','bold')
% yticklabels(Nlabel),xticklabels(Nlabel),xtickangle(45)
xticks([1:12]),yticks([1:12])
t.TileSpacing = 'compact'
text(13,6,Nlabel,'Fontname','New Times Roman','FontWeight','bold')

C=colorbar('northoutside');
set(C,'pos',[0.25 0.935 0.2350 0.017]),C.Ticks = [0 0.1 0.2 0.3]
set(gca,'Fontname','New Times Roman','FontWeight','bold')




%%
pro = find(index==1);
new = find(index==3);

for i = 1:12;
    for j = 1:12;
        if i==j
            [h p(i,j) ci stats] = ttest2(squeeze(hang(i,j,pro)),squeeze(hang(i,j,new)));
            p(i,j)=1;
        else
            [h p(i,j) ci stats] = ttest2(squeeze(hang(i,j,pro)),squeeze(hang(i,j,new)));
            
        end
    end
end
fdr_p=fdr_code(p(triu(ones(12,12)==1,1)));
[row col]=find(fdr_p<0.01)

figure,set(gcf,'color','white')
subplot(1,3,1)
h=boxplot([squeeze(hang(10,11,pro))',squeeze(hang(10,11,new))'],[ones(1,20),ones(1,15)*2],...
    'colors','k','widths',0.4)
set(h,'linewidth',1.5)
title('Subcortex-Cerenellum','Fontname','Times New Roman','Fontsize',10,'FontWeight','bold')
box off,xticklabels({'Pro','Control'})
set(gcf,'color','white')
set(gca,'linewidth',1.5,'Fontname','Times New Roman','Fontsize',10,'FontWeight','bold')

subplot(1,3,2)
h=boxplot([squeeze(hang(10,1,pro))',squeeze(hang(10,1,new))'],[ones(1,20),ones(1,15)*2],...
    'colors','k','widths',0.4)
set(h,'linewidth',1.5)
title('Subcort-Sensory','Fontname','Times New Roman','Fontsize',10,'FontWeight','bold')
box off,xticklabels({'Pro','Control'})
set(gcf,'color','white')
set(gca,'linewidth',1.5,'Fontname','Times New Roman','Fontsize',10,'FontWeight','bold')

subplot(1,3,3)
h=boxplot([squeeze(hang(7,6,pro))',squeeze(hang(7,6,new))'],[ones(1,20),ones(1,15)*2],...
    'colors','k','widths',0.4)
set(h,'linewidth',1.5)
title('Visual-VentralAttention','Fontname','Times New Roman','Fontsize',10,'FontWeight','bold')
box off,xticklabels({'Pro','Control'})
set(gcf,'color','white')
set(gca,'linewidth',1.5,'Fontname','Times New Roman','Fontsize',10,'FontWeight','bold')








