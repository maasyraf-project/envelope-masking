clc
clear all
close all

room_name = 'Room_A';
% vocoded stimuli
dataRefDir = strcat(pwd, '\results\vocoded\UniS_Anechoic_BRIR_16k\');
dataRoomDir = strcat(pwd, '\results\vocoded\UniS_',room_name,'_BRIR_16k\');
dataOnsetDir = strcat(pwd, '\results\enhanced-onset\UniS_',room_name,'_BRIR_16k\');
dataPropDir = strcat(pwd, '\results\enhanced-env-masking\UniS_',room_name,'_BRIR_16k\');

outputDir = strcat(pwd, '\figures\', room_name, '\');

if ~isfolder(outputDir)
    mkdir(outputDir)
end

dataRefFiles = dir(fullfile(dataRefDir, '**\*.mat'));
dataRoomFiles = dir(fullfile(dataRoomDir, '**\*.mat'));
dataBasFiles = dir(fullfile(dataOnsetDir, '**\*.mat'));
dataPropFiles = dir(fullfile(dataPropDir, '**\*.mat'));

dataFiles = [dataRefFiles; dataRoomFiles; dataBasFiles; dataPropFiles];

% header and legend
degree = linspace(-90, 90, 37);
degree = string(degree);
for i = 1:length(degree)
    if mod(str2num(degree(i)),10) ~= 0
        degree(i) = " ";
    end
end

label = ["AN", "REV", "ON", "EM"];

labelILD = [];
labelITD = [];
labelSII = [];

for i = 1:length(dataFiles)
    % load variabel files (.mat)
    load(fullfile(dataFiles(i).folder, dataFiles(i).name));

    % plot ILD value
    meanILD = mean(ild(:,:));
    stdILD = std(ild(:,:));

    % calculate error compared with the anechoic
    if i == 1
        meanILD_ref = meanILD;
        stdILD_ref = stdILD;
    end
    if i ~= 1
        meanILD_err = meanILD - meanILD_ref;
        stdILD_err = stdILD - stdILD_ref;
    end
    
    figure(1)
    if i == 1
        plot(meanILD, '-o', 'MarkerSize', 4, 'Color', [0 0 0] + 0.05 * i, LineWidth=0.5)
    elseif i == 2
        plot(meanILD, '--o', 'MarkerSize', 4, 'Color', [0 0 0] + 0.05 * i, LineWidth=0.5)
    elseif i == 3
        plot(meanILD, '-square', 'MarkerSize', 4, 'Color', [0 0 0] + 0.05 * i, LineWidth=0.5)
    elseif i == 4
        plot(meanILD, '-x', 'MarkerSize', 4, 'Color', [0 0 0] + 0.05 * i, LineWidth=0.5)
    end
    xlim([1 37])
    xticks([1:37])
    xticklabels(degree)
    grid on
    hold on
    xlabel("position of source (degree)")
    ylabel("ILD (dB)")
    title(strcat("ILD of Room ", room_name(end), " stimuli"))
    if i == 1
        labelILD = [labelILD, strcat(label(i), " ", "(\mu_{\DeltaILD} = ", "0", " ,\sigma_{\DeltaILD} = ", "0", ")")];
    else
        labelILD = [labelILD, strcat(label(i), " ", "(\mu_{\DeltaILD} = ", string(round(mean(meanILD_err),3)), " ,\sigma_{\DeltaILD} = ", string(round(std(stdILD_err),3)), ")")];
    end
    h = legend(labelILD);
    set(h, 'Location', 'best')
    
    % plot ITD value
    meanITD = mean(itd(:,:));
    stdITD = std(itd(:,:));

    % calculate error compared with the anechoic
    if i == 1
        meanITD_ref = meanITD;
        stdITD_ref = stdITD;
    end
    if i ~= 1
        meanITD_err = meanITD - meanITD_ref;
        stdITD_err = stdITD - stdITD_ref;
    end
    
    figure(2)
    if i == 1
        plot(meanITD, '-o', 'MarkerSize', 4, 'Color', [0 0 0] + 0.05 * i, LineWidth=0.5)
    elseif i == 2
        plot(meanITD, '--o', 'MarkerSize', 4, 'Color', [0 0 0] + 0.05 * i, LineWidth=0.5)
    elseif i == 3
        plot(meanITD, '-square', 'MarkerSize', 4, 'Color', [0 0 0] + 0.05 * i, LineWidth=0.5)
    elseif i == 4
        plot(meanITD, '-x', 'MarkerSize', 4, 'Color', [0 0 0] + 0.05 * i, LineWidth=0.5)
    end
    xlim([1 37])
    xticks([1:37])
    xticklabels(degree)
    grid on
    hold on
    xlabel("position of source (degree)")
    ylabel("ITD (ms)")
    title(strcat("ITD of Room ", room_name(end), " stimuli"))
    if i == 1
        labelITD = [labelITD, strcat(label(i), " ", "(\mu_{\DeltaITD} = ", "0", " ,\sigma_{\DeltaITD} = ", "0", ")")];
    else
        labelITD = [labelITD, strcat(label(i), " ", "(\mu_{\DeltaITD} = ", string(round(mean(meanITD_err),3)), " ,\sigma_{\DeltaITD} = ", string(round(std(stdITD_err),3)), ")")];
    end
    h = legend(labelITD);
    set(h, 'Location', 'best')

    % plot SII value
    meanSII = mean(sii(:,:));
    stdSII = std(sii(:,:));
    
    figure(3)
    if i == 1
        plot(meanSII, '-o', 'MarkerSize', 4, 'Color', [0 0 0] + 0.05 * i, LineWidth=0.5)
    elseif i == 2
        plot(meanSII, '--o', 'MarkerSize', 4, 'Color', [0 0 0] + 0.05 * i, LineWidth=0.5)
    elseif i == 3
        plot(meanSII, '-square', 'MarkerSize', 4, 'Color', [0 0 0] + 0.05 * i, LineWidth=0.5)
    elseif i == 4
        plot(meanSII, '-x', 'MarkerSize', 4, 'Color', [0 0 0] + 0.05 * i, LineWidth=0.5)
    end
    xlim([1 37])
    xticks([1:37])
    xticklabels(degree)
    grid on
    hold on
    xlabel("position of source (degree)")
    ylabel("SII")
    title(strcat("SII of Room ", room_name(end), " stimuli"))
    ylim([0 1])
    labelSII = [labelSII, strcat(label(i), " ", "(\mu = ", string(round(mean(meanSII),3)), " ,\sigma = ", string(round(std(stdSII),3)), ")")];
    h = legend(labelSII);
    set(h, 'Location', 'best')


end

gcf1 = figure(1);
gcf2 = figure(2);
gcf3 = figure(3);

set(gcf1,'Units','Inches');
pos = get(gcf1,'Position');
set(gcf1,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])

set(gcf2,'Units','Inches');
pos = get(gcf2,'Position');
set(gcf2,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])

set(gcf3,'Units','Inches');
pos = get(gcf3,'Position');
set(gcf3,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])

saveas(gcf1, strcat(outputDir, 'ILD-', room_name, '.pdf'))
saveas(gcf2, strcat(outputDir, 'ITD-', room_name, '.pdf'))
saveas(gcf3, strcat(outputDir, 'SII-', room_name, '.pdf'))