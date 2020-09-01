set(FREERTOS_DIR ${CMAKE_SOURCE_DIR}/thirdparty/FreeRTOS/FreeRTOS/Source)

if (NOT EXISTS "${FREERTOS_DIR}")
    message(FATAL_ERROR "FreeRTOS submodule not found. Initialize with 'git submodule update --init --recursive' in the root directory")
endif()

if (NOT DEFINED STM32_DEFINES)
    message(FATAL_ERROR "'STM32_DEFINES' not set. These defines need to be set before including this .cmake file")
elseif (NOT DEFINED STM32_C_COMPILER_OPTIONS)
    message(FATAL_ERROR "'STM32_C_COMPILER_OPTIONS' not set. These defines need to be set before including this .cmake file")
elseif (NOT DEFINED STM32_CXX_COMPILER_OPTIONS)
    message(FATAL_ERROR "'STM32_CXX_COMPILER_OPTIONS' not set. These defines need to be set before including this .cmake file")
elseif (NOT DEFINED STM32_CPP_COMPILER_OPTIONS)
    message(FATAL_ERROR "'STM32_CPP_COMPILER_OPTIONS' not set. These defines need to be set before including this .cmake file")
elseif (NOT DEFINED STM32_ASM_OPTIONS)
    message(FATAL_ERROR "'STM32_ASM_OPTIONS' not set. These defines need to be set before including this .cmake file")
endif()

set(FREERTOS_LIB freertos)

set(FREERTOS_INC_DIR
    ${FREERTOS_DIR}/include
    ${FREERTOS_DIR}/portable/GCC/ARM_CM3
)

include_directories(
    ${CMAKE_SOURCE_DIR}/inc
    ${FREERTOS_INC_DIR}
)

set(FREERTOS_LIB_SRC
    ${FREERTOS_DIR}/croutine.c
    ${FREERTOS_DIR}/event_groups.c
    ${FREERTOS_DIR}/list.c
    ${FREERTOS_DIR}/queue.c
    ${FREERTOS_DIR}/tasks.c
    ${FREERTOS_DIR}/timers.c
    ${FREERTOS_DIR}/portable/GCC/ARM_CM3/port.c
    ${FREERTOS_DIR}/portable/MemMang/heap_4.c
)

add_library(${FREERTOS_LIB} STATIC ${FREERTOS_LIB_SRC})

set_target_properties(${FREERTOS_LIB} PROPERTIES LINKER_LANGUAGE C)

target_compile_definitions(${FREERTOS_LIB} PRIVATE 
    $<$<COMPILE_LANGUAGE:C>:${STM32_DEFINES}>
)

target_compile_options(${FREERTOS_LIB} PRIVATE 
    $<$<COMPILE_LANGUAGE:C>:${STM32_C_COMPILER_OPTIONS}>
    $<$<COMPILE_LANGUAGE:CXX>:${STM32_CXX_COMPILER_OPTIONS}>
    $<$<COMPILE_LANGUAGE:CPP>:${STM32_CPP_COMPILER_OPTIONS}>
    $<$<COMPILE_LANGUAGE:ASM>:${STM32_ASM_OPTIONS}>
)

#string(REPLACE "-flto" "" COMPILER_OPTIMIZATIONS ${COMPILER_OPTIMIZATIONS})

set(EXTERNAL_LIBS ${EXTERNAL_LIBS} ${FREERTOS_LIB})
