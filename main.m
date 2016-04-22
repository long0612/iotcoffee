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
q.t1 = datenum(2016,04,18,00,00,00); q.t2 = datenum(2016,04,24,00,00,00);

q.dev = 'PowerBlade';
events = longQuery(servAddr,DB, USER, PWD, EVENT, q);
aP = -ones(numel(events),1);
P = -ones(numel(events),1);
tP = -ones(numel(events),1);
for k = 1:numel(events)
    if isfield(events{k}, 'apparent_power') && isfield(events{k}, 'power')
        aP(k) = str2double(events{k}.apparent_power);
        P(k) = str2double(events{k}.power);
        tP(k) = datenum8601(events{k}.recordDate);
    end
end
aP(aP==-1) = [];
P(P==-1) = [];
tP(tP==-1) = [];

q.dev = 'BLEES';
events = longQuery(servAddr,DB, USER, PWD, EVENT, q);
T = -ones(numel(events),1);
H = -ones(numel(events),1);
tB = -ones(numel(events),1);
for k = 1:numel(events)
    if isfield(events{k}, 'temperature_celcius') && isfield(events{k}, 'humidity_percent')
        T(k) = events{k}.temperature_celcius;
        H(k) = events{k}.humidity_percent;
        tB(k) = datenum8601(events{k}.recordDate);
    end
end
T(T==-1) = [];
H(H==-1) = [];
tB(tB==-1) = [];

%{
q.dev = 'Android';
events = longQuery(servAddr,DB, USER, PWD, EVENT, q);
spl = -ones(numel(events),1);
tA = -ones(numel(events),1);
for k = 1:numel(events)
    if isfield(events{k}, 'octaveFeat')
        spl(k) = mean(events{k}.octaveFeat(:));
        tA(k) = datenum8601(events{k}.recordDate);
    end
end
spl(spl==-1) = [];
tA(tA==-1) = [];
%}

% plot
tStart = min([tP;tB;tA]);
figure; 
subplot(411);plot((tP-tStart)*60*24,aP,'rx-'); ylabel('Apparent Power'); xlabel('Relative time (min)');
subplot(412);plot((tP-tStart)*60*24,P,'rx-'); ylabel('Power'); xlabel('Relative time (min)');
subplot(413);plot((tB-tStart)*60*24,T,'rx-'); ylabel('Temperature'); xlabel('Relative time (min)');
subplot(414);plot((tB-tStart)*60*24,H,'rx-'); ylabel('Humidity'); xlabel('Relative time (min)');
suptitle(['tStart = ' datestr8601(tStart)]);
%subplot(515);plot((tA-tStart)*60*24,spl,'rx-'); ylabel('Sound Pressure Level'); xlabel('Relative time (min)');
