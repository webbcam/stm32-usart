#include "FreeRTOS.h"
#include "task.h"
#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/gpio.h>

#if 0
extern void vApplicationStackOverflowHook(TaskHandle_t *pxTask,signed portCHAR *pcTaskName);

void vApplicationStackOverflowHook(TaskHandle_t *pxTask,signed portCHAR *pcTaskName) {
	(void)pxTask;
	(void)pcTaskName;
	for(;;);
}
#endif

static void gpio_setup(void) {
    /* Enable the GPIO clock */
    rcc_periph_clock_enable(RCC_GPIOC);

    /* Set GPIO 13 (in port C) to 'output push-pull' */
    gpio_set_mode(GPIOC, GPIO_MODE_OUTPUT_2_MHZ, 
                GPIO_CNF_OUTPUT_PUSHPULL, GPIO13);
}

void led_task( void *pvParameters) {

    gpio_setup();

	for (;;) {
		gpio_toggle(GPIOC,GPIO13);
        vTaskDelay(pdMS_TO_TICKS(500));
	}
}

int main() {
    /* Set clock up for "blue pill" */
    rcc_clock_setup_in_hse_8mhz_out_72mhz();

#if 0
    gpio_setup();
	for (;;) {
		gpio_toggle(GPIOC,GPIO13);
        for (int i = 0; i < 1500000; i++)
            __asm__("nop");
		gpio_toggle(GPIOC,GPIO13);
        for (int i = 0; i < 1500000; i++)
            __asm__("nop");
	}
#else
    xTaskCreate( led_task, "led_task", 512, NULL, configMAX_PRIORITIES-1, NULL);
    vTaskStartScheduler();

    for(;;)
        ;
#endif


    return 0;
}
