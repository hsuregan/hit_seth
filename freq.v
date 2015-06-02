/*
Depending on difficulty lvl, outputs frequency
*/

module freq(
	input enable,
	input [2:0] difficulty,
	input clk,
	input rst,
	
	output freq
);
	reg [31:0] counter;
	wire fourthHz, halfHz, oneHz, twoHz, fourHz; //possible outputs
	
  assign fourthHz = (counter%40 == 0); //400000000
  assign halfHz = (counter%20 == 0); //200000000
  assign oneHz = (counter%10 == 0); //100000000
  assign twoHz = (counter%5 == 0); //50000000
  assign fourHz = (counter%2 == 0); //25000000
	
	//counter

	always @(posedge clk or posedge rst) begin
		if(rst) counter <= 0;
        else if(!enable) counter <= 0;
		else counter <= counter + 1;
	end
  
  assign freq = (!enable) ? 0 :
  				(difficulty == 0) ? fourthHz : 
    			(difficulty == 1) ? halfHz :
    			(difficulty == 2) ? oneHz :
    			(difficulty == 3) ? twoHz :
    			(difficulty == 4) ? fourHz : fourthHz;
	
endmodule
