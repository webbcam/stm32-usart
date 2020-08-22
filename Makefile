TARGET = main

# Define the linker script location and chip architecture.
LD_SCRIPT = STM32F103C8T6.ld
MCU_SPEC  = cortex-m3

# Toolchain definitions (ARM bare metal defaults)
TOOLCHAIN = /usr/local
CC = $(TOOLCHAIN)/bin/arm-none-eabi-gcc
AS = $(TOOLCHAIN)/bin/arm-none-eabi-as
LD = $(TOOLCHAIN)/bin/arm-none-eabi-ld
OC = $(TOOLCHAIN)/bin/arm-none-eabi-objcopy
OD = $(TOOLCHAIN)/bin/arm-none-eabi-objdump
OS = $(TOOLCHAIN)/bin/arm-none-eabi-size
STFLASH = $(shell which st-flash)

LIBNAME		= opencm3_stm32f1
DEFS		+= -DSTM32F1

FP_FLAGS	?= -msoft-float
ARCH_FLAGS	= -mthumb -mcpu=$(MCU_SPEC) $(FP_FLAGS) -mfix-cortex-m3-ldrd

# Assembly directives.
ASFLAGS += -mcpu=$(MCU_SPEC)
ASFLAGS += -mthumb

# C compilation directives
CFLAGS += $(DEFS)
CFLAGS += $(ARCH_FLAGS)
CFLAGS += -Wall
CFLAGS	+= -Wextra -Wshadow -Wimplicit-function-declaration
CFLAGS	+= -Wredundant-decls -Wmissing-prototypes -Wstrict-prototypes
CFLAGS	+= -fno-common -ffunction-sections -fdata-sections
CFLAGS += -g
# (Set error messages to appear on a single line.)
CFLAGS += -fmessage-length=0
# (Set system to ignore semihosted junk)
#CFLAGS += --specs=nosys.specs

# Linker directives.
LSCRIPT = ./$(LD_SCRIPT)
LFLAGS += -mcpu=$(MCU_SPEC)
LFLAGS += -mthumb
LFLAGS += -Wall
#LFLAGS += --specs=nosys.specs
LFLAGS += -nostdlib
LFLAGS += -lgcc
LFLAGS += -lc
LFLAGS += -T$(LSCRIPT)

LFLAGS	+= --static -nostartfiles
LFLAGS	+= $(ARCH_FLAGS)
LFLAGS	+= -Wl,-Map=$(*).map
LFLAGS	+= -Wl,--gc-sections

LDLIBS      += -L./thirdparty/libopencm3/lib -lopencm3_stm32f1
LDLIBS		+= -specs=nosys.specs
LDLIBS		+= -Wl,--start-group -lc -lgcc -lnosys -Wl,--end-group

#VECT_TBL = ./STM32F103C8T6_vt.S
#AS_SRC   = ./STM32F103C8T6_boot.S

C_SRC    += ./thirdparty/FreeRTOS/portable/MemMang/heap_4.c
C_SRC    += ./thirdparty/FreeRTOS/portable/GCC/ARM_CM3/port.c
C_SRC    += ./thirdparty/FreeRTOS/tasks.c
C_SRC    += ./thirdparty/FreeRTOS/list.c
C_SRC    += ./thirdparty/FreeRTOS/timers.c
C_SRC    += ./thirdparty/FreeRTOS/queue.c
C_SRC    += ./src/main.c

INCLUDE  += -I./inc
INCLUDE  += -I./thirdparty/FreeRTOS/include
INCLUDE  += -I./thirdparty/FreeRTOS/portable/GCC/ARM_CM3
INCLUDE  += -I./thirdparty/libopencm3/include

#OBJS =  $(VECT_TBL:.S=.o)
#OBJS += $(AS_SRC:.S=.o)
OBJS += $(C_SRC:.c=.o)

.PHONY: all
all: $(TARGET).bin

%.o: %.S
	$(AS) $(ASFLAGS) -c $< -o $@

%.o: %.c
	$(CC) -c $(CFLAGS) $(INCLUDE) $< -o $@

$(TARGET).elf: $(OBJS)
	$(CC) $^ $(LFLAGS) $(LDLIBS) -o $@

$(TARGET).bin: $(TARGET).elf
	$(OC) -S -O binary $< $@
	$(OS) $<

.PHONY: flash
flash:
	$(STFLASH) write $(TARGET).bin 0x08000000

.PHONY: clean
clean:
	rm -f $(OBJS)
	rm -f $(TARGET).elf $(TARGET).bin $(TARGET).hex
