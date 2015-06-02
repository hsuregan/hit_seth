/*

*/

module hit(
	input clk,
	input rst,
	input freq,
	input [7:0] LED, //the random LED from the randomizer
	//only one of the [7:0] LED should be on
	input [7:0] switch,
	
	output hit,
	output miss,
    
    //debug
    output [31:0] counter_out,
    output [7:0] last_switch,
    output [7:0] switched_bit,
    output [7:0] LEDnumber_w
);

reg hit_reg;
reg miss_reg;
reg [7:0] LEDnumber;
//wire [7:0] LEDnumber_w;
reg [31:0] counter;
wire [31:0] counter_w;
reg [7:0] changed_bit; //which switch has been flipped
reg [7:0] switch_mem; //keeps track of previous set of switch

assign counter_w = counter;
assign changed_bit_wire = changed_bit;
assign hit = hit_reg;
assign miss = miss_reg;
assign counter_out = counter;
assign last_switch = switch_mem;
assign switched_bit = changed_bit;
assign LEDnumber_w = LEDnumber;
//light_duration - the LED will last for 1 sec
  //IDLE STATE == 0
//ACTIVE STATE > 0
always @(posedge clk or posedge rst or posedge freq)
begin
	if(rst) counter <= 0;
	else if(freq) counter <= 1;
	else if(counter_w == 10) counter <= 0; //counter_w = 100000000
	else if(counter_w == 0) counter <= 0; //not necessary, ensure idle stays idle
	else if(counter_w > 0) counter <= counter +1;
end

//keeps track of which switch is flipped
//switch_mem keeps track of the previous set of swtich combos

always @(posedge clk or posedge rst) begin
	if(rst) begin
		changed_bit <= 0;
		switch_mem <= 0;
	end
    //switched_bit = 0 on freq high be we don't want to use
    //the old 'switched_bit' to match the next LED number
    else if(freq) begin
        changed_bit <= 0;
    end
	else if(switch_mem != switch) begin
		changed_bit <= switch_mem ^ switch; //xor last set to current set of switch
		switch_mem <= switch; //load last switch
	end
end

//loads the random LED from randomizer
//LED is the random input, it will always have a value
//NEGEDGE FREQ to ensure correct loading
//
always @(posedge clk or posedge rst) begin
	if(rst) LEDnumber <= 0;
	else if(freq) LEDnumber <= LED;
    else if(counter == 0) LEDnumber <= 0; //idle state, led is off 
end

//counter_w is wire of counter, which keeps track of how long light
//will be on
always @(posedge clk or negedge clk or posedge rst) begin
	if(rst) begin
		hit_reg <= 0;
		miss_reg <= 0;
    //case where someone flips the switch when the light isn't on    
	end else if((!counter) && (last_switch != switch)) begin
        hit_reg <= 0;
        miss_reg <= 1;
    end else if(!counter_w) begin //LED is off, user doesn't do anything
		hit_reg <= 0;
		miss_reg <= 0;
	end else if((counter_w > 9) && (changed_bit == LEDnumber_w)) begin
		//100000000 - check on last clock cycle
        hit_reg <= 1;
		miss_reg <= 0;
    
	end /*else if((!counter_w) && (changed_bit != LEDnumber) && (counter_w > 8)) begin
		hit_reg <= 0;
		miss_reg <= 1;
	
    end */else if((counter_w > 9) && (changed_bit != LEDnumber_w)) begin
		hit_reg <= 0;
		miss_reg <= 1;
	end
end

endmodule
