%intializing of data
clear all;
clc;
x = zeros(1,4);
y = zeros(1,4);
xp = zeros(1,4);
yp = zeros(1,4);
x1 = zeros(1,4);
y1 = zeros(1,4);
x11 = zeros(1,4);
y11 = zeros(1,4);
L = zeros(1,3);
A = zeros(1,3);
B = zeros(1,3);
C = zeros(1,3);
pol = zeros(1,3);
theta = zeros(1,3);
theta1 = zeros(1,3);
m = 0;

L(1) = 0.5;
L(2) = 0.5;
L(3) = 0.5;



x1(4) =  1.2*cosd(105);
y1(4) = 1.2*sind(105);
    
% Selection of Element
str={'180`','90`','0`','45`','135`','-45`','previous location','10`'};
[Element,EOK] = listdlg('PromptString','Select an Element:',...
                'SelectionMode','single',...
                'ListString',str);
if EOK == 1
    switch Element
        case 1
            x(1) = 0;
            y(1) = 0;

            x(2) = -0.5;
            y(2) = 0;

            x(3) = -1.0;
            y(3) = 0;

            x(4) = -1.5;
            y(4) = 0;
        case 2
            x(1) = 0;
            y(1) = 0;

            x(2) = 0;
            y(2) = 0.5;

            x(3) = 0;
            y(3) = 1.0;

            x(4) = 0;
            y(4) = 1.5;
        case 3
            x(1) = 0;
            y(1) = 0;

            x(2) = 0.5;
            y(2) = 0;

            x(3) = 1.0;
            y(3) = 0;

            x(4) = 1.5;
            y(4) = 0;
        case 4
            x(1) = 0;
            y(1) = 0;

            x(2) = 0.353553;
            y(2) = 0.353553;

            x(3) = 0.707107;
            y(3) = 0.707107;

            x(4) = 1.06066;
            y(4) = 1.06066;
        case 5
            x(1) = 0;
            y(1) = 0;

            x(2) = -0.353553;
            y(2) = 0.353553;

            x(3) = -0.707107;
            y(3) = 0.707107;

            x(4) = -1.06066;
            y(4) = 1.06066;
         case 6
            x(1) = 0;
            y(1) = 0;

            x(2) = 0.353553;
            y(2) = -0.353553;

            x(3) = 0.707107;
            y(3) = -0.707107;

            x(4) = 1.06066;
            y(4) = -1.06066;
         case 7
              x = xp;
              y = yp;
         case 8
            x(1) = 0;
            y(1) = 0;

            x(2) = 0.5*cosd(32);
            y(2) = 0.5*sind(32);

            x(3) = 1.0*cosd(32);
            y(3) = 1.0*sind(32);

            x(4) = 1.5*cosd(32);
            y(4) = 1.5*sind(32);
    end
else
    disp('Enter the location type');
end

% check for reachablity
reach = sqrt((x1(4)^2)+(y1(4)^2));
if(reach < (L(1)+L(2)+L(3)))
    disp('yeah!! Reachable');
else
    disp('check the points, idiot!!')
end

ex = x1(4)- x(4); 
ey = y1(4)- y(4);

figure;
plot (x,y,'k');
axis([-2 2 0 2]);
hold on


  %% Reverse Reaching
% line 3 1st iterationr
while (abs(ex) > 0.09 || abs(ey)> 0.09) 
for p = 3 : -1:1
    theta(p) = atan2d((y1(p+1)-y(p)),(x1(p+1)-x(p))); %slope of line 3
    theta
    %restriction on wrist
    if(x1(4)>0 && acosd(x1(4)/1.2)< 30)
           theta(3)= 30;
    elseif(x1(4)>0 && acosd(x1(4)/1.2)>30)
           theta(3)=89;
    elseif(x1(4)<0)
           theta(3)= 91;
    end
    %angles in postive 
    if(theta(p) < 0)
          theta(p) = theta(p)+360;
    end
    %link 2 constraint
    cnst21 = theta(3)+210;
    cnst22 = theta(3)+240;
    %link 1 constraint
    cnst11 = theta(2)+210;
    cnst12 = theta(2)+240;
      if(theta(2) > cnst21 && theta(2)< cnst22)
          a21 = theta(2)-cnst21;
          a22 = theta(2)-cnst22;
          if(a21 < a22)
            theta(2) = cnst21;
          elseif (a21 > a22);
            theta(2) = cnst22;
          end
      end
      
      if(theta(1) > cnst21 && theta(1)< cnst22)
          a11 = theta(1)-cnst11;
          a12 = theta(1)-cnst12;
          if(a11 < a12)
            theta(1) = cnst11;
          elseif (a11 > a12);
            theta(1) = cnst12;
          end
      end
          
        %here only add last angle constrant
      if (theta(1)> 180)
          a01 = theta(1)-0;
          a02 = theta(1)-180;
          if(a01 < a02)
            theta(1) = 0;
          elseif (a01 > a02);
            theta(1) = 180;
          end
      end
      
           posx1 = x1(p+1) - sqrt((L(p))^2/(tand(theta(p))^2 +1)); % check for condition +/-
           posy1 = y1(p+1) - (tand(theta(p))*(x1(p+1)-x1(p)));
           d1 = sqrt(posx1^2+posy1^2);
           posx2 = x1(p+1) + sqrt((L(p))^2/(tand(theta(p))^2 +1)); % check for condition +/-
           posy2 = y1(p+1) - (tand(theta(p))*(x1(p+1)-x1(p)));
           d2 = sqrt(posx2^2+posy2^2);
      if(d1<d2)
          x1(p) = posx1;   
          y1(p) = posy1;
      elseif(d1>d2)
          x1(p) = posx2;  
          y1(p) = posy2;
      else
          x1(p) = posx2  
          y1(p) = posy2
      end
end
% polarity run
    for p = 1 : 1:3
    pol(p) = x1(p+1)-x1(p);
    end
    figure (2)
    plot (x1,y1,'k');
    axis([-2 2 0 2]);
    hold on
    
%% forward reaching
    for p = 2 : 1:4
            %check the run
           if (pol(p-1) > 0)
           x11(p) = x11(p-1) + sqrt((L(p-1))^2/(tand(theta(p-1))^2 +1)); % check for condition +/-
           elseif(pol(p-1)<0)
           x11(p) = x11(p-1) - sqrt((L(p-1))^2/(tand(theta(p-1))^2 +1)); % check for condition +/-
           end
           y11(p) = y11(p-1) - (tand(theta(p-1))*(x11(p-1)-x11(p))); 
    end
    x = x11;
    y = y11;% reassigment of new co ordinates
%     theta0 = theta;
%     theta
     m=m+1
%  error estimation on each axes
    ex = x11(4)- x1(4)
    ey = y11(4)- y1(4)
    
end
    figure (3)
    plot (x11,y11,'k');
    axis([-2 2 0 2]);
    hold on
%% angle calculation
    for p = 1 : 1:3
    theta1(p) = atan2d((y11(p+1)-y11(p)),(x11(p+1)-x11(p)));
    end
    theta1
    
% loading previous values
    xp = x11;
    yp = y11;