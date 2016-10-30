clear all
close all
clc
tic 
[filename,pathname] = uigetfile('*.brd');

[ b , retval ] = generateBoard([pathname filename]);
toc