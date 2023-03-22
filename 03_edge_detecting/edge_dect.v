/*
    Writer: namu00
    Github: https://github.com/namu00/most_used_modules
*/
module edge_dect(
    input clk,
    input n_rst,
    input rising_edge, //edge type select
    input sig_in,
    output sig_edge
);
    reg delay;

    assign sig_edge = (rising_edge) ? 
                    (sig_in) && (~delay) :
                    (~sig_in) && (delay);

    always @(posedge clk or negedge n_rst)begin
        if(!n_rst)  delay <= 1'b0;
        else        delay <= sig_in;
    end
endmodule