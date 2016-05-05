%---------------------------------------------------------------------
%  This function receives a statistical significanc level, a definced range of displaying NDVI values, 
%  the original range of NDVI values and
%  a series of .tif files as a time-series dataset. It returns the
%  mean NDVI, minimum NDVI, maximum NDVI, differences in NDVI, trend type, linear slope,
%  direction and statistical significance of each pixel in the time-series
%  dataset by calling the PolyTrend function and two checking fuctions and plot the result.
%  significance:a statistical significance level, 
%  dataRangethe: the original range of NDVI values and 
%  minRange,maxRange: the definced range of displaying NDVI values
%  Author:
%  Yufei Wei,Lund University, Sweden 
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
%---------------------------------------------------------------------
function PolyTrendImage(significance,dataRange,minRange,maxRange)
clc;
load NDVIColorBar;% load the styles of colorbars that will be used for the result
load TrendTypeColorBar;
load DirectionColorBar;
load SignificanceColorBar;
di = dir('C:\demo\media\*.tif');
dirNumber=size(di,1);% define the folder to read all .tif files and record the number of time-series files
[rr,cc]=size(imread(['C:\demo\media\',di(1).name]));% get the size of image matrices
smallMatx=[];
for i=1:dirNumber
%readOrder=di(i).name% uncomment to see the reading order
temp=imread(['C:\demo\media\',di(i).name]);
    if dataRange==0
        smallMatx=[smallMatx;(double(temp))./10000];% build a big matrix that contains all time-series data if the range of the original NDVI values is [-10000,10000]
    else
        smallMatx=[smallMatx;double(temp)];% build a big matrix that contains all time-series data if the range of the original NDVI values is [-1,1]
    end
end
NVMean=zeros(rr,cc); % creating 8 zero matrices to store the result
NVMin=zeros(rr,cc);
NVMax=zeros(rr,cc);
NVDif=zeros(rr,cc);
TrType=zeros(rr,cc);
Slope=zeros(rr,cc);
Direct=zeros(rr,cc);
Sign=zeros(rr,cc);
for i=1:rr
    for j=1:cc
        tp=[smallMatx(i,j)];
        for ii=1:dirNumber-1%stack pixels that have same geographical locations but with different time periods
            ttp=smallMatx(i+ii*rr,j);
            tp=[tp;ttp];% each vector contains elements have same geographical locations but with different time periods
        end
        invtp=tp';% invert the vector for sending to the checking functions
        if dataCheck(invtp)==0
            NVMean(i,j)=-12000;% if the vector cannot pass the judgement of dataCheck function then the result values are                      
            NVMin(i,j)=-12000;%replaced by -12000, except the slope matrix (out of the plotting reason)
            NVMax(i,j)=-12000;
            NVDif(i,j)=-12000;
            TrType(i,j)=-12000;
            Slope(i,j)=NaN;
            Direct(i,j)=-12000;
            Sign(i,j)=-12000;
        else
            if rangeCheck(invtp,minRange,maxRange)==0
                NVMean(i,j)=-11000;% if the vector cannot pass the judgement of rangeCheck function then the result values are
                NVMin(i,j)=-11000;%replaced by -11000, except the slope matrix (out of the plotting reason)
                NVMax(i,j)=-11000;
                NVDif(i,j)=-11000;
                TrType(i,j)=-11000;
                Slope(i,j)=NaN;
                Direct(i,j)=-11000;
                Sign(i,j)=-11000;
            else
                NVMean(i,j)=mean(tp);% if the vector can pass both ckecking functions, calculates 7 kinds of values for stacks of time-series data
                NVMin(i,j)=min(tp);
                NVMax(i,j)=max(tp);
                NVDif(i,j)=max(tp)-min(tp);
                [TrTy,Slop,Dire,Signi]=PolyTrend(tp,significance);
                TrType(i,j)=TrTy;
                Slope(i,j)=Slop;
                Direct(i,j)=Dire;
                Sign(i,j)=Signi;
            end
        end
    end
end
%% 
NVMeanPlot=NVMean;% However, if the extreme low values appear together with values such as 0,1,.. 
NVMinPlot=NVMin;% then the colorbars will failed to show the distinction.
NVMaxPlot=NVMax;
NVDifPlot=NVDif;
TrTypePlot=TrType;
DirectPlot=Direct;
SignPlot=Sign;
for i=1:rr % Out of this reason, these values will be replaced by minus values near 0 for the convinence of plot.
    for j=1:cc % But for a good distinction of the matrices' result in txt, the value of -12000 and -11000 are still be used
        if NVMeanPlot(i,j)==-12000
            NVMeanPlot(i,j)=-0.4;
        end
        if NVMeanPlot(i,j)==-11000
            NVMeanPlot(i,j)=-0.2;
        end
        if NVMinPlot(i,j)==-12000
            NVMinPlot(i,j)=-0.4;
        end
        if NVMinPlot(i,j)==-11000
            NVMinPlot(i,j)=-0.2;
        end
        if NVMaxPlot(i,j)==-12000
            NVMaxPlot(i,j)=-0.4;
        end
        if NVMaxPlot(i,j)==-11000
            NVMaxPlot(i,j)=-0.2;
        end
        if NVDifPlot(i,j)==-12000
            NVDifPlot(i,j)=-0.4;
        end
        if NVDifPlot(i,j)==-11000
            NVDifPlot(i,j)=-0.2;
        end 
        if TrTypePlot(i,j)==-12000
            TrTypePlot(i,j)=-3;
        end
        if TrTypePlot(i,j)==-11000
            TrTypePlot(i,j)=-2;
        end
        if DirectPlot(i,j)==-12000
            DirectPlot(i,j)=-5;
        end
        if DirectPlot(i,j)==-11000
            DirectPlot(i,j)=-3;
        end
        if SignPlot(i,j)==-12000
            SignPlot(i,j)=-5;
        end
        if SignPlot(i,j)==-11000
            SignPlot(i,j)=-3;  
        end
    end
end
%% plotting mean NDVI values
fgNVMe = figure;
imagesc(NVMeanPlot);
colormap(NDVIColorBar);
caxis([-0.4,1]);
set(colorbar,'ytick',[-0.4:0.2:1],'yticklabel',{'Unqualified','Excluded','0','0.2','0.4','0.6','0.8','1.0'},'FontSize', 10,'FontName','Verdana');
title('Mean Values of NDVI','FontSize', 20,'FontName','Times New Roman');
xlabel('No.(row)','FontSize', 12,'FontName','Verdana');
ylabel('No.(column)','FontSize', 12,'FontName','Verdana');
print(fgNVMe,'-djpeg','C:\demoStorage\NDVI.jpg');
%% plotting minimum NDVI values
fgNVMi = figure;
imagesc(NVMinPlot);
colormap(NDVIColorBar);
caxis([-0.4,1]);
set(colorbar,'ytick',[-0.4:0.2:1],'yticklabel',{'Unqualified','Excluded','0','0.2','0.4','0.6','0.8','1.0'},'FontSize', 10,'FontName','Verdana');
title('Minimum Values of NDVI','FontSize', 20,'FontName','Times New Roman');
xlabel('No.(row)','FontSize', 12,'FontName','Verdana');
ylabel('No.(column)','FontSize', 12,'FontName','Verdana');
print(fgNVMi,'-djpeg','C:\demoStorage\NDVImin.jpg');
%% plotting maximum NDVI values
fgNVMa = figure;
imagesc(NVMaxPlot);
colormap(NDVIColorBar);
caxis([-0.4,1]);
set(colorbar,'ytick',[-0.4:0.2:1],'yticklabel',{'Unqualified','Excluded','0','0.2','0.4','0.6','0.8','1.0'},'FontSize', 10,'FontName','Verdana');
title('Maximum Values of NDVI','FontSize', 20,'FontName','Times New Roman');
xlabel('No.(row)','FontSize', 12,'FontName','Verdana');
ylabel('No.(column)','FontSize', 12,'FontName','Verdana');
print(fgNVMa,'-djpeg','C:\demoStorage\NDVImax.jpg');
%% plotting differences NDVI values
fgNVMa = figure;
imagesc(NVDifPlot);
colormap(NDVIColorBar);
caxis([-0.4,1]);
set(colorbar,'ytick',[-0.4:0.2:1],'yticklabel',{'Unqualified','Excluded','0','0.2','0.4','0.6','0.8','1.0'},'FontSize', 10,'FontName','Verdana');
title('Differences of NDVI values','FontSize', 20,'FontName','Times New Roman');
xlabel('No.(row)','FontSize', 12,'FontName','Verdana');
ylabel('No.(column)','FontSize', 12,'FontName','Verdana');
print(fgNVMa,'-djpeg','C:\demoStorage\NDVIdif.jpg');
%% plotting trend type values
fgTrTy = figure;
imagesc(TrTypePlot);
colormap(TrendTypeColorBar);
caxis([-3,3]);
set(colorbar,'ytick',[-3:1:3],'yticklabel',{'Unqualified','Excluded','Concealed','No-trend','Linear','Quadratic','Cubic'},'FontSize', 10,'FontName','Verdana');
title('Trend Types','FontSize', 20,'FontName','Times New Roman');
xlabel('No.(row)','FontSize', 12,'FontName','Verdana');
ylabel('No.(column)','FontSize', 12,'FontName','Verdana');
print(fgTrTy,'-djpeg','C:\demoStorage\TrendType.jpg');
%% plotting statistical significance values
fgSigni = figure;
imagesc(SignPlot);
colormap(SignificanceColorBar);
caxis([-5,1]);
set(colorbar,'ytick',[-5:2:1],'yticklabel',{'Unqualified','Excluded','Insignificant','Significant'},'FontSize',10,'FontName','Verdana');
title('Statistical Significance','FontSize', 20,'FontName','Times New Roman');
xlabel('No.(row)','FontSize', 12,'FontName','Verdana');
ylabel('No.(column)','FontSize', 12,'FontName','Verdana');
print(fgSigni,'-djpeg','C:\demoStorage\Significance.jpg');
%% plotting linear slope values
fgSlop = figure;
imagesc(Slope);
colormap('jet');
set(colorbar,'FontSize', 12,'FontName','Verdana');
title('Linear Slopes','FontSize', 20,'FontName','Times New Roman');
xlabel('No.(row)','FontSize', 12,'FontName','Verdana');
ylabel('No.(column)','FontSize', 12,'FontName','Verdana');
print(fgSlop,'-djpeg','C:\demoStorage\Slope.jpg');
%% plotting direction values
fgDire = figure;
imagesc(DirectPlot);
colormap(DirectionColorBar);
caxis([-5,1]);
set(colorbar,'ytick',[-5:2:1],'yticklabel',{'Unqualified','Excluded','Negative','Positive'},'FontSize', 10,'FontName','Verdana');
title('Directions','FontSize', 20,'FontName','Times New Roman');
xlabel('No.(row)','FontSize', 12,'FontName','Verdana');
ylabel('No.(column)','FontSize', 12,'FontName','Verdana');
print(fgDire,'-djpeg','C:\demoStorage\Direction.jpg');
%% deleting all files that used in the calculation, saving results as txt files and zipping them
cd('C:\demo\media'); 
delete('*.tif');
cd('C:\demoStorage'); 
save meanNDVIMatrix.txt -ascii NVMean;
save minNDVIMatrix.txt -ascii NVMin;
save maxNDVIMatrix.txt -ascii NVMax;
save difNDVIMatrix.txt -ascii NVDif;
save TrendTypeMatrix.txt -ascii TrType;
save SlopeMatrix.txt -ascii Slope;
save DirectionMatrix.txt -ascii Direct;
save SignificanceMatrix.txt -ascii Sign;
zip('PolyTrendMatrices.zip',{'meanNDVIMatrix.txt','minNDVIMatrix.txt','maxNDVIMatrix.txt','difNDVIMatrix.txt','TrendTypeMatrix.txt','SlopeMatrix.txt','DirectionMatrix.txt','SignificanceMatrix.txt','README.txt'});
delete('meanNDVIMatrix.txt');
delete('minNDVIMatrix.txt');
delete('maxNDVIMatrix.txt');
delete('difNDVIMatrix.txt');
delete('TrendTypeMatrix.txt');
delete('SlopeMatrix.txt');
delete('DirectionMatrix.txt');
delete('SignificanceMatrix.txt');
clear;
clc;
end


