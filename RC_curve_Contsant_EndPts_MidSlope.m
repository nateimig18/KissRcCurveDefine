clear all, close all, clc

% KISS FC ripped from "http://ultraesc.de/KISSFC/rates.html" under inspect "head-script"
poly_rc = @(x, r, pr) (x.^3.*pr + x - pr.*x).*(r/10);
expo_rc = @(x, ar) 1./(1 - abs(x).*ar);
f = @(x, r, ar, pr) round(2000 * expo_rc(x, ar) .* poly_rc(x, r, pr)*100)/100;

NC = 5;                    % Number of curves
ENDPT = 720;               % Define end points "full-stick" maximum rotational vel.
CENTERSLOPE = 160;         % Define "center-stick" sensitivity.
LINP = 2;                  % Linear bound percentage Increase in Sensitivity
LINBND = 300;  

NX = 2000;                 % Number of steps (for taranis???)
HIPT = ENDPT / 200         % 1-200*rr/ENDPT > 0    ==>   rr <= ENDPT /200
LOPT = CENTERSLOPE / 200   % 1-SLOPE/(200*rr) > 0  ==>   SLOPE/200 <= rr

xx = linspace(-1, 1, NX);                    % (1xNX) Create RC Input variable x
rr = logspace(log10(LOPT), log10(HIPT), NC); % (1xNR) RC Rate   (Increase linear slop of curve
ar = abs(1 - 200*rr / ENDPT);                % (1xNR) Condition maintains the same max rotation rate
pr = abs(1 - CENTERSLOPE ./(200*rr));        % (1xNR) Expo Rate (Adds in a geometric expo, flattens mid region but increases the slop on the ends)

XX(1:NX,    1) = xx;    XX = repmat(XX, 1, NC);
PR(   1, 1:NC) = pr;    PR = repmat(PR, NX, 1);
RR(   1, 1:NC) = rr;    RR = repmat(RR, NX, 1);
AR(   1, 1:NC) = ar;    AR = repmat(AR, NX, 1);

y = f(XX, RR, AR, PR);
yDiff = diff(y, 1);
Gs = max(yDiff, [], 1) ./ min(yDiff, [], 1); % Sensitivity Gain
mnDy = min(yDiff(:, 1));

Tol = 0.1;
LINPW = zeros(1, NC); 
PWn = zeros(1, NC);
for i = 1:NC,  
   Dy = yDiff(:, i);
   
   % iDy = find((((1+LINP)*(mnDy)) <= Dy) .* (Dy <= ((1+LINP+Tol)*(mnDy))) );
   % iDy = find((LINBND <= Dy) & (Dy <= (LINBND*(1+Tol))) );
   iDy = find(( Dy >= LINBND/(NX/2) ) & (Dy <= LINBND*(1+Tol)/(NX/2)));
   
   iDy = iDy(find(iDy > length(Dy)/2));
   iDy = iDy(1);
   PWn(i) = iDy; 
   LINPW(i) = XX(iDy-1);
end 

[~, tbarH] = system('powershell; Add-Type -AssemblyName System.Windows.Forms;  $x = [System.Windows.Forms.Screen]::AllScreens; $x.Bounds.Size.Height - $x.WorkingArea.Size.Height;')
tbarH = str2double(tbarH)

figure(1);
set(gcf,'units','pixels','outerposition',[0 tbarH 1925 1080-tbarH]);
lgd = {};

subplot(1,2,1);
% title('KISS RC Curve''s w/ Sensitivity = !');
plot(XX(:,:), y(:,:)); hold;  
title(sprintf('KISS RC Curve''s w/ Center-Sensitivity = %4.3f $\\left( \\frac{deg}{sec \\cdot \\Delta} \\right)$, End Pts. = %d $\\left( \\frac{deg}{sec} \\right)$', CENTERSLOPE/1000, ENDPT),'interpreter','latex');


xn = linspace(-0.1, 0.1);
yn = CENTERSLOPE*xn;
plot(xn, yn, 'LineWidth', 2.5);
plot([-1;1;0], [-ENDPT;+ENDPT;0], 'ro')

for i = 1:NC,  lgd{i} = sprintf('RC Rate:%3.2f; Rate:%3.2f; Curve:%3.2f, G_S=%3.2f', rr(i), ar(i), pr(i), Gs(i));  end
legend(lgd, 'Location', 'SouthEast');

MARG = 0.05;
set(gca, 'Position', [0.03, 0.03, 0.5-2*0.03, 1-2*0.03]);   % LFTMARG, BOTMARP, WIDTH, HEIGHT

subplot(1,2,2);
plot(XX(1:end-1,:), yDiff(:,:)); hold;       
title(sprintf('KISS RC Sensitivity Curve''s w/ Center-Sensitivity = %4.3f $\\left( \\frac{deg}{sec \\cdot \\Delta} \\right)$, End Pts. = %d $\\left( \\frac{deg}{sec} \\right)$', CENTERSLOPE/1000, ENDPT),'interpreter','latex');
set(gca, 'Position', [0.5+0.03, 0.03, 0.5-2*0.03, 1-2*0.03]);  
plot(LINPW', repmat(LINBND/(NX/2), NC, 1), 'ro');

for i = 1:NC, lgd{i} = sprintf('RC Rate:%3.2f; Rate:%3.2f; Curve:%3.2f, G_S=%3.2f', rr(i), ar(i), pr(i), Gs(i));  end 
legend(lgd, 'Location', 'North');


%drawnow;
%set(get(handle(gcf),'JavaFrame'),'Maximized',1);

% Maximize figure with a hidden Java handle 
%pause(0.00001);
%frame_h = get(handle(gcf),'JavaFrame');
%set(frame_h,'Maximized',1);