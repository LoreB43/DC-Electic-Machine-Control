clear
clc

%% DATA
%mechanical load
wn= 314;%rad/s
vn= 60*(1000/3600); %m/s
R=vn/wn; %m
M=10*1000+200*80; %kg
an=60*(1000/3600)/25;%m/s^2
Ft=M*an;%N
Ff=(1/3)*Ft; %N
Tf=Ff*R;%Nm
beta=Tf/wn;%Nm/s
J=M*R^2;%kg*m^2

%excitation circuit
tau_e=1; %s
Ien= 1; %A
Ven= 120; %V
Re= Ven/Ien;%Ohm
Le= tau_e*Re;%H

%armature circuit
Pn=(Ft+Ff)*vn;%W
Pel=Pn/0.9;%W
Van=600; %V
Ian=Pel/Van; %A
En=Pn/Ian;%V
K=En/(Ien*wn);%ohm/s
Tn=Pn/wn;%Nm
Ks=Tn/(Ian*Ien);
Ra=0.084; %0.1*Pn/(Ian^2);%ohm
tau_a=0.010; %s
La=tau_a*Ra;%H

%% PLANT
s=tf('s');
Gw= 1/(J*s+beta); %mechanical load
GIa=1/(Ra+La*s) ; %armature circuit
GIe=1/(Re+Le*s) ; %excited circuit

%% REQUIREMENTs
%w requirements
wc_w= 7;
Pm_w= 90;

%Ia requirements
wc_Ia= wc_w*10;
Pm_Ia= 80;

%Ie requirements
wc_Ie= 0.9;
Pm_Ie= 90;


%% REGOLATORs

%w regulator
opt_w=pidtuneOptions('PhaseMargin', Pm_w);
[Reg_wpi, info_w]=pidtune(Gw,'PI',wc_w,opt_w);
Reg_w=tf(Reg_wpi);

%Ia regulator
opt_Ia=pidtuneOptions('PhaseMargin', Pm_Ia);
[Reg_Iapi, info_Ia]=pidtune(GIa,'PI',wc_Ia,opt_Ia);
Reg_Ia=tf(Reg_Iapi);

%Ie regulator
opt_Ie=pidtuneOptions('PhaseMargin', Pm_Ie);
[Reg_Iepi, info_Ie]=pidtune(GIe,'PI',wc_Ie,opt_Ie);
Reg_Ie=tf(Reg_Iepi);

%% FEEDBACKs AND GRAPHs


% Lw=Gw*Reg_w;
% LIa=GIa*Reg_Ia;
% LIe=GIe*Reg_Ie;
% figure
% bode(Gw,Lw)
% figure
% bode(GIa,LIa)
% figure
% bode(Lw,LIa)
% figure
% bode(GIe,LIe)
