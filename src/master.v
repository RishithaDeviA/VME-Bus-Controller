`timescale 1ns / 1ps

module master (
    input clk,
    input rst,
    input [1:0] master_id,
    input [31:0] address,
    output reg [31:0] data_out, // Data to be sent to slave
    input [31:0] data_in,       // Data received from slave
    output reg as_n,
    output reg ds0_n,
    output reg ds1_n,
    input write_n,
    input dtack_n,
    output reg berr_n
);

    reg [31:0] memory [0:1023]; // Master memory
    integer file, i;
              initial      begin
       case (master_id)
            2'b00: $readmemh("master0_memory_init.mem", memory);
            2'b01: $readmemh("master1_memory_init.mem", memory);
            2'b10: $readmemh("master2_memory_init.mem", memory);
            2'b11: $readmemh("master3_memory_init.mem", memory);
           endcase
      end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            as_n <= 1;
            ds0_n <= 1;
            ds1_n <= 1;
            berr_n <= 0;
            data_out <= 32'b0;


           
        end else begin
   
                if (~write_n) begin  // Write Operation
                    // Send data from master memory to slave
                    
                      begin
          case (master_id)
            2'b00: $readmemh("master0_memory_init.mem", memory);
            2'b01: $readmemh("master1_memory_init.mem", memory);
            2'b10: $readmemh("master2_memory_init.mem", memory);
            2'b11: $readmemh("master3_memory_init.mem", memory);
           endcase
      end
                    data_out <= memory[address];
                    as_n <= 1;
                    ds0_n <= 0;
                    ds1_n <= 0;
                    berr_n <= 0;
                   $display("%d",data_out);
                      // Debug: Print memory contents after initialization
       for (i = 0; i < 10; i = i + 1) begin
            $display("[DEBUG] Master %b: memory[%h] = %h", master_id, i, memory[i]);
        end
                     
                   end
                    
                   // read
         if (write_n ) begin
                     
                    begin
          case (master_id)
            2'b00: $readmemh("master0_memory_init.mem", memory);
            2'b01: $readmemh("master1_memory_init.mem", memory);
            2'b10: $readmemh("master2_memory_init.mem", memory);
            2'b11: $readmemh("master3_memory_init.mem", memory);
           endcase
      end
                
                case (master_id)
        2'b00: file = $fopen("master0_memory_init.mem", "w");
        2'b01: file = $fopen("master1_memory_init.mem", "w");
        2'b10: file = $fopen("master2_memory_init.mem", "w");
        2'b11: file = $fopen("master3_memory_init.mem", "w");
               endcase
            $display("[DEBUG] Checking memory at address-before %h of master: %h", address, memory[address]);
            memory[address] = data_in;  
            $display("[DEBUG] Checking memory at address-after %h of master: %h", address, memory[address]);
   if (file) begin
                for (i = 0; i < 1024; i = i + 1)  
                         $fwrite(file, "%h\n", memory[i]);  
 
    $fclose(file);
    end
end
                      as_n <= 0;
                      ds0_n <= 1;
                      ds1_n <= 1;
                      #5as_n <= 1;
                      ds0_n <= 0;
                      ds1_n <= 0;
 end 
 end 

    endmodule
