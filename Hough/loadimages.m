% Loading images and create iris templates
% Author: Qingbao Guo
% Gjovik University College, GUC, Norway


clear all;
%load('data');

tic %CPU time begainning

path='CASIA Iris Image Database (version 1.0)\'; %please update to your directory
subpath='00'; %please update to your directory

for i=1:108
    
            if i>=10
                %path='CASIA Iris Image Database (version 1.0)\0';
                subpath='0';
            end
            
            if i>=100
                 %path='CASIA Iris Image Database (version 1.0)\';
                 subpath='';
            end
    
    for j=1:2
        
        if j==1
        for k=1:3
            
        filesrcpath1 = strcat(path,subpath,num2str(i),'_',num2str(j),'_',num2str(k),'.jpg');     
        im = filesrcpath1;  
        [t,m] = createiristemplate(im);
        template(:,7*(i-1)+k)  = reshape(t,1,480*20);
        mask(:,7*(i-1)+k)  = reshape(m,1,480*20);
        save template_hough.mat template;
        save mask_hough.mat mask;
        end
        end
        
        if j==2
        for h=1:4
        filesrcpath2 = strcat(path,subpath,num2str(i),'_',num2str(j),'_',num2str(h),'.jpg');
        im = filesrcpath2;  
        [t,m] = createiristemplate(im);
        template(:,7*i-4+h)  = reshape(t,1,480*20);
        mask(:,7*i-4+h)  = reshape(m,1,480*20);
        save template_hough.mat template;
        save mask_hough.mat mask;
        end
        end
        
    end
end

toc %CPU time ending





 