#Python script to generate both LUTPackage.vhd, parametersPackage.vhd and stimulus.txt

import argparse #argparse is to parse command line arguments
#import os
import numpy as np

# construct the argument parse and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-n", "--ncobits", required=True,help="Number of bits for nco accumulator (12 bits max)")
ap.add_argument("-f", "--fconbits", required=True,help="Number of bits for frequency control word (ncoBits bits max)")
ap.add_argument("-d", "--databits", type=int, default=8,help="Number of bits for each sample")
ap.add_argument("-w", "--waveform", type=str, default="sin",help="Waveform to synthesize")
args = vars(ap.parse_args())
ncoBits = int(args['ncobits'])
#Set ncoBits to 12 bits max
if ncoBits > 12:
    ncoBits = 12
#end if	
#Set freqControlBits to ncoBits bits max
freqControlBits = int(args['fconbits'])
if freqControlBits > ncoBits:
    freqControlBits = ncoBits
#end if
dataBits = int(args['databits'])
waveForm = args['waveform']

#Create 'parametersPackage.vhd' file
with open('parametersPackage.vhd',mode='w') as package:
    package.write("package parametersPackage is\n")
    package.write("    constant NCOBITS : integer :=  {};\n".format(ncoBits))
    package.write("    constant FREQCONTROLBITS : integer := {};\n".format(freqControlBits))
    package.write("    constant DATABITS : integer := {};\n".format(dataBits))
    package.write("end parametersPackage;\n")

#Create 'LUTPackage.vhd' file
nPoints = 2**ncoBits
period = nPoints
time = np.linspace(0,(nPoints-1)/period,num=nPoints)
amplitude = 2**(dataBits-1) - 1
offset = 2**(dataBits-1) - 1
maxSampleValue = (2**dataBits) - 1

if waveForm == "sin":
    ##Sine function
    samples = amplitude*np.sin(2*np.pi*time) + offset
elif waveForm == "cos":
    ##Cosine function
    samples = amplitude*np.cos(2*np.pi*time) + offset
elif waveForm == "saw":
    ##Sawtooth function
    samples = 2*amplitude*(period/(nPoints-1))*time
else:
    ##Triangle function
    samp1 = 2*amplitude*(period/(nPoints/2))*time[:(nPoints//2)]
    samp2 = np.flip(samp1)
    samples = np.concatenate((samp1,samp2))
#end if
##Convert samples to int
samples = samples.astype(int)

##Write to file
with open('LUTPackage.vhd',mode='w') as LUT:
    LUT.write("package LUTPackage is\n")
    LUT.write("    type t_sig_table is array(0 to {}) of integer range 0 to {};\n".format((nPoints-1),(maxSampleValue)))
    LUT.write("    constant C_SIG_TABLE  : t_sig_table := (\n")
    for s in samples:
        LUT.write("        {},\n".format(s))
    #end for
    LUT.seek(LUT.tell()-2,0)
    LUT.write(");\n")
    LUT.write("end LUTPackage;\n")

#Create 'stimulus.txt'
values = tuple(range(2**ncoBits))
controlWords = tuple(range(1,2**freqControlBits))
valuesTop = max(values)
stop = False
accum = 0
with open('stimulus.txt',mode='w') as stim:
    for fcw in controlWords:
        s = 'c'+format(0,str(ncoBits)+'b')
        s = s.replace(' ','0')
        s += '\n'
        stim.write(s)
        while not(stop):
            accum += fcw
            if(accum > valuesTop):
                accum -= (valuesTop+1)
                if (accum == 0):
                    stop = True
                #end if
            #end if
            s = 'c'+format(accum,str(ncoBits)+'b')
            s = s.replace(' ','0')
            s += '\n'
            stim.write(s)
        #end while
        stim.write("#\n")
        stop = False
    #end for

#os.system("./test.sh")
####


            





