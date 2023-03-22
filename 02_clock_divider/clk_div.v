/*
    Writer: namu00
    Github: https://github.com/namu00/most_used_modules
*/

module clk_div #(
    parameter DIV_BY = 10
)(
    input clk,
    input n_rst,
    output div_clk
);
    localparam SIZE = $clog2(DIV_BY);

    reg [SIZE -1:0] clk_cnt; //just binary counter

    assign div_clk = clk_cnt[SIZE -1];
    always @(posedge clk or negedge n_rst)begin
        if(!n_rst) begin
            clk_cnt <= {SIZE{1'b0}};
        end

        else begin
            clk_cnt <= clk_cnt + {{{SIZE-1}{1'b0}},1'b1};
        end
    end
endmodule