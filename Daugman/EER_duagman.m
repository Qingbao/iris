
% calculation of fnmr and fmr
% same represents same subject distance result£¬diff represents different subject distance result
% Author: Qingbao Guo
% Gjovik University College, GUC, Norway

clear all;
load 'HD_same.mat';
load 'HD_diff.mat';

x = 0:0.01:1;
fmr = zeros(size(x));
fnmr = zeros(size(x));

for k=1:length(x)
    fmr(k) = sum(HD_diff(1,:) <= x(k)) / size(HD_diff,2);
    fnmr(k) = sum(HD_same(1,:) > x(k)) / size(HD_same,2);    
end

%%% EER %%%
EER = 1;
for i = 1:length(x)-1
        if fmr(i) == fnmr(i)
            EER = fmr(i);
        elseif sign(fmr(i)-fnmr(i))*sign(fmr(i+1)-fnmr(i+1)) == -1
            EER = (fmr(i)+fmr(i+1)+fnmr(i)+fnmr(i+1))/4;
            break;
        else
            EER = 1;            
        end
end
fmr
fnmr
figure
plot(fmr,fnmr,'.-b')
EER