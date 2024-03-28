//该模块的作用是每次输入有效以后进行比对，同时使用状态机控制
module comprision(
    input [24:0]number,right_number,useful_number0,useful_number1;
    input wordin_out_flag;
    input clk,rst;
    output [1:0] result_number;
);

//reg和wire
reg [2:0] state,next_state;



//状态机
always@(posedge clk or negedge rst)
begin if(rst==1'b0) begin state<=3'b000;end
      else begin state<=next_state;end
end

always@(posedge clk or negedge rst)
begin if(rst==1'b0) begin next_state<=3'b000;end
      else if(wordin_out_flag)
            begin case(state)
                    3'b000:begin  if(number==right_number) next_state<=3'b111;
                                  else if (number==useful_number0) next_state<=3'b001;
                                  else next_state<=3'b000;
                    end
                    3'b001:begin  if(number==right_number) next_state<=3'b111;
                                  else if (number==useful_number2) next_state<=3'b011;
                                  else next_state<=3'b001;
                    end
                    3'b111:begin next_state<=3'b111; end
                    default next_state<=3'b000;
            endcase
            end
end

always@(posedge clk or negedge rst)
begin if(rst==1'b0) begin result_number <= 2'b00; end
      else case(state)