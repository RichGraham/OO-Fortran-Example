VPATH = ./ : src
# Find all source files, create a list of corresponding object files
SRCS=circle.f03
OBJS=$(patsubst %.f03,%.o,$(SRCS))

# Ditto for mods (They will be in both lists)
MODS=$(wildcard mod*.f03)
MOD_OBJS=$(patsubst %.f03,%.o,$(MODS))

# Compiler/Linker settings
FC = gfortran
FCFLAGS =  -O2 -c -cpp -DDEBUG -Wall -DDEBUG -DASSERTS -Wextra -Wconversion  -ffpe-trap=invalid -ffpe-trap=zero,overflow,underflow -fbacktrace -fdump-core -fcheck=bounds -Wno-tabs  #-fmax-errors=5
#FCFLAGS = -O2  -c -cpp    -fcheck=bounds #-fmax-errors=5
FLFLAGS =  -g -Wall -DDEBUG -Wextra -Wconversion  -ffpe-trap=invalid -ffpe-trap=zero,overflow,underflow -fbacktrace -fdump-core -fcheck=bounds  -L/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib #-fmax-errors=5
PROGRAM = circles.out
PRG_OBJ = $(PROGRAM).o

# make without parameters will make first target found.
default : $(PROGRAM)

# Compiler steps for all objects
$(OBJS) : %.o : %.f03
	$(FC) $(FCFLAGS) -o $@ $<

# Linker
$(PROGRAM) : $(OBJS)
	$(FC) $(FLFLAGS) -o $@ $^

# If something doesn't work right, have a 'make debug' to
# show what each variable contains.
debug:
	@echo "SRCS = $(SRCS)"
	@echo "OBJS = $(OBJS)"
	@echo "MODS = $(MODS)"
	@echo "MOD_OBJS = $(MOD_OBJS)"
	@echo "PROGRAM = $(PROGRAM)"
	@echo "PRG_OBJ = $(PRG_OBJ)"

clean:
	rm -rf $(OBJS) $(PROGRAM) $(patsubst %.o,%.mod,$(MOD_OBJS)) *.mod
	$(MAKE) -C src clean
	$(MAKE) -C tests clean

.PHONY: debug default clean

# Dependencies
main.o:  testing_2CO2_Ar.o

# Main program depends on all modules
$(PRG_OBJ) : $(MOD_OBJS)

# Blocks and allocations depends on shared
mod_blocks.o mod_allocations.o : mod_shared.o
