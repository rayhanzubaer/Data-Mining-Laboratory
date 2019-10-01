function varargout = final(varargin)
% FINAL MATLAB code for final.fig
%      FINAL, by itself, creates a new FINAL or raises the existing
%      singleton*.
%
%      H = FINAL returns the handle to a new FINAL or the handle to
%      the existing singleton*.
%
%      FINAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINAL.M with the given input arguments.
%
%      FINAL('Property','Value',...) creates a new FINAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before final_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to final_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help final

% Last Modified by GUIDE v2.5 27-Jul-2019 21:40:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @final_OpeningFcn, ...
                   'gui_OutputFcn',  @final_OutputFcn, ...
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


% --- Executes just before final is made visible.
function final_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to final (see VARARGIN)

% Choose default command line output for final
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes final wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = final_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadTrainingImagesPushButton.
function loadTrainingImagesPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadTrainingImagesPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global RootDirectory;
    global ImageWarehouse;
    
    RootDirectory = uigetdir('*', 'Select Training Folder');
    ImageWarehouse = dir(strcat(RootDirectory, '\*.png'));
    
    set(handles.loadTrainingImagesPushButton, 'string', 'Traing Folder Selected', 'enable', 'off');
    

% --- Executes on button press in extractFeatureAndStoreInDatabasePushButton.
function extractFeatureAndStoreInDatabasePushButton_Callback(hObject, eventdata, handles)
% hObject    handle to extractFeatureAndStoreInDatabasePushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    disp('==========Feature Extraction Started==========');

    global RootDirectory;
    global ImageWarehouse;
    global FeatureMatrix;
    
    for i = 1 : length(ImageWarehouse)
        Img = imread(fullfile(RootDirectory, ImageWarehouse(i).name));
        Img = rgb2gray(Img);
        Img = im2double(Img);
        Img = Img(:);
        Min = min(Img);
        Max = max(Img);
        Median = median(Img);
        tmp = quantile(Img, [0.25, 0.75]);
        FirstQuartile = tmp(1);
        ThirdQuartile = tmp(2);
        Variance = var(Img);
        
        FeatureMatrix(i, 1) = i;
        FeatureMatrix(i, 2) = Min;
        FeatureMatrix(i, 3) = Max;
        FeatureMatrix(i, 4) = Median;
        FeatureMatrix(i, 5) = FirstQuartile;
        FeatureMatrix(i, 6) = ThirdQuartile;
        FeatureMatrix(i, 7) = Variance;
    end
    disp('==========Feature Extraction Ended==========');
    disp('==========Writing Database Started==========');
    xlswrite('db.xlsx', FeatureMatrix);
    disp('==========Writing Database Ended==========');
    set(handles.extractFeatureAndStoreInDatabasePushButton, 'string', 'Feature Extracted', 'enable', 'off');


% --- Executes on button press in loadFeatureDataPushButton.
function loadFeatureDataPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadFeatureDataPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global FeatureData

    [filename, pathname] = uigetfile({'*.xlsx'}, 'Select Database File');
    FeatureData = xlsread(fullfile(pathname, filename));
    set(handles.loadFeatureDataPushButton, 'string', 'Feature Data Loaded', 'enable', 'off');


% --- Executes on button press in loadQueryImagePushButton.
function loadQueryImagePushButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadQueryImagePushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global QueryImageFeature;
    
    [filename, pathname] = uigetfile({'*.png'}, 'Select Test Image');
    queryImage = imread(fullfile(pathname, filename));
    
    axes(handles.queryImageAxes);
    imshow(queryImage);
    
    queryImage = rgb2gray(queryImage);
    queryImage = im2double(queryImage(:));
    
    queryImageMin = min(queryImage);
    queryImageMax = max(queryImage);
    queryImageMedian = median(queryImage);
    tmp = quantile(queryImage, [0.25, 0.75]);
    queryImageFirstQuartile = tmp(1);
    queryImageThirdQuartile = tmp(2);
    queryImageVariance = var(queryImage);
    
    QueryImageFeature(1, 1) = 0;
    QueryImageFeature(1, 2) = queryImageMin;
    QueryImageFeature(1, 3) = queryImageMax;
    QueryImageFeature(1, 4) = queryImageMedian;
    QueryImageFeature(1, 5) = queryImageFirstQuartile;
    QueryImageFeature(1, 6) = queryImageThirdQuartile;
    QueryImageFeature(1, 7) = queryImageVariance;
    
    
    set(handles.loadQueryImagePushButton, 'string', 'Query Image Loaded', 'enable', 'off');
    

% --- Executes on button press in displayPushButton.
function displayPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to displayPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global RootDirectory;
    global ImageWarehouse;
    global FeatureData;
    global QueryImageFeature;
    
    
    CityBlockDistanceMatrix = zeros(length(ImageWarehouse), 2);
    
    for i = 1 : length(ImageWarehouse)
%        CityBlockDistance = abs(QueryImageFeature(1, 2) - FeatureData(i, 2)) + ...
%                            abs(QueryImageFeature(1, 3) - FeatureData(i, 2)) + ...
%                            abs(QueryImageFeature(1, 4) - FeatureData(i, 4)) + ...
%                            abs(QueryImageFeature(1, 5) - FeatureData(i, 5)) + ...
%                            abs(QueryImageFeature(1, 6) - FeatureData(i, 6)) + ...
%                            abs(QueryImageFeature(1, 7) - FeatureData(i, 7));
    
    supermumDistance = max([
        abs(QueryImageFeature(1, 2) - FeatureData(i, 2))
        abs(QueryImageFeature(1, 3) - FeatureData(i, 3))
        abs(QueryImageFeature(1, 4) - FeatureData(i, 4))
        abs(QueryImageFeature(1, 5) - FeatureData(i, 5))
        abs(QueryImageFeature(1, 6) - FeatureData(i, 6))
        abs(QueryImageFeature(1, 7) - FeatureData(i, 7))
    ]);
                        
        CityBlockDistanceMatrix(i, 1) = i;
%        CityBlockDistanceMatrix(i, 2) = CityBlockDistance;
        CityBlockDistanceMatrix(i, 2) = supermumDistance;
    end
    
    [E, index] = sortrows(CityBlockDistanceMatrix, 2);
    
    for i = 1 : 10
        Img = imread(fullfile(RootDirectory, ImageWarehouse(index(i, 1)).name));
        axes( handles.( strcat( 'axes', num2str( i + 1 ) ) ) );
        imshow(Img)
    end
    
    set(handles.displayPushButton, 'string', 'Displaying Similar Image', 'enable', 'off');

    