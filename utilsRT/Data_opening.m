function [homePt,VoxCT,CTdcm,CTInfos] = Data_opening( Pt )
%Data_opening:: Open Dicom Data
% For Ref over the dicom RT images check Maria Y. Y. Law; Brent Liu;
% RadioGraphics  2009, 29, 655-667
% http://pubs.rsna.org/doi/abs/10.1148/rg.293075172
% developed by Matteo Maspero, UMC Utrecht, 2016
% For info contact: m.maspero@umcutrecht.nl/matteo.maspero.it@gmail.com
% 

homePt=['./Data/',Pt,''];

% Open CT from dicoms
dirCT=[homePt,'/CTreg'];
dirCT_dcm=[dirCT,'/Dcm/'];

if (exist(dirCT,'dir')==7)
    disp('CT folder exists')
    if (exist(dirCT_dcm,'dir')==7)
        [Dim,VoxCT]=ImagParamsCT(dirCT_dcm);
        % Open CT Image
        namesCT=dir(fullfile([dirCT_dcm,'ct*.dcm']));
        CTInfosT=struct([]);
        CTInfos=struct([]);
        Order=zeros(length(namesCT));
        CTTmp=zeros(Dim);
        disp('Opening Dicom CT Images')
        for ii=1:length(namesCT)
            if exist(fullfile([dirCT_dcm,namesCT(ii).name]),'file')==2
                CTInfosT{ii}=dicominfo([dirCT_dcm,namesCT(ii).name]);
                Order(ii)=CTInfosT{ii}.SliceLocation;
                CTTmp(:,:,ii)=double(squeeze(dicomread(CTInfosT{ii})))*CTInfosT{ii}.RescaleSlope+CTInfosT{ii}.RescaleIntercept;
            else
                CTInfosT=0;
                warning([namesCT(ii),' does not exist!'])
            end
        end
        
        [~,Index]=sort(Order);
        CTdcm=zeros(size(CTTmp));
        for jj=1:length(Order)
            CTdcm(:,:,jj)=CTTmp(:,:,Index(jj));
            CTInfos{jj}=CTInfosT{Index(jj)};
        end
    end
else
    disp('No CT exist')
end

disp('All files have been opened!')


end

