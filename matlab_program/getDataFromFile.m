function [t,g,h] = getDataFromFile(pathName)

% Function to read data written in *_response.txt file
% Input: path to file
% Output: time, impulse and step response

% Read csv file and save it as matrix data
data = csvread(pathName);

% Extract time, impulse and step vectors from data matrix
t = data(:,1);
g = data(:,2);
h = data(:,3);

