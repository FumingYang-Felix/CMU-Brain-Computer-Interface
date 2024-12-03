
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
      - 

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
