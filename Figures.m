%% Please cite these 2 papers
% 
% [1] Onat, E., & Özkazanç, Y. (2025). Hybrid-Level Fusion of Radar Imaging Methods. International Journal of Engineering and Geosciences, 11(1), 1-20. https://doi.org/10.26833/ijeg.1611426
% [2] E. Onat and Y. Özkazanç, "An analysis of Doppler beam sharpening technique used in fighter aircraft," 2018 26th Signal Processing and Communications Applications Conference (SIU), Izmir, Turkey, 2018, pp. 1-4, doi: 10.1109/SIU.2018.8404521.
% 
% Contact
% Dr. Emrah Onat - TOBB University of Economics and Technology, Ankara, Turkey (eonat87@yahoo.com)
% Dr. Yakup Ozkazanc - Hacettepe University, Ankara, Turkey
%
% Matlab code for
% Figure 12, Figure 13, Figure 14, and Figure 15 of Hybrid-Level Fusion of Radar Imaging Methods

clear all
close all
clc

c = 3e8;       % speed of light  (m/s)
f = 10e9;      % frequency in (Hz)
v = 83.3333;   % aircraft velocity (m/s) 83.33 m/s = 300km/h
SR = 60;       % Scan Rate in degrees per sec (deg/s)
h = 866.0254;  % aircraft height (m)
D = 0.687;     % aperture diameter (m)

eta_d = 60;                % depression angle in degree
eta_r = eta_d/180*pi;      % depression angle in radian 
R = h/sin(eta_r);          % Range (m)
lambda = c/f;              % Wavelength (m)
T = 1/45;
theta_deg = 2.5;           % beamwidth - azimuth in degree
theta_r = theta_deg/180*pi;
D = lambda / theta_r;

%% RBGM cross-range resolution

d_CR_RBGM = theta_r * R;                  % x-range resolution of RBGM (m)

%% DBS cross-range resolution

v_low = v * 0.8;   % aircraft velocity 240 km/h

squint_angle = -90:1:90;
d_CR_DBS = abs(lambda * R./(2*v_low*T*sind(squint_angle)));   % x-range resolution of DBS (m)
BSR = d_CR_RBGM ./ d_CR_DBS;              % Beam Sharpening Ratio

d_CR_DBS(91) = d_CR_DBS(92);              % Get rid of Inf
d_CR_DBS_avg1 = mean2(d_CR_DBS);          % Average DBS x-range resolution

d_CR_DBS(d_CR_DBS>d_CR_RBGM) = d_CR_RBGM; % if DBS Gap is RBGM Resolution
d_CR_DBS_avg2 = mean2(d_CR_DBS);          % Average DBS x-range resolution

%% uSAR cross-range resolution

d_CR_uSAR = 2*sqrt(lambda * R);           % x-range resolution of uSAR (m)


%% Figure 12 of Hybrid-Level Fusion of Radar Imaging Methods
squint_angle = -90:1:90;

v_low = v * 0.8;   % aircraft velocity 240 km/h
d_CR_DBS1 = abs(lambda * R./(2*v_low*T*sind(squint_angle)));   % x-range resolution of DBS (m)
BSR1 = d_CR_RBGM ./ d_CR_DBS1;              % Beam Sharpening Ratio

% aircraft velocity 300 km/h
d_CR_DBS2 = abs(lambda * R./(2*v*T*sind(squint_angle)));   % x-range resolution of DBS (m)
BSR2 = d_CR_RBGM ./ d_CR_DBS2;              % Beam Sharpening Ratio

v_high = v * 1.2;   % aircraft velocity 360 km/h
d_CR_DBS3 = abs(lambda * R./(2*v_high*T*sind(squint_angle)));   % x-range resolution of DBS (m)
BSR3 = d_CR_RBGM ./ d_CR_DBS3;              % Beam Sharpening Ratio

d_CR_RBGM_array = ones(length(squint_angle))*d_CR_RBGM;

figure;
plot(squint_angle,abs(d_CR_DBS1),'k',"LineWidth",2)
hold on;
plot(squint_angle,abs(d_CR_DBS2),'g',"LineWidth",2)
hold on;
plot(squint_angle,abs(d_CR_DBS3),'r',"LineWidth",2)
hold on;
plot(squint_angle,abs(d_CR_RBGM_array),'b',"LineWidth",2)
grid on;
axis([-95 +95 0 65.5])
xlabel('Squint Angle - degree')
ylabel('Cross-Range Resolution - meter')
title('DBS and RBGM Cross-Range Resolutions');
% legend('DBS (Aircraft Speed = 0.9V km/h)', 'DBS (Aircraft Speed = V km/h)', 'DBS (Aircraft Speed = 1.1V km/h)', 'RBGM');
legend('DBS (Aircraft Speed = 240 km/h)', 'DBS (Aircraft Speed = 300 km/h)', 'DBS (Aircraft Speed = 360 km/h)', 'RBGM');


%% Figure 13 of Hybrid-Level Fusion of Radar Imaging Methods

figure;
plot(squint_angle,abs(BSR1),'k',"LineWidth",2)
hold on;
plot(squint_angle,abs(BSR2),'g',"LineWidth",2)
hold on;
plot(squint_angle,abs(BSR3),'r',"LineWidth",2)
hold on;
sq_angle = -90:5:90;bir=ones(size(sq_angle));plot(sq_angle,abs(bir),'c.',"LineWidth",2);
grid on;
axis([-95 +95 0 7.5])
xlabel('Squint Angle - degree')
ylabel('Improvement Factor')
title('Beam Sharpening Ratio Values');
legend('DBS (Aircraft Speed = 240 km/h)', 'DBS (Aircraft Speed = 300 km/h)', 'DBS (Aircraft Speed = 360 km/h)','d_C_R_-_D_B_S = d_C_R_-_R_B_G_M');

%% Figure 14 of Hybrid-Level Fusion of Radar Imaging Methods

figure;
plot(squint_angle,abs(d_CR_DBS1./R/pi*180),'k',"LineWidth",2)
hold on;
plot(squint_angle,abs(d_CR_DBS2./R/pi*180),'g',"LineWidth",2)
hold on;
plot(squint_angle,abs(d_CR_DBS3./R/pi*180),'r',"LineWidth",2)
hold on;
plot(squint_angle,abs(d_CR_RBGM_array./R/pi*180),'b',"LineWidth",2)
grid on;
axis([-95 +95 0 65.5/R/pi*180])
xlabel('Squint Angle - degree')
ylabel('Beamwidth - degree')
title('RBGM Beamwidth and DBS Effective Beamwidth Values');
% legend('DBS (Aircraft Speed = 0.9V km/h)', 'DBS (Aircraft Speed = V km/h)', 'DBS (Aircraft Speed = 1.1V km/h)', 'RBGM');
legend('DBS (Aircraft Speed = 240 km/h)', 'DBS (Aircraft Speed = 300 km/h)', 'DBS (Aircraft Speed = 360 km/h)', 'RBGM');


%% Figure 15 of Hybrid-Level Fusion of Radar Imaging Methods

R = 400:1:10000;      % Range
squint_angle = 90;    % Constant Squint angle

d_CR_DBS_R1 = abs(lambda * R./(2*v_low*T*sind(squint_angle)));
d_CR_DBS_R2 = abs(lambda * R./(2*v*T*sind(squint_angle)));
d_CR_DBS_R3 = abs(lambda * R./(2*v_high*T*sind(squint_angle)));

d_CR_uSAR_R = sqrt(R.*lambda)/0.5;  % Unfocused SAR Crossrange resolution

figure;
loglog(R,d_CR_DBS_R1,'k',"LineWidth",2);
hold on;
loglog(R,d_CR_DBS_R2,'g',"LineWidth",2)
hold on;
loglog(R,d_CR_DBS_R3,'r',"LineWidth",2)
hold on;
loglog(R,d_CR_uSAR_R,'m',"LineWidth",2)

legend('DBS (Aircraft Speed = 240 km/h)', 'DBS (Aircraft Speed = 300 km/h)', 'DBS (Aircraft Speed = 360 km/h)', 'Unfocused SAR');
title('DBS and Unfocused SAR Cross-Range Resolutions');
ylabel('Cross Range Resolution - meter')
xlabel('Range - meter')
grid on

%% Figure 13 of An analysis of Doppler beam sharpening technique used in fighter aircraft

R = 400:1:10000;      % Range
squint_angle = 90;    % Constant Squint angle

d_CR_RBGM_R = R.*theta_r;           % RBGM X-Range Resolutions vs. Range
d_CR_DBS_R = abs(lambda * R./(2*v*T*sind(squint_angle))); % DBS X-Range Resolutions vs. Range
d_CR_uSAR_R = sqrt(R.*lambda)/0.5;  % Unfocused SAR X-Range Resolutions vs. Range
d_CR_SAR_R = (D/2)*ones(size(R));   % Focused SAR X-Range Resolutions vs. Range

figure;
loglog(R,d_CR_RBGM_R,'b',"LineWidth",2);
hold on;
loglog(R,d_CR_DBS_R,'g',"LineWidth",2)
hold on;
loglog(R,d_CR_uSAR_R,'m',"LineWidth",2)
hold on;
loglog(R,d_CR_SAR_R,'y',"LineWidth",2)

legend('RBGM','DBS','unfocused SAR','focused SAR');
title('Cross Range Resolutions of Radar Imaging Methods');
ylabel('Cross Range Resolution - meter')
xlabel('Range - meter')
grid on
