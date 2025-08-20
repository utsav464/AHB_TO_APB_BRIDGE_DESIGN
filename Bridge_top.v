`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.08.2025 20:14:25
// Design Name: 
// Module Name: BRIDGE_TOP
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


module Bridge_top(input Hclk,Hresetn,Hwrite,Hreadyin,
                  input [31:0] Hwdata, Haddr,Prdata,
                  input [1:0] Htrans,
                  output Pwrite,Penable,Hreadyout,
                  output [2:0] Pselx,
                  output [31:0] Paddr,Pwdata,Hrdata,
                  output [1:0] Hresp
                   );
                  
                  
                  wire valid;
                  wire [31:0] Hwdata1,Hwdata2,Haddr1,Haddr2;
                  wire [2:0]tempselx;
                  wire Hwritereg,Hwritereg1;
          
AHB_SLAVE  ahb_slaves( 
                         .Hresetn(Hresetn),
                         .Hclk(Hclk),
                         .Hwrite(Hwrite),
                         .Hreadyin(Hreadyin),
                         .Htrans(Htrans),
                         .Hwdata(Hwdata),
                         .Haddr(Haddr),
                         .Prdata(Prdata),
                         .Haddr1(Haddr1),
                         .Haddr2(Haddr2),
                         .Hwdata1(Hwdata1),
                         .Hwdata2(Hwdata2),
                         .Hrdata(Hrdata),
                         .Hwritereg(Hwritereg),
                         .Hwritereg1(Hwritereg1),
                         .tempselx(tempselx),
                         .Hresp(Hresp),
                         .valid(valid)
                         );       
                  
APB_CONTROLLER apb_c( 
               .Hclk(Hclk),
               .Hresetn(Hresetn),
               .Hwrite(Hwrite),
               .valid(valid),
               .Hwritereg(Hwritereg),
               .Haddr(Haddr),
               .Hwdata(Hwdata),
               .Haddr1(Haddr1),
               .Haddr2(Haddr2),
               .Hwdata1(Hwdata1),
               .Hwdata2(Hwdata2),
               .tempselx(tempselx),
               .Pwrite(Pwrite),
               .Penable(Penable),
               .Paddr(Paddr),
               .Pwdata(Pwdata),
               .Pselx(Pselx),
               .Hreadyout(Hreadyout)
                );                  

  

                  
endmodule

