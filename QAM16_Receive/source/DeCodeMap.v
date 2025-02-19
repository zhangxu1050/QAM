//这是DeCodeMap.v文件的程序清单
module DeCodeMap (
	rst,clk,I,Q,bitsync,
	dout);
	
	input		rst;           //复位信号，高电平有效
	input		clk;           //FPGA系统时钟
	input		bitsync;			//定时脉冲
	input  [2:0]   I;       //星座映射的I支路数据
	input  [2:0]   Q;       //星座映射的Q支路数据
	output [3:0]	dout;    //解调后的原始数据


	 //星座逆映射
	 reg [3:0] code;
	 always @(posedge clk or posedge rst)
	    if (rst)
			begin
				code <= 4'd0;
			end
		else
			case({Q,I})
             6'b011_011: code<=4'b0000;
             6'b001_011: code<=4'b0001;
             6'b011_001: code<=4'b0010;
             6'b001_001: code<=4'b0011;
             6'b101_011: code<=4'b0100;
             6'b101_001: code<=4'b0101;
             6'b111_011: code<=4'b0110;
             6'b111_001: code<=4'b0111;
             6'b011_101: code<=4'b1000;
             6'b011_111: code<=4'b1001;
             6'b001_101: code<=4'b1010;
             6'b001_111: code<=4'b1011;
             6'b101_101: code<=4'b1100;
             6'b111_101: code<=4'b1101;
             6'b101_111: code<=4'b1110;
             6'b111_111: code<=4'b1111;
             default: code<=4'b0000;
          endcase           

	 //差分解码
	 wire c,d;
	 reg d3,d2;
	 reg [3:0] dt;
	 always @(posedge clk or posedge rst)
		if (rst)
			begin
				d3 <= 1'b0;
				d2 <= 1'b0;
				dt <= 4'd0;
			end else if(bitsync)  begin
				d3 <= code[3];
				d2 <= code[2];
				//完成差分解码后，组成新的4bit数据，还原调制数据
				dt <= {c,d,code[1:0]};
			end
	 assign dout = dt;
	 
	 wire d3xord2,d3xordc,d3xordd;
	 assign d3xord2 = code[3]^code[2];
	 assign d3xordd = code[3]^d2;
	 assign d3xordc = code[3]^d3;
	 assign c = ((!d3xord2) & d3xordd) ^(d3xord2 & d3xordc);
	 
	 wire d2xordc,d2xordd;
	 assign d2xordc = code[2]^d3;
	 assign d2xordd = code[2]^d2;
	 assign d = ((!d3xord2) & d2xordc) ^(d3xord2 & d2xordd);
	 
endmodule
	