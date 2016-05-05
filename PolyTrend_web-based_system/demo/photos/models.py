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
from django.db import models
from demo.settings import MEDIA_ROOT

# Create your models here.
class Photo( models.Model ):
    file = models.FileField( upload_to = MEDIA_ROOT )
