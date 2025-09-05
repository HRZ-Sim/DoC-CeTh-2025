# DoC-CeTh-2025
This repository contains scripts for analyzing both empirical clinical data and simulated CeTh activity using a conductance-based model, as detailed in our study, "A Shared Central Thalamus Mechanism Underlying Diverse Recoveries in Disorders of Consciousness." Below, you will find a detailed description of each folder, its functionality, and the necessary software environment and dependencies.

[General Requirements]

MATLAB Version: R2023b

Recommended: Due to the intensive computation required, especially for the simulation part, it is advised to run these scripts on a server.

[Repository Structure]

1. Empirical analysis/

This folder contains scripts for processing and analyzing empirical CeTh recordings to select and evaluate features.

-Main_pipline.m: 

    Main function orchestrating the feature selection pipeline across five steps, loading sample data from step1_sampleData.mat.
    
-organizeAllCeThfeatures.m:

    Organizes and displays all raw features.
    
-Step1_clusteringFeatures.m:

    Clusters features based on high similarity.
    
-Step2_filteredFeatureSelection.m: 

    Filters features by significance, effect size, or Fisher scores.
    
-Step3_EmbeddedFeatureSelection.m: 

    Applies Lasso regularization for embedded feature selection.
    
% linear SVM: using the liblinear-2.43

% LIBSVM page: http://www.csie.ntu.edu.tw/~cjlin/libsvm

-Step4_FeatureAggregation.m: 

    Aggregates features with high weights.
    
-Step5_WrapperFeatureSelection.m: 

    Iterates through feature combinations to identify the final optimal selections.
    
-organizefeatures_finalCeThmetric,m:

    Organizes and displays the final chosen optimal features.

Subfolders:

Empirical analysis/Intermediate results/Step3_Modelresults/: Stores model classification results from step 3.

Empirical analysis/Intermediate results/Step5_Modelresults/: Stores model classification results from step 5.

Empirical analysis/scriptFunction/: Contains utility functions supporting various scripts:

-func_FisherScore.m: 

    Calculates Fisher's score.
    
-F1score.m: 

    Calculates F1 score.

-transz.m: 

    Translates output of linkage in the clustering part.
    
-updatingfeatureName.m and nameUpdate.m: 

    Standardize feature naming across different script versions.







2. Simulation/

This folder contains scripts for simulating conditions and analyzing simulated CeTh activity.

-Main.m: 

    Main function that coordinates the following simulation tasks:
    
-task1_draw_ExampleForTonicAndLTB.m

    Example Drawing for Tonic and LTB. Visualizes spiking activity of the network under deafferented and normal conditions.
    
-task2_draw_ScandeaffRatio.m

    Scanning Deafferented Neuron Ratio. Explores the effects of varying the proportion of deafferented neurons within the network.
    
-task3_draw_ScanaffMag.m

    Scanning Afferent Magnitude. Analyzes how different levels of residual afferent input affect the network.
    
-task5_draw_4stagesPSD.m

    Scanning  through four different stages of consciousness (I, II, III, IV) as defined in the Method Section. This script evaluates the network’s response across these stages, helping to elucidate the neural correlates of varying conscious states.
    
-task6_saveResults.m

    Save results from Task6 for further analysis.
    
-task6_draw_scanaffMagANDaffStab.m

    Scanning Afferent Magnitude and Stability. Explore and visualize the combined effects of afferent input magnitude and stability on network behavior.
    
-task6_draw_2DimModchanges.m

    Visualizes the distribution of simulated CeTh activity under different states of consciousness in two dimensions: the power and stability of the theta rhythm. and drawing parallels with empirical distributions.

Subfolders:

Simulation/Task1~6/:

/Task1/: Stores the settings for two types of neuronal input (Poisson spike train). Additionally, W_N100.mat is the initial connectivity matrix used in the simulations.

/Task2~6/: Each folder stores the results from 100 trials of simulations performed on a server for each respective task.

Simulation/scriptFunction/: Contains utility functions for simulation:

-func_simulating.m: The main function for iterative simulation modeling.

-func_checkPlotINEllipse.m, func_smoothDots.m, func_interpolation.m: Support task6_draw_2DimModchanges.m.

[Notes]
For access to raw data, or if you have any questions or issues related to the code, please contact the corresponding author.

This code is licensed under CC-BY-NC 4.0

Non-commercial use only, attribution required
