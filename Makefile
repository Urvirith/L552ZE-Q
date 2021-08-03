# ARM GCC COMPILER CALL
CC		    := arm-none-eabi-gcc		# c compiler
AS			:= arm-none-eabi-as			# assembler
LD 			:= arm-none-eabi-ld 		# linker
OBJ 		:= arm-none-eabi-objcopy	# Object Copy

# -Os				Optimize for Size
# -mcpu=cortex-m4	Compile for the ARM M4 Processor
# mthumb			Target the MTHUMB Instruction Set
CFLAGS	  	:= -Os -mcpu=cortex-m33 -mthumb
ASFLAGS		:= -mcpu=cortex-m33 -mthumb
LDFLAGS 	:= -T 
OBJFLAGS	:= -O binary

SRC_DIR   	:= ./src
HAL_DIR   	:= ./src/hal
I2C_DRI   	:= ./src/driver/i2c
BLD_DIR 	:= ./build
SRC_DIR   	:= ./src
LINK_DIR 	:= ./src/linker
START_DIR	:= ./src/startup
OBJ_DIR		:= ./obj

#ONLY ONE
STARTUP		:= startup_ARMCM33.s

#ONLY ONE
LINKER		:= gcc_arm.ld

#	EXAMPLE OF AUTOMATIC VARIABLES
#	%.o: %.c %.h common.h
#		$(CC) $(CFLAGS) -c $<
#
#	$@ Looks at the target
#	(Target)
#	%.o: 			%.c %.h common.h
#	
#	$< Looks at the first source
#			(First Source)
#	%.o: 	%.c 					%.h common.h
#		$(CC) $(CFLAGS) -c $<
#	$^ Looks at the first source
#			(All Source)
#	%.o: 	%.c %.h common.h
#		$(CC) $(CFLAGS) -c $^

OBJS =	$(OBJ_DIR)/common.o \
			$(OBJ_DIR)/gpio.o \
				$(OBJ_DIR)/rcc.o \
					$(OBJ_DIR)/timer.o \
						$(OBJ_DIR)/usart.o \
							$(OBJ_DIR)/nvic.o \
								$(OBJ_DIR)/main.o

#	EXAMPLE OF AUTOMATIC VARIABLES
#	%.o: %.c %.h common.h
#		$(CC) $(CFLAGS) -c $<
#
#	$@ Looks at the target
#	(Target)
#	%.o: 			%.c %.h common.h
#	
#	$< Looks at the first source
#			(First Source)
#	%.o: 	%.c 					%.h common.h
#		$(CC) $(CFLAGS) -c $<
#	$^ Looks at the first source
#			(All Source)
#	%.o: 	%.c %.h common.h
#		$(CC) $(CFLAGS) -c $^
release: $(BLD_DIR)/main.bin

# Build An ELF 
$(BLD_DIR)/main.bin: $(BLD_DIR)/main.elf
	$(OBJ) $(OBJFLAGS) $^ $@

# Build An ELF 
$(BLD_DIR)/main.elf: $(LINK_DIR)/$(LINKER) $(BLD_DIR)/main.o $(BLD_DIR)/startup.o
	$(LD) -Os -s $(LDFLAGS) $^ -o $@

# Build An Single Object 
$(BLD_DIR)/main.o: $(OBJS)
	$(LD) -r $^ -o $@

# Build Dependances
$(BLD_DIR)/startup.o: $(START_DIR)/$(STARTUP)
	$(AS) $< $(ASFLAGS) -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(SRC_DIR)/%.h
	$(CC) $(CFLAGS) -c  $< -o $@

$(OBJ_DIR)/%.o: $(HAL_DIR)/%.c $(HAL_DIR)/%.h $(HAL_DIR)/common.h
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ_DIR)/*.o
	rm -f $(BLD_DIR)/*.o
	rm -f $(BLD_DIR)/*.elf
	rm -f $(BLD_DIR)/*.bin

flash:
	STM32_Programmer_CLI -c port=SWD -w $(BLD_DIR)/main.bin 0x08000000

info:
	STM32_Programmer_CLI -c port=SWD

reset:
	STM32_Programmer_CLI -c port=SWD -rst

hard_reset:
	STM32_Programmer_CLI -c port=SWD -hardRst