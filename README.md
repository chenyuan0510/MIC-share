# MIC-share
A novel feature selection method based on maximum information coefficient and redundancy sharing

1） MATLAB is the tool of MIC-share;

2) The Chi-MIC should be installed:https://github.com/chenyuan0510/Chi-MIC.git

3) num=randperm(size(data,1));

   data=data(num',:);# scramble the samples

   The first column of data is Y (dependent variable), the rest of the columns (X) independent variable;

   [myindex,myvalue,myindex_score]=MIC_share(data,feat_num,ifclass,threshlod);
   
   # feat_num must be less than the  number of samples of data;
   # while Y is numerical data, ifclass=0; while Y is discrete data, ifcalss=1;
   # threshlod=0 or 0.01

Source: 
袁哲明, 杨晶晶, 陈渊*. [基于最大信息系数与冗余分摊的特征选择方法．](https://doi.org/10.19678/j.issn.1000-3428.0055388)计算机工程. 2019. 
