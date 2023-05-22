clear;
close all;
clc;

%% toolbox


%% Main directories path

data_path=[pwd '\Data'];
RT_NIFTI_path=[pwd '\RTS'];
mkdir(RT_NIFTI_path);



%% get scanid, path to folder with CT, path to folder with segmentation
[CT_path_list, RT_path_list,RT_scanid_list]=fn_dicom2nifti(data_path);

for idx = 1:size(RT_scanid_list,1)
    %idx = 1:size(RT_scanid_list,1)
    
    scanid = RT_scanid_list(idx);
    rt_path = RT_path_list{idx};
    ct_path = CT_path_list{idx};
    
    %-------tracking info------- 
    info = niftiinfo([pwd '\CT' '\CT_' num2str(scanid,'%04d') '.nii.gz']);
    filename = [RT_NIFTI_path '\RTS_' num2str(scanid,'%04d')];
    
    %------------------------------
    
    %pixelDim = info.PixelDimensions;
    %info.Datatype = 'double';
    %Seg_time = segName; 
      
    % start conversion
    addpath('.\toolbox\dicomUtils');
    addpath('.\toolbox\imshow3D');
    addpath('.\toolbox\mricron');


    tmp = dir(fullfile(rt_path, '*.dcm'));
    strinfo = dicominfo(fullfile(rt_path, tmp(1).name));
    %strinfo = dicominfo(fullfile(rt_path, tmp(1).name),"UseVRHeuristic",false);
    imageheaders = loadDicomImageInfo(ct_path, strinfo.StudyInstanceUID);
    contour = readRTstructures_orig(strinfo, imageheaders); 

    %--create empty cotainer to combine Ps---
    container = zeros(info.ImageSize);
    
    sz=size(contour,2);    
        if sz>1
            fprintf('Processsing Patient Number: %04d\n', scanid);
            for j=1:sz
            segName = contour(j).ROIName;
            tumor = contour(j).Segmentation;  
            
            %tumor = flipud(tumor);
            %tumor = fliplr(tumor);
            tumor = fliplr(rot90(tumor,3)); % flip the tumor to match CT;
            tumor = flip(tumor,3);
            
            fprintf(['Segmentation: ' segName '\n']);
            extractName = split(segName,' ');
            extractName = extractName{2};

                    %tf=contains(extractName,'Pleu');
                    if contains(extractName,'eura') == 1
                        extractName = 'Pleural';
                        filename_nifti = [filename '_' extractName '.nii'];
                        niftiwrite(uint8(tumor),filename_nifti,'Compressed',true);
                        seg_info = niftiinfo([filename_nifti '.gz']);
                        seg_info.PixelDimensions = info.PixelDimensions;
                        seg_info.raw = info.raw;
                        seg_info.TransformName =  info.TransformName;
                        seg_info.Transform = info.Transform;
                        niftiwrite(uint8(rot90(tumor,3)),filename_nifti,seg_info,'Compressed',true);

                    %---if SEG P1, P2, P3.....-----------
                    %tf=contains(extractName,'P');
                    elseif contains(extractName,'P') ==1
                        container = container | tumor;
                        extractName = 'P';
                        filename_nifti = [filename '_' extractName '.nii'];
                        niftiwrite(uint8(container),filename_nifti,'Compressed',true);
                        seg_info = niftiinfo([filename_nifti '.gz']);
                        seg_info.PixelDimensions = info.PixelDimensions;
                        seg_info.raw = info.raw;
                        seg_info.TransformName =  info.TransformName;
                        seg_info.Transform = info.Transform;
                        niftiwrite(uint8(rot90(container,3)),filename_nifti,seg_info,'Compressed',true);
                    else
                        filename_nifti = [filename '_' extractName '.nii'];
                        niftiwrite(uint8(tumor),filename_nifti,'Compressed',true);
                        seg_info = niftiinfo([filename_nifti '.gz']);
                        seg_info.PixelDimensions = info.PixelDimensions;
                        seg_info.raw = info.raw;
                        seg_info.TransformName =  info.TransformName;
                        seg_info.Transform = info.Transform;
                        niftiwrite(uint8(rot90(tumor,3)),filename_nifti,seg_info,'Compressed',true);
        
                    end
            
   
         
            end
        else
            fprintf('Processsing Patient Number: %04d\n', scanid);
            segName = contour(1).ROIName;
            tumor = contour(1).Segmentation;
            
            %tumor = flipud(tumor);
            %tumor = fliplr(tumor);
            
            tumor = fliplr(rot90(tumor,3)); % flip the tumor to match CT;
            tumor = flip(tumor,3);
            extractName = split(segName,' ');
            extractName = extractName{2}; 


                    %---if SEG P1, P2, P3.....-----------
                    tf=contains(extractName,'P');
                    if tf ==1
                        container = container | tumor;
                        extractName = 'P';
                        filename_nifti = [filename '_' extractName '.nii'];
                        niftiwrite(uint8(container),filename_nifti,'Compressed',true);
                        seg_info = niftiinfo([filename_nifti '.gz']);
                        seg_info.PixelDimensions = info.PixelDimensions;
                        seg_info.raw = info.raw;
                        seg_info.TransformName =  info.TransformName;
                        seg_info.Transform = info.Transform;
                        niftiwrite(uint8(rot90(container,3)),filename_nifti,seg_info,'Compressed',true);
                    else
                        filename_nifti = [filename '_' extractName '.nii'];
                        niftiwrite(uint8(tumor),filename_nifti,'Compressed',true);
                        seg_info = niftiinfo([filename_nifti '.gz']);
                        seg_info.PixelDimensions = info.PixelDimensions;
                        seg_info.raw = info.raw;
                        seg_info.TransformName =  info.TransformName;
                        seg_info.Transform = info.Transform;
                        niftiwrite(uint8(rot90(tumor,3)),filename_nifti,seg_info,'Compressed',true);
        
                    end


        
        end
        %fprintf('Done processing ... \t\t\t %6.2f sec\n', toc);
        clear container

        
        

end
