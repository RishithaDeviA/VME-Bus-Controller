`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.01.2025 15:58:41
// Design Name: 
// Module Name: vme_arb
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


module arbiter (
  input wire clk, rst,
  input wire [3:0] BusReq,  // BusReq as an array [BusReq3, BusReq2, BusReq1, BusReq0]
  input wire [1:0] Mode,    // Mode selector: 00 = Single Priority, 01 = Prioritized Mode, 10 = Round Robin
  output reg [3:0] BusGrant, // BusGrant as an array [BusGrant3, BusGrant2, BusGrant1, BusGrant0]
  output reg BusBusy        // Bus is busy when 1
);

  // Internal register to track Round Robin state and previous mode
  reg [1:0] priority;
  reg [1:0] prevMode;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      BusGrant <= BusReq;  // Reset all bus grants
      priority <= 2'b11;    // Start Round Robin from BusReq[0]
      BusBusy  <= 1'b0;     // Bus is free initially
      prevMode <= 2'b00;    // Initialize previous mode
    end else begin
      if (Mode != prevMode) begin
        // Reset BusGrant and BusBusy when Mode changes
        BusGrant <= 4'b0000;
        BusBusy  <= 1'b0;
        prevMode <= Mode;  // Update the mode tracker
      end 
         case (Mode)
          2'b00: begin  // Single Priority Mode
            if (BusReq[3]) begin
              BusGrant <= 4'b1000;
              BusBusy  <= 1'b1;
            end else begin
              BusGrant <= 4'b0000;
              BusBusy  <= 1'b0;  // Ensure BusBusy is 0 when no request is granted
            end
          end

          2'b01: begin  // Prioritized Daisy Chain Mode
            if (BusReq[3]) begin
              BusGrant <= 4'b1000;
            end else if (BusReq[2]) begin
              BusGrant <= 4'b0100;
            end else if (BusReq[1]) begin
              BusGrant <= 4'b0010;
            end else if (BusReq[0]) begin
              BusGrant <= 4'b0001;
            end else begin
              BusGrant <= 4'b0000;
            end
            BusBusy <= |BusGrant;  // Bus is busy if any grant is given
          end

          2'b10: begin  // Round Robin Mode
            case (priority)
              2'b00: begin
                if (BusReq[0]) begin
                  BusGrant <= 4'b0001;
                  priority <= 2'b11;
                end else if (BusReq[1] || BusReq[2] || BusReq[3]) begin
                  priority <= 2'b11;
                end
              end
              2'b01: begin
                if (BusReq[1]) begin
                  BusGrant <= 4'b0010;
                  priority <= 2'b00;
                end else if (BusReq[2] || BusReq[3] || BusReq[0]) begin
                  priority <= 2'b00;
                end
              end
              2'b10: begin
                if (BusReq[2]) begin
                  BusGrant <= 4'b0100;
                  priority <= 2'b01;
                end else if (BusReq[3] || BusReq[0] || BusReq[1]) begin
                  priority <= 2'b01;
                end
              end
              2'b11: begin
                if (BusReq[3]) begin
                  BusGrant <= 4'b1000;
                  priority <= 2'b10;
                end else if (BusReq[0] || BusReq[1] || BusReq[2]) begin
                  priority <= 2'b10;
                end
              end
            endcase
            BusBusy <= |BusGrant;  // Bus is busy if any grant is given
          end

          default: begin
            BusGrant <= 4'b0000;
            BusBusy  <= 1'b0;
          end
        endcase
      end
    end
endmodule
