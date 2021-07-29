mphstart(2037)

model = mphload('0_Model_Base.mph');

import com.comsol.model.util.*
ModelUtil.showProgress(true);

%%
%%Import the information to interpolate the PP into the COMSOL mesh Data.csv
filename = 'zone.xyz';
delimiter = '\t';
formatSpec = '%f%f%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string',  'ReturnOnError', false);
fclose(fileID);
X_mesh= dataArray{:, 1};
Y_mesh = dataArray{:, 2};

filename = 'Data.csv';
delimiter = ' ';
formatSpec = '%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string',  'ReturnOnError', false);
fclose(fileID);
V_int = dataArray{:, 1};

PP_Int=[X_mesh Y_mesh V_int];

dlmwrite('PP_Int.txt',PP_Int,'precision','%.8f'); %%Save as txt file

%%
%%%Now the model
model.func('int1').discardData;
model.func('int1').importData;
model.func('int1').set('source', 'file');
model.func('int1').set('filename', 'PP_Int.txt');
model.func('int1').set('nargs', 2);
model.func('int1').set('interp', 'linear');

try
model.study('std1').run

%%
%%% EXPORT ERT Data from COMSOL
model.result().numerical("pev1").set("probetag", "none");
model.result().numerical("pev1").set("table", "tbl1");
model.result.numerical('pev1').setResult;
model.result.export('tbl1').set('filename','ERTData.txt');
model.result.export('tbl1').set('header', false);
model.result.export('tbl1').set('ifexists', 'overwrite');
model.result.export('tbl1').run;
model.result.export('data4').set('filename','out_TDS_well.txt');
model.result.export('data4').set('header', false);
model.result.export('data4').set('ifexists', 'overwrite');
model.result.export('data4').run;

%%
%%%%% Data of ERT for Table Data %%%%
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen('ERTData.txt','r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', ' ', 'MultipleDelimsAsOne', true, 'TextType', 'string',  'ReturnOnError', false);
fclose(fileID);
Table_Data=[dataArray{1:end-1}];


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%  GET ERT DATA   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n_elec=72; %number of electrodes
n_lambda=5; %number of lambdas
%res_Ref=120; %resistividad de referencia para comprobar
x0_el=-35;
I=1;
d=2; %electrode spacing

%Weights for wavenumbers (0.0031677 0.0301330 0.1285886 0.4599185 1.5842125) from Pang and Tang for
g_k=[0.0067253;0.0314373;0.1090454;0.3609340;1.3039204];

disp='Wenner';

Data_F=Table_Data(:,3:2+n_elec);
Data_F_Elec=[];
Data=[];
Dat=[];

%%
for j=1:n_elec
    
    Data_F_Elec=Data_F(n_lambda*(j-1)+1:n_lambda*j,1:n_elec);
    Dat=(sum(Data_F_Elec.*g_k))';
    Data=[Data Dat];
    j=j+1;
end

Data=Data';


[stim,Command]= stim_pattern_geophys(n_elec,disp,1);

A=(Command(:,1))'; %Current electrode 1
B=(Command(:,2))'; %Current electrode 2
M=(Command(:,3))'; %Potential electrode 1
N=(Command(:,4))'; %Potential electrode 2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% CALCULATES APP. RESISTIVITY FOR QUADRIPOLES  %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Geometric factor
V=[];
gf=[];
a=[];
dist=[];
L=[];
for k=1:length(A)
    U=Data(A(k),M(k))-Data(B(k),M(k))-Data(A(k),N(k))+Data(B(k),N(k));
    V=[V U];
    
    esp=d*abs(N(k)-M(k));
    a=[a esp];
    
    
    k=k+1;
end

%%SAVE ERT DATA%%
App_Res=(log(abs(2*pi*(V/I).*a)))';
length(App_Res);%Number of data
ERTData=[Command App_Res]; %Command and resistivities

%This saves only app. resistivities in outERT.txt file
dlmwrite('outERT.txt',App_Res,'precision','%.8f');

catch
end
exit
 