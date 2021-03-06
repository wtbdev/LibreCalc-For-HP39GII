CC            = ..\tools\gcc-arm\bin\arm-none-eabi-gcc
AS            = ..\tools\gcc-arm\bin\arm-none-eabi-as
CFLAGS        = -mtune=arm926ej-s -mcpu=arm926ej-s -mlittle-endian -O1 -pipe
INCPATH       = -I. -I..\tools\gcc-arm\arm-none-eabi\include -Iinclude -Iinclude\registers
LINKER        = ..\tools\gcc-arm\bin\arm-none-eabi-gcc
LIBS          = -L..\tools\gcc-arm\lib\gcc\arm-none-eabi\9.3.1 -lc -lgcc
LFLAGS        = -Tld.script -nodefaultlibs -nostdlib
DEL_FILE      = del
DEL_DIR       = rmdir
ELF2ROM		  = ..\tools\sbtools\elftosb.exe
SBLOADER	  = ..\tools\sbtools\sb_loader.exe


SRCOURS       =     $(shell dir *.c /b)
OBJECTS       =		$(SRCOURS:%.c=%.o)

%.o:%.c 
	$(CC) -c $(CFLAGS) $(INCPATH) -o $@ $<

all: firmware.sb

rom.elf: $(OBJECTS)
	$(LINKER) $(LFLAGS) $(OBJECTS) -o rom.elf $(LIBS)

updater: rom.elf
	$(ELF2ROM) -z -c ./build_updater.bd -o updater.sb rom.elf

firmware.sb: rom.elf
	$(ELF2ROM) -z -c ./build_fw.bd -o firmware.sb rom.elf

flash:
	$(SBLOADER) -f updater.sb

clean:
	@$(DEL_FILE) *.o
	@$(DEL_FILE) *.a
	@$(DEL_FILE) *.tmp
	@$(DEL_FILE) rom.elf
	@$(DEL_FILE) firmware.sb
	@$(DEL_FILE) updater.sb