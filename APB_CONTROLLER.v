`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.08.2025 20:17:29
// Design Name: 
// Module Name: APB_CONTROLLER
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


module APB_CONTROLLER( Hclk,Hresetn,Hwrite,valid,Hwritereg,Haddr,Hwdata,Haddr1,Haddr2,Hwdata1,Hwdata2,tempselx,Pwrite,Penable,Paddr,Pwdata,Pselx,Hreadyout);
input Hclk,Hresetn,Hwrite,valid,Hwritereg;
input [31:0] Haddr,Hwdata,Haddr1,Haddr2,Hwdata1,Hwdata2;
input [2:0] tempselx;
output reg Pwrite,Penable;
output reg [31:0]Paddr,Pwdata;
output reg [2:0]Pselx;
output reg Hreadyout;

reg penable_temp,pwrite_temp, hr_readyout_temp;
reg [2:0] psel_temp;
reg [31:0]paddr_temp,pwdata_temp;

parameter st_idle      = 3'b000,
          st_wait      = 3'b001,
          st_write     = 3'b010,
          st_writep    = 3'b011,
          st_wenablep  = 3'b100,
          st_wenable   = 3'b101,
          st_read      = 3'b110,
          st_renable   = 3'b111;
          
reg [2:0] state,next_state;



always@(posedge Hclk)
    begin
        if(!Hresetn)
            state<=st_idle;
        else
            state<=next_state;
    end
    
    
    
always@(*)            
    begin
        case(state)
            st_idle      : begin 
                              if(valid==1'b1 && Hwrite==1'b1)
                                next_state = st_wait;
                              else if(valid==1'b1 && Hwrite==1'b0)
                                next_state = st_read;
                              else
                                next_state = st_idle;
                          end
             
            st_wait     : begin
                            if(valid==1'b1)                         
                                next_state = st_writep;
                            else
                                next_state = st_write;
                          end
           
           
           st_writep   : begin
                            next_state = st_wenablep;
                         end                   
                                    
           st_write    : begin
                            if(valid== 1'b1)
                                next_state = st_wenablep;
                            else
                                next_state = st_wenable;
                         end
                         
                         
 
                         
           st_renable   : begin                                            
                            if((valid == 1'b1) && (Hwrite == 1'b0))         
                                next_state = st_read;                       
                            else if (valid == 1'b1)                         
                                next_state = st_idle;                       
                            else if ((valid == 1'b1) && (Hwrite == 1'b1))   
                                 next_state = st_wait;                      
                            else                                            
                                 next_state = st_renable;                   
                                                                            
                          end                                               
                                                                                         
                         
           st_read   : begin                         
                         next_state = st_renable;   
                       end                                          
                         
           
              
              
              st_wenablep : begin                                                    
                               if((valid==1'b1) && (Hwritereg == 1'b1))              
                                   next_state =st_writep;                            
                               else if((valid==1'b0) && (Hwritereg == 1'b1))         
                                   next_state = st_write;                            
                               else if (Hwritereg==1'b0)                             
                                   next_state = st_read;
                               else
                                   next_state = st_wenablep;     
                           end
                                                                                    
                                 
                        
          st_wenable  : begin
                            if(valid==1'b0)
                                next_state = st_idle;
                            else if((valid ==1'b1) && (Hwrite == 1'b1))
                                next_state = st_wait;
                            else if((valid ==1'b1) && (Hwrite == 1'b0))                                                                                 
                                next_state =st_read;
                            else
                                next_state = st_wenable;
                                    
                       end
         default : next_state = st_idle;
         endcase
         
     end
     
     
     
     always@(*)
        begin 
         paddr_temp       = 32'b0;
         pwdata_temp      = 32'b0;
         pwrite_temp      = 1'b0;
         psel_temp        = 3'b000;
         penable_temp     = 1'b0;
         hr_readyout_temp = 1'b1;
        

           case(state)
                st_idle: if(valid && Hwrite==0)
                            begin
                                paddr_temp       = Haddr;
                                pwrite_temp      = Hwrite;
                                psel_temp        = tempselx;
                                penable_temp     = 0;
                                hr_readyout_temp = 0;
                            end
                            
                         else if (valid==1'b1 && Hwrite==1'b1)
                            begin
                                psel_temp        = 0;
                                penable_temp     = 0;
                                hr_readyout_temp = 1;
                            end
                            
                            
                        else
                             begin
                                psel_temp        = 0;
                                penable_temp     = 0;
                                hr_readyout_temp = 1;
                            end
                                   
               st_read: 
                            begin
                                penable_temp     = 1;
                                hr_readyout_temp = 1;
                            end
                            
               st_renable : if(valid==1'b1 && Hwrite==0)
                                begin
                                    paddr_temp       = Haddr;
                                    pwrite_temp      = Hwrite;
                                    psel_temp        = tempselx;
                                    penable_temp     = 0;
                                    hr_readyout_temp = 0;
                                end
                                
                            else if (valid==1'b1 && Hwrite==1'b1)
                                 begin
                                    psel_temp        = 0;
                                    penable_temp     = 0;
                                    hr_readyout_temp = 1;
                                 end
                                                                     
                           else 
                             begin
                                    psel_temp        = 0;
                                    penable_temp     = 0;
                                    hr_readyout_temp = 1;
                                 end
              
               st_wait : if(valid)
                            begin
                                paddr_temp       = Haddr1;
                                pwrite_temp      = Hwrite;
                                pwdata_temp      = Hwdata;
                                psel_temp        = tempselx;
                                penable_temp     = 0;
                                hr_readyout_temp = 1'b0;
                           end
                           
                        else 
                            begin
                                  paddr_temp       = Haddr;
                                  pwrite_temp      = Hwrite;
                                  pwdata_temp      = Hwdata;
                                  hr_readyout_temp = 1'b0;        
                                
                           end
                           
               st_write:
                          begin
                              penable_temp     = 1;
                              hr_readyout_temp = 1;
                          end
                          
              st_wenable:
                            if(valid==1'b1 && Hwrite==1'b0)
                                begin
                                 psel_temp        = 0;
                                 penable_temp     = 0;
                                 hr_readyout_temp = 1;
                                end
                                
                            else if(valid==1'b1 && Hwrite==1'b1)
                                begin
                                     paddr_temp       = Haddr1;
                                     pwrite_temp      = Hwritereg ;
                                     psel_temp        = tempselx;
                                     penable_temp     = 0;
                                     hr_readyout_temp = 0;
                                end
                                
                           else
                                begin                           
                                    psel_temp        = 0;
                                    penable_temp     = 0;
                                    hr_readyout_temp = 1;          
                          
                                end
                                
                                
              st_writep : begin
                            hr_readyout_temp = 1;
                            penable_temp     = 1;
                          end
                          
             st_wenablep: begin
                            paddr_temp      = Haddr1;
                            pwdata_temp     = Hwdata;
                            pwrite_temp     = Hwrite;
                            psel_temp       = tempselx;
                            penable_temp    = 0;
                            hr_readyout_temp= 0;
                         end
                         
                                             
              
            endcase
         end
         
         
         always@(posedge Hclk)
            begin
                if (!Hresetn)
                    begin
                        Paddr     <=0;
                        Pwdata    <=0;
                        Pwrite    <=0;
                        Penable   <=0;
                        Pselx     <=0;
                        Hreadyout <=0;
                    end
               else
                begin
                       Paddr     <= paddr_temp;        
                       Pwdata    <= pwdata_temp;     
                       Pwrite    <= pwrite_temp;     
                       Penable   <= penable_temp;   
                       Pselx     <= psel_temp;    
                       Hreadyout <= hr_readyout_temp; 
                       
                end
              end
              
              
endmodule  