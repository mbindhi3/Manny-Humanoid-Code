%Dynamixel control
function Walk3D (start, final)
%% Add Dynamixel_IO to classpath
MATLIBS = '../../Dynamixel_IO/';
addpath( MATLIBS );

%% Initialize Dynamixel_IO
dxl_io = Dynamixel_IO;  % generate instance of the Dynamixel_IO class
dxl_io.load_library();  % load library appropriate to OS (auto-detected)
dxl_io.connect(5, 1);   % connect to port 0, at 1 MBaud
load('rightCycleAlphas.mat');
%alphaTraj = preCyclePart3Alphas;
motor_ids = [10,12,14,16,18,9,11,13,15,17];      % list of motor IDs to command
%load(alphaTraj);
a =rightCycleAlphas;
load('Motor_Biases.mat');
Motor_Biases = -1* motor_bias;
motorBias =[Motor_Biases(2:2:10); Motor_Biases(1:2:9)];
downSample = 1;
timeStep = 0.1;
pauseTime = 0.13;
%motor_bias =[-1;4;-2;4;-2;2];
speed = [];
pos_vel=zeros(6,100);
pause(1);
for i = start + downSample:downSample:final;
index = i;
dest_pos_base(1) = a(1,i);% destination position
dest_pos_base(2) = a(2,i) ;% destination position
dest_pos_base(3) = -a(3,i) ;% destination position
dest_pos_base(4) = a(4,i) ;% destination position
dest_pos_base(5) = -a(5,i) ;% destination position
dest_pos_base(6) = a(6,i);% destination position
dest_pos_base(7) = -a(7,i) ;% destination position
dest_pos_base(8) = a(8,i) ;% destination position
dest_pos_base(9) = -a(9,i) ;% destination position
dest_pos_base(10) = -a(10,i) ;% destination position

% if(index>=35 && index <=60)
% dest_pos_base(1) = a(1,i)-(0.1540/(100-i+1));% destination position
% dest_pos_base(5) = -a(5,i) + (0.0860/(100-i+1));% destination position
% else if(index>60)
% dest_pos_base(1) = a(1,i)-(0.1540);% destination position
% dest_pos_base(5) = -a(5,i) + (0.0860);% destination position 
%     end
dest_speed_base(1) = max(abs((a(1,i) - a(1,i-downSample)) /timeStep),3 *0.1745);    % speed
dest_speed_base(2) = max(abs((a(2,i) - a(2,i-downSample)) /timeStep),3 * 0.1745);    % speed
dest_speed_base(3) = max(abs((a(3,i) - a(3,i-downSample)) /timeStep),3 * 0.1745);    % speed
dest_speed_base(4) = max(abs((a(4,i) - a(4,i-downSample)) /timeStep),3 * 0.1745);    % speed
dest_speed_base(5) = max(abs((a(5,i) - a(5,i-downSample)) /timeStep),3 * 0.1745);    % speed
dest_speed_base(6) = max(abs((a(6,i) - a(6,i-downSample)) /timeStep),3 * 0.1745);    % speed
dest_speed_base(7) = max(abs((a(7,i) - a(7,i-downSample)) /timeStep),3 *0.1745);    % speed
dest_speed_base(8) = max(abs((a(8,i) - a(8,i-downSample)) /timeStep),3 * 0.1745);    % speed
dest_speed_base(9) = max(abs((a(9,i) - a(9,i-downSample)) /timeStep),3 * 0.1745);    % speed
dest_speed_base(10) = max(abs((a(10,i) - a(10,i-downSample)) /timeStep),3 * 0.1745);    % speed

dest_pos = zeros(length(motor_ids), 1);         % array destination positions to assign for each motor ID
dest_speed = zeros(length(motor_ids), 1);       % array speeds to assign for each motor ID
for motor_index = 1:length(motor_ids)
   dest_pos(motor_index) = dest_pos_base(motor_index);
   dest_speed(motor_index) = dest_speed_base(motor_index);
end
if(i==start + downSample)

dest_speed_base(1) = dest_speed_base(1)/50;  
dest_speed_base(2) = dest_speed_base(2)/50;    
dest_speed_base(3) = dest_speed_base(3)/50;   
dest_speed_base(4) = dest_speed_base(4)/50;   
dest_speed_base(5) = dest_speed_base(5)/50;    
dest_speed_base(6) = dest_speed_base(6)/50;
dest_speed_base(7) = dest_speed_base(7)/50;  
dest_speed_base(8) = dest_speed_base(8)/50;    
dest_speed_base(9) = dest_speed_base(9)/50;   
dest_speed_base(10) = dest_speed_base(10)/50;   
   
dxl_io.set_motor_pos_speed(motor_ids, motorBias, dest_pos, dest_speed);
pause(pauseTime);
else
dxl_io.set_motor_pos_speed(motor_ids,motorBias,dest_pos, dest_speed);
%pos_vel(:,i) = dxl_io.read_present_pos_vel( motor_ids, 1, 'pos');
% pos_vel_hip = dxl_io.read_present_pos_vel(10, 1, 'pos');
% e = dest_pos_base(1) - pos_vel_hip;
% dxl_io.set_motor_pos_speed(10,1,dest_pos_base(1)+1.5*e, pi/6);
pause(pauseTime);
end
speed = [speed ; dest_speed_base];

end 
end