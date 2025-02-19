//这是FpgaGardner.v文件的程序清单
module FpgaGardner (
	rst,clk,di,dq,
	yi,yq,sync,u,e,w); 
	
	input		rst;   //复位信号，高电平有效
	input		clk;   //时钟信号/数据输入速率/4倍符号速率/4 MHz
	input  signed [15:0]	di;     //基带I支路数据/4 MHz
	input  signed [15:0]	dq;     //基带Q支路数据/4 MHz
	output signed [17:0]	yi;     //插值I支路数据/1 MHz
	output signed [17:0]	yq;     //插值Q支路数据/1 MHz
	output signed [15:0]	u;      //插值间隔输出
	output signed [15:0]	e;      //误差检测器输出	
	output signed [15:0]	w;      //经环路滤波器滤波后的定时误差w
	output sync;                 //位同步脉冲/1MHz

	
	//首先对输入数据通过寄存器输入  
	reg signed [15:0] dit,dqt;
	always @(posedge clk or posedge rst)
      if (rst)
		   begin
			   dit <= 16'd0;
				dqt <= 16'd0;
			end
		else
	      begin
			   dit <= di;
		 	   dqt <= dq;
		   end
		
	//实例化数控振荡器及插值间隔产生模块
	wire signed [15:0] wk,uk,nk;
	wire strobe;
	gnco u1  ( 
		.rst (rst),
		.clk (clk),
		.wk (wk),
		.strobe (strobe),
		.uk (uk),
		.nk (nk));

   //实例化插值滤波器模块
	wire signed [17:0] yik;
	InterpolateFilter u2  ( 
		.rst (rst),
		.clk (clk),
		.din (dit),
		.uk (uk),
		.dout (yik));
 
	wire signed [17:0] yqk;
	InterpolateFilter u3  ( 
		.rst (rst),
		.clk (clk),
		.din (dqt),
		.uk (uk),
		.dout (yqk));
 
   
	//定时误差检测及环路滤波器模块
	ErrorLp u4  ( 
		.rst (rst),
		.clk (clk),
		.strobe (strobe),
		.yik (yik),
		.yqk (yqk),
		.yi (yi),
		.yq (yq),
		.sync (sync),
		.er (e),
		.wk (wk));
    	
   assign u = uk;
   assign w = wk;
	
endmodule
