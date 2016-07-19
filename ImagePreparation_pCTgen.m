%% ----------------------- ImagePreparation_pCTgen ------------------------
%
% Goal: Preparation of CT-based pCT:
% 0) CTreg = registered CT 
% 1) CTwater = water bulk-assigned pCT within the body outline of the CT
% 2) CTrange = bulk-assigne CT-based pCT that mimics the number of classes
% of the MR-based pCT generation method proposed by Schadewaldt N et al,
% Med. Phys. 41(6), 188
% 3) CTbonefil = removal of the region inside the bone and assignement of 
% the pseudo-HU in the marrow  
% A better description of the database is provided in Maspero M et al, 2016,
% Phys. Med. Biol. 
% The visualisation has been performed using a code found via matlab
% Exchange. Check view3dgui for more info.
% Developed by Matteo Maspero, UMC Utrecht, 2016
% for info contact: m.maspero@umcutrecht.nl/matteo.maspero.it@gmail.com


% N.B. 
% Please refer to Maspero M et al, 2016, Phys. Med. Biol. when using this
% code.

% Description used function:
% Data_opening -> Open dicom data
% view3Dgui    -> Visualization 3D with window levelling allowed
% Body_CT      -> Threshold-based Body Contour automatic delineation
% Discret_CT   -> Bulk-assignment of CT according to the specified ranges
% DicomNewSerie-> Generate (if does not exist) a new folder where to store
%               the dicom file with a new Serie UID

% ImagParamsCT -> Extract some info from the Dicom Header

%% Initialization Clearing/Closing


clc; clear; close all;
% This is needed in order to close the 3D viewer
closereq;closereq;closereq;closereq;closereq;closereq
clc;
%------------------------ Path to include with utils-----------------------
addpath('./utilsRT/')

% Patient Selection
Pt='Example';
%Pti=106;
tiic=tic;

%%
% Hunsfield Unit Values currently used in the MR-based pCT
% solution, check also Maspero et al, 2016, Phys. Med. Biol.
Air=-968;           %(-inf;-200)
Adip_tis=-86;       %[-200;-28.5)
Soft_tis=42;        %[-28.5;100)
Marrow=198;         %[100;575)
Cort_Bon=949;       %[575;inf) -> if not marrow=> [200;inf)

% Check for the Threshold used in Maspero et al, 2016, Phys. Med. Biol.
Air_Thre=-200;
ThresholdCT=[Air_Thre -28.5 100 575 2800];
ValueMRCAT=[Air Air Adip_tis Soft_tis Marrow Cort_Bon Cort_Bon];

%% Flags to enable visualization and Dicom saving

% ----------------------- Initial parameters ------------------------------
SAVEDicom=1234; % to save the Dicom set to 1234
VisualVol=1234;

%% Dicom file opening

tStart = tic;
disp('-------------------------------');
disp(['Processing Pt',num2str(Pt,'%04u')])

% Selection Patient & Opening Data (CT from .dcm)
[homePt,VoxCT,CT,CTinfo]=Data_opening( Pt );
if VisualVol==1234
    view3dgui(CT,VoxCT)
end

%% Body CT
% Body outline calculation on CT and air ouside the body bulk-assigned to air

tic
[ BodyMask] = Body_CT(CT,Air_Thre);
disp(['Body mask calculated in ',num2str(toc,'%4.1f'),' s'])
CTreg=CT;
CTreg(logical(~BodyMask))=Air;

%% CT-based water only pCT

CTwater=ones(size(CTreg))*Air;
CTwater(logical(BodyMask))=0;

if VisualVol==1234
    view3dgui(CTwater,VoxCT)
end

%% Range applied on CT

CTrange=Discret_CT(CT,BodyMask,ThresholdCT(1:end),ValueMRCAT(1:end));
if VisualVol==1234
    view3dgui(CTrange,VoxCT)
end

%% Filling Marrow and removal air within the body outline

Bone=zeros(size(CTreg));
Bone(CTrange>=Marrow-1)=1;
CTbonefil=CTrange;
CTbonefil(CTrange==Marrow)=Soft_tis;
[ Bone_Marrow] = Bone_Close( Bone );
CTbonefil(Bone_Marrow==1)=Marrow;
CTbonefil(CTrange==Cort_Bon)=Cort_Bon;
% Removal Air in the body outline
CTbonefil(BodyMask&CTrange==Air)=Adip_tis;
if VisualVol==1234
    view3dgui(CTbonefil,VoxCT)
end

%% Saving CT based Dicom 
% Create a new folder (or clean the current folder) and save the dicom with
% a new UDI and Serie Numbers
tic
diroutCTwater=([homePt,'/CTwater/Dcm/']);
[ WaterCTInfo,NewSerieUIDWct ] = DicomNewSerie( CTinfo,CTwater,'CTwater',511,diroutCTwater,SAVEDicom );
disp(['Dicom Saved in ',num2str(toc,'%4.1f'),' s in ',diroutCTwater])

tic
diroutCTrange=([homePt,'/CTrange/Dcm/']);
[ ~,NewSerieUIDSctrange ] = DicomNewSerie( CTinfo,CTrange,'CTrange',412,diroutCTrange,SAVEDicom);
disp(['Dicom Saved in ',num2str(toc,'%4.1f'),' s in ',diroutCTrange])

tic
diroutCTbone=([homePt,'/CTbone/Dcm/']);
[ ~,NewSerieUIDSctbone ] = DicomNewSerie( CTinfo,CTbonefil,'CTbone',412,diroutCTbone,SAVEDicom);
disp(['Dicom Saved in ',num2str(toc,'%4.1f'),' s in ',diroutCTbone])


diary off
toc(tiic)