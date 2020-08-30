cmake_minimum_required(VERSION 3.18)
project(stm32f1 VERSION 0.1)

enable_language(C ASM)
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

# Include cmake files
include(${CMAKE_SOURCE_DIR}/cmake/arm_none_eabi_cortex_m3.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/libopencm3.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/flash.cmake)

# Set directories
set(THIRDPARTY_DIR "${CMAKE_SOURCE_DIR}/thirdparty")
set(FREERTOS_DIR "${THIRDPARTY_DIR}/FreeRTOS/FreeRTOS/Source")

# Only build for arm-none-eabi
if (NOT CMAKE_SYSTEM_PROCESSOR STREQUAL "arm-none-eabi")
    message(FATAL_ERROR "Invalid CMAKE_SYSTEM_PROCESSOR: ${CMAKE_SYSTEM_PROCESSOR}")
endif()


# Set Architecture flags
set(ARCH_FLAGS -msoft-float -mthumb -mcpu=cortex-m3 -mfix-cortex-m3-ldrd)

# Set STM32 SoC specific variables
set(STM32_DEFINES
    STM32F1
)

set(COMPILER_OPTIMIZATIONS -Os -g)

# Custom STM32 options for assembler and gcc
set(STM32_ASM_OPTIONS -mthumb -mcpu=cortex-m3)

set(STM32_C_COMPILER_OPTIONS ${ARCH_FLAGS}
                        ${COMPILER_OPTIMIZATIONS}
                        -std=c99
                        -Wextra -Wshadow -Wimplicit-function-declaration
                        -Wredundant-decls -Wmissing-prototypes -Wstrict-prototypes
                        -fno-common -ffunction-sections -fdata-sections
)

set(STM32_CXX_COMPILER_OPTIONS ${ARCH_FLAGS}
                        ${COMPILER_OPTIMIZATIONS}
                        -Wextra -Wshadow -Wredundant-decls  -Weffc++
                        -fno-common -ffunction-sections -fdata-sections
)

set(STM32_CPP_COMPILER_OPTIONS -MD -Wall -Wundef)

set(LINKER_SCRIPT "${CMAKE_SOURCE_DIR}/STM32F103C8T6.ld")
set(LDLIBS -specs=nosys.specs -Wl,--start-group -lc -lgcc -lnosys -Wl,--end-group)

set(STM32_LD_OPTIONS -T${LINKER_SCRIPT} ${ARCH_FLAGS} -Wl,-Map=${PROJECT_NAME}.map -Wl,--gc-sections ${LDLIBS})

set(SOURCES 
    ${CMAKE_SOURCE_DIR}/src/main.c
    ${FREERTOS_DIR}/croutine.c
    ${FREERTOS_DIR}/event_groups.c
    ${FREERTOS_DIR}/list.c
    ${FREERTOS_DIR}/queue.c
    ${FREERTOS_DIR}/tasks.c
    ${FREERTOS_DIR}/timers.c
    ${FREERTOS_DIR}/portable/GCC/ARM_CM3/port.c
    ${FREERTOS_DIR}/portable/MemMang/heap_4.c
)

set(EXECUTABLE ${PROJECT_NAME}.elf)
add_executable(${EXECUTABLE} ${SOURCES})

# Add external dependencies
add_dependencies(${EXECUTABLE} ${EXTERNAL_DEPENDENCIES})

target_include_directories(${EXECUTABLE} PRIVATE
    ${CMAKE_SOURCE_DIR}/inc
    ${FREERTOS_DIR}/include
    ${FREERTOS_DIR}/portable/GCC/ARM_CM3
    #${EXTERNAL_INCLUDE_DIRECTORIES}
)

target_compile_definitions(${EXECUTABLE} PRIVATE 
    $<$<COMPILE_LANGUAGE:C>:${STM32_DEFINES}>
)

target_compile_options(${EXECUTABLE} PRIVATE 
    $<$<COMPILE_LANGUAGE:C>:${STM32_C_COMPILER_OPTIONS}>
    $<$<COMPILE_LANGUAGE:CXX>:${STM32_CXX_COMPILER_OPTIONS}>
    $<$<COMPILE_LANGUAGE:CPP>:${STM32_CPP_COMPILER_OPTIONS}>
    $<$<COMPILE_LANGUAGE:ASM>:${STM32_ASM_OPTIONS}>
)

#target_link_directories(${EXECUTABLE} PRIVATE ${EXTERNAL_LINK_DIRECTORIES})
target_link_libraries(${EXECUTABLE} ${STM32_LD_OPTIONS} ${EXTERNAL_LINKER_FLAGS} ${EXTERNAL_LIBS})

add_custom_target( ${PROJECT_NAME}.hex ALL 
    DEPENDS ${PROJECT_NAME}.elf
    COMMAND ${CMAKE_OBJCOPY} -O ihex ${PROJECT_NAME}.elf ${PROJECT_NAME}.hex
    COMMENT "Generating ${PROJECT_NAME}.hex"
)

add_custom_target( ${PROJECT_NAME}.bin ALL 
    DEPENDS ${PROJECT_NAME}.elf
    COMMAND ${CMAKE_OBJCOPY} -O binary ${PROJECT_NAME}.elf ${PROJECT_NAME}.bin
    COMMENT "Generating ${PROJECT_NAME}.bin"
)

add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
    COMMAND ${CMAKE_SIZE} --format=berkeley "${PROJECT_NAME}.elf"
)

add_custom_target(flash DEPENDS ${PROJECT_NAME}.bin)
add_custom_command(TARGET flash USES_TERMINAL
    COMMAND ${FLASHCMD}
)

#message(STATUS "System Processor      : ${CMAKE_SYSTEM_PROCESSOR}")
#message(STATUS
#    "BUILD FLAGS:"
#    "   STM32_DEFINES   : ${STM32_DEFINES}"
#    "   c flags         : ${CMAKE_C_FLAGS}"
#    "   c++ flags       : ${CMAKE_CXX_FLAGS}"
#    "   cpp flags       : ${CMAKE_CPP_FLAGS}"
#    "   asm flags       : ${CMAKE_ASM_FLAGS}"
#    "   ld flags        : ${CMAKE_EXE_LINKER_FLAGS}"
#    "   optimizations   : ${COMPILER_OPTIMIZATIONS}"
#    "   FreeRTOS        : ${FREERTOS_INC_DIR}"
#    "   libopencm3      : ${LIBOPENCM3_INC_DIR}"
#    "   debug UART      : ${USE_DBGUART}"
#)
