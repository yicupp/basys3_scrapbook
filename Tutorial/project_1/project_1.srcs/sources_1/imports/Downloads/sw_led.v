`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2015 12:33:28 PM
// Design Name: 
// Module Name: sw_led
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


module sw_led(
    // Slide switch inputs
    input [15:0]sw,
    // Led outputs
    output [15:0]led
    );
    
    // Assign each sw to it's respective led
    assign led = sw;
endmodule
