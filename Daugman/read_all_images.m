% File conversion 
% Reading images from CASIA database and converting to 'jpg' format
% Author: Qingbao Guo
% Gjovik University College, GUC, Norway


clear all;

path='CASIA Iris Image Database (version 1.0)\00'; %please update to your directory
subpath='00'; %please update to your directory
for i=1:108
    
            if i>=10
                path='CASIA Iris Image Database (version 1.0)\0';
                subpath='0';
            end
            
            if i>=100
                 path='CASIA Iris Image Database (version 1.0)\';
                 subpath='';
            end
    
    for j=1:2
        
        if j==1
        for k=1:3
            
        filesrcpath1 = strcat(path,num2str(i),'\',num2str(j),'\',subpath,num2str(i),'_',num2str(j),'_',num2str(k),'.bmp');
        filedespath1 = strcat(path,num2str(i),'_',num2str(j),'_',num2str(k),'.jpg');
        im = imread(filesrcpath1,'bmp');
        data(:,7*(i-1)+k) = reshape(im,1,280*320);
        imwrite(im,filedespath1,'jpg');       
        end
        end
        
        if j==2
        for h=1:4
        filesrcpath2 = strcat(path,num2str(i),'\',num2str(j),'\',subpath,num2str(i),'_',num2str(j),'_',num2str(h),'.bmp');
        filedespath2 = strcat(path,num2str(i),'_',num2str(j),'_',num2str(h),'.jpg');
        im = imread(filesrcpath2,'bmp');
        data(:,7*i-4+h) = reshape(im,1,280*320);
        imwrite(im,filedespath2,'jpg');       
        end
        end
        
    end
end
save data.mat data;