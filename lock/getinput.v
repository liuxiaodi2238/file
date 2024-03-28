module getinput(
    input clk,
    input rst,
    input [3:0] wordin,
    output number,
    output wordin_out_flag,
);

//reg和wire定义
reg [3:0] wordin_cut0,wordin_cut1;   //用于输入的信号寄存
wire wordin_flag,admit_flag;          //用于计算输入有效和确认的电平
reg  wordin_flag_cut0,wordin_flag_cut1;   //用于输入有效寄存
reg  admit_flag_cut0,admit_flag_cut1;   //用于确认有效寄存
wire wordin_flag_0,admit_flag_0;       //检测后的，只有一个时钟为高的输入有效和确认有效

reg [2:0] state,next_state;   //状态机的状态

reg wordin_out_flag;   //模块向外传递数据有效信号
reg [23:0] numberin;   //

//对输入进行寄存并边沿检测
always@(posedge clk or negedge rst)
begin if(rst==1'b0) begin wordin_cut0 <= 4'b0;
                          wordin_cut1 <= 4'b0; end
      else begin wordin_cut0 <= wordin;
                 wordin_cut1 <= wordin_cut0; end
end

assign wordin_flag = wordin[0] & wordin[1] & wordin[2] & wordin[3];
assign admit_flag = wordin[0] & wordin[1] & wordin[2] & wordin[3];

always@(posedge clk or negedge rst)
begin if(rst==1'b0) begin wordin_flag_cut0 <= 1'b0;
                          wordin_flag_cut1 <= 1'b0; end
      else begin wordin_flag_cut0 <= wordin_flag;
                 wordin_flag_cut0 <= wordin_flag_cut0; end
end

always@(posedge clk or negedge rst)
begin if(rst==1'b0) begin admit_flag_cut0 <= 1'b0;
                          admit_flag_cut1 <= 1'b0; end
      else begin admit_flag_cut0 <= admit_flag;
                 admit_flag_cut0 <= admit_flag_cut0; end
end

assign wordin_flag_0 = (~wordin_flag_cut0) & wordin_flag;
assign admit_flag_0 = (~admit_flag_cut0) & admit_flag;
                                                    //包含一些冗杂，后期删除

//设置状态机   使用三段状态机
always@(posedge clk or negedge rst)
begin if(rst == 1'b0) begin state <= 4'b0000; end
      else begin state <= next_state; end
end

always@(posedge clk or negedge rst)
begin 
    if(rst == 1'b0) begin next_state <= 3'b000; end
    else begin case (state)
                    3'b000: begin if(wordin_flag_0) begin next_state <= 3'b001; end
                                   else if(admit_flag_0) begin next_state <= 3'b000; end
                                   else begin next_state <= 3'b000; end
                             end
                    3'b001: begin if(wordin_flag_0) begin next_state <= 3'b010; end
                                   else if(admit_flag_0) begin next_state <= 3'b000; end
                                   else begin next_state <= 3'b001; end
                             end
                    3'b010: begin if(wordin_flag_0) begin next_state <= 3'b011; end
                                   else if(admit_flag_0) begin next_state <= 3'b000; end
                                   else begin next_state <= 3'b010; end
                             end
                    3'b011: begin if(wordin_flag_0) begin next_state <= 3'b100; end
                                   else if(admit_flag_0) begin next_state <= 3'b000; end
                                   else begin next_state <= 3'b011; end
                             end
                    3'b100: begin if(wordin_flag_0) begin next_state <= 3'b101; end
                                   else if(admit_flag_0) begin next_state <= 3'b000; end
                                   else begin next_state <= 3'b100; end
                             end
                    3'b101: begin if(wordin_flag_0) begin next_state <= 3'b110; end
                                   else if(admit_flag_0) begin next_state <= 3'b000; end
                                   else begin next_state <= 3'b101; end
                             end
                    3'b110: begin if(wordin_flag_0) begin next_state <= 3'b000; end
                                   else if(admit_flag_0) begin next_state <= 3'b000; end
                                   else begin next_state <= 3'b110; end
                             end
                    default begin next_state <= 3'b000; end
               endcase
         end
end

                //输出控制：密码  输出有效标志
always@(posedge clk or negedge rst)
begin if(rst) begin wordin_out_flag <= 1'b0; 
                    numberin <= 24'b0; end
      else begin case(state)
                    3'b000:begin if(wordin_flag_0) begin numberin <= {numberin[19:0],wordin};
                                                         wordin_out_flag <= 1'b0; end
                                 else if(admit_flag_0)begin numberin <= 24'b0;
                                                            wordin_out_flag <= 1'b0; end
                                 else begin numberin <= 24'b0;
                                            wordin_out_flag <= 1'b0; end
                           end
                    3'b001:begin if(wordin_flag_0) begin numberin <= {numberin[19:0],wordin};
                                                         wordin_out_flag <= 1'b0; end
                                 else begin numberin <= numberin;
                                            wordin_out_flag <= 1'b0; end
                           end
                    3'b010:begin if(wordin_flag_0) begin numberin <= {numberin[19:0],wordin};
                                                         wordin_out_flag <= 1'b0; end
                                 else begin numberin <= numberin;
                                            wordin_out_flag <= 1'b0; end
                           end
                    3'b011:begin if(wordin_flag_0) begin numberin <= {numberin[19:0],wordin};
                                                         wordin_out_flag <= 1'b0; end
                                 else begin numberin <= numberin;
                                            wordin_out_flag <= 1'b0; end
                           end
                    3'b100:begin if(wordin_flag_0) begin numberin <= {numberin[19:0],wordin};
                                                         wordin_out_flag <= 1'b0; end
                                 else if(admit_flag_0)begin numberin <= numberin;
                                                            wordin_out_flag <= 1'b1; end                        
                                 else begin numberin <= numberin;
                                            wordin_out_flag <= 1'b0; end
                           end
                    3'b101:begin if(wordin_flag_0) begin numberin <= {numberin[19:0],wordin};
                                                         wordin_out_flag <= 1'b0; end
                                 else if(admit_flag_0)begin numberin <= numberin;
                                                            wordin_out_flag <= 1'b1; end                        
                                 else begin numberin <= numberin;
                                            wordin_out_flag <= 1'b0; end
                           end
                    3'b110:begin if(wordin_flag_0) begin numberin <= {numberin[19:0],wordin};
                                                         wordin_out_flag <= 1'b0; end
                                 else if(admit_flag_0)begin numberin <= numberin;
                                                            wordin_out_flag <= 1'b1; end                        
                                 else begin numberin <= numberin;
                                            wordin_out_flag <= 1'b0; end
                           end
                    default begin numberin <= 24'b0;
                                  wordin_out_flag <= 1'b0; end
      endcase
      end
end

endmodule














