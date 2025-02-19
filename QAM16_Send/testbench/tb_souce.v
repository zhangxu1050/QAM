`timescale 1ns/1ns

module tb_souce();
	
	reg	r_CLK	;
	reg	r_Rst	;
	wire	Bit	;
	
	initial begin
        r_CLK	= 1'b1 ;
        forever begin
            # 20 ;
            r_CLK	<= ~r_CLK ;
        end
    end
	 
	 initial begin
        r_Rst	= 1'b1 	;
        # 37500 			;
		  r_Rst	= 1'b0 	;
    end


	source	source(
					.CLK(r_CLK),
					.Rst(r_Rst),
					.Bit(Bit)
					);

endmodule 