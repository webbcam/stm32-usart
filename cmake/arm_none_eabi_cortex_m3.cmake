# CMAKE toolchain for the gcc arm-none-eabi
#
set(CMAKE_SYSTEM_NAME      Generic)
set(CMAKE_SYSTEM_VERSION   1)
set(CMAKE_SYSTEM_PROCESSOR arm-none-eabi)

# set arm-none-eabi toolchain paths
if (NOT TOOLCHAIN_DIR)
find_path(TOOLCHAIN_DIR "arm-none-eabi-gcc" REQUIRED)
endif()

set(TOOL_CHAIN_PREFIX arm-none-eabi)
set(TOOLCHAIN_BIN_DIR ${TOOLCHAIN_DIR})

# which compilers to use for C and C++
#
SET(CMAKE_AR               ${TOOLCHAIN_BIN_DIR}/${TOOL_CHAIN_PREFIX}-gcc-ar${EXE})
SET(CMAKE_RANLIB           ${TOOLCHAIN_BIN_DIR}/${TOOL_CHAIN_PREFIX}-gcc-ranlib${EXE})
SET(CMAKE_LD               ${TOOLCHAIN_BIN_DIR}/${TOOL_CHAIN_PREFIX}-ld${EXE})
set(CMAKE_C_COMPILER       ${TOOLCHAIN_BIN_DIR}/${TOOL_CHAIN_PREFIX}-gcc${EXE})
set(CMAKE_CXX_COMPILER     ${TOOLCHAIN_BIN_DIR}/${TOOL_CHAIN_PREFIX}-g++${EXE})
set(CMAKE_ASM_COMPILER     ${TOOLCHAIN_BIN_DIR}/${TOOL_CHAIN_PREFIX}-as${EXE})
set(CMAKE_OBJCOPY     	   ${TOOLCHAIN_BIN_DIR}/${TOOL_CHAIN_PREFIX}-objcopy${EXE} CACHE INTERNAL "objcopy command")
set(CMAKE_OBJDUMP     	   ${TOOLCHAIN_BIN_DIR}/${TOOL_CHAIN_PREFIX}-objdump${EXE} CACHE INTERNAL "objdump command")
set(CMAKE_GDB              ${TOOLCHAIN_BIN_DIR}/${TOOL_CHAIN_PREFIX}-gdb${EXE})
set(CMAKE_SIZE              ${TOOLCHAIN_BIN_DIR}/${TOOL_CHAIN_PREFIX}-size${EXE})
