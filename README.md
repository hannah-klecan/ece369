5-stage pipelined MIPS processor 

Building a complete working processor that:
- Can execute real MIPS programs
- Runs on actual FPGA hardware
- Shows visible results on the displays

Pipelining 
- Allows multiple instructions to execute simultaneously (one in each stage)
Data hazards: execution of one instruction is dependent on the results of another instruction
- Will add data hazard detection and forwarding

LAB 7
Program should  display the (X,Y) coordinates of the block of the current minimum SAD. 
We will be using the public test case and testing the vbsme on your datapath. 
Please make sure to upload all the required files and you must upload the required instruction memory and data memory files. 
Please also make sure that you're initializing your instruction memory with $readmemh("instruction_memory.mem", memory); and your data memory with $readmemh("data_memory.mem", memory). 
In case you get errors, please use the full path that points to your memory files.

Lab Specs:
https://drive.google.com/drive/folders/1m5LsyqFT0Oifvlvaw_h5mcS9c0ATnU7G?usp=sharing
