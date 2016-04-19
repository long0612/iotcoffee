% IoT Coffee
%
% Long Le <longle1@illinois.edu>
% University of Illinois
%

clear all; close all

rootDir = 'C:/Users/Long/Projects/';

addpath([rootDir 'sas-clientLib/src/']);
addpath([rootDir 'jsonlab']);
addpath([rootDir 'V1_1_urlread2']);

servAddr = 'swarmnuc009.ifp.illinois.edu';
DB = 'publicDb';
USER = 'nan';
PWD = 'publicPwd';
DATA = 'data';
EVENT = 'event';

%% Main

% Query limited files from the database
q.t1 = datenum(2016,04,10,00,00,00); q.t2 = datenum(2016,04,20,00,00,00);
events = IllQuery(servAddr,DB, USER, PWD, EVENT, q);
