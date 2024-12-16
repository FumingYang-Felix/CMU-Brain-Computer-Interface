# **Task Design**

This document describes the **task design** for the experiment investigating decision-making behavior and neural responses in **rhesus macaques** during the **Delayed Center-Out Reaching Task**. The experiment examines how **reward levels**, **task difficulty**, and **target angles** influence behavioral and neural outcomes.

---

## **1. Task Workflow**

Each trial consists of the following key stages:

1. **Initial Phase**  
   - The monkey moves a cursor to align with the central target position.  

2. **Delay Phase**  
   - The cursor remains at the center target for a **random delay** period:  
     - `minDelayMs = 600 ms`.  

3. **Target Presentation**  
   - Two peripheral targets appear at fixed angles:  
     - **70°** and **250°**.  
   - Each target is associated with:  
     - **Reward Level**:  
       - Small = `1`, Medium = `2`, Large = `3`.  
     - **Task Difficulty** (Target Radius):  
       - Hard = `10`, Medium = `15`, Easy = `30`.  

4. **Movement Phase**  
   - A **Go Cue** prompts the monkey to move the cursor to one of the targets.  
   - The movement must be completed within:  
     - `movementJoyTime = 350 ms`.  

5. **Hold Phase**  
   - The cursor must remain in the selected target for:  
     - `targetHoldMs = 250 ms`.  

6. **Feedback Phase**  
   - If the hold phase is successful (`result = 150`), a reward is delivered based on the target's **reward level**:  
     - **Reward Timing**: `[80, 160, 400, 3000] ms`.

---

## **2. Experimental Conditions**

### **2.1 Reward Levels**
- **Small**: `1`  
- **Medium**: `2`  
- **Large**: `3`  

### **2.2 Task Difficulty**
- Defined by **target radii**:  
  - **Hard**: `10`  
  - **Medium**: `15`  
  - **Easy**: `30`  

### **2.3 Target Angles**
- Fixed at:  
  - **70°**  
  - **250°**

### **2.4 Condition Combinations**
- The experiment uses a **3x3 grid** of **Reward x Difficulty** combinations.  
- Each trial presents **two combinations** at the **two target angles** (70° and 250°).  

---

## **3. Behavioral Metrics**

### **3.1 Success Criteria**
- A trial is considered **successful** if:  
  - `result = 150`.  

### **3.2 Failure Modes**
- **Overshoot**: Cursor moves beyond the target region.  
- **Undershoot**: Cursor does not reach the target region within `movementJoyTime`.  

---

## **4. Data Recording**

### **4.1 Neural Data**
- **Channels**: `64`  
- **Spike Times**: Calculated using `spiketimesdiff` and `firstspike`.  
- **Sampling Frequency**: `30000 Hz`.  

### **4.2 Behavioral Data**
- **Result**: Trial outcome (e.g., `150` = success).  
- **Event Codes**: Recorded in `trialcodes` and `event`.  
- **Parameters**: Stored in `params.trial`, including:  
  - `targetAngle1`, `targetAngle2`: Angles (70°, 250°).  
  - `rewardIdx1`, `rewardIdx2`: Reward levels.  
  - `targRad1`, `targRad2`: Task difficulty.  
  - `choice`: Chosen target.  

---

## **5. Analysis Pipeline**

### **Step 1**: Filter Trials  
- Select trials where:  
  - `choice = 1` (valid trials).  
- Use `choiceTrial` to determine:  
  - **Target Angle** = `targetAngle1` or `targetAngle2`.  

### **Step 2**: Group Data  
- Group trials by target angles:  
  - **70°**  
  - **250°**  

### **Step 3**: Calculate Success Rate  
- For each group (70° and 250°):  
  - Compute **success rate** as:  
    ```matlab
    success_rate = num_successful_trials / total_trials;
    ```

### **Step 4**: Visualization  
- Plot **success rates** as a bar chart for:  
  - **70°** and **250°** target angles.  

---

## **6. Example Code**

```matlab
% Initialize variables
numTrials = length(dat);
success_70 = 0; total_70 = 0;
success_250 = 0; total_250 = 0;

% Loop through trials
for i = 1:numTrials
    if dat(i).params.trial.choice == 1  % Filter choice = 1 trials
        % Determine target angle
        if dat(i).params.trial.choiceTrial == 1
            angle = dat(i).params.trial.targetAngle1;
        elseif dat(i).params.trial.choiceTrial == 2
            angle = dat(i).params.trial.targetAngle2;
        else
            continue;
        end
        
        % Update success counts
        if angle == 70
            total_70 = total_70 + 1;
            if dat(i).result == 150
                success_70 = success_70 + 1;
            end
        elseif angle == 250
            total_250 = total_250 + 1;
            if dat(i).result == 150
                success_250 = success_250 + 1;
            end
        end
    end
end

% Calculate success rates
successRate_70 = success_70 / total_70;
successRate_250 = success_250 / total_250;

% Display results
fprintf('Success Rate for 70°: %.2f%%\n', successRate_70 * 100);
fprintf('Success Rate for 250°: %.2f%%\n', successRate_250 * 100);

% Plot results
figure;
bar([70, 250], [successRate_70, successRate_250] * 100);
xlabel('Target Angle (degrees)');
ylabel('Success Rate (%)');
title('Success Rate by Target Angle');
grid on;
