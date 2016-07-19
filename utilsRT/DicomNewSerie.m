function [ WaterMRInfo,NewSerieUID ] = DicomNewSerie( Infodcm,Volume,NameSerie,NumberSerie,dirout,SAVEDicom )
%DicomNewSerie Genearate dicom files with new Serie UID

WaterMRInfo=Infodcm;
NewSerieUID=dicomuid;

if SAVEDicom==1234
    if exist(dirout)==7
        rmdir(dirout,'s')
        disp(['Removal ',dirout])
    end
    mkdir(dirout)
end

for ii=1:length(Infodcm)
    WaterMRInfo{ii}.SeriesDescription=NameSerie;
    WaterMRInfo{ii}.ProtocolName=NameSerie;
    WaterMRInfo{ii}.SeriesInstanceUID=NewSerieUID;
    WaterMRInfo{ii}.SeriesNumber=NumberSerie;
    WaterMRInfo{ii}.SOPInstanceUID=dicomuid;
    WaterMRInfo{ii}.InstanceCreationDate=datestr((date),'yyyymmdd');
    WaterMRInfo{ii}.InstanceCreationTime=datestr((clock),'HHMMSS');
    %  WaterMRInfo{ii}.StudyDate=datestr((date),'yyyymmdd');
    %  WaterMRInfo{ii}.StudyTime=datestr((clock),'HHMMSS');
    %    WaterMRInfo{ii}.SOPClassUID='1.2.840.10008.5.1.4.1.1.481.1';
    WaterMRInfo{ii}.RescaleSlope=1;
    WaterMRInfo{ii}.RescaleIntercept=0;
    WaterMRInfo{ii}.WindowCenter=0;
    WaterMRInfo{ii}.WindowWidth=2000;
    Filename=fullfile(dirout,[NameSerie,num2str(ii,'%04u'),'.dcm']);
    WaterMRInfo{ii}.Filename=Filename;
    if SAVEDicom==1234
        dicomwrite(int16(squeeze(Volume(:,:,ii))),Filename,WaterMRInfo{ii});
    end
end

end
