`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.08.2025 11:33:55
// Design Name: 
// Module Name: AHB_Master
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


module AHB_Master(input Hclk,Hresetn,Hreadyout,
                  input [31:0] Hrdata,
                  output reg [31:0]Haddr,Hwdata,
                  output reg Hwrite,Hreadyin,
                  output reg [1:0]Htrans );
                  
                  reg [2:0]Hburst;
                  reg [2:0]Hsize;
                  
integer i,j;

task single_write();
    begin
        @(posedge Hclk)
        #1;
        
        begin
            Hwrite = 1;
            Htrans = 2'd2;
            Hsize =0;
            Hburst =0;
            Hreadyin =1;
            Haddr =32'h8000_0001;
        end
        
        @(posedge Hclk)
        #1;
        
        begin
            Htrans = 2'd0;
            Hwdata =8'h80;
        end
    end
endtask


task single_read();
    begin
        @(posedge Hclk)
        #1;
            begin
                Hwrite = 0;
                Htrans = 2'd2;
                Hsize =0;
                Hburst =0;
                Hreadyin =1;
                Haddr =32'h8000_0001;
           end

        @(posedge Hclk)
        #1;
            begin
                Htrans = 2'd0;
            end    
    end 
    
endtask       
        


task burst_write();
    begin
        @(posedge Hclk)
        #1;
            begin
                 Hwrite = 1;
                 Htrans = 2'd2;
                 Hsize =0;
                 Hburst =3'd3;
                 Hreadyin =1;
                 Haddr =32'h8000_0001;        
        
           end
           
           
           @(posedge Hclk)
           #1
            begin
                Haddr = Haddr+1'b1;
                Hwdata ={$random}%256;
                Htrans = 2'd3;
           end
           
           
    for(i=0;i<2;i=i+1)
        begin
            @(posedge Hclk)
            #1;
            Haddr = Haddr+1'b1;
            Hwdata ={$random}%256;
            Htrans = 2'd3;                           
        end
        
        @(posedge Hclk)
        #1;
        begin
         Hwdata ={$random}%256;
         Htrans = 2'd0;     
        end
        
    end     
endtask
                     
                  
                 
endmodule
