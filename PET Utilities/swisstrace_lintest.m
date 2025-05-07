% swisstrace_lintest.m

% Written by Christian Østergaard Mariager, May 2025

% This function plots a test of linearity using data from a Swisstrace
% Twilite Three bloodsampler

% Inputs:   
% background_data = path to .crv file only containing the initial background data
% decay_data = path to .crv file only containing the decay/phantom data
% A0 = the activity concentration of the phantom at Swisstrace insertion time in MBq/mL
% halflife = the halflife of the used tracer in minutes

% Outputs:
% A plot showing the Activity concentration over time versus the recorded
% counts over time from the Swisstrace unit.

function swisstrace_lintest(background_data, decay_data, A0, halflife)

    % load data
    background = tdfread(background_data);
    decay = tdfread(decay_data);
    
    % sort data
    background_fields = fieldnames(background);
    decay_fields = fieldnames(decay);
    
    background_coincidenses = mean(background.(background_fields{2}));
    decay_coincidenses = decay.(decay_fields{2});
    
    % calc activity
    time = 0:1:length(decay_coincidenses)-1;
    A = A0*exp(-time.*log(2)./(halflife*60));

    % decay data
    D = decay_coincidenses-background_coincidenses;

    % linear fit to data
    [p,S] = polyfit(A,D,1);
    [y_fit,delta] = polyval(p,A,S);
    
    % plot
    plot(A,D,'r.')
    hold on
    plot(A,y_fit,'k-','linewidth',3)
    title('Swisstrace linearity test')
    xlabel('Activity concentration [MBq/mL]')
    ylabel('Swisstrace [coincidenses/second]')
    legend('Data','Fit','Location','northwest')
    axis padded
    grid on;

    % display fit equation
    xl = xlim;
    yl = ylim;
    xt = 0.02 * (xl(2)-xl(1)) + xl(1);
    yt = 0.85 * (yl(2)-yl(1)) + yl(1);
    fit_equation = sprintf('y = %f * x + %f', p(1), p(2));
    text(xt, yt, fit_equation, 'FontSize', 10, 'FontWeight', 'bold');

    % save print of plot in the datafolder
    [filepath,~,~] = fileparts(background_data);
    f = gcf;
    exportgraphics(f,[filepath '/swisstrace_lintest.png'],'Resolution',300)

end

