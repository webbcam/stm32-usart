###

BINARY      = main
SRCFILES    += src/main.c
#SRCFILES    += thirdparty/FreeRTOS/FreeRTOS/Source/croutine.c
#SRCFILES    += thirdparty/FreeRTOS/FreeRTOS/Source/event_groups.c
SRCFILES    += thirdparty/FreeRTOS/FreeRTOS/Source/list.c
SRCFILES    += thirdparty/FreeRTOS/FreeRTOS/Source/queue.c
#SRCFILES    += thirdparty/FreeRTOS/FreeRTOS/Source/stream_buffer.c
SRCFILES    += thirdparty/FreeRTOS/FreeRTOS/Source/tasks.c
SRCFILES    += thirdparty/FreeRTOS/FreeRTOS/Source/timers.c
SRCFILES    += thirdparty/FreeRTOS/FreeRTOS/Source/portable/GCC/ARM_CM3/port.c
SRCFILES    += thirdparty/FreeRTOS/FreeRTOS/Source/portable/MemMang/heap_4.c

all: elf bin

include Makefile.common

# End
