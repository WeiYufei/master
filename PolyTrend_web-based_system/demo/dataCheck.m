%---------------------------------------------------------------------------------------------
%  Check if the time-series should be processed. Time-series with         
%  any negative data value or with a low amplitude, indicating       
%  values over see or desert, should not be processed.   
%  y: a vector contains time-series NDVI values
%  Authors:                                                              
%  Per J\"onsson, Malm\"o University, Sweden 
%  Email: per.jonsson@ts.mah.se
%
%  Lars Eklundh, Lund University, Sweden 
%  Email: lars.eklundh@nateko.lu.se  
%
%  Yufei Wei, Lund University
%  Email: weiyufei2014@outlook.com  
%  Copyright (C) 2016 Per J\"onsson, Lars Eklundh, Yufei Wei
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
%  For a copy of the GNU General Public License,
%  see <http://www.gnu.org/licenses/>.  
%---------------------------------------------------------------------------------------------
function process = dataCheck(y)
npt=size(y,2);% count the number of NDVI values
dif=zeros(1,npt-1);% create a zero vector to store differences between each values comparing  
                   % with its neighbors
difpt=npt-1;% the number of the differences
signY=sign(y);% get the sign of each element
for i=1:difpt
    dif(i)=abs(y(i+1)-y(i));
end
if (sum(dif<1.e-6)>=3*npt/4)||any(signY==-1)% If at least one NDVI values in the whole 
                                            % time span is smaller than 0,
    process=0; % or if during the whole time span, the number of NDVI pixels that have   
else           % a difference of less than 0.000001 comparing to the ones that represent  
    process=1; % adjacent years is larger than or equal to 3 times the number of years 
end            % of the whole time span divided by 4, then the whole vector is viewed 
end            % as unqualified and will not be processed.
