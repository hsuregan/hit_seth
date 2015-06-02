module top(
	input enable,
	input [2:0] difficulty,
	input clk,
	input rst,
	input [7:0] switch, //the seven switches should be wired here
	
	output hit,
	output miss,
    output [7:0] LEDnumber_w, //OUTPUT GOES TO FPGA LIGHT

    
    //debugging
    output frequency,
    output [31:0] counter,
    output [2:0] LED_val,
    output [7:0] last_switch,
    output [7:0] switched_bit,
   	output [7:0] LED

);

wire [12:0] random;
wire freq;
assign frequency = freq;




freq uut(
	//inputs
	.clk(clk),
	.rst(rst),
	.enable(enable), //enable frequency to send pulses
	.difficulty(difficulty),

	//outputs
	.freq(freq)
);


LFSR uut1(
	//inputs
	.clock(clk),
	.reset(rst),
	
	//output
	.rnd(random)
	
);

randomizer uut2(
	//inputs
	.clk(clk),
	.rst(rst),
	.freq(freq),
	.rnd(random),
	
	//outputs
	.LED_num(LED),
    .LED_val(LED_val)

);

hit uut3(
	.clk(clk),
	.rst(rst),
	.freq(freq),
	.LED(LED),
	.switch(switch),
	
	.hit(hit),
	.miss(miss),
    .counter_out(counter),
    .last_switch(last_switch),
    .switched_bit(switched_bit),
    .LEDnumber_w(LEDnumber_w)
); 

endmodule