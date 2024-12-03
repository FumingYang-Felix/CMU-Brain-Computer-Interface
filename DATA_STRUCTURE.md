
# **Data Structure Documentation**

This document provides a detailed description of the `dat` data structure used in the project. The dataset contains recordings from **1885 trials**, with each trial stored as an entry in a structured array. Below is a comprehensive breakdown of the fields within the `dat` structure.

---

## **1. Overview**
Each trial is represented as a structured entry, with the following key components:
- **Neural Data**: Spike times and related channel information.
- **Behavioral Events**: Trial-specific events and outcomes.
- **Task Parameters**: Metadata defining task conditions, including reward, target angles, and difficulty.

---

## **2. Field Descriptions**

### **2.1 `channels`**
- **Type**: `64x2 double`
- **Content**:
  - The **first column** contains the neural recording channel numbers:
    ```
    129, 130, 131, ..., 160, 225, 226, ..., 256
    ```
  - The **second column** contains the constant value `1` for all entries.

---

### **2.2 `time`**
- **Type**: `1x2 double`
- **Content**:
  - Represents the start and end time of the trial (in seconds).

---

### **2.3 `text`**
- **Type**: `char`
- **Content**:
  - Encodes detailed trial-specific information as a string. Example:
    ```
    'emptyCnd=1;baseHue=1;targetAngle1=70;rewardIdx1=2;rewardIdx2=3;targRad1=15;targRad2=15;currBlock=1;initHsv=0.125 1 0.67;focusDifficultyMod=1;targetAngle2=250;minDelayMs=600;choiceTrial=1;choice=2;'
    ```
  - **Explanation**:
    - `emptyCnd`: Condition ID.
    - `baseHue`: Stimulus base hue.
    - `targetAngle1`, `targetAngle2`: Target angles (always **70°** and **250°**).
    - `rewardIdx1`, `rewardIdx2`: Reward levels for two choices (Small = 1, Medium = 2, Large = 3).
    - `targRad1`, `targRad2`: Target radii (10 = hard, 15 = medium, 30 = easy).
    - `minDelayMs`: Minimum delay duration (in ms).
    - `choiceTrial`: Indicates if this was a choice trial.
    - `choice`: The choice made during the trial.

---

### **2.4 `trialcodes`**
- **Type**: `Nx3 double`
- **Content**:
  - **Column 1**: Always `0`.
  - **Column 2**: Event codes corresponding to specific task events (e.g., "go cue," "target acquisition").
  - **Column 3**: Event timestamps (in seconds).

---

### **2.5 `event`**
- **Type**: `Nx3 uint32`
- **Content**:
  - Includes all recorded events for the trial.
  - **Column 3**: Timestamps in samples. To convert to seconds:
    ```
    time_in_seconds = event(:, 3) / 30000;  % Sampling frequency = 30,000 Hz
    ```

---

### **2.6 `firstspike`**
- **`firstspike`**:
  - Time (in samples) of the first spike relative to the start of the trial.

---


### **2.7 `spiketimesdiff`**

- **`spiketimesdiff`**:
  - Inter-spike intervals (in samples) for all subsequent spikes.
- **Usage**:
  - To compute absolute spike times:
    ```matlab
    spike_times = (cumsum(spiketimesdiff) + firstspike) / 30000; % Convert to seconds
    ```
  - Append `firstspike` at the start of the spike_times array.

---


### **2.8 `spikeinfo`**
- **Type**: `Nx2 uint16`
- **Content**:
  - **Column 1**: Channel numbers corresponding to each spike (64 different channels).
  - **Column 2**: Spike identifiers.

---

### **2.9 `result`**
- **Type**: Integer
- **Content**:
  - Encodes the trial outcome (specific codes depend on the task definition).

---

### **2.10 `params`**
- **Type**: `struct`
- **Content**:
  - Nested structure containing parameters for the trial/block. Key fields include:
    - **`params.trial`**:
      - `targetAngle1`, `targetAngle2`: Target angles (70° and 250°).
      - `rewardIdx1`, `rewardIdx2`: Reward levels (1 = Small, 2 = Medium, 3 = Large).
      - `targRad1`, `targRad2`: Target radii, defining difficulty (10 = hard, 15 = medium, 30 = easy).
      - `minDelayMs`: Minimum delay duration (in ms).
      - `choiceTrial`: Indicates if this was a choice trial.
      - `choice`: The chosen option.
    - **`params.block`**:
      - **General Information**:
        - `SubjectID`: Identifier for the experimental subject (e.g., `'pumbaa'`).
        - `sessionNumber`: Session number for the current experiment (e.g., `450`).
        - `experimenter`: Name of the experimenter conducting the session (e.g., `'chris'`).
        - `name`: The name of the experimental task (e.g., `'rewardChoiceFocusTask'`).

      - **Experimental Parameters**:
        - `targetAngleAll`: All potential target angles presented during the session (e.g., `[0, 60, 120, 180, 240, 300]`).
        - `targetDistance`: Distance from the center to the target in spatial units (e.g., `300`).
        - `targRadPunish`: Punishment radius for the target (e.g., `35`).
        - `targWinRad`: Target window radius, defining the tolerance for target acquisition (e.g., `60`).
        - `focusDifficultyShifts`: List of difficulty settings for focus-based tasks (e.g., `[30, 30, 30, 30]`).
        - `focusProbabilityEasyBlock`: Probability distribution for easier blocks (e.g., `[0.1000, 0.2000, 0.3000, 0.4000]`).
        - `focusProbabilityHardBlock`: Probability distribution for harder blocks (e.g., `[0.4000, 0.3000, 0.2000, 0.1000]`).

      - **Visual and Display Settings**:
        - `bgColor`: Background color of the display (e.g., `[128, 128, 128]` for gray).
        - `fixColor`: Color of the fixation point (e.g., `[0, 0, 255]` for blue).
        - `fixWinRad`: Radius of the fixation window, defining tolerance for maintaining fixation (e.g., `33`).
        - `displayWidth`, `displayHeight`: Resolution of the display in pixels (e.g., `1024x768`).
        - `displayHz`: Refresh rate of the display in Hz (e.g., `100`).
        - `displayFrameTime`: Time per frame in seconds (e.g., `0.0100`).

      - **Timing Parameters**:
        - `minNumFlashes`: Minimum number of flashes presented during the task (e.g., `3`).
        - `movementJoyTime`: Time allowed for joystick movements (e.g., `350` ms).
        - `targetHoldMs`: Time the cursor must remain within the target to register a successful trial (e.g., `250` ms).
        - `reactionTimeMaximum`: Maximum allowed reaction time (e.g., `340` ms).

      - **Neural Recording Settings**:
        - `neuralRecordingSamplingFrequency`: Sampling frequency for neural data (e.g., `30000` Hz).
        - `sampleFreq`: Overall sampling frequency for all recordings (e.g., `48000` Hz).

      - **Reward Parameters**:
        - `rewardDistribution`: Type of reward distribution used (e.g., `'unif'` for uniform).
        - `rewardDistributionParams`: Parameters for reward distribution (e.g., `[1, 5]`).
        - `rewarding`: Flag indicating whether rewards are enabled (e.g., `1`).
        - `variableRewardMs`: Variable reward timing (e.g., `[80, 160, 400, 3000]`).

      - **Behavioral Control**:
        - `bciEnabled`: Flag indicating whether brain-computer interface control is enabled (e.g., `0` for disabled).
        - `blockRandomize`: Whether trials are randomized within blocks (e.g., `1` for enabled).
        - `retry_WRONG_TARG`: Whether retries are enabled for wrong target selections (e.g., `0` for disabled).

      - **Calibration and Configuration**:
        - `calibPixX`, `calibPixY`: Calibration settings for X and Y pixel ranges.
        - `calibVoltX`, `calibVoltY`: Voltage calibration ranges for X and Y axes.
        - `pixPerCM`: Pixels per centimeter for screen calibration (e.g., `26.3000`).

      - **Networking and System**:
        - `bci2controlIP`: IP address for brain-computer interface control communication (e.g., `'192.168.2.10'`).
        - `control2bciIP`: IP address for control-to-BCI communication (e.g., `'192.168.2.11'`).
        - `nasNetFolderBciComputer`: Path to the network-attached storage folder for BCI data.
"""


---

## **3. Task Configuration**
- **Reward Levels**: Small, Medium, Large (RewardIdx = 1, 2, 3).
- **Target Angles**: Fixed at **70°** and **250°**.
- **Task Difficulty**: Defined by target radii (10, 15, 30; larger radius = easier).
- **3x3 Combinations**:
  - Trials involve combinations of reward levels and difficulty.
  - Two combinations are shown per trial, one at each angle.

---

## **4. Key Notes**
- **Neural Data**: `channels`, `spikeinfo`, `spiketimesdiff`, and `firstspike` provide all necessary neural activity information.
- **Behavioral Events**: `trialcodes`, `event`, and `result` describe task events and trial outcomes.
- **Parameters**: `params.trial` encodes metadata crucial for interpreting trial conditions.

---
