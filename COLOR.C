#include<pc.h>

#include"color.h"
#include"main.h"

void vsync()
{
  while(inportb(0x3DA) & 8);
  while(!(inportb(0x3DA) & 8));
}

void set_color(char c, unsigned char r, unsigned char g, unsigned char b)
{
  outportb(0x3C8, c);
  outportb(0x3C9, r);
  outportb(0x3C9, g);
  outportb(0x3C9, b);
}

void init_color()
{
  vsync();
  set_color(COLOR_BLACK, 0, 0, 0);
  set_color(COLOR_WHITE, 255, 255, 255);
  set_color(COLOR_BLUE, 0, 0, 255);
  set_color(COLOR_DARKBLUE, 0, 0, 225);
  set_color(COLOR_RED, 255, 0, 0);
  set_color(COLOR_YELLOW, 255, 255, 0);
  set_color(COLOR_GREEN, 0, 255, 0);
  set_color(COLOR_GREY, 225, 225, 225);
}
