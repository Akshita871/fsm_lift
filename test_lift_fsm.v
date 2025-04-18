module test_lift_fsm;

  // Inputs and outputs of the elevator FSM
  reg clk;
  reg reset;
  reg [11:0] floor_call_buttons;
  reg door_open_sensor;
  reg door_close_sensor;
  reg [3:0]elevator_position_sensor;
  reg passenger_weight_sensor;
  reg fire_alarm_sensor;
  reg power_outage_sensor;
  reg disability_sensor;
  wire elevator_motor_control;
  wire door_open_control;
  wire door_close_control;
  wire [11:0]floor_display;
  wire alarm_signal;
  wire emergency_mode_signal;

  // Elevator FSM instance
  lift_fsm dut (
    .clk(clk),
    .reset(reset),
    .floor_call_buttons(floor_call_buttons),
    .door_open_sensor(door_open_sensor),
    .door_close_sensor(door_close_sensor),
    .elevator_position_sensor(elevator_position_sensor),
    .passenger_weight_sensor(passenger_weight_sensor),
    .fire_alarm_sensor(fire_alarm_sensor),
    .power_outage_sensor(power_outage_sensor),
    .elevator_motor_control(elevator_motor_control),
    .door_open_control(door_open_control),
    .door_close_control(door_close_control),
    .floor_display(floor_display),
    .alarm_signal(alarm_signal),
    .emergency_mode_signal(emergency_mode_signal),
    .disability_sensor(disability_sensor)
  );

  // Test stimulus
  initial begin
    clk <= 1'b0;
    reset <= 1'b1;
    floor_call_buttons<=12'b000000000000;
    
    #10 reset <= 1'b0;

    // Test case 1: Elevator is idle and a call button is pressed
    power_outage_sensor<=1'b0;
    fire_alarm_sensor <= 1'b0;
    floor_call_buttons[0] <= 12'b000000000000;
    elevator_position_sensor<=4'b0000;
    door_open_sensor=1'b0;
    door_close_sensor=1'b0;
    power_outage_sensor<=1'b0;
    fire_alarm_sensor<=1'b0;
    disability_sensor<=1'b0;
    passenger_weight_sensor<=1'b0;
    #10;

    // Test case 2: Elevator is moving up to 5th floor and reaches the destination floor
     power_outage_sensor<=1'b0;
     fire_alarm_sensor <= 1'b0;
    floor_call_buttons[5] <= 12'b000000000101;
    door_open_sensor<=1'b1;
    door_close_sensor<=1'b0;
    elevator_position_sensor <= 4'b0101;
    disability_sensor<=1'b1;
    #10;

    // Test case 3: Elevator is moving down and reaches the destination floor
    power_outage_sensor<=1'b0;
    floor_call_buttons[10] <= 12'b000000001010;
    fire_alarm_sensor <= 1'b0;
    elevator_position_sensor <= 4'b1010;
    door_open_sensor<=1'b1;
    disability_sensor<=1'b0;

    #10;

    // Test case 4: Elevator doors are opening and all passengers have entered
     power_outage_sensor<=1'b0;
    fire_alarm_sensor <= 1'b0;
    door_open_sensor <= 1'b1;
    door_close_sensor<=1'b0;
    passenger_weight_sensor <= 1'b1;
    disability_sensor<=1'b1;
    #10;

    // Test case 5: Elevator doors are closing and all passengers have exited
    power_outage_sensor<=1'b0;
    fire_alarm_sensor <= 1'b0;
    door_close_sensor <= 1'b1;
    passenger_weight_sensor <= 1'b0;
    disability_sensor<=1'b1;
    #10;

    // Test case 6: Fire alarm is detected
    fire_alarm_sensor <= 1'b1;
    #10;

    // Test case 7: Power outage occurs
    power_outage_sensor <= 1'b1;
    #10;
   
    //Test case 8: Disability sensor activates
    disability_sensor<=1'b1;
  end

  // Monitor the outputs of the elevator FSM
  always @(posedge clk) begin
    $display("Motor control signal: %b", elevator_motor_control);
    $display("Door open control signal: %b", door_open_control);
    $display("Floor display: %b", floor_display);
    $display("Alarm signal: %b", alarm_signal);
    $display("Emergency mode signal: %b", emergency_mode_signal);
end

endmodule

