%% Clear previous variables
clc;
clear;
close all;

%% Data path
data_path=[pwd '\Data'];
%% New modules path
temp_path = [pwd '\temp'];
nifti_path = [pwd '\CT'];


%% start conversion

addpath('.\toolbox\dicomUtils');
addpath('.\toolbox\imshow3D');
addpath('.\toolbox\mricron');
conversion_tool = [pwd '\toolbox\mricron\dcm2nii'];
conversion_params =' -a n -g y -d n -e y -i n -r n -p n -n y -o ';

%% Create directory for converted input;
mkdir(temp_path);
mkdir(nifti_path);


%% Get the list of patients
[ct_path_list,seg_path_list,scanid_list]=fn_dicom2nifti(data_path); 

%% Main program

for i = 1:size(scanid_list,1)
    scanid=scanid_list(i);   
    tic % tic starts a stopwatch timer
    fprintf('---------------------------------------------------\n');
    fprintf('Converting dicom data for Patient_%04d.....\n', scanid);
    fprintf('---------------------------------------------------\n');
 %% convert to 3D matlab matrix
    ct_path = ct_path_list{i};   
    DICOM_Dir = ct_path;
    SaveDir = temp_path ;
    status = dos([conversion_tool, conversion_params, SaveDir, ' ', DICOM_Dir]); 
    
  %% Edit the naming
     old_name = dir(strcat( SaveDir,'\','*.nii.gz'));
     new_name = [nifti_path '\CT_' num2str(scanid,'%04d') '.nii.gz'];
     movefile([SaveDir '\' old_name.name],new_name);
     
   
end

fprintf('Done processing ... \t\t\t %6.2f sec\n', toc);

