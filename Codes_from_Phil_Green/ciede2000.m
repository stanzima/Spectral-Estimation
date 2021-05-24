function DE=ciede2000(LABREF,LAB,K)

% CIEDE2000 calculates colour difference between a reference and sample 
% using CIEDE2000 colour difference (as defined in Luo, Cui and Rigg (2000))
%
% Input data can be single values or multiple values arranged in columns
% LABREF can be a single value while LAB is a column
%
% Parametric weighting factors, if used, should be supplied either as a vector of
% 2 values (kH is then set to 1) or as a vector of three values.
% Example:
%   DE=ciede2000(labref,labsample,[1.5,1.2,0.8]);
%
%   Colour Engineering Toolbox
%   author:    © Phil Green
%   version:   1.1
%   date:  	   17-01-2001
%   updated:   29-8-2007
%   book:      http://www.wileyeurope.com/WileyCDA/WileyTitle/productCd-0471486884.html
%   web:       http://www.digitalcolour.org

% set the values of parametric weighting factors KL,KC,KH

if nargin>2
   if length(K)==3
       kL=K(1);kC=K(2);kH=K(3);
   elseif length(K)==2
       kL=K(1);kC=K(2);kH=1;
   end
else
   kL=1;kC=1;kH=1;
end

%___________________________________________________________________

L=LABREF(:,1);a=LABREF(:,2);b=LABREF(:,3);
C=(a.^2+b.^2).^0.5;

Ls=LAB(:,1);as=LAB(:,2);bs=LAB(:,3);
Cs=(as.^2+bs.^2).^0.5;

%find G and recompute a', C' and h'
Cm=(C+Cs)/2;
G=0.5*(1-(Cm.^7./(Cm.^7+25^7)).^0.5);
a=(1+G).*a;
as=(1+G).*as;
C=(a.^2+b.^2).^0.5;
h=hue_angle(a,b);
Cs=(as.^2+bs.^2).^0.5;
hs=hue_angle(as,bs);

%find the mean chroma and hue for each reference/sample pair
Cm=(Cs+C)/2;
hm=(h+hs)/2;
j=find(abs(h-hs)>180);hm(j)=hm(j)-180;
k=hm<0;hm(k)=hm(k)+360; % case where sample and reference cross h=0;
m=(a==0) & (b==0);hm(m)=hs(m); % case where reference is at the origin
n=(as==0) & (bs==0);hm(n)=h(n); % case where sample is at the origin

% hue difference
Dh=h-hs;
Dh(Dh>180)=360-Dh(Dh>180); % case where sample and reference cross h=0;
p=(bs==0) & (b<0);Dh(p)=-Dh(p); % case where bs=0 and b < 0

% L* and C* difference
DL=(L-Ls);
DC=(C-Cs);
rad=pi/180;
DH=2*((C.*Cs).^0.5).*sin(rad*(Dh)/2);

% calculate T
T=1-0.17*cos(rad*(hm-30))+0.24*cos(rad*2*hm)+0.32*cos(rad*(3*hm+6))-0.2*cos(rad*(4*hm-63));

%calculate weighting factors SL, SC, SH
SL=1+(0.015.*((L+Ls)./2-50).^2)./(20+((L+Ls)./2-50).^2).^.5;
SC=1+0.045.*Cm;
SH=1+0.015.*Cm.*T;

Dt=30*exp(-(((hm-275)/25).^2));
RC=2.*((Cm.^7)./(Cm.^7+25.^7)).^.5;
RT=-sin(2*rad*Dt).*RC;

DE=((DL./(SL.*kL)).^2+(DC./(SC.*kC)).^2+(DH./(SH.*kH)).^2+RT.*(DC./(SC.*kC)).*(DH./(SH.*kH))).^0.5;
