clear all, close all, clc

% KISS FC ripped from "http://ultraesc.de/KISSFC/rates.html" under inspect "head-script"
poly_rc = @(x, r, pr) (x.^3.*pr + x - pr.*x).*(r/10);
expo_rc = @(x, ar) 1./(1 - abs(x).*ar);
f = @(x, r, ar, pr) round(2000 * expo_rc(x, ar) .* poly_rc(x, r, pr)*100)/100;

NC = 5;                    % Number of curves
ENDPT = 800;               % Define end points "full-stick"         
CENTERSLOPE = 150;         % Define "center-stick" sensitivity
NX = 2000;                 % Number of steps 

HIPT = ENDPT / 200         % 1-200*rr/ENDPT > 0    ==>   rr <= ENDPT /200
LOPT = CENTERSLOPE / 200   % 1-SLOPE/(200*rr) > 0  ==>   SLOPE/200 <= rr

xx = linspace(-1, 1, NX);                    % (1xNX) Create RC Input variable x
rr = logspace(log10(LOPT), log10(HIPT), NC); % (1xNR) RC Rate   (Increase linear slop of curve
ar = 1 - 200*rr / ENDPT;                     % (1xNR) Condition maintains the same max rotation rate
pr = 1 - CENTERSLOPE ./(200*rr);                % (1xNP) Expo Rate (Adds in a geometric expo, flattens mid region but increases the slop on the ends)

XX(1:NX,    1) = xx;    XX = repmat(XX, 1, NC);
PR(   1, 1:NC) = pr;    PR = repmat(PR, NX, 1);
RR(   1, 1:NC) = rr;    RR = repmat(RR, NX, 1);
AR(   1, 1:NC) = ar;    AR = repmat(AR, NX, 1);

yuso = f(XX, RR, AR, PR);

figure(1);
plot(XX(:,:), yuso(:,:)); hold;
title('Define your KISS poison!');

xn = linspace(-0.1, 0.1);
yn = CENTERSLOPE*xn;
plot(xn, yn, 'LineWidth', 2.5);
plot([-1;1;0], [-ENDPT;+ENDPT;0], 'ro')

lgd = {};
for i = 1:NC,  lgd{i} = sprintf('RC Rate:%3.2f; Rate:%3.2f; Curve:%3.2f', rr(i), ar(i), pr(i));  end 
legend(lgd, 'Location', 'SouthEast');


yusoDiff = diff(yuso, 1);

figure(2);
plot(XX(1:end-1,:), yusoDiff(:,:)); hold;       title('Define your KISS poison!');
lgd = {};
for i = 1:NC,  lgd{i} = sprintf('RC Rate:%3.2f; Rate:%3.2f; Curve:%3.2f', rr(i), ar(i), pr(i));  end 
legend(lgd, 'Location', 'North');