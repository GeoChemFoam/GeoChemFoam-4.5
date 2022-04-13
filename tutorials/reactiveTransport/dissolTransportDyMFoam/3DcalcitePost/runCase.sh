#!/bin/bash




# ###### DO NOT MAKE CHANGES FROM HERE ###################################



set -e


python << END
import os


def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        return False


a=0;
s=str(0);

for n in range(0,9001,1800):
  os.system('cp system/controlDictRun system/controlDict')
  os.system('sed -i "s/var/'+str(n)+'/g" system/controlDict') 
  while a<n:
    os.system('echo time='+s)
    os.system('echo "decomposePar"')
    os.system('decomposePar >> 3DcalcitePost.out')
    os.system('echo "Run dissolTransportDyMFoam in parallel"')
    os.system('mpiexec -np 8 dissolTransportDyMFoam -parallel >> 3DcalcitePost.out')
    os.system('reconstructPar >> 3DcalcitePost.out' )
    os.system('rm -rf processor*')
    for directories in os.listdir(os.getcwd()): 
      if (is_number(directories)):
        if (float(directories)>a):
          a=float(directories)
          s=directories
    os.system('echo  "remesh"')
    os.system( './remesh.sh >> 3DcalcitePost.out') 
    os.system('echo "mapFields"')
    os.system('mapFields ../3DcalcitePost -case ../temp -sourceTime latestTime >> 3DcalcitePost.out')
    os.system('mv ../temp/0/pointMotionU* ../temp/0/pointMotionU')
    os.system('rm -rf '+s)
    os.system('mv ../temp/0 ./'+s)
    os.system('rm -rf ../temp')
END

echo -e "processPoroPerm"
processPoroPerm > processPoroPer.out


