function Body_Mask_only = Body_CT( data,thre )
%Body_CT:: Body Mask of the CT data,
% based on tresholdibg, small region removal, and region filling.
% Developed by Matteo Maspero, UMC Utrecht, 2016
% for info contact: m.maspero@umcutrecht.nl/matteo.maspero.it@gmail.com

dim=size(data);
Body_Mask_only=zeros(dim);
Body_Mask=data>thre;
 for ii=1:dim(3)
     I=squeeze(Body_Mask(:,:,ii));
     II=logical(bwareaopen(I,ceil(dim(1)*dim(2)*0.01)));
     III=imfill(II,'holes');
     Body_Mask_only(:,:,ii) = III;
end

