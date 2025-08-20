`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.08.2025 12:57:24
// Design Name: 
// Module Name: top_tb
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


module top_tb();
reg Hclk,Hresetn;
wire [31:0] Haddr,Hwdata,Hrdata,Paddr,Pwdata,Pwdata_out,Paddr_out,Prdata;
wire [1:0] Hresp,Htrans;
wire [2:0] Psel_out,Pselx ;
wire Hreadyout, Hwrite, Hreadyin, Penable,Pwrite_out,Penable_out;



AHB_Master ahb (
                .Hclk(Hclk),
                .Hresetn(Hresetn),
                .Hreadyout(Hresdfyout),
                .Hrdata(Hrdata),
                .Haddr(Haddr),
                .Hwdata(Hwdata),
                .Hwrite(Hwrite),
                .Hreadyin(Hreadyin),
                .Htrans(Htrans)
                 );
                 
APB_Interface apb (
                  .Pwrite(Pwrite),
                  .Penable(Penable),
                  .Pselx(Pselx),
                  .Paddr(Paddr),
                  .Pwdata(Pwdata),
                  .Pwrite_out(Pwrite_out),
                  .Penable_out(Penable_out),
                  .Psel_out(Psel_out),
                  .Paddr_out(Paddr_out),
                  .Pwdata_out(Pwdata_out),
                  .Prdata(Prdata)
                   );
Bridge_top bridge(
                 .Hclk(Hclk),
                 .Hresetn(Hresetn),
                 .Hwrite(Hwrite),
                 .Hreadyin(Hreadyin),
                 .Hwdata(Hwdata),
                 .Haddr(Haddr),
                 .Prdata(Prdata),
                 .Htrans(Htrans),
                 .Pwrite(Pwrite),
                 .Penable(Penable),
                 .Hreadyout(Hreadyout),
                 .Pselx(Pselx),
                 .Paddr(Paddr),
                 .Pwdata(Pwdata),
                 .Hrdata(Hrdata),
                 .Hresp(Hresp)
                  );
                   
initial 
begin
    Hclk=1'b1;
    forever #10 Hclk=~Hclk;
end

task reset();
begin 
    @(negedge Hclk)
        Hresetn=1'b0;
    @(negedge Hclk)  
        Hresetn=1'b1;
end
endtask     

initial
begin
   reset;
   //ahb.single_write();
   //ahb.burst_write();
   ahb.single_read();
   #200 $finish;
end         
endmodule
