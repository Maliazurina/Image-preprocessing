
function [ct_path_list, seg_path_list,scanid_list]=fn_dicom2nifti(path_data)


parent_dir = dir(path_data); 
parent_dir = parent_dir(~ismember({parent_dir.name},{'.','..'}));   % clear the first two unwanted parent folders

parent_num = size(parent_dir,1); 

ct_path_list = cell(0);
segpath_list = cell(0);
scanid_list= zeros(parent_num,1);
%scanid_list = cell(0); 
num = 1;


%% get directory list
        for idx = 1:parent_num
            ipath = [path_data '\' parent_dir(idx).name];
            dicom_path = dir([ipath '\*dicom*']);
            dicom_path = [ipath '\' dicom_path.name];
            
            seg_path = dir([ipath '\*SEG*']);
            seg_path = [ipath '\' seg_path.name];

            ct_path_list{num}=dicom_path;
            seg_path_list{num}=seg_path;
            scanid=parent_dir(idx).name(1:4);
            scanid_list(num)=str2num(scanid);
            num =  num+1;
                           
        end
            
                
        
 end

