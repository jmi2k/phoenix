BOARD   = icesugar_pro
PACKAGE = CABGA256
FCLK    = 25000000
SIZE    = 25k
TOP     = SoC
TEST    = SoC
TTY     = /dev/ttyACM0
BAUDS   = 9600

all: $(TOP).bit test/$(TEST).vcd

clean:
	rm -f *.bit *.hex rtl/*.config rtl/*.json test/*.vcd test/*.vvp

serial: 
	picocom -q -b $(BAUDS) $(TTY)

wave: test/$(TEST).vcd
	gtkwave $<

rtl/SoC.v: hello.hex rtl/Uart.v rtl/Vga.v
rtl/Uart.v: rtl/Uart/Tx.v
test/SoC.v: rtl/SoC.v

%.bit: rtl/%.config
	ecppack --input $< --bit $@

%.config: %.json
	nextpnr-ecp5 \
		--json $< \
		--lpf $(BOARD).lpf \
		--package $(PACKAGE) \
		--textcfg $@ \
		--$(SIZE) 

%.json: %.v
	yosys -q -D 'FCLK=$(FCLK)' -p 'read -incdir rtl; synth_ecp5 -json $@' $<

%.vcd: %.vvp
	vvp $<

test/%.vvp: test/%.v
	iverilog -Irtl -D 'DUMP="test/$*.vcd"' -D 'FCLK=$(FCLK)' -o $@ $<

%.hex: %.txt
	printf '\0' | cat $< - | od -v -A n -t x1 > $@

.PHONY: all clean serial wave
