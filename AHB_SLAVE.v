`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.08.2025 20:16:23
// Design Name: 
// Module Name: AHB_SLAVE
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


module AHB_SLAVE( Hresetn,Hclk,Hwrite,Hreadyin,Htrans,Hwdata,Haddr,Prdata,Haddr1,Haddr2,Hwdata1,Hwdata2,Hrdata,Hwritereg,Hwritereg1,tempselx,Hresp,valid);
input Hresetn,Hclk,Hwrite,Hreadyin;
input[1:0]Htrans;
input [31:0]Hwdata,Haddr,Prdata;
output reg [31:0] Haddr1,Haddr2,Hwdata1,Hwdata2;
output reg Hwritereg ,Hwritereg1,valid;
output reg [2:0]tempselx;
output  [1:0]Hresp;
output[31:0]Hrdata;



always@(posedge Hclk)
      begin
          if(Hresetn==1'b0)
            begin
              Haddr1<=0;
              Haddr2<=0;
            end        
          
          else
             begin
                  Haddr1<=Haddr;
                  Haddr2<=Haddr1;
             end        
      end
      
      
      
      
always@(posedge Hclk)
     begin 
         if(Hresetn==1'b1)
            begin
              Hwdata1<=0;
              Hwdata2<=0;
            end   
            
         else
          begin
               Hwdata1<=Hwdata;
               Hwdata2<=Hwdata1;
          end             
     end
     
     
     
always@(posedge Hclk)
     begin
         if(Hresetn==1'b0)      
            begin                 
              Hwritereg<=0;        
              Hwritereg1<=0;        
            end                                                     
         else                    
          begin                  
               Hwritereg<=Hwrite; 
               Hwritereg1<=Hwritereg; 
          end   
     end
     
 
 
 
 always@(*)
      begin
      
        if((Haddr>=32'h8000_0000) && (Haddr<32'h8400_0000))
             tempselx<=3'b001;
        else if((Haddr>=32'h8400_0000) && (Haddr<32'h8800_0000))
             tempselx<=3'b010;
                  
        else if((Haddr>=32'h8800_0000)&& (Haddr<32'h8c00_0000))
             tempselx<=3'b100;                              
        else
             tempselx<=3'b000;
             
      end
 
 
 
 always@(*)
     begin
        if((Haddr>=32'h8000_0000 && Haddr<32'h8c00_0000)&& (Hreadyin==1'b1) && (Htrans==2'b10 || Htrans==2'b11))  
              valid=1'b1;
        else
              valid=1'b0;
     end
     
     
 assign Hresp = 2'd0;
 assign Hrdata= Prdata;
                    
                                   

endmodule