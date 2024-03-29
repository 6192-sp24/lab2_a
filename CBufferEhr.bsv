import Ehr::*;
import StmtFSM::*;
import Vector::*;
import FIFO::*;

typedef Bit#(3) Token;
typedef Bit#(32) Response;

// Time Spent:

interface CBuffer;
    method ActionValue#(Token) getToken();
    method Action put(Token t, Response r);
    method ActionValue#(Response) getResponse();
endinterface

(* synthesize *)
module mkCBufferEhr(CBuffer);
    // TODO
    method ActionValue#(Token) getToken();
        // TODO
        noAction;
        return 3;
    endmethod

    method Action put(Token t, Response r);
        // TODO
        noAction;
    endmethod

    method ActionValue#(Response) getResponse();
        // TODO
        noAction;
        return 0;
    endmethod
endmodule

/////// Testing infrastructure below
module mkCBufferEhrTb(Empty);
    CBuffer dut1 <- mkCBufferEhr;
    FIFO#(Token) tok <- mkSizedFIFO(8);
    Reg#(Bit#(32)) req <- mkReg(18);
    Reg#(Bit#(32)) resp <- mkReg(18);
    Reg#(Bit#(32)) tic <- mkReg(0);

    rule do_tic;
        if (tic == 0)
            $display("Start testing the register-based CBuffer");
        $display("Cycle %d", tic);
        tic <= tic + 1;
        if (tic == 100)
            $finish(1);
    endrule

    rule emit_request if (req > 0); 
        let x <- dut1.getToken();
        req <= req - 1;
        $display("Emit request with token: %d", x);
        tok.enq(x);
        emitRequest(x);
    endrule  

    rule emit_response if (tic > 4); 
        let y <- response();
        if ( y != -1) begin 
            Bit#(3) ty = truncate(y);
            $display("Completion buffer received response corresponding to token: %d", ty);
            dut1.put(ty, y);
        end
    endrule

    rule get_resp;
        let x <- dut1.getResponse();
        let y = tok.first();
        tok.deq();
        if (truncate(x) != y) begin 
            $display("The completion buffer produced a result that did not respect FIFO: it produced the result for token %d while the next expected in FIFO order was %d", x, y);
            $finish(1);
        end else begin 
            $display("The completion buffer CORRECTLY produced the result %d, which was the one expected in FIFO order.", x);
        end
        resp <= resp - 1;
        if (resp == 1) begin
                $display("CBufferEhrTest passed in %d cycles",tic);
                $finish(0);
        end
    endrule
endmodule

import "BDPI" function Action emitRequest(Bit#(3) x);
import "BDPI" function ActionValue#(Bit#(32)) response();
