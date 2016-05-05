%---------------------------------------------------------------------
%  This function computes p-value for testing statistical significance 
%  of first coefficient of a polynomial (i.e. a) in ax^n+bx^(n-1)+...
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
function p=Pvalue(coef,R,normr,df)
% coef: the first coefficient of the polynomial
% R, normr, and df are fields of the structure S (see help for the polyfit)
           VC=(inv(R))*(inv(R))'*(normr^2)/df; % Variance-Covariance Matrix (see help for the polyfit), same as VC=inv(A'*A)*(normr^2)/df, if A is the design matrix (L=A.X)
           VC1=sqrt(VC(1,1));% Variance of the first coefficient
           statistic=(coef)/VC1;% t_ststistic to test significance of the first coefficient 
           p=2*(1-tcdf(abs(statistic),df));% p value 
end
