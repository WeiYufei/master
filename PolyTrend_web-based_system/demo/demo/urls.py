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
from django.conf import settings
from django.conf.urls import patterns,url
from django.conf.urls.static import static
from photos import views
urlpatterns = patterns('',
    url( r'^$', views.entry, name = 'entry' ),
    url( r'^home/$', views.Home.as_view(), name = 'home' ),
    url( r'upload/', views.upload, name = 'jfu_upload' ),
    url( r'^delete/(?P<pk>\d+)$', views.upload_delete, name = 'jfu_delete' ),
    url( r'result/$', views.result, name='result'),
    url( r'info/$', views.info, name='info'),
    url(r'^count/$', views.count, name='count'),
    url( r'about/$', views.about, name='about'),
    url( r'terms/$', views.terms, name='terms'),

    (r'^site_media/(?P<path>.*)','django.views.static.serve',{'document_root':'C:/demoStorage'}),  
)
urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT) 
