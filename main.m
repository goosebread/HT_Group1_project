%Alex Yeh 4/7/2021
%Project Final Report

%script to extract features from raw data and plot EMG total power

subjects=["u","m","a"];
for i=1:3
    for j=1:3
        feature_extract(subjects(i),j);
    end
end
output_read(subjects);
