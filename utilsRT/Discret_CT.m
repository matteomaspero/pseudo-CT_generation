function [ True_CT ] = Discret_CT( CT,BodyCT,ThresholdCT,ValueMRCAT )
%Discret_CT discretization of the CT or pCT according to:
% Hunsfield Unit Values for several class of tissues from "Evaluation of Dixon
% based Soft Tissue and Bone Classification in the Pelvis for MR-only-based
% RTP", M. Helle et al, ISMRM 2014 #4238

% if isempty(Value)
% Value=1:numel(Level);
% end

if numel(ValueMRCAT)~=numel(ThresholdCT)+2
    error('Check the size of the vector Threshold and Value (value=thresh+2)')
end

True_CT=ones(size(CT))*ValueMRCAT(1);

for ii=1:numel(ThresholdCT)
    if ii==1
        %True_CT(BodyCT.*CT<ThresholdCT(1))=ValueMRCAT(2);
        True_CT(BodyCT.*CT<ThresholdCT(ii))=ValueMRCAT(ii+1);
    elseif ii>1&&ii<numel(ThresholdCT)
        %True_CT(BodyCT.*CT>=ThresholdCT(1)&BodyCT.*CT<ThresholdCT(2))=ValueMRCAT(3);
        True_CT(BodyCT.*CT>=ThresholdCT(ii-1)&BodyCT.*CT<ThresholdCT(ii))=ValueMRCAT(ii+1);
    elseif ii==numel(ThresholdCT)
        %True_CT(BodyCT.*CT>=ThresholdCT(3)&BodyCT.*CT<ThresholdCT(4))=ValueMRCAT(5);
        %True_CT(BodyCT.*CT>=ThresholdCT(4))=ValueMRCAT(6);
        True_CT(BodyCT.*CT>=ThresholdCT(ii-1)&BodyCT.*CT<ThresholdCT(ii))=ValueMRCAT(ii+1);
        True_CT(BodyCT.*CT>=ThresholdCT(ii))=ValueMRCAT(ii+2);
    end
    
    True_CT(~BodyCT)=ValueMRCAT(1);
    
    
end

