%---------------------------------------------------------------------
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
%  Yufei Wei, Lund University, Sweden 
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
%  You should have received a copy of the GNU General Public License
%  along with this program.  If not, see <http://www.gnu.org/licenses/>.
%---------------------------------------------------------------------
function process = dataCheck(y)
npt=size(y,2);% count the number of NDVI values
dif=zeros(1,npt-1);% create a zero vector to store differences between each values comparing with its neighbors
for i=1:npt-1
    dif(i)=abs(y(i+1)-y(i));
end
if (sum(dif<1.e-6)>=3*npt/4)||any(sign(y)==-1)% If at least one NDVI values in the whole time span is smaller than 0,
    process=0; %or if during the whole time span, the number of NDVI pixels that have a difference of less than 0.000001  
else           % comparing to the ones that represent adjacent years is larger than or equal to 3 multiplies the number of 
    process=1; % years of whole time span divided by 4,
end            % then the whole vector is viewed as unqualified and will not be processed.
end
