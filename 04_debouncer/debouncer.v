/*
    Writer: namu00
    Github: https://github.com/namu00/most_used_modules
    Description: Pushbutton Debouncer

    *Notion*
    __OUTPUT( "rectified_out" ) IS ACTIVE HIGH__
*/
module debouncer(
    parameter WAIT_TIME_NS = 20,            //wait time (ns), default: 20 ns
    parameter CLK_FREQ_MHZ = 50_000_000     //clock frequency (mHz), default: 50 mHz
)(
    input clk,
    input n_rst,
    input active_low,
    input push_button,
    output rectified_out
);
    //parameter define
    localparam CLK_PERIOD = 1_000_000_000 / CLK_FREQ;
    localparam CNT_MAX = CLK_PERIOD * WAIT_TIME_NS;
    localparam CNT_WIDTH = $clog2(CNT_MAX);

    //state define
    localparam RELEASED = 0;
    localparam PUSH_WAIT = 1;
    localparam PUSHED = 2;

    reg [CNT_WIDTH-1 : 0] clk_cnt;  //clock counter
    reg [1:0] c_state, n_state;     //state registers
    reg rect_out;                   //rectified output (registered output)

    wire counter_max;   //counter max flag
    wire cnt_busy;      //counter busy flag
    wire button;        //button signal

    //flag assignment
    assign counter_max = (clk_cnt == (CNT_MAX -1)) ? 1'b1 : 1'b0;
    assign cnt_busy = (c_state == PUSH_WAIT) ? 1'b1 : 1'b0;
    assign button = push_button && ~(active_low);

    //output assignment
    assign rectified_out = rect_out;

    //busy edge detecting logic
    always @(posedge clk or negedge n_rst)begin
        if(!n_rst)  busy_d <= 1'b0;
        else        busy_d <= busy;
    end

    //clock counter logic
    always @(posedge clk or negedge n_rst)begin
        if(!n_rst)              clk_cnt <= {CNT_WIDTH{1'b0}};
        else if(cnt_busy)       clk_cnt <= {(CNT_WIDTH-1){1'b0},1'b1};
        else                    clk_cnt <= {CNT_WIDTH{1'b0}};
    end
    
    //current state assigner
    always @(posedge clk or negedge n_rst)begin
        if(!n_rst)  c_state <= RELEASED;
        else        c_state <= n_state;
    end

    //next state assigner
    always @(*)begin
        case(c_state)
            RELEASED:   n_state = (button) ? PUSH_WAIT : c_state;
            PUSH_WAIT:  n_state = (counter_max) ? PUSHED : c_state;
            PUSHED:     n_state = (!button) ? RELEASED : c_state;
            default:    n_state = RELEASED;
        endcase
    end

    //output assigner
    always @(posedge clk or negedge n_rst)begin
        case(c_state)
            RELEASED:   rect_out <= 1'b0;
            PUSH_WAIT:  rect_out <= 1'b1;
            PUSHED:     rect_out <= 1'b1;
            default:    rect_out <= 1'b0;
        endcase
    end
endmodule
