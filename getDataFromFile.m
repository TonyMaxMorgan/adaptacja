function [t,g,h] = getDataFromFile(pathName)

data = csvread(pathName);

t = data(:,1);
g = data(:,2);
h = data(:,3);

