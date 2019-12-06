#include <avr/io.h>
#include <util/delay.h>

#include "I2CSlave.h"

#define I2C_ADDR 0x10

void I2C_received(uint8_t received_data)
{
  PORTD = received_data;
}

void I2C_requested()
{
  I2C_transmitByte(PORTD);
}

int main()
{
  PORTD = 0x01;
  DDRD = 0xFF;

  I2C_setCallbacks(I2C_received, I2C_requested);
  I2C_init(I2C_ADDR);

  while(1);
}
