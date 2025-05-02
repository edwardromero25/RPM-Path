set(0, 'DefaultAxesFontName', 'Raleway');

processor = AccelerometerDataProcessor('Martian_G_RPM_Data_Output.txt');
[meas_x_acc, meas_y_acc, meas_z_acc, time_in_hours] = processor.getData();

%% Angular Position
meas_theta_alpha = asin(meas_y_acc);
meas_theta_alpha_deg = rad2deg(meas_theta_alpha);

figure;
subplot(2, 1, 1);
plot(time_in_hours, meas_theta_alpha_deg, 'Color', [128 179 255]/255);
title('Outer');
xlabel('Time (h)');
ylabel('Angular Position (deg)');

meas_theta_beta = atan2(-meas_x_acc, meas_z_acc);
meas_theta_beta_unwrapped = unwrap(meas_theta_beta);
meas_theta_beta_deg = rad2deg(meas_theta_beta_unwrapped);

subplot(2, 1, 2);
plot(time_in_hours, meas_theta_beta_deg, 'Color', [128 179 255]/255);
title('Inner')
xlabel('Time (h)');
ylabel('Angular Position (deg)');

%% Gravitational Acceleration Components
meas_x_acc_avg = cumsum(meas_x_acc) ./ (1:length(meas_x_acc))';
meas_y_acc_avg = cumsum(meas_y_acc) ./ (1:length(meas_y_acc))';
meas_z_acc_avg = cumsum(meas_z_acc) ./ (1:length(meas_z_acc))';

figure;
subplot(2, 1, 1);
plot(time_in_hours, meas_x_acc_avg, 'r', ...
     time_in_hours, meas_y_acc_avg, 'g', ...
     time_in_hours, meas_z_acc_avg, 'k');
title('Experimental');
xlabel('Time (h)');
ylabel('Acceleration (g)');
legend('X', 'Y', 'Z');

pred_x_acc = -sin(meas_theta_beta_unwrapped) .* cos(meas_theta_alpha);
pred_y_acc = sin(meas_theta_alpha);
pred_z_acc = cos(meas_theta_beta_unwrapped) .* cos(meas_theta_alpha);

pred_x_acc_avg = cumsum(pred_x_acc) ./ (1:length(pred_x_acc))';
pred_y_acc_avg = cumsum(pred_y_acc) ./ (1:length(pred_y_acc))';
pred_z_acc_avg = cumsum(pred_z_acc) ./ (1:length(pred_z_acc))';

subplot(2, 1, 2);
plot(time_in_hours, pred_x_acc_avg, 'r', ...
     time_in_hours, pred_y_acc_avg, 'g', ...
     time_in_hours, pred_z_acc_avg, 'k');
title('Theoretical')
xlabel('Time (h)');
ylabel('Acceleration (g)');
legend('X', 'Y', 'Z');

%% Gravitational Acceleration Magnitude
meas_magnitude_avg = sqrt(meas_x_acc_avg.^2 + meas_y_acc_avg.^2 + meas_z_acc_avg.^2)';
meas_magnitude = mean(meas_magnitude_avg);
meas_magnitude_label = sprintf('Magnitude: %.3g', meas_magnitude);

figure;
subplot(2, 1, 1);
plot(time_in_hours, meas_magnitude_avg, 'b', 'DisplayName', meas_magnitude_label);
title('Experimental');
xlabel('Time (h)');
ylabel('Acceleration (g)');
legend('show');

pred_magnitude_avg = sqrt(pred_x_acc_avg.^2 + pred_y_acc_avg.^2 + pred_z_acc_avg.^2)';
pred_magnitude = mean(pred_magnitude_avg);
pred_magnitude_label = sprintf('Magnitude: %.3g', pred_magnitude);

subplot(2, 1, 2);
plot(time_in_hours, pred_magnitude_avg, 'b', 'DisplayName', pred_magnitude_label);
title('Theoretical')
xlabel('Time (h)');
ylabel('Acceleration (g)');
legend('show');

%% Orientation Distribution
figure;
subplot(1, 2, 1);
hold on;
title('Experimental');
xlabel('X (g)');
ylabel('Y (g)');
zlabel('Z (g)');
xticks([-1 -0.5 0 0.5 1]);
yticks([-1 -0.5 0 0.5 1]);
zticks([-1 -0.5 0 0.5 1]);
grid off;
view(3);
xlim([-1 1]);
ylim([-1 1]);
zlim([-1 1]);
axis equal;
[u, v] = meshgrid(linspace(0, 2*pi, 25), linspace(0, pi, 25));
x = cos(u) .* sin(v);
y = sin(u) .* sin(v);
z = cos(v);
mesh(x, y, z, 'EdgeColor', [0.5 0.5 0.5], 'FaceAlpha', 0, 'EdgeAlpha', 0.5, 'HandleVisibility', 'off');
meas_line = plot3(NaN, NaN, NaN, 'b', 'LineWidth', 0.75);

subplot(1, 2, 2);
hold on;
title('Theoretical');
xlabel('X (g)');
ylabel('Y (g)');
zlabel('Z (g)');
xticks([-1 -0.5 0 0.5 1]);
yticks([-1 -0.5 0 0.5 1]);
zticks([-1 -0.5 0 0.5 1]);
grid off;
view(3);
xlim([-1 1]);
ylim([-1 1]);
zlim([-1 1]);
axis equal;
mesh(x, y, z, 'EdgeColor', [0.5 0.5 0.5], 'FaceAlpha', 0, 'EdgeAlpha', 0.5, 'HandleVisibility', 'off');
pred_line = plot3(NaN, NaN, NaN, 'b', 'LineWidth', 0.75);

for k = 1:1:length(meas_x_acc)
    set(meas_line, 'XData', meas_x_acc(1:k), ...
                   'YData', meas_y_acc(1:k), ...
                   'ZData', meas_z_acc(1:k));
    set(pred_line, 'XData', pred_x_acc(1:k), ...
                   'YData', pred_y_acc(1:k), ...
                   'ZData', pred_z_acc(1:k));
    drawnow;
end
