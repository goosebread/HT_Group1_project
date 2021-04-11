%Alex Yeh 4/7/2021
%Project Final Report

%read feature_extract output files

%distinguish groups in scatterplot using circle, diamond, square

function output_read(subjects)
%input is groups to analyze

subject_colors = [[1 1 0];[0 1 1];[1 0 1]];
markers=['o','s','d'];

pow_fig=figure('NumberTitle', 'off', 'Name', "EMG Power vs Angles");
colormap jet;
colorbar;
caxis([-100,100]);
xlabel("Flexion Power (dB)");
ylabel("Extension Power (dB)");

hold on;

for sbj=1:length(subjects)
    
    group=subjects(sbj);
    
    for g=1:3
        %to read later,
        filename = append(group,"_",num2str(g),'_output.txt');
        delimiterIn = ' ';
        headerlinesIn = 1;
        A = importdata(filename,delimiterIn,headerlinesIn);
        
        %fit the accel to a abs(x-offset) model
        %graph the 3 sets of data together with their trendlines??
        
        %plot flex and ext all together.
        
        %for now, its all repeat data.
        % %
        % % figure('NumberTitle', 'off', 'Name', "Accelerometer angles");
        % % hold on;
        % %
        % % %no correction for zero drift or sign of angle
        % % scatter(A.data(:,2),A.data(:,3),'filled');
        % %
        % % xlabel("intended angles (deg)");
        % % ylabel("calculated angles (with zero drift) (deg)");
        % % title("Intended angle vs Calculated angle");
        % %
        
        
        %normalize power values
        %needs apriori knowledge of arm orientation to use correct maximum
        maxf=max(A.data(:,4));
        flx=A.data(:,4);%/maxf;
        
        maxe=max(A.data(:,5));
        ext=A.data(:,5);%/maxe;
        
        
        
        %plot power vs angle
        
        figure(pow_fig);
        hold on;
        
        %no correction for zero drift or sign of angle
        %scatter(A.data(:,2),flx,'filled','r');
        
        
        
        %plotting in db
        s=scatter(db(flx),db(ext),[],A.data(:,2),markers(g),'filled');
        s.MarkerEdgeColor=subject_colors(sbj,:);
        
    end
    legend(["Palm Down","Palm Up","Sideways"]);
    
end

end