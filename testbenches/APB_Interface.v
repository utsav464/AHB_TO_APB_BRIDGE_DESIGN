`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.08.2025 12:02:41
// Design Name: 
// Module Name: APB_Interface
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module APB_Interface(input Penable,Pwrite,
                     input [2:0] Pselx,
                     input [31:0] Paddr, Pwdata,
                     output Pwrite_out,Penable_out,
                     output [2:0] Psel_out,
                     output [31:0] Paddr_out,Pwdata_out,
                     output reg [31:0] Prdata);
                     
                     
                     
                     assign Pwrite_out= Pwrite;
                     assign Psel_out = Pselx;
                     assign Paddr_out = Paddr;
                     assign Pwdata_out =Pwdata;
                     assign Penable_out = Penable;
                     
                     
                     
                     always@(*)
                     begin  
                        if(!Pwrite && Penable)
                            begin
                                Prdata=8'd25;
                            end
                            
                     end
                                
                      
endmodule
