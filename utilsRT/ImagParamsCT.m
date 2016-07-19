function [Dim,Vox]=ImagParamsCT( pat )
%ImagParams print on screen some image parameters for CT
% The input is the path to the folder containing the dicom files
% Developed by m.maspero@umcutrecht.nl, 2105
% In case of comments/improvements just let me know

dicomsCT=dir(fullfile(pat,'/ct*.dcm'));
dcmCT=dicominfo([pat,'/',dicomsCT(5).name]);
dcmCT2=dicominfo([pat,'/',dicomsCT(6).name]);
assignin('base','dcmCT',dcmCT)
assignin('base','dcmCT2',dcmCT2)


if ~strcmp(dcmCT.Modality,'CT')
error('The selected dicoms are not CT images')
end


%AcqMat=dcmCT.AcquisitionMatrix(dcmCT.AcquisitionMatrix~=0);
Nr_Slices=numel(dicomsCT);
Dim=[dcmCT.Rows dcmCT.Columns Nr_Slices];
Vox=[dcmCT.PixelSpacing(1) dcmCT.PixelSpacing(2) dcmCT.SliceThickness];
fprintf(['Acq date: %s @ %s ; PatiendID: %s (%s)\n',...
    '"%s" Imaging parameters on %s %s, %s  \n',...
    'Acq Matrix %ix%ix%i; Pixel=%.2fx%.2fx%.2f,  FOV = %ix%ix%i mm \n'...,
    'KVP = %0.1f  ------------------\n'],...
    dcmCT.AcquisitionDate,dcmCT.AcquisitionTime,dcmCT.PatientID,dcmCT.PatientSex,...   
    dcmCT.StudyDescription,dcmCT.Manufacturer,dcmCT.ManufacturerModelName,...
    dcmCT.Modality,...
    dcmCT.Rows,dcmCT.Columns,Nr_Slices,...
    dcmCT.PixelSpacing(1),dcmCT.PixelSpacing(2),dcmCT.SliceThickness,...
    dcmCT.Rows*dcmCT.PixelSpacing(1),dcmCT.Columns*dcmCT.PixelSpacing(2),dcmCT.SliceThickness*Nr_Slices,...
    dcmCT.KVP);    
%     dcmCT.AcquisitionDuration);

end

