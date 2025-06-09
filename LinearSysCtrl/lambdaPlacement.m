close all; clear all; clc;
A = [-11, 30;...
      -4, 11];
B = [10; 4];
K = [2/5.3852, 0];

eig(A-B*K)