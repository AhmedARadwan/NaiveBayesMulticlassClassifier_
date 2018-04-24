function [Mdl] = naiveBaysSegmentation(im,im_truth)

im_groundTruth=im_truth;
X=im;
l=length(im_truth);


%Six categories/classes have been defined:
%Impervious surfaces (RGB: 255, 255, 255)  ind 3
%Building (RGB: 0, 0, 255) ind 2
%Low vegetation (RGB: 0, 255, 255) ind 4
%Tree (RGB: 0, 255, 0)ind 0
%Car (RGB: 255, 255, 0) ind 5
%Clutter/background (RGB: 255, 0, 0) ind 1
%water (RGB: 0 ,0 ,0 ) ind 6
class_names={'Tree', 'Clutter/background' ,'Building','Impervious surfaces','Low vegetation','Car','water'};
for i=1:l
    Y{i} = class_names{im_groundTruth(i)+1};
end


% train Naive bayisean classifier
Mdl = fitcnb(X,Y');%,'ClassNames',class_names); %'ClassNames',class_names,

%Follow this tutorial:
%https://www.mathworks.com/help/stats/naive-bayes-classification.html
%https://www.mathworks.com/help/stats/classificationnaivebayes-class.html 
%https://www.mathworks.com/help/stats/fitcnb.html