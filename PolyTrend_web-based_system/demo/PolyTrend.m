%---------------------------------------------------------------------
%  This function detects nonlinear/linear trend in time series of a pixel data
%  and determines the trend type, slope, direction, and statistical significance.
%  Sadegh Jamali                                                                
%  Lund University, Sweden                                                      
%  E-mail: Sadegh.Jamali@nateko.lu.se 
%  Copyright (C) 2016 Sadegh Jamali
%  
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation, either version 3 of the License, or
%  (at your option) any later version.
%  
%  This program is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
%  
%  You should have received a copy of the GNU General Public License
%  along with this program.  If not, see <http://www.gnu.org/licenses/>. 
%---------------------------------------------------------------------
function [Trend_type,Slope,Direction,Significance]=PolyTrend(Y,alpha)
% Y: time series pixel data (column vector)
% alpha: statistical significance level 
% Trend_type: -1=concealed, 0=no trend, 1=linear,  2=quadratic, 3=cubic 
% Slope: linear slope value
% Direction: 1=positive ; -1=negative
% Significance: 1=statistically significant ; -1=statistically insignificant
X=(1:length(Y))';       
[p3,S3]=polyfit(X,Y,3); % Cubic fit
Roots3=roots([3*p3(1),2*p3(2),p3(3)]);
Roots3=sort(Roots3,'ascend');
Pcubic=Pvalue(p3(1),S3.R,S3.normr,S3.df);% Pvalue is a function to test significance of the obtained fit (cubic here) coefficient
if imag(Roots3(1))==0  && imag(Roots3(2))==0  && Roots3(1)~=Roots3(2) && X(1)<=Roots3(1) && Roots3(1)<=X(end) && X(1)<=Roots3(2) && Roots3(2)<=X(end) && Pcubic<alpha
    [p1,S1]=polyfit(X,Y,1);% linear fit
    Plin=Pvalue(p1(1),S1.R,S1.normr,S1.df);% P value for linear coefficient
    Slope=p1(1); % slope value
    Direction=sign(Slope); % slope direction (positive or negative) 
    if Plin<alpha
        Trend_type=3;% 3 means cubic trend
        Significance=1; % 1 means significant linear trend
        Poly_degree=3; % polynomial degree
    else
        Trend_type=-1;% -1 means concealed trend
        Significance=-1; % -1 means in-significant linear trend
        Poly_degree=3; % polynomial degree
    end 
else
    [p2,S2]=polyfit(X,Y,2);% Quadratic fit
    Roots2=roots([2*p2(1),p2(2)]);
    Pquadratic=Pvalue(p2(1),S2.R,S2.normr,S2.df);% P value for the quadratic coefficient
   
    if X(1)<=Roots2 && Roots2<=X(end) && Pquadratic<alpha
        [p1,S1]=polyfit(X,Y,1);% linear fit
        Plin=Pvalue(p1(1),S1.R,S1.normr,S1.df);% P value for the linear coefficient
        Slope=p1(1); % slope value
        Direction=sign(Slope); % slope direction (positive or negative) 
        if Plin<alpha
            Trend_type=2;% 2 means quadratic trend
            Significance=1; % 1 means significant linear trend
            Poly_degree=2; % polynomial degree
        else
            Trend_type=-1;% -1 means concealed trend
            Significance=-1; % -1 means insignificant linear trend
            Poly_degree=2; % polynomial degree     
        end          
    else                           
        [p1,S1]=polyfit(X,Y,1);% Linear fit
        Plin=Pvalue(p1(1),S1.R,S1.normr,S1.df);% P value for the linear coefficient
        Slope=p1(1); % slope value
        Direction=sign(Slope); % slope direction (positive or negative)      
        if Plin<alpha
            Trend_type=1;% 1 means linear trend 
            Significance=1; % 1 means significant linear trend      
            Poly_degree=1; % polynomial degree
        else
            Trend_type=0;% 0 means no-trend type
            Significance=-1; % -1 means in-significant linear trend        
            Poly_degree=0; % polynomial degree
        end
    end
end
end