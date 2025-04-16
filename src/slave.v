`timescale 1ns / 1ps

module slave (
    input clk,
    input rst,
    input [31:0] address,
    inout [31:0] data_bus,    // Bidirectional data bus
    input [31:0] data_in,     // Input for write operations
    input as_n,
    input ds0_n,
    input ds1_n,
    input write_n,
    input dtack_n,            // dtack_n is an input from master
    output reg berr_n,
    input [1:0] slave_id,
    output reg [31:0] data_out // Data sent to master
);

    reg [31:0] memory [0:1023]; // Slave memory
    integer file, i;
    reg [31:0] data_reg; // Internal register for bus operations
    reg [31:0]read_data;
         initial begin
                  case (slave_id)
            2'b00: $readmemh("slave0_memory_init.mem", memory);
            2'b01: $readmemh("slave1_memory_init.mem", memory);
            2'b10: $readmemh("slave2_memory_init.mem", memory);
            2'b11: $readmemh("slave3_memory_init.mem", memory);
           endcase
         end
            
    // Drive data_bus only during write operation
    assign data_bus = (!write_n) ? data_reg : data_bus;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            berr_n <= 0;
            data_out <= 32'b0;
            data_reg <= 32'b0;
        end 
        else  begin // Address is valid & dtack_n is low
            if (!write_n) begin  // Write Operation
                  // Store data_in into memory
                   begin
                  case (slave_id)
            2'b00: $readmemh("slave0_memory_init.mem", memory);
            2'b01: $readmemh("slave1_memory_init.mem", memory);
            2'b10: $readmemh("slave2_memory_init.mem", memory);
            2'b11: $readmemh("slave3_memory_init.mem", memory);
           endcase
         end
     case (slave_id)
                    2'b00: file = $fopen("slave0_memory_init.mem", "w");
                    2'b01: file = $fopen("slave1_memory_init.mem", "w");
                    2'b10: file = $fopen("slave2_memory_init.mem", "w");
                    2'b11: file = $fopen("slave3_memory_init.mem", "w");
                endcase
                  $display("[DEBUG] Checking memory at address %h for slave: %h", address, memory[address]);
            memory[address] = data_in;  
            $display("[DEBUG] Checking memory at address %h for slave: %h", address, memory[address]);
                if (file) begin
                    for (i = 0; i < 1024; i = i + 1) 
                        $fwrite(file, "%h\n", memory[i]);
                    $fclose(file);
                 end
            begin
                  case (slave_id)
            2'b00: $readmemh("slave0_memory_init.mem", memory);
            2'b01: $readmemh("slave1_memory_init.mem", memory);
            2'b10: $readmemh("slave2_memory_init.mem", memory);
            2'b11: $readmemh("slave3_memory_init.mem", memory);
           endcase
         end
            
            // Store data from bus into memory
                read_data = memory[address]; // Output the stored data
                for (i = 0; i < 10; i = i + 1) begin
            $display("[DEBUG] Slave %b: memory[%h] = %h", slave_id, i, memory[i]);
         //       $display("[DEBUG] Slave %b: Data %h read from bus and stored at address %h", slave_id, data_bus, address);
            end
        
         data_reg = read_data  ;  
           end     
            else begin  // Read Operation
             begin
                  case (slave_id)
            2'b00: $readmemh("slave0_memory_init.mem", memory);
            2'b01: $readmemh("slave1_memory_init.mem", memory);
            2'b10: $readmemh("slave2_memory_init.mem", memory);
            2'b11: $readmemh("slave3_memory_init.mem", memory);
           endcase
         end
            
             case (slave_id)
                    2'b00: file = $fopen("slave0_memory_init.mem", "w");
                    2'b01: file = $fopen("slave1_memory_init.mem", "w");
                    2'b10: file = $fopen("slave2_memory_init.mem", "w");
                    2'b11: file = $fopen("slave3_memory_init.mem", "w");
                endcase
                  $display("[DEBUG] Checking memory at address %h of slave: %h", address, memory[address]);
            memory[address] = data_bus;  
            $display("[DEBUG] Checking memory at address %h of slave: %h", address, memory[address]);
                if (file) begin
                    for (i = 0; i < 1024; i = i + 1) 
                        $fwrite(file, "%h\n", memory[i]);
                    $fclose(file);
                  end
            begin
                  case (slave_id)
            2'b00: $readmemh("slave0_memory_init.mem", memory);
            2'b01: $readmemh("slave1_memory_init.mem", memory);
            2'b10: $readmemh("slave2_memory_init.mem", memory);
            2'b11: $readmemh("slave3_memory_init.mem", memory);
           endcase
         end
            
            // Store data from bus into memory
                read_data = memory[address]; // Output the stored data
                $display("[DEBUG] Slave %b: Data %h read from bus and stored at address %h", slave_id, read_data, address);
            end
              data_out= read_data  ;  

        end
    end

endmodule
