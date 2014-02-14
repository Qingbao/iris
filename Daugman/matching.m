% Getting Hamming Distance for Intra-class and Inter-class
% Author: Qingbao Guo
% Gjovik University College, GUC, Norway

clear all;
load 'template.mat';
load 'mask.mat';

tic
%same_index = 1;
diff_index = 1;
%intra-class
% for i=1:108
% 
% for j=1:6
%     
%    for k=1:6
%        
%     if (j+k)>7;       
%         break;
%     end
%     
%     template1 = reshape(template(:,7*(i-1)+j),20,480);
%     mask1 = reshape(mask(:,7*(i-1)+j),20,480);
% 
%     template2 = reshape(template(:,7*(i-1)+k+j),20,480);
%     mask2= reshape(mask(:,7*(i-1)+k+j),20,480);
%     
%     HD_same(1,same_index) = gethammingdistance(template1, mask1, template2, mask2, 1);
%    
%     same_index= same_index +1;
%     
%    end
% end
% end


%inter-class
 for i=1:107

    for j=1:7
    
        for k=1:749
        
        if (7*(i-1)+k+7)>756;
            break;
        end
            
        template1 = reshape(template(:,7*(i-1)+j),20,480);
        mask1 = reshape(mask(:,7*(i-1)+j),20,480);

        template2 = reshape(template(:,7*(i-1)+k+7),20,480);
        mask2= reshape(mask(:,7*(i-1)+k+7),20,480);

        HD_diff(1,diff_index) = gethammingdistance(template1, mask1, template2, mask2, 1);

        diff_index= diff_index +1;
                
        end
    end
end








save HD_diff.mat HD_diff;
HD_diff

% save HD_same.mat HD_same
% HD_same
toc