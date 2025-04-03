%% ============= Heatmap: Choice Probability for 70° =============
% Here we construct a 9×9 matrix M_70.
%  - Rows correspond to (R_70, D_70)
%  - Columns correspond to (R_250, D_250)
%  - Each cell is the probability (in %) that the 70° target is chosen,
%    among the trials where 70° side is (R_70,D_70) and 250° side is (R_250,D_250).

% Initialize a 9×9 matrix
M_70 = zeros(9,9);

% Helper functions to map reward/difficulty to array indices
getRewardIndex = @(r) find(rewardLevels == r, 1);
getDifficultyIndex = @(d) find(difficultyLevels == d, 1);

for i = 1:9
    % combos(i,:) = [R_70, D_70]
    r70  = combos(i,1);
    d70  = combos(i,2);
    iR_70 = getRewardIndex(r70);
    iD_70 = getDifficultyIndex(d70);

    for j = 1:9
        % combos(j,:) = [R_250, D_250]
        r250 = combos(j,1);
        d250 = combos(j,2);
        iR_250 = getRewardIndex(r250);
        iD_250 = getDifficultyIndex(d250);

        % Retrieve the number of offers and choices
        offers = double_offerCount_70(iR_70, iD_70, iR_250, iD_250);
        chooses= double_choseCount_70(iR_70, iD_70, iR_250, iD_250);

        if offers > 0
            M_70(i,j) = (chooses / offers) * 100;  % Convert to percentage
        else
            M_70(i,j) = 0;
        end
    end
end

figure('Name','Choice Probability Heatmap (70°)');
imagesc(M_70);
colormap(jet);       % You may switch to hot/parula/turbo, etc.
colorbar;
caxis([0 100]);      % Match the range 0..100%
axis equal tight;

xticks(1:9);
yticks(1:9);
xticklabels(comboLabels);
yticklabels(comboLabels);
xtickangle(45);

xlabel('(R2,D2) for 250° side');
ylabel('(R,D) for 70° side');
title('Choice Probability (70°) in %');

saveas(gcf, 'ChoiceProbability_70_Heatmap.jpg');


%% ============= Heatmap: Choice Probability for 250° =============
% Similarly, we construct a 9×9 matrix M_250
%  - Rows correspond to (R_250, D_250)
%  - Columns correspond to (R_70, D_70)

M_250 = zeros(9,9);

for i = 1:9
    % combos(i,:) = [R_250, D_250]
    r250 = combos(i,1);
    d250 = combos(i,2);
    iR_250 = getRewardIndex(r250);
    iD_250 = getDifficultyIndex(d250);

    for j = 1:9
        % combos(j,:) = [R_70, D_70]
        r70 = combos(j,1);
        d70 = combos(j,2);
        iR_70 = getRewardIndex(r70);
        iD_70 = getDifficultyIndex(d70);

        offers = double_offerCount_250(iR_250, iD_250, iR_70, iD_70);
        chooses= double_choseCount_250(iR_250, iD_250, iR_70, iD_70);

        if offers > 0
            M_250(i,j) = (chooses / offers) * 100;
        else
            M_250(i,j) = 0;
        end
    end
end

figure('Name','Choice Probability Heatmap (250°)');
imagesc(M_250);
colormap(jet);
colorbar;
caxis([0 100]);
axis equal tight;

xticks(1:9);
yticks(1:9);
xticklabels(comboLabels);
yticklabels(comboLabels);
xtickangle(45);

xlabel('(R2,D2) for 70° side');
ylabel('(R,D) for 250° side');
title('Choice Probability (250°) in %');

saveas(gcf, 'ChoiceProbability_250_Heatmap.jpg');



%% ========== Single-Target Heatmap: y=Reward, x=Difficulty ==========
% We'll construct a 3×3 matrix for single-target 250° success rates,
% where the row = Reward index and column = Difficulty index.

nR = length(rewardLevels);  % = 3
nD = length(difficultyLevels); % = 3

% Build the 3×3 matrix (row=Reward, col=Difficulty)
M_single_250 = zeros(nR, nD);

for iR = 1:nR
    for iD = 1:nD
        totalTrials = single_totalCount_250(iR, iD);
        successTrials = single_successCount_250(iR, iD);
        if totalTrials > 0
            M_single_250(iR, iD) = (successTrials / totalTrials) * 100;
        else
            M_single_250(iR, iD) = 0;  % If no trials, record 0
        end
    end
end

figure('Name','SingleTarget_250_Heatmap');
imagesc(M_single_250);
colormap(jet);
colorbar;
caxis([0 100]);
axis equal tight;

% Set X and Y ticks with labels
set(gca, 'XTick', 1:nD, 'XTickLabel', {'D=10','D=15','D=30'});
set(gca, 'YTick', 1:nR, 'YTickLabel', {'R=1','R=2','R=3'});

xlabel('Difficulty');
ylabel('Reward');
title('Single-Target Success Rate (250°) in %');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The following code sets up the 4D arrays for double_offerCount_250, etc.
% It shows how we loop through bigDat to fill them in for (250° vs. 70°).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rewardLevels = [1, 2, 3];  % R
difficultyLevels = [10, 15, 30]; % D

% 4D array dims = (length(R), length(D), length(R), length(D))
double_offerCount_250 = zeros(length(rewardLevels), length(difficultyLevels), ...
                              length(rewardLevels), length(difficultyLevels));
double_choseCount_250 = zeros(size(double_offerCount_250));

% Iterate over all trials
for i = 1:length(bigDat)
    trialParams = bigDat(i).params.trial;

    % Only consider double-target
    if trialParams.choiceTrial ~= 1
        continue;
    end

    % Skip if there's no choice field
    if ~isfield(trialParams, 'choice')
        continue;
    end

    chosen = trialParams.choice;
    angle1 = trialParams.targetAngle1;
    angle2 = trialParams.targetAngle2;
    R1 = trialParams.rewardIdx1;
    R2 = trialParams.rewardIdx2;
    D1 = trialParams.targRad1;
    D2 = trialParams.targRad2;

    % Check if it's (250 vs 70)
    is250_70 = ((angle1==250 && angle2==70) || (angle1==70 && angle2==250));
    if ~is250_70
        continue;
    end

    % Identify which side is 250°, which side is 70°, and record chosen
    if angle1 == 250
        iR_250 = find(rewardLevels==R1, 1);
        iD_250 = find(difficultyLevels==D1, 1);
        iR_70  = find(rewardLevels==R2, 1);
        iD_70  = find(difficultyLevels==D2, 1);
        chose250 = (chosen == 1);
    else
        % angle1 == 70, angle2 == 250
        iR_250 = find(rewardLevels==R2, 1);
        iD_250 = find(difficultyLevels==D2, 1);
        iR_70  = find(rewardLevels==R1, 1);
        iD_70  = find(difficultyLevels==D1, 1);
        chose250 = (chosen == 2);
    end

    % If any index is empty, skip
    if isempty(iR_250) || isempty(iD_250) || isempty(iR_70) || isempty(iD_70)
        continue;
    end

    % Increment offerCount
    double_offerCount_250(iR_250, iD_250, iR_70, iD_70) = ...
        double_offerCount_250(iR_250, iD_250, iR_70, iD_70) + 1;

    % If 250° was chosen, increment choseCount
    if chose250
        double_choseCount_250(iR_250, iD_250, iR_70, iD_70) = ...
            double_choseCount_250(iR_250, iD_250, iR_70, iD_70) + 1;
    end
end



%% ============= Heatmap: Choice Probability for 250° =============
% Suppose we have double_offerCount_250(iR_250, iD_250, iR_70, iD_70),
% double_choseCount_250(iR_250, iD_250, iR_70, iD_70),
% plus combos, comboLabels, rewardLevels, difficultyLevels in our workspace.

% We'll prepare a 9×9 matrix M_250 (rows and columns follow combos order)
M_250 = zeros(9,9);

getRewardIndex = @(r) find(rewardLevels == r, 1);
getDifficultyIndex = @(d) find(difficultyLevels == d, 1);

% Fill M_250 row-by-row and column-by-column
for i = 1:9
    % combos(i,:) = [R_250, D_250] for the 250° side
    r250 = combos(i,1);
    d250 = combos(i,2);
    iR_250 = getRewardIndex(r250);
    iD_250 = getDifficultyIndex(d250);

    for j = 1:9
        % combos(j,:) = [R_70, D_70] for the 70° side
        r70 = combos(j,1);
        d70 = combos(j,2);
        iR_70 = getRewardIndex(r70);
        iD_70 = getDifficultyIndex(d70);

        offers = double_offerCount_250(iR_250, iD_250, iR_70, iD_70);
        chooses= double_choseCount_250(iR_250, iD_250, iR_70, iD_70);

        if offers > 0
            M_250(i,j) = (chooses / offers) * 100;
        else
            M_250(i,j) = 0;
        end
    end
end

figure('Name','Choice Probability Heatmap (250°)');
imagesc(M_250);

% Set colormap and color range
colormap(jet);
colorbar;
caxis([0 100]);    % Map [0..100]% onto the color scale

axis equal tight;  % Keep x,y ratio equal

% Set tick marks and labels
xticks(1:9);
yticks(1:9);
xticklabels(comboLabels);
yticklabels(comboLabels);
xtickangle(45);

xlabel('(R2,D2) for 70° side');
ylabel('(R,D) for 250° side');
title('Choice Probability (250°) in %');

% Optionally save
saveas(gcf, 'ChoiceProbability_250_Heatmap.jpg');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Below is a function that plots 18 separate 3×3 heatmaps, each for a
% specific (R,D,Angle) combination vs. an opponent's (R_opp,D_opp).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function analyze_combo_choice_18figs()
    %% (1) Read and merge data
    fileList = dir('Pu*_datM1.mat');
    if isempty(fileList)
        error('No Pu*_datM1.mat files found.');
    end

    bigDat = [];
    for f = 1:length(fileList)
        datStruct = load(fileList(f).name, 'dat');
        if ~isfield(datStruct, 'dat')
            warning('File %s does not have variable dat', fileList(f).name);
            continue;
        end
        bigDat = [bigDat; datStruct.dat(:)];
    end
    fprintf('Merged a total of %d trials.\n', length(bigDat));

    %% (2) Define the list of 18 combos (Reward, Difficulty, Angle)
    combos = [
        1,10,70;  1,10,250;
        1,15,70;  1,15,250;
        1,30,70;  1,30,250;
        2,10,70;  2,10,250;
        2,15,70;  2,15,250;
        2,30,70;  2,30,250;
        3,10,70;  3,10,250;
        3,15,70;  3,15,250;
        3,30,70;  3,30,250
    ];

    comboLabels = {
        'r1d10a70','r1d10a250','r1d15a70','r1d15a250','r1d30a70','r1d30a250',...
        'r2d10a70','r2d10a250','r2d15a70','r2d15a250','r2d30a70','r2d30a250',...
        'r3d10a70','r3d10a250','r3d15a70','r3d15a250','r3d30a70','r3d30a250'
    };

    nCombo = size(combos,1);  % 18 combos

    % Opponent reward & difficulty levels
    rewardLevels = [1, 2, 3];
    difficultyLevels = [10, 15, 30];

    % Helper function: find (R,D,ang) in combos => row index
    function idx = findComboIndex(R, D, ang)
        idxList = find(combos(:,1)==R & combos(:,2)==D & combos(:,3)==ang);
        if isempty(idxList)
            idx = [];
        else
            idx = idxList(1);
        end
    end

    %% (3) Process each main combo (iCombo)
    for iCombo = 1:nCombo
        R_i = combos(iCombo,1);
        D_i = combos(iCombo,2);
        A_i = combos(iCombo,3);

        % We'll gather offers & chosen in a 3×3 matrix
        offersMat = zeros(3,3);
        chosenMat = zeros(3,3);

        %% (4) Go through all trials
        for t = 1:length(bigDat)
            trialParams = bigDat(t).params.trial;
            if trialParams.choiceTrial ~= 1
                continue;  % only double-target
            end
            if ~isfield(trialParams, 'choice')
                continue;
            end

            chosen = trialParams.choice;  % 1 => targetAngle1; 2 => targetAngle2
            angle1 = trialParams.targetAngle1;
            angle2 = trialParams.targetAngle2;
            R1     = trialParams.rewardIdx1;
            R2     = trialParams.rewardIdx2;
            D1     = trialParams.targRad1;
            D2     = trialParams.targRad2;

            % Find which combos each target belongs to
            i1 = findComboIndex(R1, D1, angle1);
            i2 = findComboIndex(R2, D2, angle2);

            % If invalid or same combo, skip
            if isempty(i1) || isempty(i2) || i1==i2
                continue;
            end

            % Check if target1 is our main combo
            if i1 == iCombo
                % Opponent => i2
                R_opp = combos(i2,1);
                D_opp = combos(i2,2);
                % Opponent angle not relevant here, only (R_opp,D_opp)
                iR_opp = find(rewardLevels==R_opp, 1);
                iD_opp = find(difficultyLevels==D_opp, 1);
                if ~isempty(iR_opp) && ~isempty(iD_opp)
                    offersMat(iR_opp, iD_opp) = offersMat(iR_opp, iD_opp) + 1;
                    if chosen==1
                        chosenMat(iR_opp, iD_opp) = chosenMat(iR_opp, iD_opp) + 1;
                    end
                end

            elseif i2 == iCombo
                % Opponent => i1
                R_opp = combos(i1,1);
                D_opp = combos(i1,2);
                iR_opp = find(rewardLevels==R_opp, 1);
                iD_opp = find(difficultyLevels==D_opp, 1);
                if ~isempty(iR_opp) && ~isempty(iD_opp)
                    offersMat(iR_opp, iD_opp) = offersMat(iR_opp, iD_opp) + 1;
                    if chosen==2
                        chosenMat(iR_opp, iD_opp) = chosenMat(iR_opp, iD_opp) + 1;
                    end
                end
            end
        end

        %% (5) Compute choice probability (3×3 matrix)
        choiceProbMat = zeros(3,3);
        for r2i = 1:3
            for d2i = 1:3
                if offersMat(r2i,d2i) > 0
                    choiceProbMat(r2i,d2i) = (chosenMat(r2i,d2i)/offersMat(r2i,d2i))*100;
                else
                    choiceProbMat(r2i,d2i) = 0;
                end
            end
        end

        %% (6) Plot and save
        figure('Name', sprintf('Combo_%d Heatmap', iCombo));
        imagesc(choiceProbMat);
        colormap(jet);
        colorbar;
        caxis([0 100]);
        axis equal tight;

        % Y-axis: R=1..3, X-axis: D=10,15,30
        set(gca, 'XTick', 1:3, 'XTickLabel', {'D=10','D=15','D=30'});
        set(gca, 'YTick', 1:3, 'YTickLabel', {'R=1','R=2','R=3'});
        xlabel('Difficulty of Opponent');
        ylabel('Reward of Opponent');

        comboLabel = comboLabels{iCombo};
        titleStr = sprintf('Choice Probability for Combo=%s (%%)', comboLabel);
        title(titleStr);

        saveas(gcf, sprintf('ChoiceProbability_%s.jpg', comboLabel));
    end

    fprintf('Generated %d heatmaps, each is a main combo vs. 3×3 opponents (ignoring their angle).\n', nCombo);
end
