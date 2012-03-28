import pybotrixindex
import numpy
import math
import time

def botrix(tempday,precday):
    result=[]
    for i in range(len(tempday)):
        if (tempday[i]!= -9999 and precday[i] != -9999):
            if(tempday[i] < 12):
		tempday[i]=12
            if(tempday[i] > 32 and tempday[i]< 40):
		tempday[i]= 32
            tmp=calcolo(tempday[i], precday[i])
            if(tempday[i]>= 40):
		tmp=0
            if(precday[i] < 4):
		tmp=0
        else:
            tmp= -9999
        result.append(tmp)
    return result

def calcolo(x,y):
    b0 = -2.647866
    b1 = -0.374927
    b2 = 0.061601
    b3 = -0.001511          
    return math.exp(b0+(b1*y)+(b2*y*x)+(b3*y*(x*x))) / (1+math.exp(b0+(b1*y)+(b2*y*x)+(b3*y*(x*x))))

im = open("Tgrd_20040815_AVG.txt")
tempday=im.readline().split()
im = open("Pgrd_20010115_AVG.txt")
precday=im.readline().split()
tempday_ar=numpy.array(tempday, dtype="float32")
precday_ar=numpy.array(precday, dtype="float32")
inizio_gpu=time.time()
#tempday_ar[0]=0
#precday_ar[0]=0
for i in range(367):
#    tempday_ar[0]+=1
#    tempday_ar[0]%=40
#    precday_ar[0]+=1
#    precday_ar[0]%=30
    result_cuda=pybotrixindex.botrix_index(tempday_ar,precday_ar)
#    print result_cuda[0]
#    print i
fine_gpu=time.time()
inizio_cpu=time.time()
#result_cpu=numpy.array(botrix(tempday_ar,precday_ar), dtype="float32")
#for i in range(10):
#    tempday_ar[0]+=1
#    tempday_ar[0]%=40
#    precday_ar[0]+=1
#    precday_ar[0]%=30
#result_cpu=botrix(tempday_ar,precday_ar)
#    print result_cpu[0]
#    print i
fine_cpu=time.time()
#print "cuda"
#print result_cuda
#print "cpu"
#print result_cpu

print "Tempo impiegato GPU:"
print fine_gpu-inizio_gpu
print "Tempo impiegato python:"
print fine_cpu-inizio_cpu

import csv
writer=csv.writer(open("output_python.txt","wb"),delimiter=" ")
writer.writerow(result_cpu)
writer=csv.writer(open("output_cuda.txt","wb"),delimiter=" ")
writer.writerow(result_cuda)
