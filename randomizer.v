/* 
Everytime frequency sends pulse, this module changes LED number
Random number is fed in from lsfr
*/

module randomizer(
	input clk,
	input rst,
	input freq, //from the frequency module
	input[12:0] rnd, //from the lfsr module

	output [7:0] LED_num,
    
    //debug 
    output [2:0] LED_val
);

reg [2:0] LED;
reg [7:0] LED_out;
assign LED_num = LED_out;
assign LED_val = LED;
//reg [31:0] one_sec;
//assign LED_on = one_sec < 100000000; //LED is on for 1 sec 


//replace LED number everytime frequency pulses
always @(posedge clk or posedge rst) begin
	if(rst) begin 
        LED <= 0;
	end
    else if(freq) begin
		LED <= {rnd[2:0]};
		case(LED) //switches on specific LED on the board
			0: LED_out <= 8'b00000001;
			1: LED_out <= 8'b00000010;
			2: LED_out <= 8'b00000100;
			3: LED_out <= 8'b00001000;
			4: LED_out <= 8'b00010000;
			5: LED_out <= 8'b00100000;
			6: LED_out <= 8'b01000000;
			7: LED_out <= 8'b10000000;
			default: LED_out <= 8'b00010000;
		endcase
	end else begin
        LED <= LED;
    end
end

//one_sec

/*
always @(posedge clk or posedge rst) begin 
	if(rst) one_sec <= 0;
	else if(freq) one_sec <= 0; //on freq pulse, one_sec begins to count
	else if(one_sec < 100000000) one_sec <= one_sec + 1; 
	//at 100000000, one_sec is frozen until freq brings one_sec back to zero 
	
end
*/
endmodule