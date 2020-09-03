set(LIBOPENCM3_DIR ${CMAKE_SOURCE_DIR}/thirdparty/libopencm3)

set(LIBOPENCM3_LIB opencm3)

set(LIBOPENCM3_INC_DIR
    ${LIBOPENCM3_DIR}/include
    ${LIBOPENCM3_DIR}/include/libopencm3
    ${LIBOPENCM3_DIR}/include/libopencm3/cm3
    ${LIBOPENCM3_DIR}/include/libopencm3/dispatch
    ${LIBOPENCM3_DIR}/include/libopencm3/stm32
    ${LIBOPENCM3_DIR}/include/libopencm3/stm32/common
    ${LIBOPENCM3_DIR}/include/libopencm3/stm32/f1
    ${LIBOPENCM3_DIR}/include/libopencm3/stm32/usb
    ${LIBOPENCM3_DIR}/include/libopencm3/stm32/usb/dwc
    ${LIBOPENCM3_DIR}/include/libopencmsis
    ${LIBOPENCM3_DIR}/include/libopencmsis/stm32/f1
)
include_directories(${LIBOPENCM3_INC_DIR})
link_directories(${LIBOPENCM3_DIR}/lib)

set(LIBOPENCM3_LIB_SRC 
    ${LIBOPENCM3_DIR}/lib/stm32/f1/adc.c
    ${LIBOPENCM3_DIR}/lib/stm32/f1/flash.c
    ${LIBOPENCM3_DIR}/lib/stm32/f1/gpio.c
    ${LIBOPENCM3_DIR}/lib/stm32/f1/i2c.c
    ${LIBOPENCM3_DIR}/lib/stm32/f1/rcc.c
    ${LIBOPENCM3_DIR}/lib/stm32/f1/rtc.c
    ${LIBOPENCM3_DIR}/lib/stm32/f1/timer.c

    ${LIBOPENCM3_DIR}/lib/stm32/common/crc_common_all.c
    ${LIBOPENCM3_DIR}/lib/stm32/common/dac_common_all.c
    ${LIBOPENCM3_DIR}/lib/stm32/common/desig_common_all.c
    ${LIBOPENCM3_DIR}/lib/stm32/common/desig_common_v1.c
    ${LIBOPENCM3_DIR}/lib/stm32/common/dma_common_l1f013.c
    ${LIBOPENCM3_DIR}/lib/stm32/common/exti_common_all.c
    ${LIBOPENCM3_DIR}/lib/stm32/common/flash_common_all.c
    ${LIBOPENCM3_DIR}/lib/stm32/common/flash_common_f.c
    ${LIBOPENCM3_DIR}/lib/stm32/common/flash_common_f01.c
    ${LIBOPENCM3_DIR}/lib/stm32/common/gpio_common_all.c
    ${LIBOPENCM3_DIR}/lib/stm32/common/i2c_common_v1.c
    ${LIBOPENCM3_DIR}/lib/stm32/common/iwdg_common_all.c
    ${LIBOPENCM3_DIR}/lib/stm32/common/pwr_common_v1.c
    ${LIBOPENCM3_DIR}/lib/stm32/common/rcc_common_all.c
    ${LIBOPENCM3_DIR}/lib/stm32/common/spi_common_all.c
    ${LIBOPENCM3_DIR}/lib/stm32/common/spi_common_v1.c
    ${LIBOPENCM3_DIR}/lib/stm32/common/st_usbfs_core.c
    ${LIBOPENCM3_DIR}/lib/stm32/st_usbfs_v1.c
    ${LIBOPENCM3_DIR}/lib/stm32/common/timer_common_all.c
    ${LIBOPENCM3_DIR}/lib/stm32/common/usart_common_all.c
    ${LIBOPENCM3_DIR}/lib/stm32/common/usart_common_f124.c

    ${LIBOPENCM3_DIR}/lib/cm3/assert.c
    ${LIBOPENCM3_DIR}/lib/cm3/dwt.c
    ${LIBOPENCM3_DIR}/lib/cm3/nvic.c
    ${LIBOPENCM3_DIR}/lib/cm3/scb.c
    ${LIBOPENCM3_DIR}/lib/cm3/sync.c
    ${LIBOPENCM3_DIR}/lib/cm3/systick.c
    ${LIBOPENCM3_DIR}/lib/cm3/vector.c

    ${LIBOPENCM3_DIR}/lib/usb/usb.c
    ${LIBOPENCM3_DIR}/lib/usb/usb_control.c
    ${LIBOPENCM3_DIR}/lib/usb/usb_dwc_common.c
    ${LIBOPENCM3_DIR}/lib/usb/usb_f107.c
    ${LIBOPENCM3_DIR}/lib/usb/usb_hid.c
    ${LIBOPENCM3_DIR}/lib/usb/usb_msc.c
    ${LIBOPENCM3_DIR}/lib/usb/usb_standard.c
)

# Add running the irq2nvic_h script as requirement when building libopencm3
add_custom_target(irq2nvic
    COMMENT "Generating nvic header files..."
    WORKING_DIRECTORY ${LIBOPENCM3_DIR}
    COMMAND ./scripts/irq2nvic_h ./include/libopencm3/stm32/f1/irq.json
    BYPRODUCTS 
        ${LIBOPENCM3_DIR}/include/libopencm3/stm32/f1/nvic.h 
        ${LIBOPENCM3_DIR}/include/libopencmsis/stm32/f1/irqhandlers.h
        ${LIBOPENCM3_DIR}/lib/stm32/f1/vector_nvic.c
    USES_TERMINAL
)

add_library(${LIBOPENCM3_LIB} STATIC ${LIBOPENCM3_LIB_SRC})
add_dependencies(${LIBOPENCM3_LIB} irq2nvic)

set_target_properties(${LIBOPENCM3_LIB} PROPERTIES LINKER_LANGUAGE C)

set(LIBOPENCM3_LINKER_FLAGS --static -nostartfiles)

target_compile_definitions(${LIBOPENCM3_LIB} PRIVATE 
    $<$<COMPILE_LANGUAGE:C>:${STM32_DEFINES}>
)

target_compile_options(${LIBOPENCM3_LIB} PRIVATE 
    $<$<COMPILE_LANGUAGE:C>:${STM32_C_COMPILER_OPTIONS}>
    $<$<COMPILE_LANGUAGE:CXX>:${STM32_CXX_COMPILER_OPTIONS}>
    $<$<COMPILE_LANGUAGE:CPP>:${STM32_CPP_COMPILER_OPTIONS}>
    $<$<COMPILE_LANGUAGE:ASM>:${STM32_ASM_OPTIONS}>
)



# Target should include each of these EXTERNAL_*
#set(EXTERNAL_INCLUDE_DIRECTORIES ${EXTERNAL_INCLUDE_DIRECTORIES} ${LIBOPENCM3_DIR/}include)
set(EXTERNAL_LINK_DIRECTORIES ${EXTERNAL_LINK_DIRECTORIES} ${LIBOPENCM3_DIR}/lib})
set(EXTERNAL_LINKER_FLAGS ${EXTERNAL_DEPENDENCIES_LINKER_FLAGS} ${LIBOPENCM3_LINKER_FLAGS})
set(EXTERNAL_LIBS ${EXTERNAL_LIBS} ${LIBOPENCM3_LIB})
set(EXTERNAL_DEPENDENCIES ${EXTERNAL_DEPENDENCIES} ${LIBOPENCM3_LIB})
