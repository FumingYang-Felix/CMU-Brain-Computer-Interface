function analyze_choice_histogram_250_fraction()

    %% (1) Read and merge all Pu*_datM1.mat files in the current directory
    fileListStruct = dir('Pu*_datM1.mat');
    if isempty(fileListStruct)
        error('No Pu*_datM1.mat files found. Please check your path or filenames.');
    end

    bigDat = [];  % A large struct array to hold all trials
    for f = 1:length(fileListStruct)
        fname = fileListStruct(f).name;
        loadedData = load(fname, 'dat');
        if ~isfield(loadedData, 'dat')
            warning('File %s does not contain variable "dat"; skipping...', fname);
            continue;
        end
        bigDat = [bigDat; loadedData.dat(:)];
    end
    fprintf('After merging, there are %d trials in total.\n', length(bigDat));

    %% (2) Define parameter ranges
    rewardLevels = [1, 2, 3];       % Possible rewards
    difficultyLevels = [10, 15, 30];% Possible difficulties
    angleInterest = 250;            % Main target angle of interest
    angleOpponent = 70;             % Opponent angle in double-target trials

    % We maintain two sets of counters:
    % (a) single_* for single-target (250°): success/total
    single_successCount_250 = zeros(length(rewardLevels), length(difficultyLevels));
    single_totalCount_250   = zeros(length(rewardLevels), length(difficultyLevels));

    % (b) double_* for double-target (250 vs. 70), specifically when the subject chooses 250°:
    %     success/total
    double_successCount_250 = zeros(length(rewardLevels), length(difficultyLevels), ...
                                    length(rewardLevels), length(difficultyLevels));
    double_totalCount_250   = zeros(size(double_successCount_250));

    % Helper functions: index lookups for reward/difficulty
    getRewardIndex = @(r) find(rewardLevels == r, 1);
    getDifficultyIndex = @(d) find(difficultyLevels == d, 1);

    %% (3) Traverse bigDat and record performance for the 250° target
    for i = 1:length(bigDat)
        trialParams = bigDat(i).params.trial;
        resultCode  = bigDat(i).result;  % 150 => success
        isSuccess   = (resultCode == 150);

        if trialParams.choiceTrial == 0
            % ---- (A) Single-target (250°) ----
            if isfield(trialParams, 'targetAngle1') && ...
                    (trialParams.targetAngle1 == angleInterest)
                iR = getRewardIndex(trialParams.rewardIdx1);
                iD = getDifficultyIndex(trialParams.targRad1);
                if ~isempty(iR) && ~isempty(iD)
                    single_totalCount_250(iR, iD) = ...
                        single_totalCount_250(iR, iD) + 1;
                    if isSuccess
                        single_successCount_250(iR, iD) = ...
                            single_successCount_250(iR, iD) + 1;
                    end
                end
            end

        else
            % ---- (B) Double-target (choiceTrial=1) ----
            if ~isfield(trialParams, 'choice')
                continue;  % No choice field => cannot determine which target was chosen
            end

            angle1 = trialParams.targetAngle1;
            angle2 = trialParams.targetAngle2;

            % Check if it is (250 vs. 70)
            is250_70 = ((angle1 == angleInterest && angle2 == angleOpponent) || ...
                        (angle1 == angleOpponent && angle2 == angleInterest));
            if ~is250_70
                continue;
            end

            chosenTarget = trialParams.choice;  % 1 => target1 chosen; 2 => target2 chosen
            if angle1 == angleInterest
                iR_250 = getRewardIndex(trialParams.rewardIdx1);
                iD_250 = getDifficultyIndex(trialParams.targRad1);
                iR_70  = getRewardIndex(trialParams.rewardIdx2);
                iD_70  = getDifficultyIndex(trialParams.targRad2);

                chose250 = (chosenTarget == 1);
            else
                % angle1=70, angle2=250
                iR_250 = getRewardIndex(trialParams.rewardIdx2);
                iD_250 = getDifficultyIndex(trialParams.targRad2);
                iR_70  = getRewardIndex(trialParams.rewardIdx1);
                iD_70  = getDifficultyIndex(trialParams.targRad1);

                chose250 = (chosenTarget == 2);
            end

            % If the subject actually chose 250°, record success/total
            if ~isempty(iR_250) && ~isempty(iD_250) && ...
               ~isempty(iR_70) && ~isempty(iD_70) && ...
               chose250

                double_totalCount_250(iR_250, iD_250, iR_70, iD_70) = ...
                    double_totalCount_250(iR_250, iD_250, iR_70, iD_70) + 1;
                if isSuccess
                    double_successCount_250(iR_250, iD_250, iR_70, iD_70) = ...
                        double_successCount_250(iR_250, iD_250, iR_70, iD_70) + 1;
                end
            end
        end
    end

    %% (4) Plot bar charts (single-target + double-target opponents), showing "#success/#total"
    nR = length(rewardLevels);
    nD = length(difficultyLevels);
    figureCount = 0;

    for iR = 1:nR
        for iD = 1:nD
            % (1) Single-target (250°): success/total
            sTot = single_totalCount_250(iR, iD);
            sSuc = single_successCount_250(iR, iD);
            if sTot > 0
                singleRate = sSuc / sTot;   % range [0..1]
            else
                singleRate = 0;
            end

            % (2) Double-target (250 vs 70), 9 combos for (R2,D2)
            barValues = zeros(1, 1 + nR*nD);   % The first bar is for single-target
            fractionLabels = cell(size(barValues));

            % First bar: single-target success rate
            barValues(1) = singleRate * 100;
            fractionLabels{1} = sprintf('%d/%d', sSuc, sTot);

            xLabels = cell(size(barValues));
            xLabels{1} = 'Single';

            idxBar = 2;
            for iR2 = 1:nR
                for iD2 = 1:nD
                    dtot = double_totalCount_250(iR, iD, iR2, iD2);
                    dsuc = double_successCount_250(iR, iD, iR2, iD2);

                    if dtot > 0
                        drate = (dsuc / dtot) * 100;  % convert to percentage
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

            % Even if all bars are 0, we'll still generate a figure.
            figureCount = figureCount + 1;
            figHandle = figure('Name', sprintf('ChoiceHistogram_250_%d', figureCount));

            % Plot the bar chart (in %)
            bar(barValues);
            set(gca, 'XTick', 1:length(barValues), ...
                     'XTickLabel', xLabels, ...
                     'XTickLabelRotation', 45);

            titleStr = sprintf('Success Rate (R=%d, D=%d, Angle=250)', ...
                rewardLevels(iR), difficultyLevels(iD));
            title(titleStr);
            ylabel('Success Rate (%)');
            ylim([0 100]);
            grid on;

            % Display fraction "#success/#total" above each bar
            hold on;
            for ib = 1:length(barValues)
                valPercent = barValues(ib);
                if ~strcmp(fractionLabels{ib}, '0/0')  % skip if "0/0"
                    text(ib, valPercent, fractionLabels{ib}, ...
                        'HorizontalAlignment','center', ...
                        'VerticalAlignment','bottom', ...
                        'FontSize', 9);
                end
            end
            hold off;

            % Automatically save as JPG
            jpgFileName = sprintf('ChoiceHistogram_250_%d.jpg', figureCount);
            saveas(figHandle, jpgFileName);
        end
    end

    fprintf('All plots completed (main target = 250°).\n');
end
