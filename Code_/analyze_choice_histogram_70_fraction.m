function analyze_choice_histogram_70_fraction()
    %% (1) Read and merge all Pu*_datM1.mat files in the current directory
    fileListStruct = dir('Pu*_datM1.mat');
    if isempty(fileListStruct)
        error('No Pu*_datM1.mat files found. Please check your path or filenames.');
    end

    bigDat = [];  % This will store all trial structures
    for f = 1:length(fileListStruct)
        fname = fileListStruct(f).name;
        loadedData = load(fname, 'dat');
        if ~isfield(loadedData, 'dat')
            warning('File %s has no variable dat. Skipping...', fname);
            continue;
        end
        bigDat = [bigDat; loadedData.dat(:)];
    end
    fprintf('After merging, there are %d trials in total.\n', length(bigDat));

    %% (2) Define parameter ranges
    rewardLevels = [1, 2, 3];         % Reward (R)
    difficultyLevels = [10, 15, 30];  % Difficulty (D)

    angleInterest = 70;               % Our primary angle of interest is now 70°
    angleOpponent = 250;              % The other angle in double-target trials is 250°

    % (a) For single-target 70°: record success vs. total
    single_successCount_70 = zeros(length(rewardLevels), length(difficultyLevels));
    single_totalCount_70   = zeros(length(rewardLevels), length(difficultyLevels));

    % (b) For double-target (70 vs. 250) when the subject chose the 70° target:
    %     record success vs. total
    double_successCount_70 = zeros(length(rewardLevels), length(difficultyLevels), ...
                                   length(rewardLevels), length(difficultyLevels));
    double_totalCount_70   = zeros(size(double_successCount_70));

    % Helper functions to map reward/difficulty to indices
    getRewardIndex = @(r) find(rewardLevels == r, 1);
    getDifficultyIndex = @(d) find(difficultyLevels == d, 1);

    %% (3) Traverse bigDat and collect success/total counts for (70°)
    for i = 1:length(bigDat)
        trialParams = bigDat(i).params.trial;
        resultCode  = bigDat(i).result;      % 150 => success
        isSuccess   = (resultCode == 150);

        if trialParams.choiceTrial == 0
            % ---- (A) Single-target (70°) ----
            if isfield(trialParams, 'targetAngle1') && ...
                    (trialParams.targetAngle1 == angleInterest)
                iR = getRewardIndex(trialParams.rewardIdx1);
                iD = getDifficultyIndex(trialParams.targRad1);

                if ~isempty(iR) && ~isempty(iD)
                    single_totalCount_70(iR, iD) = single_totalCount_70(iR, iD) + 1;
                    if isSuccess
                        single_successCount_70(iR, iD) = single_successCount_70(iR, iD) + 1;
                    end
                end
            end

        else
            % ---- (B) Double-target ----
            if ~isfield(trialParams, 'choice')
                continue;  % No choice field => can't determine which target was chosen
            end

            angle1 = trialParams.targetAngle1;
            angle2 = trialParams.targetAngle2;

            % Check if it's (70 vs. 250)
            is70_250 = ((angle1 == angleInterest && angle2 == angleOpponent) || ...
                        (angle1 == angleOpponent && angle2 == angleInterest));
            if ~is70_250
                continue;
            end

            chosenTarget = trialParams.choice;  % 1 => target1 chosen, 2 => target2 chosen
            if angle1 == angleInterest
                iR_70  = getRewardIndex(trialParams.rewardIdx1);
                iD_70  = getDifficultyIndex(trialParams.targRad1);
                iR_250 = getRewardIndex(trialParams.rewardIdx2);
                iD_250 = getDifficultyIndex(trialParams.targRad2);

                chose70 = (chosenTarget == 1);
            else
                % angle1=250, angle2=70
                iR_70  = getRewardIndex(trialParams.rewardIdx2);
                iD_70  = getDifficultyIndex(trialParams.targRad2);
                iR_250 = getRewardIndex(trialParams.rewardIdx1);
                iD_250 = getDifficultyIndex(trialParams.targRad1);

                chose70 = (chosenTarget == 2);
            end

            % If the subject indeed chose the 70° side, record success/total
            if ~isempty(iR_70) && ~isempty(iD_70) && ...
               ~isempty(iR_250) && ~isempty(iD_250) && ...
               chose70

                double_totalCount_70(iR_70, iD_70, iR_250, iD_250) = ...
                    double_totalCount_70(iR_70, iD_70, iR_250, iD_250) + 1;
                if isSuccess
                    double_successCount_70(iR_70, iD_70, iR_250, iD_250) = ...
                        double_successCount_70(iR_70, iD_70, iR_250, iD_250) + 1;
                end
            end
        end
    end

    %% (4) Plot bar charts (single-target + vs. opponents), with fraction label on top
    nR = length(rewardLevels);
    nD = length(difficultyLevels);
    figureCount = 0;

    for iR = 1:nR
        for iD = 1:nD
            % (1) Single-target (70°)
            sTot = single_totalCount_70(iR, iD);
            sSuc = single_successCount_70(iR, iD);
            if sTot > 0
                singleRate = sSuc / sTot;   % 0..1
            else
                singleRate = 0;
            end

            % (2) Double-target (70 vs 250) with 9 combos (R2,D2)
            barValues = zeros(1, 1 + nR*nD);
            fractionLabels = cell(size(barValues));

            % First bar: single-target
            barValues(1) = singleRate * 100;
            fractionLabels{1} = sprintf('%d/%d', sSuc, sTot);
            xLabels = cell(size(barValues));
            xLabels{1} = 'Single';

            idxBar = 2;
            for iR2 = 1:nR
                for iD2 = 1:nD
                    dtot = double_totalCount_70(iR, iD, iR2, iD2);
                    dsuc = double_successCount_70(iR, iD, iR2, iD2);
                    if dtot > 0
                        drate = (dsuc / dtot)*100;
                    else
                        drate = 0;
                    end
                    barValues(idxBar) = drate;
                    fractionLabels{idxBar} = sprintf('%d/%d', dsuc, dtot);

                    xLabels{idxBar} = sprintf('R=%d,D=%d', ...
                        rewardLevels(iR2), difficultyLevels(iD2));
                    idxBar = idxBar + 1;
                end
            end

            % Generate the figure
            figureCount = figureCount + 1;
            figHandle = figure('Name', sprintf('ChoiceHistogram_70_%d', figureCount));
            bar(barValues);
            set(gca, 'XTick', 1:length(barValues), ...
                     'XTickLabel', xLabels, ...
                     'XTickLabelRotation', 45);

            titleStr = sprintf('Success Rate (R=%d, D=%d, Angle=70)', ...
                rewardLevels(iR), difficultyLevels(iD));
            title(titleStr);
            ylabel('Success Rate (%)');
            ylim([0 100]);
            grid on;

            % Display fraction "success/total" at top of each bar
            hold on;
            for ib = 1:length(barValues)
                valPercent = barValues(ib);
                if ~strcmp(fractionLabels{ib}, '0/0')
                    text(ib, valPercent, fractionLabels{ib}, ...
                        'HorizontalAlignment','center', ...
                        'VerticalAlignment','bottom', ...
                        'FontSize', 9);
                end
            end
            hold off;

            % Save the figure as a jpg
            jpgFileName = sprintf('ChoiceHistogram_70_%d.jpg', figureCount);
            saveas(figHandle, jpgFileName);
        end
    end

    fprintf('Done plotting for angle=70°.\n');
end
