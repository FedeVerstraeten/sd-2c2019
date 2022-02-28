#!/usr/bin/env python3

# Plot NCO output
import pandas as pd
import matplotlib.pyplot as plt

FILE_SIN="./nco_sin_output.txt"
FILE_COS="./nco_cos_output.txt"

data_sin = pd.read_csv(FILE_SIN,sep=',',header=None)
data_sin.reset_index(inplace=True)
data_sin.columns=["x","sin"]

data_cos = pd.read_csv(FILE_COS,sep=',',header=None)
data_cos.reset_index(inplace=True)
data_cos.columns=["x","cos"]

x_sin=data_sin["x"]
y_sin=data_sin["sin"]

x_cos=data_cos["x"]
y_cos=data_cos["cos"]

fig,(ax_sin,ax_cos)=plt.subplots(2)

fig.suptitle("NCO")
ax_sin.set(xlabel='x', ylabel='sin(x)')
ax_cos.set(xlabel='x', ylabel='cos(x)')
ax_sin.grid()
ax_cos.grid()
ax_sin.plot(x_sin,y_sin,'b-')
ax_cos.plot(x_cos,y_cos,'r-')

plt.show()
