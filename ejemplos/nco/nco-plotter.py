#!/usr/bin/env python3

# Plot NCO output
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

FILE="./nco_output.txt"
data_csv = pd.read_csv(FILE,sep=',',header=None)
data_csv.reset_index(inplace=True)
data_csv.columns=["x","sin"]

x=data_csv["x"]
y=data_csv["sin"]

fig1,ax=plt.subplots()
fig1.suptitle("NCO")
ax.set(xlabel='x', ylabel='sin(x)')
ax.grid()
ax.plot(x,y,'-')

plt.show()
