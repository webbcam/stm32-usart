cmake_minimum_required(VERSION 3.18)
project(stm32f1 VERSION 0.1)

enable_language(C ASM)
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Set directories
set(THIRDPARTY_DIR "${CMAKE_SOURCE_DIR}/thirdparty")

# Set STM32 defines
set(STM32_DEFINES
    STM32F1
)

# Set Architecture flags
set(ARCH_FLAGS -msoft-float -mthumb -mcpu=cortex-m3 -mfix-cortex-m3-ldrd)

# Set Compiler optimization flags
set(COMPILER_OPTIMIZATIONS -O0 -g)

# Set custom STM32 options for assembler and gcc
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

# Include cmake files
include(${CMAKE_SOURCE_DIR}/cmake/arm_none_eabi_cortex_m3.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/libopencm3.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/freertos.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/flash.cmake)

# Only build for arm-none-eabi
if (NOT CMAKE_SYSTEM_PROCESSOR STREQUAL "arm-none-eabi")
    message(FATAL_ERROR "Invalid CMAKE_SYSTEM_PROCESSOR: ${CMAKE_SYSTEM_PROCESSOR}")
endif()

set(SOURCES 
    ${CMAKE_SOURCE_DIR}/src/main.c
)

# Set executable
set(EXECUTABLE ${PROJECT_NAME}.elf)
add_executable(${EXECUTABLE} ${SOURCES})

# Add external dependencies
if (NOT "${EXTERNAL_DEPENDENCIES}" STREQUAL "")
    add_dependencies(${EXECUTABLE} ${EXTERNAL_DEPENDENCIES})
endif()

target_include_directories(${EXECUTABLE} PRIVATE
    ${CMAKE_SOURCE_DIR}/inc
    ${EXTERNAL_INCLUDE_DIRECTORIES}
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
set_target_properties(${EXECUTABLE} PROPERTIES ADDITIONAL_CLEAN_FILES "${PROJECT_NAME}.map")

add_custom_target( ${PROJECT_NAME}.hex ALL 
    DEPENDS ${PROJECT_NAME}.elf
    COMMAND ${CMAKE_OBJCOPY} -O ihex ${PROJECT_NAME}.elf ${PROJECT_NAME}.hex
    BYPRODUCTS ${PROJECT_NAME}.hex
    COMMENT "Generating ${PROJECT_NAME}.hex"
)

add_custom_target( ${PROJECT_NAME}.bin ALL 
    DEPENDS ${PROJECT_NAME}.elf
    COMMAND ${CMAKE_OBJCOPY} -O binary ${PROJECT_NAME}.elf ${PROJECT_NAME}.bin
    BYPRODUCTS ${PROJECT_NAME}.bin
    COMMENT "Generating ${PROJECT_NAME}.bin"
)

add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
    COMMAND ${CMAKE_SIZE} --format=berkeley "${PROJECT_NAME}.elf"
)

add_custom_target(flash DEPENDS ${PROJECT_NAME}.bin)
add_custom_command(TARGET flash USES_TERMINAL
    COMMAND ${FLASHCMD}
)
