clear all
close all

addpath(genpath('additional-packages'));
addpath(genpath('Vocoder'));
addpath(genpath('CI_CODING_STRAT'));

% import audio
[x, fs] = audioread("sample-speech.wav");
x = x/max(abs(x));

% import impulse response 
startTwoEars  % optional

% load impulse response
irAnFilename = 'impulse_responses/surrey_cortex_rooms/UniS_Anechoic_BRIR_16k.sofa';
irRevFilename = 'impulse_responses/surrey_cortex_rooms/UniS_Room_D_BRIR_16k.sofa';

irAnName = split(irAnFilename,'/');
irRevName = split(irRevFilename,'/');

irAnFilenameDir = char(strcat('\', irAnName(1),'\', irAnName(2),'\', irAnName(3)));
irAnDir = char(strcat(pwd, '\additional-packages\TwoEars\BinauralSimulator\tmp',irAnFilenameDir));
irAnName = char(irAnName(end));
irAnName = irAnName(1:end-5);

irRevFilenameDir = char(strcat('\', irRevName(1),'\', irRevName(2),'\', irRevName(3)));
irRevDir = char(strcat(pwd, '\additional-packages\TwoEars\BinauralSimulator\tmp',irRevFilenameDir));
irRevName = char(irRevName(end));
irRevName = irRevName(1:end-5);

if ~exist(irAnDir, "file")
    irAnFilename = db.downloadFile(irAnFilename);
    irAn = SOFAload(irAnFilename);
else
    irAn = SOFAload(strcat(irAnName,'.sofa'));
end

if ~exist(irRevDir, "file")
    irRevFilename = db.downloadFile(irRevFilename);
    irRev = SOFAload(irRevFilename);
else
    irRev = SOFAload(strcat(irRevName,'.sofa'));
end

% make reverberant stimuli
audioOutputAn = [conv(x, squeeze(irAn.Data.IR(37,1,:))) ...
    conv(x, squeeze(irAn.Data.IR(37,2,:)))];

audioOutputRev = [conv(x, squeeze(irRev.Data.IR(37,1,:))) ...
    conv(x, squeeze(irRev.Data.IR(37,2,:)))];

audioOutputRev = audioOutputRev(1:length(audioOutputAn),:);

% make original vocoder
vocodedAn = [CI_Sim_Left(audioOutputAn(:,1), fs, 'EAS') ...
                CI_Sim_Right(audioOutputAn(:,2), fs, 'EAS')];

vocodedRev = [CI_Sim_Left(audioOutputRev(:,1), fs, 'EAS') ...
                CI_Sim_Right(audioOutputRev(:,2), fs, 'EAS')];

enhanced = [CI_Sim_Enh_Left(audioOutputRev(:,1), audioOutputAn(:,1), fs, 'EAS') ...
                CI_Sim_Enh_Right(audioOutputRev(:,2), audioOutputAn(:,2), fs, 'EAS')];

itdValueRev = estimate_ITD_Broadband(vocodedRev, fs)*1000;             % in ms
ildValueRev = 20*log10(rms(vocodedRev(:,1))/rms(vocodedRev(:,2)));                        % in dB

itdValueEnh = estimate_ITD_Broadband(enhanced, fs)*1000;             % in ms
ildValueEnh = 20*log10(rms(enhanced(:,1))/rms(enhanced(:,2)));                        % in dB

siiRev = mbstoi(vocodedAn(:,1),vocodedAn(:,2), vocodedRev(:,1), vocodedRev(:,2), fs);
siiEnh = mbstoi(vocodedAn(:,1),vocodedAn(:,2), enhanced(:,1), enhanced(:,2), fs);