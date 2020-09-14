# STM32F1-USART
Boilerplate project that uses FreeRTOS and libopencm3 for using USART on STM32F1 board

## How to clone
This project uses git submodules for handling dependencies

To clone using HTTPS:
```
git clone https://github.com/webbcam/stm32-blink.git --recurse-submodules
```

To clone using SSH:
```
git clone git@github.com:webbcam/stm32-blink.git --recurse-submodules
```

If you already downloaded the repo w/out using --recurse-submodules, run this:
```
git submodule update --init --recursive
```

## How to Build
This project uses [cmake](https://cmake.org/) for building
```
mkdir build
cd build
cmake .. -G "Unix Makefiles"
make
```

## How to Flash
Flashing requires [st-flash tool](https://github.com/stlink-org/stlink)
```
cd build
make flash
```
