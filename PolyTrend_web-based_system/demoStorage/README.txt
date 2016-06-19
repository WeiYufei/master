####################################################################################################################################
# EXPLANATION of the files in PolyTrendMatrices.zip      
# Yufei Wei, Lund University
# weiyufei2014@outlook.com


# The pixels in the results are viewed as unqualified if they fulfill at least one of the following criteria. 
##### For a single pixel in the results, at least one NDVI values in the whole time span is smaller than 0.
##### For a single pixel in the results, during the whole time span, the number of NDVI pixels that have a difference of less than 0.000001 comparing to the ones that represent adjacent years is larger than or equal to 3 times the number of NDVI pixels of the whole time span divided by 4.
##### For all matrices except SlopeMatrix.txt, the value of unqualified pixels is -12000.


# The pixels in the results are viewed as excluded if they are qualified pixels but are out of the desired range defined by the user.
##### For all matrices except SlopeMatrix.txt, the value of excluded pixels is -11000.

All .txt files can be opened in WordPad, MATLAB, Excel, ArcGIS, etc. and may appear unrecognized code when opened in Notepad.
####################################################################################################################################

# meanNDVIMatrix.txt -- Mean NDVI value of each pixel during the time period.
# minNDVIMatrix.txt -- Minimum NDVI value of each pixel during the time period.
# maxNDVIMatrix.txt -- Maximum NDVI value of each pixel during the time period.
# difNDVIMatrix.txt -- Differences in NDVI values of each pixel during the time period.
##### Normalized Difference Vegetation Index (NDVI) ranges from -1 to 1. It is used to assess to what extent the observed location contains vegetation. This index is computed from the equation: NDVI = (NIR - RED) / (NIR + RED), where NIR represents spectral reflectance measured in the near-infrared channel and RED represents spectral reflectance measured in the red channel.
##### Positive values of NDVI represent vegetation. The higher the value is, the higher-density vegetation the location has. Zero values of NDVI represent bare lands or rocks without vegetation. Negative values of NDVI indicate the existence of water, clouds or snow. In this algorithm, negative values are unqualified values since the algorithm focus on describing vegetation trends.


# TrendTypeMatrix.txt -- Trend type of each pixel. 3~cubic, 2~quadratic, 1~linear, 0~no_trend, -1~concealed
## Cubic:
##### The pattern of vegetation trends can be fitted by a cubic polynomial.
##### The net change of vegetation amount can be detected when the statistical significance level in a t-test is α.
## Quadratic:
##### The pattern of vegetation trends can be fitted by a quadratic polynomial.
##### The net change of vegetation amount can be detected when the statistical significance level in a t-test is α.
## Linear:
##### The pattern of vegetation trends can be fitted by a linear polynomial.
##### The net change of vegetation amount can be detected when the statistical significance level in a t-test is α.
## No-trend:
##### The pattern of vegetation trends can neither be fitted by a cubic, quadratic, nor linear polynomial.
##### No net change of vegetation amount can be detected when the statistical significance level in a t-test is α.
## Concealed:
##### The pattern of vegetation trends can be fitted by a cubic polynomial or a quadratic polynomial.
##### No net change of vegetation amount can be detected when the statistical significance level in a t-test is α.


SlopeMatrix.txt -- The inclination of the net change of NDVI of each pixel during the whole time period.
##### The extreme dark-blue pixels refer to unqualified and/or excluded pixels.
##### NaN in the matrix represents unqualified and/or excluded pixels.

DirectionMatrix.txt -- For each pixel, if the linear slope's value is negative the value will be -1, otherwise it will be 1.
##### Positive: In general, the net change of NDVI increases. 
##### Negative: In general, the net change of NDVI decreases.


SignificanceMatrix.txt -- For each pixel, if the trend type belongs to "cubic", "quadratic" or "linear" the value will be 1, otherwise it will be -1.
##### Significant: The trend type is cubic, quadratic or linear. 
##### Insignificant: The trend type is no-trend or concealed. 
       
