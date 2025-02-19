module BoardTst(
	input 						CLK				,
	input						Rst				,
	inout						FPGA_CLK_A_N	,
	inout						FPGA_CLK_A_P	,
	output						LEDG0			,
	output	signed [13:0]		DA				,
	output	signed [13:0]		DB
	);
	
	reg	   	signed [13:0]		r_DA			;
	reg	   	signed [13:0]		r_DiffA			;
	reg	   	signed [13:0]		r_DiffB			;
//	wire	   signed [13:0]	s_DA				;
//	wire		signed [13:0]	s_DB				;
	wire	signed [29:0]		s_dout			;
	wire						sys_clk			;
	wire						sys_clk_180deg	;
	wire						pll_locked		;
	
	//myqam模块例化
	myqam myqam(
				.CLK	(sys_clk)		,
				.Rst	(!Rst	)		,
				.dout	(s_dout	)			
				);
				
	//FPGA提供时钟驱动
	pll pll_inst(
			.inclk0	(CLK			)	,
			.c0		(sys_clk		)	,
			.c1		(sys_clk_180deg	)	,
			.locked	(pll_locked		)
			);
	
	//有符号数到无符号数的转化
	
	always @(posedge sys_clk or negedge Rst)	begin
		if (!Rst)	begin
			r_DA	<= 14'd0	;
		end else begin
			r_DA	<= s_dout[20:7] + 14'd8192	;
		end
	end
	
	//两路差分信号
	always @(posedge sys_clk or negedge Rst)	begin
		if (!Rst) begin
			r_DiffA	<= 14'd0	;
			r_DiffB	<= 14'd0 ;
		end else begin
			r_DiffA	<= r_DA	;
			r_DiffB	<= ~r_DA ;
		end
	end
	
	
	
	//信号输出
	assign	LEDG0			= pll_locked		;		// pll locked
	assign	DA				= r_DiffA			;
	assign	DB 				= r_DiffB			;
	assign	FPGA_CLK_A_P	=  sys_clk_180deg	;
	assign	FPGA_CLK_A_N	= ~sys_clk_180deg	;
	
	
	
endmodule
