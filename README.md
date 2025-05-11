# TrafficController

# Traffic Light Controller - LogicalStep 

## Project Overview
This project implements a Traffic Light Controller (TLC) system on a MAX 10 FPGA board using VHDL. The system controls traffic lights at an intersection with North-South and East-West directions, handling pedestrian crossing requests while ensuring safe traffic flow.

## Project Team
Lukas Ruprecht, Guhan Iyer

## Features
- Two-way traffic light control (North-South and East-West)
- Pedestrian crossing request buttons with synchronization
- Visual indicators for traffic light states
- State number display for debugging and monitoring
- Proper synchronization of inputs to prevent metastability
- Holding registers to maintain crossing requests until serviced
- Blinking lights for pedestrian crossing indicators

## Hardware Requirements
- LogicalStep board with Altera MAX 10 FPGA
- 7-segment displays for traffic light status visualization
- Push buttons for pedestrian crossing requests
- LEDs for state and status indicators

## Project Components

![image](https://github.com/user-attachments/assets/92d94445-e759-4d84-b009-d2e078d5286c)



### Main Files
- `LogicalStep_Lab4_top.vhd` - Top-level entity that connects all components
- `LogicalStep_Lab4.qpf` - Quartus project file

### Key Components
1. **Push Button Filters** (`pb_filters`)
   - Debounces push button inputs
   - Filters the reset signal

2. **Push Button Inverters** (`pb_inverters`)
   - Inverts active-low push button signals for internal use

3. **Synchronizers** (`synchronizer`)
   - Prevents metastability by synchronizing asynchronous inputs with the system clock
   - Used for reset and pedestrian crossing request signals

4. **Clock Generator** (`clock_generator`)
   - Generates state machine clock enable and blinking signals
   - Supports simulation and hardware modes

5. **Holding Registers** (`holding_register`)
   - Maintains pedestrian crossing requests until serviced
   - Can be cleared by control signals from the state machine

6. **State Machine** (`State_Machine`)
   - Core traffic light control logic
   - Manages traffic light sequences and timing
   - Handles pedestrian crossing requests
   - Outputs state number for monitoring

7. **7-Segment Display Multiplexer** (`segment7_mux`)
   - Controls dual 7-segment displays for visualization
   - Shows traffic light states for both directions

## Signal Flow
1. Push buttons are filtered and inverted
2. Pedestrian crossing requests are synchronized with the system clock
3. Synchronized requests are stored in holding registers
4. The state machine processes requests based on current state and timing
5. Traffic light outputs are sent to 7-segment displays
6. State information is displayed on LEDs

## Controls
- **Push Button 0**: Request North-South pedestrian crossing
- **Push Button 1**: Request East-West pedestrian crossing
- **Reset Button (rst_n)**: System reset (active low)

## LED Indicators
- **LED 0**: North-South crossing active
- **LED 1**: North-South crossing request pending
- **LED 2**: East-West crossing active
- **LED 3**: East-West crossing request pending
- **LED 4-7**: Current state number (binary)

## 7-Segment Displays
- **Left Display**: East-West traffic light status (Red, Green, Amber)
- **Right Display**: North-South traffic light status (Red, Green, Amber)

## State Machine Operation
The state machine follows a specific sequence to ensure safe traffic flow:
1. Standard traffic light cycling between North-South and East-West directions
2. Handling of pedestrian crossing requests with appropriate safety measures
3. Proper transition timing between states (green → amber → red)
4. Blinking indicators during pedestrian crossing phases

## Building and Running the Project
1. Open Quartus Prime and load the project file (`LogicalStep_Lab4.qpf`)
2. Compile the project using the "Start Compilation" button
3. Program the FPGA using the Programmer tool
4. Use push buttons to request pedestrian crossings and observe the traffic light sequences

## Simulation
To simulate the system behavior:
1. Set the `sim_mode` constant to `TRUE` in `LogicalStep_Lab4_top.vhd`
2. Use the built-in simulator in Quartus or ModelSim-Altera
3. Uncomment the simulation output ports in the entity declaration if needed

## Design Considerations
- Synchronization is critical to prevent metastability issues
- Holding registers ensure pedestrian requests aren't missed
- The state machine is designed to prioritize safety while maintaining efficient traffic flow
- The clock generator provides appropriate timing for realistic traffic light operation
