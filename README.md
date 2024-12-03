# Chase-Lab
Data Structure and Analysis Overview

_______________________________________________________________________________________________________

Introduction:
This repository documents the dataset structure and analysis pipeline for experiments investigating decision-making behavior and neural responses in rhesus macaques during delayed reaching tasks. The study builds upon existing methodologies while incorporating new experimental design elements to address how reward levels, target angles, and task difficulty influence behavioral and neural outcomes.

_______________________________________________________________________________________________________

Background:
The foundational experimental setup involved three adult male rhesus macaques performing delayed center-out reaching tasks. Each monkey interacted with targets under varying conditions while neural data from the primary motor cortex (M1) and dorsal premotor cortex (PMd) were recorded using implanted Utah arrays. Behavioral data, such as reaction times and success rates, were collected alongside neural spike data, providing a comprehensive view of task performance and neural engagement.

_______________________________________________________________________________________________________
***** Key Experimental Details from Previous Studies *****

  1. Task Design:

Monkeys initiated trials by positioning a cursor at a central target. After a randomized delay, a peripheral target appeared, and a go cue prompted the monkey to move the cursor to the target within a specific time window. The reward magnitude was indicated by visual cues and varied across trials (Small, Medium, Large, Jackpot).
 
  2. Behavioral Metrics:

Success rates depended on precise target acquisition and maintenance during the hold phase. Failure modes were categorized as overshoots (cursor moving past the target) or undershoots (cursor failing to reach the target in time).
  
  3. Neural Data Acquisition:
  
Neural activity was recorded with high temporal resolution and analyzed for directional tuning, reward modulation, and trial-to-trial variability.
  
  4. Surface EMG:
  
For Monkey R, surface EMG data were recorded to assess muscle activation during the tasks, providing additional insights into the motor execution phase.
  

_______________________________________________________________________________________________________
***** New Experimental Design *****

Building on these foundational methods, the current study introduces new task parameters to further dissect the role of task difficulty and simplified reward structures in decision-making and neural tuning.

  1. Simplified Reward Structure:

The new setup reduces the reward conditions to three levels: Small, Medium, and Large, removing the Jackpot condition.

  2. Restricted Target Angles:
Instead of multiple target angles, only 70° and 250° are used. This ensures a focused analysis of how behavioral and neural responses vary with constrained spatial configurations.

  3. Task Difficulty:
     
Task difficulty is introduced as a new parameter, defined by the radius of the target region:
Difficulty Levels: 10 (hard), 15 (medium), and 30 (easy), where larger radii correspond to lower difficulty.
Difficulty modulates the precision required for successful target acquisition.
  
  4. Condition Combinations:

A 3x3 grid of experimental conditions (Reward x Difficulty) is established. In each trial, two combinations from this grid are presented, one at each target angle (70° and 250°). This ensures that monkeys encounter varying levels of reward and difficulty simultaneously.


_______________________________________________________________________________________________________
***** Experimental Goals *****
  1. Behavioral Objectives:

Investigate how reward magnitude and task difficulty influence success rates, reaction times, and failure modes.
Examine decision-making strategies when presented with simultaneous conditions.

  2. Neural Objectives:

Analyze the directional tuning and reward modulation of neural firing rates in M1 and PMd during the delay and reach phases.
Evaluate trial-to-trial variability and how neural encoding adapts to task difficulty.

  3. Comparison with Previous Work:

Determine how simplified conditions and added difficulty parameters alter behavioral and neural outcomes compared to the original experiment.
Structure of this Repository


_______________________________________________________________________________________________________
This repository is organized as follows (You can directly search by name):

    Behavioral Data Analysis Outline
  
   - Success Rates and Failure Modes Analysis
  
   - Single-Trial Behavioral Metrics

    Surface EMG Analysis Outline

   - Directional Tuning of EMG Signals
  
   - EMG Analysis During Delay Phase

    Neural Data Analysis Outline

   - PSTH Analysis
  
   - Single-Unit Tuning Analysis
  
   - Trial-to-Trial Variability Analysis
  
   - Neural Signal Aggregation

    
    Combined Behavioral and Neural Analysis Outline

   - Correlation Between Neural Activity and Behavioral Metrics 
  

- Analysis Pipeline: Outlines the step-by-step procedures for analyzing behavioral metrics, neural data, and their combined insights.

- Results and Outputs: Summarizes key findings and provides visualization scripts for reproducing figures.
