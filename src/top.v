//! @title ALU top level
//! @file top.v
//! @author Felipe Montero Bruni
//! @date 09-2023
//! @version 0.1

module top
#(
    parameter NB_LEDS = 16,
    parameter NB_SW   = 16,

    // ALU parameters
    parameter NB_REG = 16,             //! NB of inputs and output
    parameter NB_OP  = 6               //! NB of operation input
)
(
    output [NB_LEDS - 1 : 0] o_led  ,  //! Basys 3 leds
    input  [NB_SW   - 1 : 0] i_sw   ,  //! Basys 3 sw
    input                    i_btn_1,
    input                    i_btn_2,
    input                    i_btn_3,
    input                    i_rst  ,
    input                    clk
);

    reg [NB_SW - 1 : 0] reg_a;
    reg [NB_SW - 1 : 0] reg_b;
    reg [NB_OP - 1 : 0] reg_op;

    always @(posedge clk) begin
        if (i_rst) begin
            reg_a  <= {NB_SW{1'b0}};
            reg_b  <= {NB_SW{1'b0}};
            reg_op <= {NB_SW{1'b0}};
        end
        else begin
            if (i_btn_1) begin
                reg_a <= i_sw;
            end
            if (i_btn_2) begin
                reg_b <= i_sw;
            end
            if (i_btn_3) begin
                reg_op <= i_sw[NB_OP - 1 : 0];
            end
        end
    end

    alu
    #(
        .NB_REG (NB_REG),              //! NB of inputs and output
        .NB_OP  (NB_OP )               //! NB of operation input
    )
        u_alu
        (
            .o_out (o_led ),
            .i_a   (reg_a ),
            .i_b   (reg_b ),
            .i_op  (reg_op)
        );
    
endmodule