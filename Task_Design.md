# **Task Design**

This experiment investigates decision-making behavior and neural responses of rhesus macaques in the **Delayed Center-Out Reaching Task**. The design focuses on how **reward levels**, **target angles**, and **task difficulty** influence behavior and neural activity.

---

## **1. Experiment Overview**

- **Subjects**:  
  - Three adult male rhesus macaques.  
- **Neural Recording**:  
  - Neural activity is recorded using **Utah arrays** from the **Primary Motor Cortex (M1)** and **Dorsal Premotor Cortex (PMd)**.  
- **Behavioral Data**:  
  - Includes reaction times, success rates, and trial outcomes.  
- **Surface EMG**:  
  - Recorded for **Monkey R** to assess muscle activation during motor execution.

---

## **2. Task Workflow**

Each trial consists of the following **phases**:

### **2.1 Initial Phase**
- The monkey moves the cursor to align with the **central target** position.  
- This ensures the trial starts with a consistent baseline position.  

### **2.2 Delay Phase**
- The cursor remains on the center target for a **random delay**:  
  - **Minimum delay duration**: `minDelayMs = 600 ms`.

### **2.3 Target Presentation**
- Two peripheral targets appear simultaneously at fixed angles:  
  - **Target Angles**: `70°` and `250°`.  
- Each target is associated with:  
  - **Reward Level**:  
    - Small = `1`, Medium = `2`, Large = `3`.  
  - **Task Difficulty**:  
    - Hard: `targRad = 10` (small radius).  
    - Medium: `targRad = 15` (medium radius).  
    - Easy: `targRad = 30` (large radius).  

### **2.4 Movement Phase**
- A **Go Cue** prompts the monkey to move the cursor to the chosen target.  
- The movement must be completed within:  
  - **Movement Time Limit**: `movementJoyTime = 350 ms`.  

### **2.5 Hold Phase**
- The cursor must remain within the target area for:  
  - **Hold Time**: `targetHoldMs = 250 ms`.  
- Success depends on precise movement and hold duration.

### **2.6 Feedback Phase**
- If the trial is successful:  
  - A reward is provided based on the chosen target’s **reward level**.  
  - **Reward Durations**: `[80, 160, 400, 3000] ms`.

---

## **3. Experimental Conditions**

The experiment combines **reward levels** and **task difficulty** in a **3x3 factorial design**:

### **3.1 Reward Levels**
- Small = `1`  
- Medium = `2`  
- Large = `3`  

### **3.2 Task Difficulty**
- Hard: **Radius = 10**  
- Medium: **Radius = 15**  
- Easy: **Radius = 30**  

### **3.3 Target Angles**
- Fixed at:  
  - **70°**  
  - **250°**  

### **3.4 Condition Combinations**
- Each trial presents **two combinations** (one per target angle):  
  - **Reward Level x Difficulty** grid:  
    | **Reward** | **Difficulty** |  
    |------------|----------------|  
    | Small      | Hard, Medium, Easy |  
    | Medium     | Hard, Medium, Easy |  
    | Large      | Hard, Medium, Easy |  

---

## **4. Visual and Display Settings**

- **Background Color**: Gray `[128, 128, 128]`.  
- **Fixation Point Color**: Blue `[0, 0, 255]`.  
- **Cursor Color**: Blue-Green `[0, 100, 25]`.  
- **Target Color**: White `[255, 255, 255]`.  
- **Screen Resolution**: `1024 x 768 pixels`.  
- **Refresh Rate**: `100 Hz`.  
- **Pixel/CM Ratio**: `26.3 pixels/cm`.

---

## **5. Time Parameters**

- **Minimum Delay Duration**: `600 ms`.  
- **Reaction Time Limit**: `340 ms`.  
- **Movement Time Limit**: `350 ms`.  
- **Hold Duration**: `250 ms`.  
- **False Start Penalty**: `800 ms`.  

---

## **6. Randomization Settings**

- **Block Randomization**: Enabled (`blockRandomize = 1`).  
- **Difficulty Distribution Probabilities**:  
  - **Easy Block**: `[0.1, 0.2, 0.3, 0.4]`.  
  - **Hard Block**: `[0.4, 0.3, 0.2, 0.1]`.  

---

## **7. Behavioral and Neural Goals**

### **7.1 Behavioral Objectives**
- Investigate how **reward levels** and **task difficulty** influence:  
  - Success rates.  
  - Reaction times.  
  - Failure modes (e.g., overshoot, undershoot).  
- Analyze decision-making strategies when two conditions are presented simultaneously.  

### **7.2 Neural Objectives**
- Evaluate neural activity in **M1** and **PMd** during:  
  - **Delay Phase**: Encoding of reward and difficulty.  
  - **Movement Phase**: Directional tuning and reward modulation.  
- Assess trial-to-trial variability in neural encoding.

---

## **8. Summary**

This experiment introduces a controlled **decision-making task** with simplified **reward levels** and varying **task difficulties** at two fixed angles. The design provides a framework to study the trade-off between **reward** and **effort** while simultaneously examining the neural basis of motor control and decision-making.

---

