# CMAKE flashing tool

if (NOT FLASHCMD)
    find_path(STFLASH_DIR "st-flash" REQUIRED)
    set(FLASHCMD ${STFLASH_DIR}/st-flash write ${PROJECT_NAME}.bin 0x8000000)
endif()

