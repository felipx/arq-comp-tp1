//! @title ALU testbench top level
//! @file top.v
//! @author Felipe Montero Bruni
//! @date 09-2023
//! @version 0.1

`timescale 1ns/100ps

module tb_top ();

    parameter NB_LEDS = 16          ;
    parameter NB_SW   = 16          ;

    // ALU parameters
    parameter NB_REG = 16           ;  //! NB of inputs and output
    parameter NB_OP  = 16           ;  //! NB of operation input

    parameter NB_RANDOM = 32        ;

    wire [NB_LEDS   - 1 : 0] o_led  ;  //! Basys 3 leds
    reg  [NB_SW     - 1 : 0] i_sw   ;  //! Basys 3 sw
    reg                      i_btn_1;
    reg                      i_btn_2;
    reg                      i_btn_3;
    reg                      i_rst  ;
    reg  [NB_RANDOM - 1 : 0] rnd    ;
    reg  [NB_REG    - 1 : 0] reg_a  ;
    reg  [NB_REG    - 1 : 0] reg_b  ;
    reg                      clk    ;

    top
    #(
        .NB_LEDS (NB_LEDS),
        .NB_SW   (NB_SW  ),
        .NB_REG  (NB_REG ),
        .NB_OP   (NB_OP  )
    )
    u_top
    (
        .o_led   (o_led   ),             //! Basys 3 leds
        .i_sw    (i_sw    ),             //! Basys 3 sw
        .i_btn_1 (i_btn_1 ),
        .i_btn_2 (i_btn_2 ),
        .i_btn_3 (i_btn_3 ),
        .i_rst   (i_rst   ),
        .clk     (clk     )
    );

    integer i;

    initial begin
        $display("Starting Testbench");
        clk     = 1'b0                ;
        i_sw    = {NB_SW  {1'b0}}     ;
        i_btn_1 = 1'b0                ;
        i_btn_2 = 1'b0                ;
        i_btn_3 = 1'b0                ;
        i_rst   = 1'b0                ;
        reg_a   = {NB_REG   {1'b0}}   ;
        reg_b   = {NB_REG   {1'b0}}   ;
        rnd     = {NB_RANDOM{1'b0}}   ;

        #10 i_rst = 1'b1              ;
        #10 i_rst = 1'b0              ;

        for (i = 0; i < 1000; i = i + 1) begin
            
            #20 rnd     = $random    ;
            #20 i_sw    = rnd[15 : 0];
                reg_a   = rnd[15 : 0];
            #20 i_btn_1 = 1'b1       ;
            #20 i_btn_1 = 1'b0       ;

            #20 rnd  = $random       ;
            #20 i_sw    = rnd[15 : 0];
                reg_b   = rnd[15 : 0];
            #20 i_btn_2 = 1'b1       ;
            #20 i_btn_2 = 1'b0       ;

            #20 rnd     = $random    ;
            #20 i_sw    = rnd[15 : 0];
            #20 i_btn_3 = 1'b1       ;
            #20 i_btn_3 = 1'b0       ;

            #10

            case (i_sw)
                6'b000000 : begin
                                if (o_led != reg_a << reg_b) begin
                                    $display("SSL Test Failed!");
                                    $finish                     ;
                                end
                            end
                6'b000010 : begin
                                if (o_led != reg_a >> reg_b) begin
                                    $display("SRL Test Failed!");
                                    $finish                     ;
                                end
                            end
                6'b000011 : begin
                                if (o_led != $signed(reg_a) >>> reg_b) begin
                                    $display("SRA Test Failed!");
                                    $finish                     ;
                                end
                            end
                6'b100000 : begin
                                if (o_led != reg_a + reg_b) begin
                                    $display("ADD Test Failed!");
                                    $finish                     ;
                                end
                            end
                6'b100010 : begin
                                if (o_led != reg_a - reg_b) begin
                                    $display("SUB Test Failed!");
                                    $finish                     ;
                                end
                            end
                6'b100100 : begin
                                if (o_led != reg_a & reg_b) begin
                                    $display("AND Test Failed!");
                                    $finish                     ;
                                end
                            end
                6'b100101 : begin
                                if (o_led != reg_a | reg_b) begin
                                    $display("OR Test Failed!");
                                    $finish                     ;
                                end
                            end
                6'b100110 : begin
                                if (o_led != reg_a ^ reg_b) begin
                                    $display("XOR Test Failed!");
                                    $finish                     ;
                                end
                            end
                6'b100111 : begin
                                if (o_led != ~(reg_a | reg_b)) begin
                                    $display("NOR Test Failed!");
                                    $finish                     ;
                                end
                            end
                6'b101010 : begin
                                if (($signed(reg_a) < $signed(reg_b)) & (o_led == 1'b0)) begin
                                    $display("SLT Test Failed!");
                                    $finish                     ;
                                end
                                else if (($signed(reg_a) > $signed(reg_b)) & (o_led == 1'b1)) begin
                                    $display("SLT Test Failed!");
                                    $finish                     ;
                                end
                            end
                6'b101011 : begin
                                if ((reg_a < reg_b) & (o_led == 1'b0)) begin
                                    $display("SLTu Test Failed!");
                                    $finish                      ;
                                end
                                else if ((reg_a > reg_b) & (o_led == 1'b1)) begin
                                    $display("SLTu Test Failed!");
                                    $finish                      ;
                                end
                            end
                default   : begin
                                if (o_led != {NB_REG{1'b0}}) begin
                                    $display("default case Test Failed!");
                                    $finish                     ;
                                end
                            end
            endcase

        end
     
        #20 $display("Testbench finished");
        #20 $finish;
    end

    always #5 clk = ~clk;



endmodule