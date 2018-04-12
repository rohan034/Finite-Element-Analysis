function FEA3DS8_create_input
%********************************************************************
%*    Input Data Translator - ABAQUS -> FEA                         *
%*                                                                  *
%*    Steps for you to take:                                        *
%*      1. copy the Abaqus input file to file node.txt              *
%*      2. Edit node.txt and delete all lines except                *
%*         the nodal coordinate data which occurs under             *
%*         the name "NODE*" in the Abaqus input file.               *
%*      3. copy the Abaqus input file to file element.txt           *
%*      4. Edit element.txt and delete all lines except             *
%*         the element connectivity data which occurs under         *
%*         the name "ELEMENT*" in the Abaqus input file.            *
%*    Then this program does the following:                         *
%*      1. loads Abaqus data from files node.txt and element.txt    *
%*      2. Transforms Abaqus data to FEA data.                      *
%*      3. Saves matlab FEA data for nodes and elements and         *
%*         other data in FEA_input_data.mat.                        *
%********************************************************************
node=load('FEA3DS8_node.txt'); 
element=load('FEA3DS8_element.txt'); 

num_ele = size(element,1);

coord = node(:,2:4);

lotogo = zeros(num_ele,8);

% LOAD LOCAL NODE NUMBERING CONNECTIVITY DATA FROM ABAQUS TO FEA
lotogo(:,1) = element(:,2);
lotogo(:,2) = element(:,3);
lotogo(:,3) = element(:,4);
lotogo(:,4) = element(:,5);
lotogo(:,5) = element(:,6);
lotogo(:,6) = element(:,7);
lotogo(:,7) = element(:,8);
lotogo(:,8) = element(:,9);



% ADDING THE BOUNDARY RESTRAINT CONDITIONS
% ----------------------------------------
% JJ = 1 MEANS THAT DOF IS FREE TO MOVE
% JJ = 0 MEANS THE DOF IS FIXED OR RESTRAINED
%
jj = ones(size(coord,1),6);
%
% SET RESTRAINTS TO ZERO FOR NODES AT THE "OFFSET"
%********************************************************************
%*    NOTE: THIS PART NEEDS TO BE MODIFIED FOR THE PROJECT MODEL    *
%********************************************************************
offset = 0;
ind = (abs(coord(:,1)-offset)<1e-6);
jj(ind,:) = 0;
ind = (abs(coord(:,2)-offset)<1e-6);
%
jj(ind,:) = 0;
offset = 20;
ind = (abs(coord(:,1)-offset)<1e-6);
jj(ind,:) = 0;
ind = (abs(coord(:,2)-offset)<1e-6);
jj(ind,:) = 0;
% ----------------------------------

% MATERIAL PROPERTIES 
young = 29e6;
poisson = 0.3;
density = .0008;
coefExp = 0.000007;

% DYNAMIC ANALYSIS PARAMETERS
ntimeStep = 200;
dt = .005;
AlfaDamp = 0.08;
BetaDamp = 0.002;

% TEMPERATURE VARIATION
dTemp = 0;

% THICKNESS OF THE SHELL
Thickness = 2;

% PRESSURE ON THE SHELL SURFACE
Pressure = 0;

% ----------------------------------------
% CONCENTRATED FORCES
% ----------------------------------------
%********************************************************************
%*    NOTE: THIS PART NEEDS TO BE MODIFIED FOR THE PROJECT MODEL    *
%********************************************************************
% % GLOBAL NODES AT WHICH FORCES ARE APPLIED 
% offset = 25.0 ;
% ind = (abs(coord(:,1)-offset)<1e-6);
% ifornod = find(ind)';

% % FORCE DIRECTIONS (1 - X, 2 - Y, 3 - Z)
% ifordir = 1*ones(1,size(ifornod,2));

% % FORCE VALUES
% for i=1:size(ifornod,2)
       % forval(i) = 1000*50*Thickness/size(ifornod,2); 
% end
ifornod = [28 40 49 27 7 39 12 48 17 57 32 43 52 31 8 42 13 51 18 60 35 45 54 34 9 44 14 53 19 62 38 47 56];
ifordir = 3*ones(1,size(ifornod,2));
forval = -10*20*20/33*[ones(1,33)];
% ----------------------------------------

save FEA_input_data.mat coord lotogo jj young poisson density ifornod ifordir forval ntimeStep dt AlfaDamp BetaDamp dTemp coefExp Thickness Pressure;

clear
end