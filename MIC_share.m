function [myindex,myvalue,myindex_score]=MIC_share(data,feat_num,ifclass,threshlod)
% for regression or classfication
% caculate shared score by oic association measure
% myvalue is the shared score; the first row of myindex_score are numerator; 
% the second row of myindex_score are denominator;
% myvalue=sum(myindex_score(1,:)./myindex_score(2,:))
if nargin <4
	threshlod=0;
end
y=data(:,1);
sample_num=length(y);
x=data(:,2:end);
xnum=size(x,2);
tic;
dist=nan(1,xnum);
if ifclass
    for i=1:xnum
        [dist(i),~]=MIC_OIC_chi_1_1_class([y,x(:,i)],0.55,5);%  major
    end
else
    for i=1:xnum
        [dist(i),~]=MIC_OIC_chi_1_1([y,x(:,i)],sample_num^0.55,5,sample_num);
    end
end
disp('have finished all distance');
toc;
myindex=nan(1,feat_num);
myindex_score=nan(2,feat_num);
[myindex_score(1,1),myindex(1)]=max(dist);
myvalue=nan(1,feat_num);
myvalue(1)=myindex_score(1,1);
myindex_score(2,:)=1;
featindex=1:xnum;
featindex(myindex(1))=[];
dist(myindex(1))=[];
Ddist=nan(feat_num-1,xnum-1);
nocomplete=0;
for i=1:feat_num-1
    tic;
    for j=1:length(featindex)
        [Ddist(i,j),~,~,~,~,~]=MIC_OIC_chi_1_1([x(:,featindex(j)),x(:,myindex(i))],sample_num^0.55,5,sample_num);% two x
        %         Ddist(i,j) = distcorr(x(:,featindex(j)),x(:,myindex(i)));
    end
    [myvalue(i+1),index]=max(sum(repmat(myindex_score(1,1:i)',1,length(featindex))./(repmat...
        (myindex_score(2,1:i)',1,length(featindex))+Ddist(1:i,:)),1)+dist./(1+sum(Ddist(1:i,:),1)));
    fprintf('have introduce %d  score== %d  ',i+1,myvalue(i+1));
    toc;
	if threshlod ~= 0
		if ((myvalue(i+1)-myvalue(i))/myvalue(i))<=threshlod
			nocomplete=1;
			break;
		else
			myindex_score(1,i+1)=dist(index);
			myindex_score(2,1:i)=myindex_score(2,1:i)+Ddist(1:i,index)';
			myindex_score(2,i+1)=1+sum(Ddist(1:i,index));
			%     [~,index]=max(dist-mean(Ddist(1:i,:),1));
			myindex(i+1)=featindex(index);
			featindex(index)=[];
			dist(index)=[];
			Ddist(:,index)=[];
		end
	else
% 		if myvalue(i+1)<myvalue(i)
% 			nocomplete=1;
% 			break;
% 		else
			myindex_score(1,i+1)=dist(index);
			myindex_score(2,1:i)=myindex_score(2,1:i)+Ddist(1:i,index)';
			myindex_score(2,i+1)=1+sum(Ddist(1:i,index));
			%     [~,index]=max(dist-mean(Ddist(1:i,:),1));
			myindex(i+1)=featindex(index);
			featindex(index)=[];
			dist(index)=[];
			Ddist(:,index)=[];
% 		end
	end
end
if nocomplete
    num=sum(~isnan(myindex));
else
    num=feat_num;
end
myindex_score=myindex_score(:,1:num);
myindex=myindex(1:num);
myvalue=myvalue(1:num);

