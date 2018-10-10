function [] = plot_mat(pca_vec,full_label_struct,vAxis,title_str)

ax         = [];
% subj_names = {'Subject 1';'Subject 2';'Subject 3';'Subject 4';'Subject 5';'Subject 6';'Subject 7';'Subject 8';'Subject 9';'Subject 10';'Subject 11';'S01';'S02';'S03';'S04';'S05'};
subj_names = {'1';'2';'3';'4';'5';'6';'7';'8';'9';'10';'11'};
num_sub    = unique(full_label_struct{2});
N          = length(num_sub);
color_list = num2cell(cat(1,parula(N),[[1 0 0];[0 1 0];[1 0 1]]),2);
% shape_list = {'square';'o';'diamond';'square';'o';'diamond';'square';'o';'diamond';'square';'o';'diamond';};
shape_list = {'o';'d';'s';'^';'v';'>';'<';'h';'o';'d';'s';};
shape_size = {150;200;250;150;150;150;150;250;150;150;200;250;};

if N == 2
    figure; hold on; grid on; ax(1) = gca;
    for ii = 1 : N
        idx = find(full_label_struct{2} == num_sub(ii));
        scatter(pca_vec(1,idx), pca_vec(2,idx), shape_size{ii},'MarkerFaceColor',color_list{ii},'MarkerEdgeColor','k', 'Marker', shape_list{ii}, 'LineWidth', 0.05);  
    end
    subj_str = subj_names(num_sub);
    xlabel('$\psi_1$','Interpreter','latex');
    ylabel('$\psi_2$','Interpreter','latex');
    h = legend(subj_str(:), 'location','best');
    set(h, 'Interpreter', 'Latex' ,'color','none');
    % title(sprintf('Colored per subject with %s', title_str),'interpreter','latex');
    % axis(vAxis);
    axis tight
    set_figure_prop;

    figure; hold on; grid on; ax(2) = gca;
    num_stim = unique(full_label_struct{3});
    for jj = 1 : N
        for ii = 1 : length(num_stim)
            idx = find(and(full_label_struct{3} == num_stim(ii),full_label_struct{2} == num_sub(jj)));
            scatter(pca_vec(1,idx), pca_vec(2,idx),180 - 10*N,'MarkerFaceColor',color_list{ii+N},'MarkerEdgeColor','k','Marker', shape_list{jj},'LineWidth', 0.05);
        end
    end
    xlabel('$\psi_1$','Interpreter','latex');
    ylabel('$\psi_2$','Interpreter','latex');
    h = legend(full_label_struct{4}(:), 'Interpreter', 'latex', 'location', 'best');
    set(h,'color','none');
    % title(sprintf('Colored per stimulus with %s', title_str),'interpreter','latex');
    % axis(vAxis); 
    axis tight
    set_figure_prop;
    % linkprop(ax,{'CameraPosition','CameraUpVector'}); 
    set(ax,'XAxisLocation','bottom');
    set(ax, 'FontSize', 16);
else
    figure; hold on; grid on; ax(1) = gca;
    for ii = 1 : N
        idx = find(full_label_struct{2} == num_sub(ii));
        scatter(pca_vec(1,idx), pca_vec(2,idx), round(shape_size{ii}/3),'MarkerFaceColor',color_list{ii},'MarkerEdgeColor','k', 'Marker', shape_list{ii}, 'LineWidth', 0.05);  
    end
    subj_str = subj_names(num_sub);
    colorbar('Ticks',1/(2*N):1/N:1,'TickLabels',subj_str,'TickLabelInterpreter','latex');
    xlabel('$\psi_1$','Interpreter','latex');
    ylabel('$\psi_2$','Interpreter','latex');
%     h = legend(subj_str(:), 'location','best');
%     set(h, 'Interpreter', 'Latex'); % ,'color','none');
    % title(sprintf('Colored per subject with %s', title_str),'interpreter','latex');
    % axis(vAxis);
    axis tight
    set_figure_prop;

    figure; hold on; grid on; ax(2) = gca;
    num_stim = unique(full_label_struct{3});
    for jj = 1 : N
        for ii = 1 : length(num_stim)
            idx = find(and(full_label_struct{3} == num_stim(ii),full_label_struct{2} == num_sub(jj)));
            scatter(pca_vec(1,idx), pca_vec(2,idx),round(shape_size{jj}/3),'MarkerFaceColor',color_list{ii+N},'MarkerEdgeColor','k','Marker', shape_list{jj},'LineWidth', 0.05);
        end
    end
    xlabel('$\psi_1$','Interpreter','latex');
    ylabel('$\psi_2$','Interpreter','latex');
    h = legend(full_label_struct{4}(:), 'Interpreter', 'latex', 'location', 'best');
    set(h,'color','none');
    % title(sprintf('Colored per stimulus with %s', title_str),'interpreter','latex');
    % axis(vAxis); 
    axis tight
    set_figure_prop;
    % linkprop(ax,{'CameraPosition','CameraUpVector'}); 
    set(ax,'XAxisLocation','bottom');
    set(ax, 'FontSize', 16);
end