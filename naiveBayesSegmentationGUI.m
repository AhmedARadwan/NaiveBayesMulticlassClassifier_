function varargout = naiveBayesSegmentationGUI(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @naiveBayesSegmentationGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @naiveBayesSegmentationGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before naiveBayesSegmentationGUI is made visible.
function naiveBayesSegmentationGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to naiveBayesSegmentationGUI (see VARARGIN)
% Choose default command line output for naiveBayesSegmentationGUI
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = naiveBayesSegmentationGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close();

% --- Executes on button press in pushbuttonTraining.
function pushbuttonTraining_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonTraining (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.model = naiveBaysSegmentation_(handles.totalinstances,handles.totalClassLabels);
cla(handles.axes1,'reset');
set(handles.text5,'String','Done Training');
guidata(hObject, handles);

% --- Executes on button press in pushbuttonValidationImage.
function pushbuttonValidationImage_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonValidationImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[name1 path_im1] = uigetfile('*.*');  %brows the image you need from PC
handles.vaildationImagePath = fullfile(name1); %define path to traning image
guidata(hObject, handles);

% --- Executes on button press in pushbuttonValidation.
function pushbuttonValidation_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonValidation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_test = imread(fullfile('train', handles.vaildationImagePath));
[rows ,cols ,depth] = size(image_test);
X = double(reshape(image_test , rows*cols , depth));
output_image = predict(handles.model,X);
image_out = zeros(rows,cols,depth);
output_image_ = reshape(output_image , rows, cols);
class_names={'Tree', 'Clutter/background' ,'Building','Impervious surfaces','Low vegetation','Car','water'};
for i = 1:1:rows
    for q = 1:1:cols
        %Impervious surfaces (RGB: 255, 255, 255)
        if isequal(output_image_{i,q}, class_names{4})
            image_out(i,q,1) = 0;
            image_out(i,q,2) = 255;
            image_out(i,q,3) = 255;
        end
        %Building (RGB: 0, 0, 255)
        if isequal(output_image_{i,q}, class_names{1})
            image_out(i,q,1) = 0;
            image_out(i,q,2) = 0;
            image_out(i,q,3) = 255;
        end
        %Low vegetation (RGB: 0, 255, 255)
        if isequal(output_image_{i,q}, class_names{5})
            image_out(i,q,1) = 255;
            image_out(i,q,2) = 255;
            image_out(i,q,3) = 255;
        end
        %Tree (RGB: 0, 255, 0)
        if isequal(output_image_{i,q}, class_names{3})
            image_out(i,q,1) = 0;
            image_out(i,q,2) = 255;
            image_out(i,q,3) = 0;
        end
        %Car (RGB: 255, 255, 0)
        if isequal(output_image_{i,q}, class_names{6})
            image_out(i,q,1) = 255;
            image_out(i,q,2) = 255;
            image_out(i,q,3) = 0;
        end
        %Clutter/background (RGB: 255, 0, 0)
        if isequal(output_image_{i,q}, class_names{2})
            image_out(i,q,1) = 255;
            image_out(i,q,2) = 0;
            image_out(i,q,3) = 0;
        end
        %water (RGB: 0, 0, 0)
        if isequal(output_image_{i,q}, class_names{7})
            image_out(i,q,1) = 0;
            image_out(i,q,2) = 0;
            image_out(i,q,3) = 0;
        end
    end
end
imshow(image_out);
handles.image_out = image_out;
guidata(hObject, handles);

% --- Executes on button press in pushbuttonClear.
function pushbuttonClear_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes1,'reset');

% --- Executes on button press in pushbuttonExit.
function pushbuttonExit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonExit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all;clc;
close();

% --- Executes on button press in pushbuttonImport.
function pushbuttonImport_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonImport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set(handles.text8,'String','Loading...');
% guidata(hObject, handles);
imagefiles=dir('train/*.tif');
segimagefiles=dir('train_seg/*.tif');
numImages=length(imagefiles);
instances=0;
for i=1: numImages
    arr=strcat('train/',imagefiles(i).name);
    arr2=strcat('train_seg/',segimagefiles(i).name);
    im=imread(arr);
    im_truth=imread(arr2);
    im_groundTruth = rgb2ind(im_truth,7);
    [rows ,cols ,depth] = size(im);
    im_groundTruth = reshape(im_groundTruth ,rows*cols ,1) ;
    X = double(reshape(im , rows*cols , depth));
    instances=instances+rows*cols;
end
handles.totalinstances=zeros(instances,depth);
handles.totalClassLabels=zeros(instances,1);
idx=1;
for i=1: numImages
    arr=strcat('train/',imagefiles(i).name);
    arr2=strcat('train_seg/',segimagefiles(i).name);
    im=imread(arr);
    im_truth=imread(arr2);
    im_groundTruth = rgb2ind(im_truth,7);
    [rows ,cols ,depth] = size(im);
    im_groundTruth = reshape(im_groundTruth ,rows*cols ,1);
    X = double(reshape(im , rows*cols , depth));
    handles.totalinstances(idx:idx+rows*cols-1,:)=X;
    handles.totalClassLabels(idx:idx+rows*cols-1,1)=im_groundTruth;
    idx=idx+rows*cols;
end
set(handles.text8,'String','Done Importing!');
guidata(hObject, handles);

% --- Executes on button press in pushbuttonsave.
function pushbuttonsave_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonsave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get the name of the file that the user wants to save.
% Note, if you're saving an image you can use imsave() instead of uiputfile().
startingFolder = userpath;
defaultFileName = fullfile(startingFolder, '*.tif');
[baseFileName, folder] = uiputfile(defaultFileName, 'Specify a file');
if baseFileName == 0
	% User clicked the Cancel button.
	return;
end
fullFileName = fullfile(folder, baseFileName);
imwrite(handles.image_out, fullFileName);

% --- Executes on button press in pushbuttonBrowseAccuracy.
function pushbuttonBrowseAccuracy_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonBrowseAccuracy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[name1 path_im1] = uigetfile('*.*');  %brows the image you need from PC
handles.accuracyImagePath = fullfile(name1); %define path to traning image
guidata(hObject, handles);

% --- Executes on button press in pushbuttonCalcAccuracy.
function pushbuttonCalcAccuracy_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCalcAccuracy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_test_err = imread(fullfile('train_seg', handles.accuracyImagePath));
image_test_err=double(image_test_err);
[rows ,cols ,depth] = size(image_test_err);
mean_error = 0;
for q=1:1:rows
    for w=1:1:cols
        for e=1:1:depth
            mean_error = mean_error +(handles.image_out(q,w,e)~=image_test_err(q,w,e));
        end
    end
end
% mean_error
mean_error = mean_error/(rows*cols*depth);
accuracy = (1-mean_error)*100;
set(handles.text10,'String',['Accuracy = ' num2str(accuracy) ' %']);
guidata(hObject, handles);
