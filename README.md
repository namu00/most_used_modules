# most used verilog modules

### Replication Operator Usage:
```verilog
    parameter WIDTH = 4;

    reg [WIDTH-1:0] counter;
    wire full;

    //When counter == 4'b1111, 'full' goes HIGH
    assign full = (counter == {N{1'b1}}) ? 1'b1 : 1'b0;

    always @(posedge clk)begin
        //counter <= 4'b0000;
        if(!n_rst)  counter <= {WIDTH{1'b0}};

        //counter <= counter + 4'b0001;
        else        counter <= counter + {(N-1){1'b0},1'b1};
    end
```
