import Ehr::*;
import StmtFSM::*;

interface LabCounter;
    method Action inc();
    method Bit#(32) cur();
    method Action set(Bit#(32) newvalue);
endinterface

(* synthesize *)
module mkCounterEhr(LabCounter);
    // TODO

    method Action inc();
        // TODO
        noAction;
    endmethod

    method Bit#(32) cur();
        // TODO
        return 0;
    endmethod

    method Action set(Bit#(32) newvalue);
        //TODO
        noAction;
    endmethod
endmodule




// Reference implementation using only registers.
(* synthesize *)
module mkCounter(LabCounter);
    Reg#(Bit#(32)) cntSt <- mkReg(0); 

    method Action inc();
        cntSt <= cntSt + 1;
    endmethod

    method Bit#(32) cur();
        return cntSt;
    endmethod

    method Action set(Bit#(32) newvalue);
        cntSt <= newvalue;
    endmethod
endmodule

// Testbench (do not modify)
module mkLabCounterTb(Empty);
    LabCounter ehrized <- mkCounterEhr;
    Stmt test =
        (seq 
            action
                $display("Starting with the counter being 0");
                $display("m.inc() and x=m.cur() called in the same cycle:");
                ehrized.inc();
                let x = ehrized.cur();
                if (x != 1) begin 
                    $display("x was expected to be 1, but was %d", x);
                    $finish(1);
                end
            endaction
            action
                $display("Next cycle\nm.inc() and m.set(42) and m.cur() in the same cycle:");
                ehrized.set(42);
                ehrized.inc();
                let x = ehrized.cur();
                if (x != 43) begin 
                    $display("x was expected to be 43, but was %d", x);
                    $finish(1);
                end
            endaction
            action
                $display("Next cycle\nm.cur() called alone");
                let x = ehrized.cur();
                if (x != 43) begin 
                    $display("x was expected to be 43, but was %d", x);
                    $finish(1);
                end
            endaction
            action
                $display("Test passed");
                $finish(0);
            endaction
        endseq);

    FSM test_fsm <- mkFSM(test);

    Reg#(Bool) going <- mkReg(False);

    rule start (!going);
        going <= True;
        test_fsm.start;
    endrule
endmodule