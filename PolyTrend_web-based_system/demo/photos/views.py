# <!-- 
#   Yufei Wei, Lund University
#   E-mail: weiyufei2014@outlook.com 
#   Copyright (C) 2016  Yufei Wei
# 
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
# 
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
# 
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
import os
from django.http import HttpResponse
from django.conf import settings
from django.core.urlresolvers import reverse
from django.views import generic
from django.views.decorators.http import require_POST
from jfu.http import upload_receive, UploadResponse, JFUResponse
from photos.models import Photo
from django.shortcuts import render
import matlab.engine
class Home( generic.TemplateView ):
    template_name = 'base.html'

    def get_context_data(self, **kwargs):
        context = super( Home, self ).get_context_data( **kwargs )
        context['accepted_mime_types'] = ['image/*']
        return context
    
@require_POST
def upload( request ):
    # The assumption here is that jQuery File Upload
    # has been configured to send files one at a time.
    # If multiple files can be uploaded simulatenously,
    # 'file' may be a list of files.
    file = upload_receive( request )
    instance = Photo( file = file )
    instance.save()
    basename = os.path.basename( instance.file.path )
    file_dict = {
        'name' : basename,
        'size' : file.size,
        'url': settings.MEDIA_URL + basename,
        'thumbnailUrl': settings.MEDIA_URL + basename,
        'deleteUrl': reverse('jfu_delete', kwargs = { 'pk': instance.pk }),
        'deleteType': 'POST',
    }
    return UploadResponse( request, file_dict )

@require_POST
def upload_delete( request, pk ):
    success = True
    try:
        instance = Photo.objects.get( pk = pk )
        os.unlink( instance.file.path )
        instance.delete()
    except Photo.DoesNotExist:
        success = False
    return JFUResponse( request, success )

def result(request):
    targetDir=os.listdir('C:/demo/media')
    fileNumber=len(targetDir)#count how many files in the folder
    i=0
    dictionary=dict()
    while i<fileNumber:
        dirFileName=targetDir[i]
        fileFullName='C:/demo/media/'+(str(dirFileName))
        creationTime=os.stat(fileFullName).st_ctime_ns #get the creation time of the file in unit of nanoseconds
        dictionary[creationTime]=dirFileName #create a item of the dictionary
        i=i+1
    ###print (dictionary) # uncomment this line to see the dictionary, key is creation time, value is filename 

    dicKey=dictionary.keys()# get the keys of the dictionary, in original order
    originalNameList=[]# create an empty for storing original names of files
    newNameList=[]# create an empty for storing new names of files
    ordNumber=10000000001  # a part of new prefix 
    for j in sorted(dicKey):
        ###print (j,dictionary[j]) uncomment this line to see items in dict
        originalNameList.append(str(dictionary[j]))
        combineName='tif'+str(ordNumber)+'.tif'# new file name
        newNameList.append(combineName)
        ordNumber=ordNumber+1
#     print (originalNameList)
#     print (newNameList)
    lg=len(originalNameList)
    while lg>0:
        oriName=originalNameList.pop()# pop begins from tails, each time pop one from old name list and new name list respectively
        newName=newNameList.pop()
        os.rename('C:/demo/media/'+str(oriName),'C:/demo/media/'+str(newName))# rename
        lg=lg-1
    getDict=request.GET
    if len(getDict)==5:# if the user chooses the default range then the number of parameter sent from the from tend will be 5
        significanceLevel=getDict['significanceLevel']
        matlabSignificance=float(significanceLevel)
        dataRange=getDict['dataRange']
        matlabDataRange=int(dataRange)
        defaultMinRange=getDict['defaultMinRange']
        matlabMinRange=float(defaultMinRange)
        defaultMaxRange=getDict['defaultMaxRange']
        matlabMaxRange=float(defaultMaxRange)
    else:# if the user chooses the default range then the number of parameter sent from the from tend will be 5
        significanceLevel=getDict['significanceLevel']
        matlabSignificance=float(significanceLevel)
        dataRange=getDict['dataRange']
        matlabDataRange=int(dataRange)
        customizeMinRange=getDict['customizeMinRange']
        matlabMinRange=float(customizeMinRange)
        customizeMaxRange=getDict['customizeMaxRange']
        matlabMaxRange=float(customizeMaxRange)
#     print (matlabSignificance,matlabDataRange,matlabMinRange,matlabMaxRange) #uncomment this to see all input arguments
    eng = matlab.engine.start_matlab()
    eng.PolyTrendImage(matlabSignificance,matlabDataRange,matlabMinRange,matlabMaxRange,nargout=0)# call Matlab function
    return render(request, 'result.html')


def entry(request):
    return render(request, 'entry.html')
def info(request):
    return render(request, 'oneTab.html')
def about(request):
    return render(request, 'about.html')
def terms(request):
    return render(request, 'terms.html')
def count(request):# count the number of the uploaded files
    targetFolder=os.listdir('C:/demo/media')
    countFile=len(targetFolder) 
    return HttpResponse(str(countFile))

