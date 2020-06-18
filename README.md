# Bachelor Degree Project

In this Github repository one can find the code files that were modified or created from scratch for the Project. I will introduce each of the Matlab files (.m) on the following paragraphs, explaning which is the role of each of them. In case one of the files already existed, I will also specify which were the modifications done. 

## Notes

- The aim of this page is only to display the most important parts of the code that were developed for the Bachelor Degree Project. 
- These files are part of a software created in Matlab called SpyCode and therefore cannot be executed individually. 

## Content

### GSM_filter_getParam.m (modified)

**Description:** This function obtains the parameters of the chosen algorithm from user input.

**Before**: It obtained the parameters for the Notch Filter: Type, sampling frequency., filter bandwidth and number of harmonics.

**After**: It obtains the Wiener and RLS parameters: Filter type, sampling frequency, filter order (and forgetting factor for the RLS).

### GSM_filter_elW.m (modified)

**Description:** This is the function responsible for making the call to the desired algorithm (with the parameters obtained with the previous function).

**Before**: The option was limited to the only filter available: Notch.

**After**: Two more options were added. The one for the Wiener corresponds to $s==2$, and the one for the RLS $s==3$.


### GSM_Filter_all_elW.m (modified)

**Description:** Main GSM filtering code: it takes the parameters of the selected filter, creates the folder where the filtered data will be placed and filters the artifact.

**Before**: It was not possible to apply two different filters to the same data without overwriting the filtered data. It was also impossible to choose a reference electrode and 3 representative for the analysis. This led to an arduous and laborious filtering.

**After**: The name of the folder changes automatically with each specific filter (and parameter) so that the data is not overwritten. This is translated to a possibility of applying several filters with several parameters at the same time. It has also been added the possibility to choose 4 electrodes (from phase E) and facilitate the analysis.

### wiener.m (created)

**Description:** The algorithm takes as arguments the signal x (which comes from the reference electrode: the raw signal of the artifact), d (the data of the electrode to analyze which contains the biological signal plus the artifact) and the order of the filter. After applying the Wiener algorithm it returns the coefficients h_w. These coefficients will be used to filter the data of the reference electrode through the filter() function. 

### rls_filter.m (created)

**Description:** The algorithm takes as arguments the signal x (which comes from the reference electrode: the raw signal of the artifact), d (the data of the electrode to analyze which contains the biological signal plus the artifact) and the algorithm parameters. After applying the RLS algorithm it returns the _filtered_GSM_data_ array.


### plotpeaksraw.m (modified)

**Description:** Main code for the plotting of the spikes.

**Before**: A single plot could be done, showing the spikes of the selected electrode. The plot did not carry any information about the data plotted.

**After**: An option to make several plots of the spikes has been added. Each of the plots specifies: 
- the number of the experiment
- the modulation frequency
- the analysis phase 
- the electrode chosen
- the filter chosen
- the forget factor (if filter = RLS). 

Moreover, it is possible to plot the spectrum of several data (before and after filtering) with its specific title (ph. S2 and E).
