###

BINARY      = main
SRCFILES    += src/main.c
#SRCFILES    += thirdparty/FreeRTOS/croutine.c
#SRCFILES    += thirdparty/FreeRTOS/event_groups.c
SRCFILES    += thirdparty/FreeRTOS/list.c
SRCFILES    += thirdparty/FreeRTOS/queue.c
#SRCFILES    += thirdparty/FreeRTOS/stream_buffer.c
SRCFILES    += thirdparty/FreeRTOS/tasks.c
SRCFILES    += thirdparty/FreeRTOS/timers.c
SRCFILES    += thirdparty/FreeRTOS/portable/GCC/ARM_CM3/port.c
SRCFILES    += thirdparty/FreeRTOS/portable/MemMang/heap_4.c

all: elf bin

include Makefile.common

# End
