/*
    Writer: namu00
    Github: https://github.com/namu00/most_used_modules
    Description: Pushbutton Debouncer

    *Notion*
    __OUTPUT( "rectified_out" ) IS ACTIVE HIGH__
*/
module debouncer#(
  parameter CLK_PERIOD_NS = 20,   // 20ns period
  parameter BOUNCE_TIME_MS = 20   // 20ms bouncing
)(
  input clk,
  input n_rst,

  input active_low,    //active-low flag
  input button_in,     //push button input
  output button_out    //rectified output
);

  /*parameter define*/
  //for implementing
  localparam TIME_SCALE = 1_000_000; //1ns

  //for fast simulation
  //localparam TIME_SCALE = CLK_PERIOD_NS;
  localparam CNT_MAX = (BOUNCE_TIME_MS * TIME_SCALE) / CLK_PERIOD_NS;
  localparam CNT_WIDTH = $clog2(CNT_MAX);

  /*state define*/
  localparam RELEASED = 0;
  localparam PUSH_WAIT = 1;
  localparam PUSHED = 2;
  localparam RELEASE_WAIT = 3;

  /*reg & wire define*/
  reg [CNT_WIDTH-1:0] clk_cnt;
  reg rect_out;

  reg [1:0] c_state, n_state;

  wire btn;
  wire cnt_max;
  wire cnt_busy;

  /*flag assignment*/
  assign btn = (active_low) ? !(button_in) : (button_in); //make "btn" act like active-high
  assign cnt_max = (clk_cnt == (CNT_MAX-1)) ? 1'b1 : 1'b0;
  assign cnt_busy = ((c_state == PUSH_WAIT) || (c_state == RELEASE_WAIT));

  /*output assignment*/
  assign button_out = rect_out;

  /*clock counter logic*/
  always @(posedge clk or negedge n_rst)begin
    if(!n_rst)        clk_cnt <= 0;
    else if(cnt_busy) clk_cnt <= clk_cnt + {{{CNT_WIDTH-1}{1'b0}},1'b1};
    else              clk_cnt <= 0;  
  end

  /*current state assigner*/
  always @(posedge clk or negedge n_rst)begin
    if(!n_rst)  c_state <= RELEASED;
    else        c_state <= n_state;
  end

  /*next state assigner*/
  always @(*)begin
    case(c_state)
      RELEASED:     n_state = (btn) ? PUSH_WAIT : c_state;
      PUSH_WAIT:    n_state = (cnt_max) ? PUSHED : c_state;
      PUSHED:       n_state = !(btn) ? RELEASE_WAIT : c_state;
      RELEASE_WAIT: n_state = (cnt_max) ? RELEASED : c_state;
      default:      n_state = RELEASED;
    endcase
  end

  /*state output assigner*/
  always @(*)begin
    case(c_state)
      PUSHED:     rect_out = 1'b1;
      PUSH_WAIT:  rect_out = 1'b1;
      default:    rect_out = 1'b0;
    endcase
  end
endmodule
