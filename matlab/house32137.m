% create system 
sys = 'house32137_subsys'; 
new_system(sys, 'subsystem') 

% initialise workspace 
building_length = 30; 
building_width = 50; 
building_height = 2.5; 
door_area = 1.2; 
duct_area = 0.01; 
fan_flow_rate_table = [0,0.08,0.12,0.16,0.2]; 
fan_setting_table = [0,1,2,3,4]; 
floor_conductivity = 0.15; 
floor_heat_transfer_coeff_internal = 15; 
floor_thickness = 0.1; 
flow_reversal_Mach = 0.00001; 
ground_temperature = 25; 
initial_temperature = 30; 
roof_conductivity = 0.035; 
roof_density = 2000; 
roof_heat_transfer_coeff_external = 30; 
roof_heat_transfer_coeff_internal = 10; 
roof_specific_heat = 840; 
roof_thickness = 0.2; 
wall_conductivity = 0.04; 
wall_density = 2000; 
wall_heat_transfer_coeff_external = 35; 
wall_heat_transfer_coeff_internal = 25; 
wall_specific_heat = 840; 
wall_thickness = 0.2; 
zone_flow_area = 26.25; 
ac_count = 1; 
room_count = 4; 
link_count = 3; 

% connection ports and AC control 
try 
   add_block('Simscape/Utilities/Connection Port', 'house32137_subsys/Door', 'Position', [10 110 40 125]) 
catch 
   add_block('simulink/Signal Routing/Connection Port', 'house32137_subsys/Door', 'Position', [10 110 40 125]) 
end 
add_block('built-in/SubSystem', 'house32137_subsys/ac_control', 'Position', [10 160 40 175]) 
add_block('simulink/Signal Routing/From', 'house32137_subsys/ac_control/room10', 'Position', [-50 10 0 40], 'GotoTag', 'room10', 'TagVisibility', 'global') 
add_block('simulink/Discrete/Unit Delay', 'house32137_subsys/ac_control/unitDelay1', 'Position', [30 10 60 40], 'InitialCondition', 'initial_temperature', 'SampleTime', '-1') 
add_block('simulink/Signal Routing/From', 'house32137_subsys/ac_control/room3', 'Position', [-50 70 0 100], 'GotoTag', 'room3', 'TagVisibility', 'global') 
add_block('simulink/Discrete/Unit Delay', 'house32137_subsys/ac_control/unitDelay2', 'Position', [30 70 60 100], 'InitialCondition', 'initial_temperature', 'SampleTime', '-1') 
add_block('simulink/Signal Routing/From', 'house32137_subsys/ac_control/room8', 'Position', [-50 130 0 160], 'GotoTag', 'room8', 'TagVisibility', 'global') 
add_block('simulink/Discrete/Unit Delay', 'house32137_subsys/ac_control/unitDelay3', 'Position', [30 130 60 160], 'InitialCondition', 'initial_temperature', 'SampleTime', '-1') 
add_block('simulink/Signal Routing/From', 'house32137_subsys/ac_control/room5', 'Position', [-50 190 0 220], 'GotoTag', 'room5', 'TagVisibility', 'global') 
add_block('simulink/Discrete/Unit Delay', 'house32137_subsys/ac_control/unitDelay4', 'Position', [30 190 60 220], 'InitialCondition', 'initial_temperature', 'SampleTime', '-1') 
add_block('simulink/Math Operations/MinMax', 'house32137_subsys/ac_control/max', 'Position', [90 10 120 220], 'Function', 'max', 'Inputs', '4') 
add_block('simulink/Math Operations/Add', 'house32137_subsys/ac_control/sum', 'Position', [210 10 240 220], 'IconShape', 'rectangular', 'Inputs', '++++') 
add_block('simulink/Discontinuities/Relay', 'house32137_subsys/ac_control/relay1', 'Position', [150 10 180 40], 'OnSwitchValue', '26', 'OffSwitchValue', '25') 
add_block('simulink/Discontinuities/Relay', 'house32137_subsys/ac_control/relay2', 'Position', [150 70 180 100], 'OnSwitchValue', '27', 'OffSwitchValue', '26') 
add_block('simulink/Discontinuities/Relay', 'house32137_subsys/ac_control/relay3', 'Position', [150 130 180 160], 'OnSwitchValue', '28', 'OffSwitchValue', '27') 
add_block('simulink/Discontinuities/Relay', 'house32137_subsys/ac_control/relay4', 'Position', [150 190 180 220], 'OnSwitchValue', '29', 'OffSwitchValue', '28') 
add_block('simulink/Signal Routing/Goto', 'house32137_subsys/ac_control/fan_cntrl', 'Position', [270 10 320 40], 'GotoTag', 'fan_cntrl', 'TagVisibility', 'global') 
add_block('simulink/Commonly Used Blocks/Integrator', 'house32137_subsys/ac_control/integrator', 'Position', [270 70 300 100]) 
add_block('simulink/Sinks/To Workspace', 'house32137_subsys/ac_control/toWorkspace', 'Position', [330 70 360 100], 'VariableName', 'fan_cost', 'MaxDataPoints', 'inf', 'SaveFormat', 'Array', 'Save2DSignal', '2-D array (concatenate along first dimension)', 'FixptAsFi', 'on', 'SampleTime', '-1') 
add_block('built-in/SubSystem', 'house32137_subsys/plot', 'Position', [10 210 40 225]) 
add_block('simulink/Commonly Used Blocks/Mux', 'house32137_subsys/plot/mux', 'Position', [10 10 10 340], 'Inputs', '6') 
add_block('simulink/Signal Routing/From', 'house32137_subsys/plot/room10', 'Position', [-50 10 0 40], 'GotoTag', 'room10', 'TagVisibility', 'global') 
add_block('simulink/Signal Routing/From', 'house32137_subsys/plot/room3', 'Position', [-50 70 0 100], 'GotoTag', 'room3', 'TagVisibility', 'global') 
add_block('simulink/Signal Routing/From', 'house32137_subsys/plot/room8', 'Position', [-50 130 0 160], 'GotoTag', 'room8', 'TagVisibility', 'global') 
add_block('simulink/Signal Routing/From', 'house32137_subsys/plot/room5', 'Position', [-50 190 0 220], 'GotoTag', 'room5', 'TagVisibility', 'global') 
add_block('simulink/Signal Routing/From', 'house32137_subsys/plot/T_ext', 'Position', [-50 250 0 280], 'GotoTag', 'T_ext', 'TagVisibility', 'global') 
add_block('simulink/Signal Routing/From', 'house32137_subsys/plot/fan_cntrl', 'Position', [-50 310 0 340], 'GotoTag', 'fan_cntrl', 'TagVisibility', 'global') 
add_block('simulink/Commonly Used Blocks/Scope', 'house32137_subsys/plot/scope', 'Position', [60 10 110 60]) 
add_block('built-in/SubSystem', 'house32137_subsys/AirProperties', 'Position', [10 260 40 275]) 
add_block('fl_lib/Gas/Utilities/Gas Properties (G)', 'house32137_subsys/AirProperties/AirProperties', 'Position', [30 30 60 60], 'p_min_perfect', '1e-6', 'Mach_rev', 'flow_reversal_Mach') 
add_block('nesl_utility/Solver Configuration', 'house32137_subsys/AirProperties/SolverConfiguration', 'Position', [30 90 60 120]) 
try 
   add_block('Simscape/Utilities/Connection Port', 'house32137_subsys/AirProperties/toAC', 'Position', [90 60 120 90]) 
catch 
   add_block('simulink/Signal Routing/Connection Port', 'house32137_subsys/AirProperties/toAC', 'Position', [90 60 120 90]) 
end 
add_line('house32137_subsys/ac_control', 'room10/1', 'unitDelay1/1') 
add_line('house32137_subsys/ac_control', 'unitDelay1/1', 'max/1') 
add_line('house32137_subsys/ac_control', 'room3/1', 'unitDelay2/1') 
add_line('house32137_subsys/ac_control', 'unitDelay2/1', 'max/2') 
add_line('house32137_subsys/ac_control', 'room8/1', 'unitDelay3/1') 
add_line('house32137_subsys/ac_control', 'unitDelay3/1', 'max/3') 
add_line('house32137_subsys/ac_control', 'room5/1', 'unitDelay4/1') 
add_line('house32137_subsys/ac_control', 'unitDelay4/1', 'max/4') 
add_line('house32137_subsys/ac_control', 'max/1', 'relay1/1') 
add_line('house32137_subsys/ac_control', 'relay1/1', 'sum/1') 
add_line('house32137_subsys/ac_control', 'max/1', 'relay2/1') 
add_line('house32137_subsys/ac_control', 'relay2/1', 'sum/2') 
add_line('house32137_subsys/ac_control', 'max/1', 'relay3/1') 
add_line('house32137_subsys/ac_control', 'relay3/1', 'sum/3') 
add_line('house32137_subsys/ac_control', 'max/1', 'relay4/1') 
add_line('house32137_subsys/ac_control', 'relay4/1', 'sum/4') 
add_line('house32137_subsys/ac_control', 'sum/1', 'fan_cntrl/1') 
add_line('house32137_subsys/ac_control', 'sum/1', 'integrator/1') 
add_line('house32137_subsys/ac_control', 'integrator/1', 'toWorkspace/1') 
add_line('house32137_subsys/plot', 'room10/1', 'mux/1') 
add_line('house32137_subsys/plot', 'room3/1', 'mux/2') 
add_line('house32137_subsys/plot', 'room8/1', 'mux/3') 
add_line('house32137_subsys/plot', 'room5/1', 'mux/4') 
add_line('house32137_subsys/plot', 'T_ext/1', 'mux/5') 
add_line('house32137_subsys/plot', 'fan_cntrl/1', 'mux/6') 
add_line('house32137_subsys/plot', 'mux/1', 'scope/1') 
add_line('house32137_subsys/AirProperties', 'AirProperties/RConn1', 'SolverConfiguration/RConn1') 
add_line('house32137_subsys/AirProperties', 'AirProperties/RConn1', 'toAC/RConn1') 

% rooms 

% room10 
room10_length = 24; 
room10_width = 12.0; 
room10_height = building_height; 
room10_wall_area = room10_height * (room10_length + room10_width); 
room10_floor_area = room10_length * room10_width; 
room10_zone_volume = room10_floor_area * building_height; 

add_block('built-in/SubSystem', 'house32137_subsys/room10', 'Position', [100 100 150 150]) 
add_block('built-in/SubSystem', 'house32137_subsys/room10/ThermalResistance', 'Position', [80 50 110 80]) 
add_block('simulink/Commonly Used Blocks/In1', 'house32137_subsys/room10/ThermalResistance/Ext', 'Position', [10 10 40 40]) 
add_block('nesl_utility/Simulink-PS Converter', 'house32137_subsys/room10/ThermalResistance/PSConverter', 'Position', [60 10 90 40], 'unit', 'degC', 'AffineConversion', 'on') 
add_block('fl_lib/Thermal/Thermal Sources/Controlled Temperature Source', 'house32137_subsys/room10/ThermalResistance/External Temperature', 'Position', [160 10 190 40]) 
add_block('fl_lib/Thermal/Thermal Elements/Thermal Reference', 'house32137_subsys/room10/ThermalResistance/Thermal Reference', 'Position', [110 40 140 70]) 
add_block('fl_lib/Thermal/Thermal Elements/Convective Heat Transfer', 'house32137_subsys/room10/ThermalResistance/Convection Wall to External', 'Position', [230 10 260 40], 'area', 'room10_wall_area', 'heat_tr_coeff', 'wall_heat_transfer_coeff_external') 
add_block('fl_lib/Thermal/Thermal Elements/Conductive Heat Transfer', 'house32137_subsys/room10/ThermalResistance/Wall Conduction External Side', 'Position', [280 10 310 40], 'area', 'room10_wall_area', 'thickness', 'wall_thickness / 2', 'th_cond', 'wall_conductivity') 
add_block('fl_lib/Thermal/Thermal Elements/Conductive Heat Transfer', 'house32137_subsys/room10/ThermalResistance/Wall Conduction Internal Side', 'Position', [350 10 380 40], 'area', 'room10_wall_area', 'thickness', 'wall_thickness / 2', 'th_cond', 'wall_conductivity') 
add_block('fl_lib/Thermal/Thermal Elements/Convective Heat Transfer', 'house32137_subsys/room10/ThermalResistance/Convection Wall to Internal', 'Position', [400 10 430 40], 'area', 'room10_wall_area', 'heat_tr_coeff', 'wall_heat_transfer_coeff_internal') 
try 
   add_block('Simscape/Utilities/Connection Port', 'house32137_subsys/room10/ThermalResistance/Int', 'Position', [470 10 500 40]) 
catch 
   add_block('simulink/Signal Routing/Connection Port', 'house32137_subsys/room10/ThermalResistance/Int', 'Position', [470 10 500 40]) 
end 
add_block('fl_lib/Thermal/Thermal Elements/Thermal Mass', 'house32137_subsys/room10/ThermalResistance/Wall Thermal Mass', 'Position', [330 70 350 90], 'mass', 'room10_wall_area * wall_thickness * wall_density', 'sp_heat', 'wall_specific_heat', 'T_specify', 'on', 'T', 'initial_temperature', 'T_unit', 'degC') 
add_block('fl_lib/Thermal/Thermal Elements/Convective Heat Transfer', 'house32137_subsys/room10/ThermalResistance/Convection Roof to External', 'Position', [230 120 260 150], 'area', 'room10_floor_area', 'heat_tr_coeff', 'roof_heat_transfer_coeff_external') 
add_block('fl_lib/Thermal/Thermal Elements/Conductive Heat Transfer', 'house32137_subsys/room10/ThermalResistance/Roof Conduction External Side', 'Position', [280 120 310 150], 'area', 'room10_floor_area', 'thickness', 'roof_thickness / 2', 'th_cond', 'wall_conductivity') 
add_block('fl_lib/Thermal/Thermal Elements/Conductive Heat Transfer', 'house32137_subsys/room10/ThermalResistance/Roof Conduction Internal Side', 'Position', [350 120 380 150], 'area', 'room10_floor_area', 'thickness', 'roof_thickness / 2', 'th_cond', 'wall_conductivity') 
add_block('fl_lib/Thermal/Thermal Elements/Convective Heat Transfer', 'house32137_subsys/room10/ThermalResistance/Convection Roof to Internal', 'Position', [400 120 430 150], 'area', 'room10_floor_area', 'heat_tr_coeff', 'roof_heat_transfer_coeff_internal') 
add_block('fl_lib/Thermal/Thermal Elements/Thermal Mass', 'house32137_subsys/room10/ThermalResistance/Roof Thermal Mass', 'Position', [330 180 350 200], 'mass', 'room10_floor_area * roof_thickness * wall_density', 'sp_heat', 'roof_specific_heat', 'T_specify', 'on', 'T', 'initial_temperature', 'T_unit', 'degC') 
add_block('fl_lib/Thermal/Thermal Sources/Temperature Source', 'house32137_subsys/room10/ThermalResistance/Ground Temperature', 'Position', [280 230 310 260], 'temperature', 'ground_temperature', 'temperature_unit', 'degC') 
add_block('fl_lib/Thermal/Thermal Elements/Conductive Heat Transfer', 'house32137_subsys/room10/ThermalResistance/Floor Conduction', 'Position', [350 230 380 260], 'area', 'room10_floor_area', 'thickness', 'floor_thickness', 'th_cond', 'floor_conductivity') 
add_block('fl_lib/Thermal/Thermal Elements/Convective Heat Transfer', 'house32137_subsys/room10/ThermalResistance/Convection Floor to Internal', 'Position', [400 230 430 260], 'area', 'room10_floor_area', 'heat_tr_coeff', 'floor_heat_transfer_coeff_internal') 
add_block('fl_lib/Thermal/Thermal Sensors/Temperature Sensor', 'house32137_subsys/room10/ThermalResistance/Temperature Sensor', 'Position', [440 290 460 310]) 
add_block('fl_lib/Thermal/Thermal Elements/Thermal Reference', 'house32137_subsys/room10/ThermalResistance/Thermal Reference1', 'Position', [430 380 450 400]) 
add_block('nesl_utility/PS-Simulink Converter', 'house32137_subsys/room10/ThermalResistance/PSConverter1', 'Position', [450 330 470 350], 'unit', 'degC', 'AffineConversion', 'on') 
add_block('simulink/Signal Routing/Goto', 'house32137_subsys/room10/ThermalResistance/TempGoto', 'Position', [490 330 540 350], 'GotoTag', 'room10', 'TagVisibility', 'global') 
add_block('simulink/Signal Routing/From', 'house32137_subsys/room10/T_ext', 'Position', [10 50 60 80], 'GotoTag', 'T_ext', 'TagVisibility', 'global') 
add_block('fl_lib/Gas/Elements/Constant Volume Chamber (G)', 'house32137_subsys/room10/Zone', 'Position', [160 50 190 80], 'num_ports', 'foundation.enum.num_ports.three', 'area_A', 'zone_flow_area', 'area_B', 'zone_flow_area', 'area_C', 'zone_flow_area', 'area_D', 'zone_flow_area', 'volume', 'room10_zone_volume', 'p_I_specify', 'on', 'p_I', '1', 'p_I_unit', 'atm', 'T_I_specify', 'on', 'T_I', 'initial_temperature', 'T_I_unit', 'degC') 
add_block('fl_lib/Gas/Elements/Cap (G)', 'house32137_subsys/room10/Cap', 'Position', [170 110 200 140]) 
try 
   add_block('Simscape/Utilities/Connection Port', 'house32137_subsys/room10/room3', 'Position', [50 10 80 40]) 
catch 
   add_block('simulink/Signal Routing/Connection Port', 'house32137_subsys/room10/room3', 'Position', [50 10 80 40]) 
end 
try 
   add_block('Simscape/Utilities/Connection Port', 'house32137_subsys/room10/room8', 'Position', [100 10 130 40]) 
catch 
   add_block('simulink/Signal Routing/Connection Port', 'house32137_subsys/room10/room8', 'Position', [100 10 130 40]) 
end 

add_line('house32137_subsys/room10/ThermalResistance', 'Ext/1', 'PSConverter/1') 
add_line('house32137_subsys/room10/ThermalResistance', 'PSConverter/RConn1', 'External Temperature/RConn1') 
add_line('house32137_subsys/room10/ThermalResistance', 'Thermal Reference/LConn1', 'External Temperature/RConn2') 
add_line('house32137_subsys/room10/ThermalResistance', 'External Temperature/LConn1', 'Convection Wall to External/LConn1') 
add_line('house32137_subsys/room10/ThermalResistance', 'Convection Wall to External/RConn1', 'Wall Conduction External Side/LConn1') 
add_line('house32137_subsys/room10/ThermalResistance', 'Wall Conduction External Side/RConn1', 'Wall Conduction Internal Side/LConn1') 
add_line('house32137_subsys/room10/ThermalResistance', 'Wall Thermal Mass/LConn1', 'Wall Conduction Internal Side/LConn1') 
add_line('house32137_subsys/room10/ThermalResistance', 'Wall Conduction Internal Side/RConn1', 'Convection Wall to Internal/LConn1') 
add_line('house32137_subsys/room10/ThermalResistance', 'Convection Wall to Internal/RConn1', 'Int/RConn1') 
add_line('house32137_subsys/room10/ThermalResistance', 'External Temperature/LConn1', 'Convection Roof to External/LConn1') 
add_line('house32137_subsys/room10/ThermalResistance', 'Convection Roof to External/RConn1', 'Roof Conduction External Side/LConn1') 
add_line('house32137_subsys/room10/ThermalResistance', 'Roof Conduction External Side/RConn1', 'Roof Conduction Internal Side/LConn1') 
add_line('house32137_subsys/room10/ThermalResistance', 'Roof Thermal Mass/LConn1', 'Roof Conduction Internal Side/LConn1') 
add_line('house32137_subsys/room10/ThermalResistance', 'Roof Conduction Internal Side/RConn1', 'Convection Roof to Internal/LConn1') 
add_line('house32137_subsys/room10/ThermalResistance', 'Convection Roof to Internal/RConn1', 'Int/RConn1') 
add_line('house32137_subsys/room10/ThermalResistance', 'Ground Temperature/LConn1', 'Floor Conduction/LConn1') 
add_line('house32137_subsys/room10/ThermalResistance', 'Floor Conduction/RConn1', 'Convection Floor to Internal/LConn1') 
add_line('house32137_subsys/room10/ThermalResistance', 'Convection Floor to Internal/RConn1', 'Int/RConn1') 
add_line('house32137_subsys/room10/ThermalResistance', 'Temperature Sensor/LConn1', 'Int/RConn1') 
add_line('house32137_subsys/room10/ThermalResistance', 'Thermal Reference1/LConn1', 'Temperature Sensor/RConn1') 
add_line('house32137_subsys/room10/ThermalResistance', 'Temperature Sensor/RConn2', 'PSConverter1/LConn1') 
add_line('house32137_subsys/room10/ThermalResistance', 'PSConverter1/1', 'TempGoto/1') 
add_line('house32137_subsys/room10', 'T_ext/1', 'ThermalResistance/1') 
add_line('house32137_subsys/room10', 'ThermalResistance/LConn1', 'Zone/LConn2') 
add_line('house32137_subsys/room10', 'Zone/LConn1', 'Cap/LConn1') 
add_line('house32137_subsys/room10', 'Zone/RConn1', 'room3/RConn1') 
add_line('house32137_subsys/room10', 'Zone/RConn2', 'room8/RConn1') 

% room3 
room3_length = 30; 
room3_width = 16.0; 
room3_height = building_height; 
room3_wall_area = room3_height * (room3_length + room3_width); 
room3_floor_area = room3_length * room3_width; 
room3_zone_volume = room3_floor_area * building_height; 

add_block('built-in/SubSystem', 'house32137_subsys/room3', 'Position', [200 100 250 150]) 
add_block('built-in/SubSystem', 'house32137_subsys/room3/ThermalResistance', 'Position', [80 50 110 80]) 
add_block('simulink/Commonly Used Blocks/In1', 'house32137_subsys/room3/ThermalResistance/Ext', 'Position', [10 10 40 40]) 
add_block('nesl_utility/Simulink-PS Converter', 'house32137_subsys/room3/ThermalResistance/PSConverter', 'Position', [60 10 90 40], 'unit', 'degC', 'AffineConversion', 'on') 
add_block('fl_lib/Thermal/Thermal Sources/Controlled Temperature Source', 'house32137_subsys/room3/ThermalResistance/External Temperature', 'Position', [160 10 190 40]) 
add_block('fl_lib/Thermal/Thermal Elements/Thermal Reference', 'house32137_subsys/room3/ThermalResistance/Thermal Reference', 'Position', [110 40 140 70]) 
add_block('fl_lib/Thermal/Thermal Elements/Convective Heat Transfer', 'house32137_subsys/room3/ThermalResistance/Convection Wall to External', 'Position', [230 10 260 40], 'area', 'room3_wall_area', 'heat_tr_coeff', 'wall_heat_transfer_coeff_external') 
add_block('fl_lib/Thermal/Thermal Elements/Conductive Heat Transfer', 'house32137_subsys/room3/ThermalResistance/Wall Conduction External Side', 'Position', [280 10 310 40], 'area', 'room3_wall_area', 'thickness', 'wall_thickness / 2', 'th_cond', 'wall_conductivity') 
add_block('fl_lib/Thermal/Thermal Elements/Conductive Heat Transfer', 'house32137_subsys/room3/ThermalResistance/Wall Conduction Internal Side', 'Position', [350 10 380 40], 'area', 'room3_wall_area', 'thickness', 'wall_thickness / 2', 'th_cond', 'wall_conductivity') 
add_block('fl_lib/Thermal/Thermal Elements/Convective Heat Transfer', 'house32137_subsys/room3/ThermalResistance/Convection Wall to Internal', 'Position', [400 10 430 40], 'area', 'room3_wall_area', 'heat_tr_coeff', 'wall_heat_transfer_coeff_internal') 
try 
   add_block('Simscape/Utilities/Connection Port', 'house32137_subsys/room3/ThermalResistance/Int', 'Position', [470 10 500 40]) 
catch 
   add_block('simulink/Signal Routing/Connection Port', 'house32137_subsys/room3/ThermalResistance/Int', 'Position', [470 10 500 40]) 
end 
add_block('fl_lib/Thermal/Thermal Elements/Thermal Mass', 'house32137_subsys/room3/ThermalResistance/Wall Thermal Mass', 'Position', [330 70 350 90], 'mass', 'room3_wall_area * wall_thickness * wall_density', 'sp_heat', 'wall_specific_heat', 'T_specify', 'on', 'T', 'initial_temperature', 'T_unit', 'degC') 
add_block('fl_lib/Thermal/Thermal Elements/Convective Heat Transfer', 'house32137_subsys/room3/ThermalResistance/Convection Roof to External', 'Position', [230 120 260 150], 'area', 'room3_floor_area', 'heat_tr_coeff', 'roof_heat_transfer_coeff_external') 
add_block('fl_lib/Thermal/Thermal Elements/Conductive Heat Transfer', 'house32137_subsys/room3/ThermalResistance/Roof Conduction External Side', 'Position', [280 120 310 150], 'area', 'room3_floor_area', 'thickness', 'roof_thickness / 2', 'th_cond', 'wall_conductivity') 
add_block('fl_lib/Thermal/Thermal Elements/Conductive Heat Transfer', 'house32137_subsys/room3/ThermalResistance/Roof Conduction Internal Side', 'Position', [350 120 380 150], 'area', 'room3_floor_area', 'thickness', 'roof_thickness / 2', 'th_cond', 'wall_conductivity') 
add_block('fl_lib/Thermal/Thermal Elements/Convective Heat Transfer', 'house32137_subsys/room3/ThermalResistance/Convection Roof to Internal', 'Position', [400 120 430 150], 'area', 'room3_floor_area', 'heat_tr_coeff', 'roof_heat_transfer_coeff_internal') 
add_block('fl_lib/Thermal/Thermal Elements/Thermal Mass', 'house32137_subsys/room3/ThermalResistance/Roof Thermal Mass', 'Position', [330 180 350 200], 'mass', 'room3_floor_area * roof_thickness * wall_density', 'sp_heat', 'roof_specific_heat', 'T_specify', 'on', 'T', 'initial_temperature', 'T_unit', 'degC') 
add_block('fl_lib/Thermal/Thermal Sources/Temperature Source', 'house32137_subsys/room3/ThermalResistance/Ground Temperature', 'Position', [280 230 310 260], 'temperature', 'ground_temperature', 'temperature_unit', 'degC') 
add_block('fl_lib/Thermal/Thermal Elements/Conductive Heat Transfer', 'house32137_subsys/room3/ThermalResistance/Floor Conduction', 'Position', [350 230 380 260], 'area', 'room3_floor_area', 'thickness', 'floor_thickness', 'th_cond', 'floor_conductivity') 
add_block('fl_lib/Thermal/Thermal Elements/Convective Heat Transfer', 'house32137_subsys/room3/ThermalResistance/Convection Floor to Internal', 'Position', [400 230 430 260], 'area', 'room3_floor_area', 'heat_tr_coeff', 'floor_heat_transfer_coeff_internal') 
add_block('fl_lib/Thermal/Thermal Sensors/Temperature Sensor', 'house32137_subsys/room3/ThermalResistance/Temperature Sensor', 'Position', [440 290 460 310]) 
add_block('fl_lib/Thermal/Thermal Elements/Thermal Reference', 'house32137_subsys/room3/ThermalResistance/Thermal Reference1', 'Position', [430 380 450 400]) 
add_block('nesl_utility/PS-Simulink Converter', 'house32137_subsys/room3/ThermalResistance/PSConverter1', 'Position', [450 330 470 350], 'unit', 'degC', 'AffineConversion', 'on') 
add_block('simulink/Signal Routing/Goto', 'house32137_subsys/room3/ThermalResistance/TempGoto', 'Position', [490 330 540 350], 'GotoTag', 'room3', 'TagVisibility', 'global') 
add_block('simulink/Signal Routing/From', 'house32137_subsys/room3/T_ext', 'Position', [10 50 60 80], 'GotoTag', 'T_ext', 'TagVisibility', 'global') 
add_block('fl_lib/Gas/Elements/Constant Volume Chamber (G)', 'house32137_subsys/room3/Zone', 'Position', [160 50 190 80], 'num_ports', 'foundation.enum.num_ports.three', 'area_A', 'duct_area', 'area_B', 'zone_flow_area', 'area_C', 'zone_flow_area', 'area_D', 'zone_flow_area', 'volume', 'room3_zone_volume', 'p_I_specify', 'on', 'p_I', '1', 'p_I_unit', 'atm', 'T_I_specify', 'on', 'T_I', 'initial_temperature', 'T_I_unit', 'degC') 
try 
   add_block('Simscape/Utilities/Connection Port', 'house32137_subsys/room3/Internal', 'Position', [170 110 200 140]) 
catch 
   add_block('simulink/Signal Routing/Connection Port', 'house32137_subsys/room3/Internal', 'Position', [170 110 200 140]) 
end 
try 
   add_block('Simscape/Utilities/Connection Port', 'house32137_subsys/room3/room10', 'Position', [50 10 80 40]) 
catch 
   add_block('simulink/Signal Routing/Connection Port', 'house32137_subsys/room3/room10', 'Position', [50 10 80 40]) 
end 
try 
   add_block('Simscape/Utilities/Connection Port', 'house32137_subsys/room3/room8', 'Position', [100 10 130 40]) 
catch 
   add_block('simulink/Signal Routing/Connection Port', 'house32137_subsys/room3/room8', 'Position', [100 10 130 40]) 
end 

add_line('house32137_subsys/room3/ThermalResistance', 'Ext/1', 'PSConverter/1') 
add_line('house32137_subsys/room3/ThermalResistance', 'PSConverter/RConn1', 'External Temperature/RConn1') 
add_line('house32137_subsys/room3/ThermalResistance', 'Thermal Reference/LConn1', 'External Temperature/RConn2') 
add_line('house32137_subsys/room3/ThermalResistance', 'External Temperature/LConn1', 'Convection Wall to External/LConn1') 
add_line('house32137_subsys/room3/ThermalResistance', 'Convection Wall to External/RConn1', 'Wall Conduction External Side/LConn1') 
add_line('house32137_subsys/room3/ThermalResistance', 'Wall Conduction External Side/RConn1', 'Wall Conduction Internal Side/LConn1') 
add_line('house32137_subsys/room3/ThermalResistance', 'Wall Thermal Mass/LConn1', 'Wall Conduction Internal Side/LConn1') 
add_line('house32137_subsys/room3/ThermalResistance', 'Wall Conduction Internal Side/RConn1', 'Convection Wall to Internal/LConn1') 
add_line('house32137_subsys/room3/ThermalResistance', 'Convection Wall to Internal/RConn1', 'Int/RConn1') 
add_line('house32137_subsys/room3/ThermalResistance', 'External Temperature/LConn1', 'Convection Roof to External/LConn1') 
add_line('house32137_subsys/room3/ThermalResistance', 'Convection Roof to External/RConn1', 'Roof Conduction External Side/LConn1') 
add_line('house32137_subsys/room3/ThermalResistance', 'Roof Conduction External Side/RConn1', 'Roof Conduction Internal Side/LConn1') 
add_line('house32137_subsys/room3/ThermalResistance', 'Roof Thermal Mass/LConn1', 'Roof Conduction Internal Side/LConn1') 
add_line('house32137_subsys/room3/ThermalResistance', 'Roof Conduction Internal Side/RConn1', 'Convection Roof to Internal/LConn1') 
add_line('house32137_subsys/room3/ThermalResistance', 'Convection Roof to Internal/RConn1', 'Int/RConn1') 
add_line('house32137_subsys/room3/ThermalResistance', 'Ground Temperature/LConn1', 'Floor Conduction/LConn1') 
add_line('house32137_subsys/room3/ThermalResistance', 'Floor Conduction/RConn1', 'Convection Floor to Internal/LConn1') 
add_line('house32137_subsys/room3/ThermalResistance', 'Convection Floor to Internal/RConn1', 'Int/RConn1') 
add_line('house32137_subsys/room3/ThermalResistance', 'Temperature Sensor/LConn1', 'Int/RConn1') 
add_line('house32137_subsys/room3/ThermalResistance', 'Thermal Reference1/LConn1', 'Temperature Sensor/RConn1') 
add_line('house32137_subsys/room3/ThermalResistance', 'Temperature Sensor/RConn2', 'PSConverter1/LConn1') 
add_line('house32137_subsys/room3/ThermalResistance', 'PSConverter1/1', 'TempGoto/1') 
add_line('house32137_subsys/room3', 'T_ext/1', 'ThermalResistance/1') 
add_line('house32137_subsys/room3', 'ThermalResistance/LConn1', 'Zone/LConn2') 
add_line('house32137_subsys/room3', 'Zone/LConn1', 'Internal/RConn1') 
add_line('house32137_subsys/room3', 'Zone/RConn1', 'room10/RConn1') 
add_line('house32137_subsys/room3', 'Zone/RConn2', 'room8/RConn1') 

% room8 
room8_length = 26; 
room8_width = 24.0; 
room8_height = building_height; 
room8_wall_area = room8_height * (room8_length + room8_width); 
room8_floor_area = room8_length * room8_width; 
room8_zone_volume = room8_floor_area * building_height; 

add_block('built-in/SubSystem', 'house32137_subsys/room8', 'Position', [300 100 350 150]) 
add_block('built-in/SubSystem', 'house32137_subsys/room8/ThermalResistance', 'Position', [80 50 110 80]) 
add_block('simulink/Commonly Used Blocks/In1', 'house32137_subsys/room8/ThermalResistance/Ext', 'Position', [10 10 40 40]) 
add_block('nesl_utility/Simulink-PS Converter', 'house32137_subsys/room8/ThermalResistance/PSConverter', 'Position', [60 10 90 40], 'unit', 'degC', 'AffineConversion', 'on') 
add_block('fl_lib/Thermal/Thermal Sources/Controlled Temperature Source', 'house32137_subsys/room8/ThermalResistance/External Temperature', 'Position', [160 10 190 40]) 
add_block('fl_lib/Thermal/Thermal Elements/Thermal Reference', 'house32137_subsys/room8/ThermalResistance/Thermal Reference', 'Position', [110 40 140 70]) 
add_block('fl_lib/Thermal/Thermal Elements/Convective Heat Transfer', 'house32137_subsys/room8/ThermalResistance/Convection Wall to External', 'Position', [230 10 260 40], 'area', 'room8_wall_area', 'heat_tr_coeff', 'wall_heat_transfer_coeff_external') 
add_block('fl_lib/Thermal/Thermal Elements/Conductive Heat Transfer', 'house32137_subsys/room8/ThermalResistance/Wall Conduction External Side', 'Position', [280 10 310 40], 'area', 'room8_wall_area', 'thickness', 'wall_thickness / 2', 'th_cond', 'wall_conductivity') 
add_block('fl_lib/Thermal/Thermal Elements/Conductive Heat Transfer', 'house32137_subsys/room8/ThermalResistance/Wall Conduction Internal Side', 'Position', [350 10 380 40], 'area', 'room8_wall_area', 'thickness', 'wall_thickness / 2', 'th_cond', 'wall_conductivity') 
add_block('fl_lib/Thermal/Thermal Elements/Convective Heat Transfer', 'house32137_subsys/room8/ThermalResistance/Convection Wall to Internal', 'Position', [400 10 430 40], 'area', 'room8_wall_area', 'heat_tr_coeff', 'wall_heat_transfer_coeff_internal') 
try 
   add_block('Simscape/Utilities/Connection Port', 'house32137_subsys/room8/ThermalResistance/Int', 'Position', [470 10 500 40]) 
catch 
   add_block('simulink/Signal Routing/Connection Port', 'house32137_subsys/room8/ThermalResistance/Int', 'Position', [470 10 500 40]) 
end 
add_block('fl_lib/Thermal/Thermal Elements/Thermal Mass', 'house32137_subsys/room8/ThermalResistance/Wall Thermal Mass', 'Position', [330 70 350 90], 'mass', 'room8_wall_area * wall_thickness * wall_density', 'sp_heat', 'wall_specific_heat', 'T_specify', 'on', 'T', 'initial_temperature', 'T_unit', 'degC') 
add_block('fl_lib/Thermal/Thermal Elements/Convective Heat Transfer', 'house32137_subsys/room8/ThermalResistance/Convection Roof to External', 'Position', [230 120 260 150], 'area', 'room8_floor_area', 'heat_tr_coeff', 'roof_heat_transfer_coeff_external') 
add_block('fl_lib/Thermal/Thermal Elements/Conductive Heat Transfer', 'house32137_subsys/room8/ThermalResistance/Roof Conduction External Side', 'Position', [280 120 310 150], 'area', 'room8_floor_area', 'thickness', 'roof_thickness / 2', 'th_cond', 'wall_conductivity') 
add_block('fl_lib/Thermal/Thermal Elements/Conductive Heat Transfer', 'house32137_subsys/room8/ThermalResistance/Roof Conduction Internal Side', 'Position', [350 120 380 150], 'area', 'room8_floor_area', 'thickness', 'roof_thickness / 2', 'th_cond', 'wall_conductivity') 
add_block('fl_lib/Thermal/Thermal Elements/Convective Heat Transfer', 'house32137_subsys/room8/ThermalResistance/Convection Roof to Internal', 'Position', [400 120 430 150], 'area', 'room8_floor_area', 'heat_tr_coeff', 'roof_heat_transfer_coeff_internal') 
add_block('fl_lib/Thermal/Thermal Elements/Thermal Mass', 'house32137_subsys/room8/ThermalResistance/Roof Thermal Mass', 'Position', [330 180 350 200], 'mass', 'room8_floor_area * roof_thickness * wall_density', 'sp_heat', 'roof_specific_heat', 'T_specify', 'on', 'T', 'initial_temperature', 'T_unit', 'degC') 
add_block('fl_lib/Thermal/Thermal Sources/Temperature Source', 'house32137_subsys/room8/ThermalResistance/Ground Temperature', 'Position', [280 230 310 260], 'temperature', 'ground_temperature', 'temperature_unit', 'degC') 
add_block('fl_lib/Thermal/Thermal Elements/Conductive Heat Transfer', 'house32137_subsys/room8/ThermalResistance/Floor Conduction', 'Position', [350 230 380 260], 'area', 'room8_floor_area', 'thickness', 'floor_thickness', 'th_cond', 'floor_conductivity') 
add_block('fl_lib/Thermal/Thermal Elements/Convective Heat Transfer', 'house32137_subsys/room8/ThermalResistance/Convection Floor to Internal', 'Position', [400 230 430 260], 'area', 'room8_floor_area', 'heat_tr_coeff', 'floor_heat_transfer_coeff_internal') 
add_block('fl_lib/Thermal/Thermal Sensors/Temperature Sensor', 'house32137_subsys/room8/ThermalResistance/Temperature Sensor', 'Position', [440 290 460 310]) 
add_block('fl_lib/Thermal/Thermal Elements/Thermal Reference', 'house32137_subsys/room8/ThermalResistance/Thermal Reference1', 'Position', [430 380 450 400]) 
add_block('nesl_utility/PS-Simulink Converter', 'house32137_subsys/room8/ThermalResistance/PSConverter1', 'Position', [450 330 470 350], 'unit', 'degC', 'AffineConversion', 'on') 
add_block('simulink/Signal Routing/Goto', 'house32137_subsys/room8/ThermalResistance/TempGoto', 'Position', [490 330 540 350], 'GotoTag', 'room8', 'TagVisibility', 'global') 
add_block('simulink/Signal Routing/From', 'house32137_subsys/room8/T_ext', 'Position', [10 50 60 80], 'GotoTag', 'T_ext', 'TagVisibility', 'global') 
add_block('fl_lib/Gas/Elements/Constant Volume Chamber (G)', 'house32137_subsys/room8/Zone', 'Position', [160 50 190 80], 'num_ports', 'foundation.enum.num_ports.three', 'area_A', 'door_area', 'area_B', 'zone_flow_area', 'area_C', 'zone_flow_area', 'area_D', 'zone_flow_area', 'volume', 'room8_zone_volume', 'p_I_specify', 'on', 'p_I', '1', 'p_I_unit', 'atm', 'T_I_specify', 'on', 'T_I', 'initial_temperature', 'T_I_unit', 'degC') 
try 
   add_block('Simscape/Utilities/Connection Port', 'house32137_subsys/room8/Door', 'Position', [170 110 200 140]) 
catch 
   add_block('simulink/Signal Routing/Connection Port', 'house32137_subsys/room8/Door', 'Position', [170 110 200 140]) 
end 
try 
   add_block('Simscape/Utilities/Connection Port', 'house32137_subsys/room8/room10', 'Position', [50 10 80 40]) 
catch 
   add_block('simulink/Signal Routing/Connection Port', 'house32137_subsys/room8/room10', 'Position', [50 10 80 40]) 
end 
try 
   add_block('Simscape/Utilities/Connection Port', 'house32137_subsys/room8/room3', 'Position', [100 10 130 40]) 
catch 
   add_block('simulink/Signal Routing/Connection Port', 'house32137_subsys/room8/room3', 'Position', [100 10 130 40]) 
end 

add_line('house32137_subsys/room8/ThermalResistance', 'Ext/1', 'PSConverter/1') 
add_line('house32137_subsys/room8/ThermalResistance', 'PSConverter/RConn1', 'External Temperature/RConn1') 
add_line('house32137_subsys/room8/ThermalResistance', 'Thermal Reference/LConn1', 'External Temperature/RConn2') 
add_line('house32137_subsys/room8/ThermalResistance', 'External Temperature/LConn1', 'Convection Wall to External/LConn1') 
add_line('house32137_subsys/room8/ThermalResistance', 'Convection Wall to External/RConn1', 'Wall Conduction External Side/LConn1') 
add_line('house32137_subsys/room8/ThermalResistance', 'Wall Conduction External Side/RConn1', 'Wall Conduction Internal Side/LConn1') 
add_line('house32137_subsys/room8/ThermalResistance', 'Wall Thermal Mass/LConn1', 'Wall Conduction Internal Side/LConn1') 
add_line('house32137_subsys/room8/ThermalResistance', 'Wall Conduction Internal Side/RConn1', 'Convection Wall to Internal/LConn1') 
add_line('house32137_subsys/room8/ThermalResistance', 'Convection Wall to Internal/RConn1', 'Int/RConn1') 
add_line('house32137_subsys/room8/ThermalResistance', 'External Temperature/LConn1', 'Convection Roof to External/LConn1') 
add_line('house32137_subsys/room8/ThermalResistance', 'Convection Roof to External/RConn1', 'Roof Conduction External Side/LConn1') 
add_line('house32137_subsys/room8/ThermalResistance', 'Roof Conduction External Side/RConn1', 'Roof Conduction Internal Side/LConn1') 
add_line('house32137_subsys/room8/ThermalResistance', 'Roof Thermal Mass/LConn1', 'Roof Conduction Internal Side/LConn1') 
add_line('house32137_subsys/room8/ThermalResistance', 'Roof Conduction Internal Side/RConn1', 'Convection Roof to Internal/LConn1') 
add_line('house32137_subsys/room8/ThermalResistance', 'Convection Roof to Internal/RConn1', 'Int/RConn1') 
add_line('house32137_subsys/room8/ThermalResistance', 'Ground Temperature/LConn1', 'Floor Conduction/LConn1') 
add_line('house32137_subsys/room8/ThermalResistance', 'Floor Conduction/RConn1', 'Convection Floor to Internal/LConn1') 
add_line('house32137_subsys/room8/ThermalResistance', 'Convection Floor to Internal/RConn1', 'Int/RConn1') 
add_line('house32137_subsys/room8/ThermalResistance', 'Temperature Sensor/LConn1', 'Int/RConn1') 
add_line('house32137_subsys/room8/ThermalResistance', 'Thermal Reference1/LConn1', 'Temperature Sensor/RConn1') 
add_line('house32137_subsys/room8/ThermalResistance', 'Temperature Sensor/RConn2', 'PSConverter1/LConn1') 
add_line('house32137_subsys/room8/ThermalResistance', 'PSConverter1/1', 'TempGoto/1') 
add_line('house32137_subsys/room8', 'T_ext/1', 'ThermalResistance/1') 
add_line('house32137_subsys/room8', 'ThermalResistance/LConn1', 'Zone/LConn2') 
add_line('house32137_subsys/room8', 'Zone/LConn1', 'Door/RConn1') 
add_line('house32137_subsys', 'Door/RConn1', 'room8/LConn1') 
add_line('house32137_subsys/room8', 'Zone/RConn1', 'room10/RConn1') 
add_line('house32137_subsys/room8', 'Zone/RConn2', 'room3/RConn1') 

% room5 
room5_length = 18; 
room5_width = 6.0; 
room5_height = building_height; 
room5_wall_area = room5_height * (room5_length + room5_width); 
room5_floor_area = room5_length * room5_width; 
room5_zone_volume = room5_floor_area * building_height; 

add_block('built-in/SubSystem', 'house32137_subsys/room5', 'Position', [400 100 450 150]) 
add_block('built-in/SubSystem', 'house32137_subsys/room5/ThermalResistance', 'Position', [80 50 110 80]) 
add_block('simulink/Commonly Used Blocks/In1', 'house32137_subsys/room5/ThermalResistance/Ext', 'Position', [10 10 40 40]) 
add_block('nesl_utility/Simulink-PS Converter', 'house32137_subsys/room5/ThermalResistance/PSConverter', 'Position', [60 10 90 40], 'unit', 'degC', 'AffineConversion', 'on') 
add_block('fl_lib/Thermal/Thermal Sources/Controlled Temperature Source', 'house32137_subsys/room5/ThermalResistance/External Temperature', 'Position', [160 10 190 40]) 
add_block('fl_lib/Thermal/Thermal Elements/Thermal Reference', 'house32137_subsys/room5/ThermalResistance/Thermal Reference', 'Position', [110 40 140 70]) 
add_block('fl_lib/Thermal/Thermal Elements/Convective Heat Transfer', 'house32137_subsys/room5/ThermalResistance/Convection Wall to External', 'Position', [230 10 260 40], 'area', 'room5_wall_area', 'heat_tr_coeff', 'wall_heat_transfer_coeff_external') 
add_block('fl_lib/Thermal/Thermal Elements/Conductive Heat Transfer', 'house32137_subsys/room5/ThermalResistance/Wall Conduction External Side', 'Position', [280 10 310 40], 'area', 'room5_wall_area', 'thickness', 'wall_thickness / 2', 'th_cond', 'wall_conductivity') 
add_block('fl_lib/Thermal/Thermal Elements/Conductive Heat Transfer', 'house32137_subsys/room5/ThermalResistance/Wall Conduction Internal Side', 'Position', [350 10 380 40], 'area', 'room5_wall_area', 'thickness', 'wall_thickness / 2', 'th_cond', 'wall_conductivity') 
add_block('fl_lib/Thermal/Thermal Elements/Convective Heat Transfer', 'house32137_subsys/room5/ThermalResistance/Convection Wall to Internal', 'Position', [400 10 430 40], 'area', 'room5_wall_area', 'heat_tr_coeff', 'wall_heat_transfer_coeff_internal') 
try 
   add_block('Simscape/Utilities/Connection Port', 'house32137_subsys/room5/ThermalResistance/Int', 'Position', [470 10 500 40]) 
catch 
   add_block('simulink/Signal Routing/Connection Port', 'house32137_subsys/room5/ThermalResistance/Int', 'Position', [470 10 500 40]) 
end 
add_block('fl_lib/Thermal/Thermal Elements/Thermal Mass', 'house32137_subsys/room5/ThermalResistance/Wall Thermal Mass', 'Position', [330 70 350 90], 'mass', 'room5_wall_area * wall_thickness * wall_density', 'sp_heat', 'wall_specific_heat', 'T_specify', 'on', 'T', 'initial_temperature', 'T_unit', 'degC') 
add_block('fl_lib/Thermal/Thermal Elements/Convective Heat Transfer', 'house32137_subsys/room5/ThermalResistance/Convection Roof to External', 'Position', [230 120 260 150], 'area', 'room5_floor_area', 'heat_tr_coeff', 'roof_heat_transfer_coeff_external') 
add_block('fl_lib/Thermal/Thermal Elements/Conductive Heat Transfer', 'house32137_subsys/room5/ThermalResistance/Roof Conduction External Side', 'Position', [280 120 310 150], 'area', 'room5_floor_area', 'thickness', 'roof_thickness / 2', 'th_cond', 'wall_conductivity') 
add_block('fl_lib/Thermal/Thermal Elements/Conductive Heat Transfer', 'house32137_subsys/room5/ThermalResistance/Roof Conduction Internal Side', 'Position', [350 120 380 150], 'area', 'room5_floor_area', 'thickness', 'roof_thickness / 2', 'th_cond', 'wall_conductivity') 
add_block('fl_lib/Thermal/Thermal Elements/Convective Heat Transfer', 'house32137_subsys/room5/ThermalResistance/Convection Roof to Internal', 'Position', [400 120 430 150], 'area', 'room5_floor_area', 'heat_tr_coeff', 'roof_heat_transfer_coeff_internal') 
add_block('fl_lib/Thermal/Thermal Elements/Thermal Mass', 'house32137_subsys/room5/ThermalResistance/Roof Thermal Mass', 'Position', [330 180 350 200], 'mass', 'room5_floor_area * roof_thickness * wall_density', 'sp_heat', 'roof_specific_heat', 'T_specify', 'on', 'T', 'initial_temperature', 'T_unit', 'degC') 
add_block('fl_lib/Thermal/Thermal Sources/Temperature Source', 'house32137_subsys/room5/ThermalResistance/Ground Temperature', 'Position', [280 230 310 260], 'temperature', 'ground_temperature', 'temperature_unit', 'degC') 
add_block('fl_lib/Thermal/Thermal Elements/Conductive Heat Transfer', 'house32137_subsys/room5/ThermalResistance/Floor Conduction', 'Position', [350 230 380 260], 'area', 'room5_floor_area', 'thickness', 'floor_thickness', 'th_cond', 'floor_conductivity') 
add_block('fl_lib/Thermal/Thermal Elements/Convective Heat Transfer', 'house32137_subsys/room5/ThermalResistance/Convection Floor to Internal', 'Position', [400 230 430 260], 'area', 'room5_floor_area', 'heat_tr_coeff', 'floor_heat_transfer_coeff_internal') 
add_block('fl_lib/Thermal/Thermal Sensors/Temperature Sensor', 'house32137_subsys/room5/ThermalResistance/Temperature Sensor', 'Position', [440 290 460 310]) 
add_block('fl_lib/Thermal/Thermal Elements/Thermal Reference', 'house32137_subsys/room5/ThermalResistance/Thermal Reference1', 'Position', [430 380 450 400]) 
add_block('nesl_utility/PS-Simulink Converter', 'house32137_subsys/room5/ThermalResistance/PSConverter1', 'Position', [450 330 470 350], 'unit', 'degC', 'AffineConversion', 'on') 
add_block('simulink/Signal Routing/Goto', 'house32137_subsys/room5/ThermalResistance/TempGoto', 'Position', [490 330 540 350], 'GotoTag', 'room5', 'TagVisibility', 'global') 
add_block('simulink/Signal Routing/From', 'house32137_subsys/room5/T_ext', 'Position', [10 50 60 80], 'GotoTag', 'T_ext', 'TagVisibility', 'global') 
add_block('fl_lib/Gas/Elements/Constant Volume Chamber (G)', 'house32137_subsys/room5/Zone', 'Position', [160 50 190 80], 'num_ports', 'foundation.enum.num_ports.one', 'area_A', 'duct_area', 'area_B', 'zone_flow_area', 'area_C', 'zone_flow_area', 'area_D', 'zone_flow_area', 'volume', 'room5_zone_volume', 'p_I_specify', 'on', 'p_I', '1', 'p_I_unit', 'atm', 'T_I_specify', 'on', 'T_I', 'initial_temperature', 'T_I_unit', 'degC') 
try 
   add_block('Simscape/Utilities/Connection Port', 'house32137_subsys/room5/Mixed', 'Position', [170 110 200 140]) 
catch 
   add_block('simulink/Signal Routing/Connection Port', 'house32137_subsys/room5/Mixed', 'Position', [170 110 200 140]) 
end 

add_line('house32137_subsys/room5/ThermalResistance', 'Ext/1', 'PSConverter/1') 
add_line('house32137_subsys/room5/ThermalResistance', 'PSConverter/RConn1', 'External Temperature/RConn1') 
add_line('house32137_subsys/room5/ThermalResistance', 'Thermal Reference/LConn1', 'External Temperature/RConn2') 
add_line('house32137_subsys/room5/ThermalResistance', 'External Temperature/LConn1', 'Convection Wall to External/LConn1') 
add_line('house32137_subsys/room5/ThermalResistance', 'Convection Wall to External/RConn1', 'Wall Conduction External Side/LConn1') 
add_line('house32137_subsys/room5/ThermalResistance', 'Wall Conduction External Side/RConn1', 'Wall Conduction Internal Side/LConn1') 
add_line('house32137_subsys/room5/ThermalResistance', 'Wall Thermal Mass/LConn1', 'Wall Conduction Internal Side/LConn1') 
add_line('house32137_subsys/room5/ThermalResistance', 'Wall Conduction Internal Side/RConn1', 'Convection Wall to Internal/LConn1') 
add_line('house32137_subsys/room5/ThermalResistance', 'Convection Wall to Internal/RConn1', 'Int/RConn1') 
add_line('house32137_subsys/room5/ThermalResistance', 'External Temperature/LConn1', 'Convection Roof to External/LConn1') 
add_line('house32137_subsys/room5/ThermalResistance', 'Convection Roof to External/RConn1', 'Roof Conduction External Side/LConn1') 
add_line('house32137_subsys/room5/ThermalResistance', 'Roof Conduction External Side/RConn1', 'Roof Conduction Internal Side/LConn1') 
add_line('house32137_subsys/room5/ThermalResistance', 'Roof Thermal Mass/LConn1', 'Roof Conduction Internal Side/LConn1') 
add_line('house32137_subsys/room5/ThermalResistance', 'Roof Conduction Internal Side/RConn1', 'Convection Roof to Internal/LConn1') 
add_line('house32137_subsys/room5/ThermalResistance', 'Convection Roof to Internal/RConn1', 'Int/RConn1') 
add_line('house32137_subsys/room5/ThermalResistance', 'Ground Temperature/LConn1', 'Floor Conduction/LConn1') 
add_line('house32137_subsys/room5/ThermalResistance', 'Floor Conduction/RConn1', 'Convection Floor to Internal/LConn1') 
add_line('house32137_subsys/room5/ThermalResistance', 'Convection Floor to Internal/RConn1', 'Int/RConn1') 
add_line('house32137_subsys/room5/ThermalResistance', 'Temperature Sensor/LConn1', 'Int/RConn1') 
add_line('house32137_subsys/room5/ThermalResistance', 'Thermal Reference1/LConn1', 'Temperature Sensor/RConn1') 
add_line('house32137_subsys/room5/ThermalResistance', 'Temperature Sensor/RConn2', 'PSConverter1/LConn1') 
add_line('house32137_subsys/room5/ThermalResistance', 'PSConverter1/1', 'TempGoto/1') 
add_line('house32137_subsys/room5', 'T_ext/1', 'ThermalResistance/1') 
add_line('house32137_subsys/room5', 'ThermalResistance/LConn1', 'Zone/LConn2') 
add_line('house32137_subsys/room5', 'Zone/LConn1', 'Mixed/RConn1') 

% air conditioners 

% room3AC 
add_block('built-in/SubSystem', 'house32137_subsys/room3AC', 'Position', [200 80 220 100]) 
try 
   add_block('Simscape/Utilities/Connection Port', 'house32137_subsys/room3AC/Internal', 'Position', [-30 250 0 280]) 
catch 
   add_block('simulink/Signal Routing/Connection Port', 'house32137_subsys/room3AC/Internal', 'Position', [-30 250 0 280]) 
end 
try 
   add_block('Simscape/Utilities/Connection Port', 'house32137_subsys/room3AC/Mixed', 'Position', [570 220 600 250]) 
catch 
   add_block('simulink/Signal Routing/Connection Port', 'house32137_subsys/room3AC/Mixed', 'Position', [570 220 600 250]) 
end 
add_block('simulink/Signal Routing/From', 'house32137_subsys/room3AC/T_fan', 'Position', [10 10 60 40], 'GotoTag', 'T_fan', 'TagVisibility', 'global') 
add_block('nesl_utility/Simulink-PS Converter', 'house32137_subsys/room3AC/PSConverterA', 'Position', [90 10 120 40], 'unit', 'degC', 'AffineConversion', 'on') 
add_block('simulink/Commonly Used Blocks/Constant', 'house32137_subsys/room3AC/Constant1', 'Position', [10 70 40 100], 'Value', '1') 
add_block('nesl_utility/Simulink-PS Converter', 'house32137_subsys/room3AC/PSConverterB', 'Position', [90 70 120 100], 'unit', 'atm', 'AffineConversion', 'off') 
add_block('fl_lib/Gas/Elements/Controlled Reservoir (G)', 'house32137_subsys/room3AC/FanAirIn', 'Position', [150 10 240 100], 'area_A', 'duct_area', 'area_A_unit', 'm^2') 
add_block('simulink/Commonly Used Blocks/Constant', 'house32137_subsys/room3AC/Constant2', 'Position', [10 130 40 160], 'Value', 'duct_area') 
add_block('simulink/Signal Routing/From', 'house32137_subsys/room3AC/recycling', 'Position', [10 190 60 220], 'GotoTag', 'recycling', 'TagVisibility', 'global') 
add_block('simulink/Commonly Used Blocks/Product', 'house32137_subsys/room3AC/Product', 'Position', [90 190 120 220]) 
add_block('simulink/Commonly Used Blocks/Sum', 'house32137_subsys/room3AC/Sum', 'Position', [150 130 180 160], 'Inputs', '|+-') 
add_block('nesl_utility/Simulink-PS Converter', 'house32137_subsys/room3AC/PSConverterC', 'Position', [210 130 240 160], 'unit', 'm^2', 'AffineConversion', 'off') 
add_block('nesl_utility/Simulink-PS Converter', 'house32137_subsys/room3AC/PSConverterD', 'Position', [210 190 240 220], 'unit', 'm^2', 'AffineConversion', 'off') 
add_block('fl_lib/Gas/Elements/Local Restriction (G)', 'house32137_subsys/room3AC/ExternalAirRestriction', 'Position', [270 10 360 100], 'restriction_type', 'foundation.enum.restriction_type.variable', 'min_area', '1e-10', 'min_area_unit', 'm^2', 'max_area', '0.99 * duct_area', 'max_area_unit', 'm^2', 'area', 'duct_area', 'Cd', '0.8', 'B_lam', '0.999') 
add_block('fl_lib/Gas/Elements/Local Restriction (G)', 'house32137_subsys/room3AC/InternalAirRestriction', 'Position', [270 190 360 280], 'restriction_type', 'foundation.enum.restriction_type.variable', 'min_area', '1e-10', 'min_area_unit', 'm^2', 'max_area', '0.99 * duct_area', 'max_area_unit', 'm^2', 'area', 'duct_area', 'Cd', '0.8', 'B_lam', '0.999') 
add_block('simulink/Lookup Tables/1-D Lookup Table', 'house32137_subsys/room3AC/LookupTable', 'Position', [270 310 360 400], 'NumberOfTableDimensions', '1', 'BreakpointsForDimension1', 'fan_setting_table', 'Table', 'fan_flow_rate_table', 'ExtrapMethod', 'Clip', 'InternalRulePriority', 'Speed', 'RndMeth', 'Simplest') 
add_block('simulink/Signal Routing/From', 'house32137_subsys/room3AC/fan_cntrl', 'Position', [190 340 240 370], 'GotoTag', 'fan_cntrl', 'TagVisibility', 'global') 
add_block('nesl_utility/Simulink-PS Converter', 'house32137_subsys/room3AC/PSConverterE', 'Position', [390 340 420 370], 'unit', 'kg/s', 'AffineConversion', 'off') 
add_block('fl_lib/Gas/Sources/Controlled Mass Flow Rate Source (G)', 'house32137_subsys/room3AC/Fan', 'Position', [450 190 540 280], 'power_spec', '1', 'ComponentVariants', 'foundation.gas.sources.controlled_mass_flow_source', 'ComponentVariantNames', 'controlled_mass_flow_source', 'area_A', 'duct_area', 'area_A_unit', 'm^2', 'area_B', 'duct_area', 'area_B_unit', 'm^2') 
add_block('fl_lib/Gas/Elements/Pipe (G)', 'house32137_subsys/room3AC/Duct', 'Position', [210 250 240 280], 'length', 'building_length + building_width', 'area', 'duct_area', 'Dh', 'sqrt(duct_area)', 'length_add', '0', 'shape_factor', '56.92', 'Nu_lam', '2.98', 'p_I_specify', 'on', 'p_I', '1', 'p_I_unit', 'atm', 'T_I_specify', 'on', 'T_I', 'initial_temperature', 'T_I_unit', 'degC') 
add_block('fl_lib/Gas/Elements/Local Restriction (G)', 'house32137_subsys/room3AC/Extraction', 'Position', [150 250 180 280], 'restriction_type', 'foundation.enum.restriction_type.fixed', 'restriction_area', '0.5 * duct_area', 'area', 'duct_area', 'Cd', '0.8') 
add_block('fl_lib/Gas/Elements/Controlled Reservoir (G)', 'house32137_subsys/room3AC/ExtractionAirOut', 'Position', [90 310 120 340], 'area_A', 'duct_area') 
add_block('nesl_utility/Simulink-PS Converter', 'house32137_subsys/room3AC/PSConverterF', 'Position', [30 370 60 400], 'Unit', 'degC', 'AffineConversion', 'on') 
add_block('simulink/Signal Routing/From', 'house32137_subsys/room3AC/T_ext', 'Position', [30 430 60 460], 'GotoTag', 'T_ext', 'TagVisibility', 'global') 
add_block('nesl_utility/Simulink-PS Converter', 'house32137_subsys/room3AC/PSConverterG', 'Position', [90 370 120 400], 'Unit', 'atm') 
add_block('simulink/Commonly Used Blocks/Constant', 'house32137_subsys/room3AC/Constant', 'Position', [90 430 120 460], 'Value', '1') 
add_line('house32137_subsys/room3AC', 'T_fan/1', 'PSConverterA/1') 
add_line('house32137_subsys/room3AC', 'Constant1/1', 'PSConverterB/1') 
add_line('house32137_subsys/room3AC', 'PSConverterA/RConn1', 'FanAirIn/RConn1') 
add_line('house32137_subsys/room3AC', 'PSConverterB/RConn1', 'FanAirIn/RConn2') 
add_line('house32137_subsys/room3AC', 'Constant2/1', 'Product/1') 
add_line('house32137_subsys/room3AC', 'recycling/1', 'Product/2') 
add_line('house32137_subsys/room3AC', 'Constant2/1', 'Sum/1') 
add_line('house32137_subsys/room3AC', 'Product/1', 'Sum/2') 
add_line('house32137_subsys/room3AC', 'Sum/1', 'PSConverterC/1') 
add_line('house32137_subsys/room3AC', 'Product/1', 'PSConverterD/1') 
add_line('house32137_subsys/room3AC', 'FanAirIn/LConn1', 'ExternalAirRestriction/LConn1') 
add_line('house32137_subsys/room3AC', 'PSConverterC/RConn1', 'ExternalAirRestriction/LConn2') 
add_line('house32137_subsys/room3AC', 'PSConverterD/RConn1', 'InternalAirRestriction/LConn2') 
add_line('house32137_subsys/room3AC', 'fan_cntrl/1', 'LookupTable/1') 
add_line('house32137_subsys/room3AC', 'LookupTable/1', 'PSConverterE/1') 
add_line('house32137_subsys/room3AC', 'ExternalAirRestriction/RConn1', 'Fan/LConn1') 
add_line('house32137_subsys/room3AC', 'InternalAirRestriction/RConn1', 'Fan/LConn1') 
add_line('house32137_subsys/room3AC', 'PSConverterE/RConn1', 'Fan/LConn2') 
add_line('house32137_subsys/room3AC', 'Fan/RConn1', 'Mixed/RConn1') 
add_line('house32137_subsys/room3AC', 'Internal/RConn1', 'Extraction/LConn1') 
add_line('house32137_subsys/room3AC', 'Extraction/RConn1', 'ExtractionAirOut/LConn1') 
add_line('house32137_subsys/room3AC', 'ExtractionAirOut/RConn1', 'PSConverterF/RConn1') 
add_line('house32137_subsys/room3AC', 'ExtractionAirOut/RConn2', 'PSConverterG/RConn1') 
add_line('house32137_subsys/room3AC', 'T_ext/1', 'PSConverterF/1') 
add_line('house32137_subsys/room3AC', 'Constant/1', 'PSConverterG/1') 
add_line('house32137_subsys/room3AC', 'Extraction/LConn1', 'Duct/LConn1') 
add_line('house32137_subsys/room3AC', 'Duct/RConn1', 'InternalAirRestriction/LConn1') 
add_line('house32137_subsys', 'room3AC/LConn1', 'room5/LConn1') 
add_line('house32137_subsys', 'room3AC/LConn2', 'room3/LConn1') 
add_line('house32137_subsys', 'room3AC/LConn1', 'AirProperties/LConn1') 

% links 
add_block('fl_lib/Gas/Elements/Flow Resistance (G)', 'house32137_subsys/room10 to room3', 'Position', [160 100 190 130], 'delta_p_nominal', '20', 'delta_p_nominal_unit', 'Pa', 'mdot_nominal', '0.04', 'rho_nominal', '1.2', 'area', 'zone_flow_area') 
add_line('house32137_subsys', 'room10 to room3/LConn1', 'room10/LConn1') 
add_line('house32137_subsys', 'room10 to room3/RConn1', 'room3/LConn2') 
add_block('fl_lib/Gas/Elements/Flow Resistance (G)', 'house32137_subsys/room10 to room8', 'Position', [160 100 190 130], 'delta_p_nominal', '20', 'delta_p_nominal_unit', 'Pa', 'mdot_nominal', '0.04', 'rho_nominal', '1.2', 'area', 'zone_flow_area') 
add_line('house32137_subsys', 'room10 to room8/LConn1', 'room10/LConn2') 
add_line('house32137_subsys', 'room10 to room8/RConn1', 'room8/LConn2') 
add_block('fl_lib/Gas/Elements/Flow Resistance (G)', 'house32137_subsys/room3 to room8', 'Position', [260 100 290 130], 'delta_p_nominal', '20', 'delta_p_nominal_unit', 'Pa', 'mdot_nominal', '0.04', 'rho_nominal', '1.2', 'area', 'zone_flow_area') 
add_line('house32137_subsys', 'room3 to room8/LConn1', 'room3/LConn3') 
add_line('house32137_subsys', 'room3 to room8/RConn1', 'room8/LConn3') 

save_system(sys) 
