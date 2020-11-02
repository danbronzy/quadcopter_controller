function [] = plot_quadrotor_errors(state, state_des,time_vector)

%% Get individual plots from state

pos = state(1:3,:);
vel = state(4:6,:);
rpy = state(7:9,:);
ang_vel = state(10:12,:);
acc = state(13:15,:);

pos_des = state_des(1:3,:);
vel_des = state_des(4:6,:);
rpy_des = state_des(7:9,:);
ang_vel_des = state_des(10:12,:);
acc_des = state_des(13:15,:);

%% Get error from desired and actual

error_pos = pos-pos_des;
error_vel = vel-vel_des;
error_rpy = rpy-rpy_des;
error_ang_vel = ang_vel-ang_vel_des;
error_acc = acc - acc_des;
% No error in rpm, assume perfect motor speed control

%% Dans plotting

%calculate some rise times
[rise_time, settling_time, mp_overshoot] = step_response_stats(time_vector, error_pos(3,:));
fprintf("Z 90%% rise time: %d\n", rise_time);
fprintf("Z 10%% settling time: %d\n", settling_time);
fprintf("Z MP overshoot: %d\n", mp_overshoot);

% Plot position error
labels = {'x [m]', 'y [m]', 'z [m]'};
title_name = {'Error in x','Error in y','Error in z'};
str = 'Plot of Pose Error';
figure('Name',str);

for i = 1:3
    subplot(2, 3, i)
    plot(time_vector,error_pos(i,:),'r');
    grid on
    xlabel('time [s]')
    ylabel(labels{i})
    title(title_name{i})
    if i == 3
        yline(0.1,'g:','linewidth',2);
        yline(-0.1,'g:','linewidth',2);
        yline(mp_overshoot, '-.', 'linewidth', 1.2);
        xline(rise_time, '-.', 'linewidth', 1.2);
        xline(settling_time, '-.', 'linewidth', 1.2);
    end
    
end

%calculate some step response parameters w/ a little normalization stuff
norm = 1/max(abs(error_rpy(3,:)));
[psi_rise_time, psi_settling_time, psi_mp_overshoot] = step_response_stats(time_vector, norm*error_rpy(3,:));
psi_mp_overshoot = psi_mp_overshoot/norm;
fprintf("Psi 90%% rise time: %d\n", psi_rise_time);
fprintf("Psi 10%% settling time: %d\n", psi_settling_time);
fprintf("Psi MP overshoot: %d\n", psi_mp_overshoot);

% Plot orientation error

labels = {'\phi', '\theta', '\psi'};
title_name = {'Error in \phi','Error in \theta','Error in \psi'};

for i = 1:3
    subplot(2, 3, i+3)
    plot(time_vector,error_rpy(i,:),'r');
    grid on
    xlabel('time [s]')
    ylabel(labels{i})
    title(title_name{i})
    
    if i == 3
        yline(0.1,'g:','linewidth',2);
        yline(-0.1,'g:','linewidth',2);
        yline(mp_overshoot, '-.', 'linewidth', 1.2);
        xline(rise_time, '-.', 'linewidth', 1.2);
        xline(settling_time, '-.', 'linewidth', 1.2);
    end
end

%% Plot error

% Plot position error
labels = {'x [m]', 'y [m]', 'z [m]'};
title_name = {'Error in x','Error in y','Error in z'};
str = 'Plot of Error';
figure('Name',str);

for i = 1:3
    subplot(5, 3, i)
    plot(time_vector,error_pos(i,:),'r');
    grid on
    xlabel('time [s]')
    ylabel(labels{i})
    title(title_name{i})
end

% Plot orientation error

labels = {'\phi', '\theta', '\psi'};
title_name = {'Error in \phi','Error in \theta','Error in \psi'};

for i = 1:3
    subplot(5, 3, i+3)
    plot(time_vector,error_rpy(i,:),'r');
    grid on
    xlabel('time [s]')
    ylabel(labels{i})
    title(title_name{i})
end

% Plot velocity error

labels = {'vx [m/s]', 'vy [m/s]', 'vz [m/s]'};
title_name = {'Error in v_x','Error in v_y','Error in v_z'};

for i = 1:3
    subplot(5, 3, i+6)
    plot(time_vector,error_vel(i,:),'r');
    grid on
    xlabel('time [s]')
    ylabel(labels{i})
    title(title_name{i})
end

% Plot angular velocity error

labels = {'\omega x [rad/s]', '\omega y [rad/s]', '\omega z [rad/s]'};
title_name = {'Error in \omega_x','Error in \omega_y','Error in \omega_z'};

for i = 1:3
    subplot(5, 3, i+9)
    plot(time_vector,error_ang_vel(i,:),'r');
    
    grid on
    xlabel('time [s]')
    ylabel(labels{i})
    title(title_name{i})
end

labels = {'ax [m/s^2]', 'ay [m/s^2]', 'az [m/s^2]'};
title_name = {'Error in a_x','Error in a_y','Error in a_z'};

for i = 1:3
    subplot(5, 3, i+12)
    plot(time_vector,error_acc(i,:),'r');
    grid on
    xlabel('time [s]')
    ylabel(labels{i})
    title(title_name{i})
end

%% Dans plotting
% Plot Position
labels = {'x [m]', 'y [m]', 'z [m]'};
title_name = {'Position in x','Position in y','Position in z'};

str = 'Position';
figure('Name',str);

for i = 1:3
    subplot(2, 3, i)
    h = plot(time_vector, pos_des(i,:),'b',time_vector, pos(i,:),'r--');
    grid on
    xlabel('time [s]')
    ylabel(labels{i})
    title(title_name{i})
    xline(0,'g:');
    xline(2,'g:');
    xline(4,'g:');
    xline(6,'g:');
    legend(h, 'Desired','Actual');
end

% Plot Attitude
labels = {'\phi', '\theta', '\psi'};
title_name = {'Orientation in \phi','Orientation in \theta','Orientation in \psi'};

for i = 1:3
    subplot(2, 3, i+3)
    h = plot(time_vector, rpy_des(i,:), 'b', time_vector, rpy(i,:), 'r--');
    grid on
    xlabel('time [s]')
    ylabel(labels{i})
    title(title_name{i})
    xline(0,'g:');
    xline(2,'g:');
    xline(4,'g:');
    xline(6,'g:');
    legend(h, 'Desired','Actual');
end

%% Plot desired and actual

% Plot Position
labels = {'x [m]', 'y [m]', 'z [m]'};
title_name = {'Position in x','Position in y','Position in z'};

str = 'Position';
figure('Name',str);

for i = 1:3
    subplot(5, 3, i)
    plot(time_vector, pos_des(i,:),'b',time_vector, pos(i,:),'r--');
    grid on
    xlabel('time [s]')
    ylabel(labels{i})
    title(title_name{i})
    legend('Desired','Actual');
end

% Plot Attitude
labels = {'\phi', '\theta', '\psi'};
title_name = {'Orientation in \phi','Orientation in \theta','Orientation in \psi'};

for i = 1:3
    subplot(5, 3, i+3)
    plot(time_vector, rpy_des(i,:), 'b', time_vector, rpy(i,:), 'r--');
    grid on
    xlabel('time [s]')
    ylabel(labels{i})
    title(title_name{i})
    legend('Desired','Actual');
end

% Plot velocity

labels = {'vx [m/s]', 'vy [m/s]', 'vz [m/s]'};
title_name = {'Velocity in x','Velocity in y','Velocity in z'};

for i = 1:3
    subplot(5, 3, i+6)
    plot(time_vector, vel_des(i,:), 'b', time_vector, vel(i,:), 'r--');
    grid on
    xlabel('time [s]')
    ylabel(labels{i})
    title(title_name{i})
end

% Plot angular velocity
labels = {'\omega x [rad/s]', '\omega y [rad/s]', '\omega z [rad/s]'};
title_name = {'Angular Velocity in x','Angular Velocity in y','Angular Velocity in z'};


for i = 1:3
    subplot(5, 3, i+9)
    plot(time_vector, ang_vel_des(i,:),'b',time_vector, ang_vel(i,:),'r--');
    grid on
    xlabel('time [s]')
    ylabel(labels{i})
    title(title_name{i})
    legend('Desired','Actual');
end

% Plot Acceleration
labels = {'ax [m/s^2]', 'ay [m/s^2]', 'az [m/s^2]'};
title_name = {'Acceleration in x','Acceleration in y','Acceleration in z'};

for i = 1:3
    subplot(5, 3, i+12)
    plot(time_vector,acc_des(i,:),'b',time_vector,acc(i,:),'r--');
    grid on
    xlabel('time [s]')
    ylabel(labels{i})
    title(title_name{i})
    legend('Desired','Actual');
end

end

