`timescale 1ns / 1ps

module vme_top (
    input clk,
    input rst,
    input [3:0] BusReq,       // Request signals from masters
    input [1:0] Mode,         // Arbiter mode selection
    output [3:0] BusGrant,    // Grant signals to masters
    output BusBusy,           // Indicates if the bus is in use

    // Bus Interface Signals
    input [31:0] address,
    inout [31:0] data_bus,    // Bidirectional data bus
    //output as_n, ds0_n, ds1_n,
    input write_n,
    input dtack_n, 
    output berr_n
);

    // Internal signals for master_id and slave_id
    reg [1:0] master_id;
    reg [1:0] slave_id;

    // Internal signals for data transfer
    wire [31:0] slave_master;  
    wire [31:0] master_slave;   
  
    // Assign master_id based on BusGrant
    always @(*) begin
        case (1'b1)  
            BusGrant[0]: master_id = 2'b00;
            BusGrant[1]: master_id = 2'b01;
            BusGrant[2]: master_id = 2'b10;
            BusGrant[3]: master_id = 2'b11;
           // default: master_id = 2'bxx;
        endcase
    end

    // Assign slave_id based on master_id
    always @(*) begin
        case (master_id)  
            2'b00: slave_id = 2'b00;
            2'b01: slave_id = 2'b01;
            2'b10: slave_id = 2'b10;
            2'b11: slave_id = 2'b11;
            //default: slave_id = 2'bxx;
        endcase
    end

    // Instantiate Arbiter
    arbiter arb_inst (
        .clk(clk),
        .rst(rst),
        .BusReq(BusReq),
        .Mode(Mode),
        .BusGrant(BusGrant),
        .BusBusy(BusBusy)
    );

    // Instantiate Master
    master master_inst (
        .clk(clk),
        .rst(rst),
        .master_id(master_id),
        .address(address),
        .as_n(as_n),
        .ds0_n(ds0_n),
        .ds1_n(ds1_n),
        .write_n(write_n),
        .dtack_n(dtack_n),
        .berr_n(berr_n),
        .data_out(master_slave), // Data from master to slave 
        .data_in(slave_master)    // Data to master from slave
    );

    // Instantiate Slave
    slave slave_inst (
        .clk(clk),
        .rst(rst),
        .address(address),
        .data_bus(data_bus),
        .as_n(as_n),
        .ds0_n(ds0_n),
        .ds1_n(ds1_n),
        .write_n(write_n),
        .dtack_n(dtack_n),
        .berr_n(berr_n),
        .slave_id(slave_id),
        .data_out(slave_master), // Data to master (from slave)
        .data_in(master_slave)  // Data from master (to slave)
    );

endmodule
