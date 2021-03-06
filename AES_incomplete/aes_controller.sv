module aes_controller( input  logic         clk,
                       input  logic         reset_n,
                       input  logic [127:0] msg_en,
                       input  logic [127:0] key,
                       output logic [127:0] msg_de,
                       input  logic         io_ready,
                       output logic         aes_ready );

    enum logic [1:0] { WAIT, COMPUTE, READY } state, next_state;

    AES aes0(.Ciphertext(msg_en), .Cipherkey(key), .clk, .reset(reset_n), .run(), .Plaintext(msg_de), .ready(aes_ready));

    always_ff @ (posedge clk, negedge reset_n) begin
        if (reset_n == 1'b0)
            state <= WAIT;
        else
            state <= next_state;
    end

    always_comb begin
        next_state = state;
        case (state)
            WAIT: begin
                if (io_ready)
                    next_state = COMPUTE;
            end

            COMPUTE: begin
                next_state = READY;
            end

            READY: begin
                next_state = WAIT;
            end
        endcase
    end

    always_comb begin
        aes_ready = 1'b0;
        case (state)
            WAIT: ;
            COMPUTE: ;
            READY: aes_ready = 1'b1;
        endcase
    end

endmodule