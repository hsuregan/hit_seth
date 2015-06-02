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

	//possible outputs
	//note that LED is on for ONE SECOND, so cannot be slower than that
	wire one_point_five_sec,
		 one_point_sevenish_sec, 
		 two_sec,
		 two_point_twoish_sec,
		 two_point_five_sec,
		 two_point_sevenish_sec,
		 three_sec,
		 three_point_five_sec;


	assign one_point_five_sec = (counter%150000000 == 0);
	assign one_point_sevenish_sec = (counter%170000000 == 0);
	assign two_sec = (counter%200000000 == 0);
	assign two_point_twoish_sec = (counter%220000000 == 0);
	assign two_point_five_sec = (counter%250000000 == 0);
	assign two_point_sevenish_sec = (counter%270000000 == 0);
	assign three_sec = (counter%300000000 == 0);
	assign three_point_five_sec = (counter%350000000 == 0);
	
	//counter

	always @(posedge clk or posedge rst) begin
		if(rst) counter <= 0;
        else if(!enable) counter <= 0;
		else counter <= counter + 1;
	end
  
  assign freq = (!enable) ? 0 :
  				(difficulty == 0) ? three_point_five_sec : 
    			(difficulty == 1) ? three_sec :
    			(difficulty == 2) ? two_point_sevenish_sec :
    			(difficulty == 3) ? two_point_five_sec :
    			(difficulty == 4) ? two_point_twoish_sec : 
    			(difficulty == 5) ? two_sec :
    			(difficulty == 6) ? one_point_sevenish_sec :
    			(difficulty == 7) ? one_point_five_sec : three_point_five_sec;
	
endmodule
