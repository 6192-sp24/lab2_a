import Ehr::*;
import StmtFSM::*;

// Time Spent:

interface StepCounter;
    method Action inc();
    method Bit#(32) cur();
    method Action set(Bit#(32) newVal);
endinterface

(* synthesize *)
module mkCounterEhr(StepCounter);
    // TODO

    method Action inc();
        // TODO (remove noAction)
        noAction;
    endmethod

    method Bit#(32) cur();
        // TODO 
        return 0;
    endmethod

    method Action set(Bit#(32) newVal);
        //TODO (remove noAction)
        noAction;
    endmethod
endmodule




// Reference implementation using only simple registers.
(* synthesize *)
module mkCounter(StepCounter);
    Reg#(Bit#(32)) curVal <- mkReg(0); 

    method Action inc();
        curVal <= curVal + 1;
    endmethod

    method Bit#(32) cur();
        return curVal;
    endmethod

    method Action set(Bit#(32) newVal);
        curVal <= newVal;
    endmethod
endmodule

// Testbench (do not modify)
module mkStepCounterTb(Empty);
    StepCounter ehrized <- mkCounterEhr;
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
