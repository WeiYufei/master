%---------------------------------------------------------------------------------------------
%  Check if the time-series should be processed. Time-series with any data value that        
%  is out of a predefined range should not be processed.   
%  y: a vector contains time-series NDVI values
%  Author:                                                                                                                          
%  Yufei Wei, Lund University 
%  Email: weiyufei2014@outlook.com       
%  Copyright (C) 2016 Yufei Wei
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
%---------------------------------------------------------------------------------------------
function process = rangeCheck(y,minRange,maxRange)
minValue=min(y);
maxValue=max(y);
if minValue<minRange || maxValue>maxRange
    process=0;
else
    process=1;
end
end
