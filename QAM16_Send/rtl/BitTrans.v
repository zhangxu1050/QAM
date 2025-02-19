module BitTrans (
		input				rst	,
		input 			clk	,
		input				din	,
		output	[3:0]	code
		); 

    
	reg 	   [3:0] 	r_code;
	reg 	   [2:0] 	r_count;
	reg 					r_din1;
	reg					r_din2;
	reg					r_din3;
	
	//数据输入缓存
	always @(posedge clk or posedge rst)	begin
		if(rst)	begin
			r_din1	<= 1'b0;
			r_din2	<= 1'b0;
			r_din3	<= 1'b0;
		end else begin
			if(r_count[0])	begin
				r_din1	<= din	;
				r_din2	<= r_din1;
				r_din3	<= r_din2;
			end
		end
	end
			
	
	//串并转换，4Mbps的单比特数据转换为1 Mbps的双比特码元
    always @(posedge clk or posedge rst) begin
	    if (rst)	begin
			r_code	<= 4'd0;
			r_count	<= 3'd0;
		end else begin
			r_count <= r_count + 3'd1;
			if (r_count == 3'd0)	begin
				r_code <={r_din3,r_din2,r_din1,din};
			end
		end
	end
	
	assign code	= r_code ;
	
endmodule