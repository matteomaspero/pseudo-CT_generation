function [ Marrow2] = Bone_Close( data )
%Bone_Close:: bone region closure
% Developed by Matteo Maspero, UMC Utrecht, 2016
% for info contact: m.maspero@umcutrecht.nl/matteo.maspero.it@gmail.comdim=size(data);
dim=size(data);
Region=zeros(dim);
for ii=1:dim(3)
    New=bwareaopen(data(:,:,ii),ceil(dim(1)*dim(2)*0.0002));
    Marrow2(:,:,ii) = bwmorph(imfill(bwmorph(New,'close'),'holes'),'erode',0);
end

end

