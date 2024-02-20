.DEFAULT_GOAL := all
BUILD_DIR=build
BINARY_NAME=LabCounter CBuffer CBufferEhr
BSC_FLAGS=--aggressive-conditions --show-schedule -vdir $(BUILD_DIR) -bdir $(BUILD_DIR) -simdir $(BUILD_DIR) -o 

.PHONY: clean all submit

all: $(BINARY_NAME)
	./LabCounter 2>&1 | tee output.log

$(BINARY_NAME): LabCounter.bsv
	mkdir -p $(BUILD_DIR)
	bsc $(BSC_FLAGS) $@ -verilog --show-schedule -g mk$@Tb -u $@.bsv
	bsc $(BSC_FLAGS) $@ -sim -g mk$@Tb -u $@.bsv
	bsc $(BSC_FLAGS) $@ -sim -e mk$@Tb reorderer.c

clean:
	rm -rf $(BUILD_DIR)
	rm -f $(BINARY_NAME)
	rm -f *.so
	rm -f *.o
	rm -f *.sched

submit: all
	git add -A
	git commit -am "Save Changes & Submit"
	git push

