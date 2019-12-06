DEVICE = atmega8
MCU    = atmega8
F_CPU  = 1000000UL
TARGET = avr-i2c-portd-kill-switch

CC      = avr-gcc
OBJCOPY = avr-objcopy

INCLUDES = -I./ -I/usr/lib/avr/include
CFLAGS   = -std=c99 -g -Wall -mmcu=$(MCU) -DF_CPU=$(F_CPU) $(INCLUDES) -Os
LDFLAGS  = -Wl,-gc-sections -Wl,-relax

OBJECT_FILES = main.o I2CSlave.o

all: $(TARGET).hex size

size:
	@if [ -f $(TARGET).obj ]; then avr-size -C --mcu=$(MCU) $(TARGET).obj; fi

clean:
	rm -rf *.o *.hex *.obj

%.hex: %.obj
	$(OBJCOPY) -R .eeprom -O ihex $< $@

%.obj: $(OBJECT_FILES)
	$(CC) $(CFLAGS) $(OBJECT_FILES) $(LDFLAGS) -o $@

load: all
	avrdude -F -V -c usbasp -p ATmega8 -P usb -U flash:w:$(TARGET).hex
