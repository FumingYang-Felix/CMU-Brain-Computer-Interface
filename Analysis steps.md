# Analysis Steps

## 1. Load `Pu*_datM1.mat` Files
- Used `dir('Pu*_datM1.mat')` to locate all `.mat` files.
- For each file, loaded the `dat` variable (if present) and appended it into a single structure array `bigDat`.
- Verified that all files were correctly merged.

---

## 2. Define Parameter Spaces
- Established reward levels `[1, 2, 3]` and difficulty levels `[10, 15, 30]`.
- Identified angles of interest (most commonly `70°` and `250°`).
- Created either:
  - **9 combos** (if ignoring angle), or
  - **18 combos** (if including angle: `(Reward, Difficulty, Angle)`).

---

## 3. Single-Target Statistics
- Focused on trials where `choiceTrial = 0` to gather data for a single target (e.g., angle = `70°` or `250°`).
- Recorded how many times that target was offered (`totalCount`) and how many ended in success (`successCount`), based on `resultCode == 150`.

---

## 4. Double-Target Statistics
- Analyzed trials where `choiceTrial = 1` and angles were `(70° vs. 250°)`.
- Noted which target was chosen (the `choice` field).
- Built 4D arrays such as `double_offerCount_70` / `double_choseCount_70` (or similarly for `250`) to tabulate:
  - **Offers**: how many times each `(R,D)` pair (for 70°) faced each `(R,D)` pair (for 250°).
  - **Choses**: how many times participants actually chose that angle.

---

## 5. Generate Bar Charts
- For each `(R, D, Angle)`, plotted a series of bars:
  - **First bar**: single-target performance (success rate).
  - **Next bars**: success rate when facing different opponent combos (e.g., `(R2, D2)`).
- Displayed text labels on top of each bar in the form `#success / #total` (or fractional/percentage).
- Automatically saved figures in `.jpg` format.

---

## 6. Generate Heatmaps
- Created 9×9 matrices where rows/columns represent `(R,D)` combos for `70°` vs. `250°`.
- Filled each cell with either:
  - **Choice Probability**: how often participants chose one angle over the other, or
  - **Success Rate**: how often they succeeded.
- Used `imagesc` + `colorbar` in MATLAB to visualize values with color scales (`caxis([0 100])` for percentages).
- Labeled axes (`(R,D)` for 70° side vs. `(R2,D2)` for 250° side) and saved heatmaps as `.jpg`.

---

## 7. Combo-Based Heatmaps (18 Combos)
- Implemented a function (e.g., `analyze_combo_choice_18figs`) to iterate through 18 `(Reward, Difficulty, Angle)` combos.
- For each combo, constructed a 3×3 matrix (opponent `(R_opp, D_opp)`) showing how often the main combo was chosen.
- Output separate heatmaps (`.jpg`) for each combo.

---
