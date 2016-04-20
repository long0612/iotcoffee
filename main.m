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
q.t1 = datenum(2016,04,19,00,00,00); q.t2 = datenum(2016,04,22,00,00,00);
events = IllQuery(servAddr,DB, USER, PWD, EVENT, q);
T = -ones(numel(events),1);
P = -ones(numel(events),1);
tB = -ones(numel(events),1);
tP = -ones(numel(events),1);
for k = 1:numel(events)
    if isfield(events{k}, 'device')
        if strcmp(events{k}.device,'PowerBlade')
            if isfield(events{k}, 'power')
                P(k) = str2double(events{k}.power);
                tP(k) = datenum8601(events{k}.recordDate);
            end
        else
            if isfield(events{k}, 'temperature_celcius')
                T(k) = events{k}.temperature_celcius;
                tB(k) = datenum8601(events{k}.recordDate);
            end
        end
    end
end
P(P==-1) = [];
tP(tP==-1) = [];
T(T==-1) = [];
tB(tB==-1) = [];

% plot
figure; 
subplot(211);plot((tP-min(tP))*3600*24,P); ylabel('Power');
subplot(212);plot((tB-min(tB))*3600*24,T); ylabel('Temperature')
xlabel('Event index');
