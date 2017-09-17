/*
  The graphics 'driver'
*/
#include<dpmi.h>
#include<stdio.h>
#include<sys/movedata.h>
#include<string.h>

#include"vga.h"

#define bit(b) (1<<b)

char framebuffer[320*200];

void set_mode_13h()
{
  __dpmi_regs r;
  r.x.ax = 0x13;
  __dpmi_int(0x10, &r);
  memset(framebuffer, 0, sizeof(framebuffer));
}

void set_mode_text()
{
  __dpmi_regs r;
  r.x.ax = 3;
  __dpmi_int(0x10, &r);
}
// Draw a rect to the screen
int draw_rect(int x1, int y1, int width, int height, char color)
{
  int x,y;
  // TODO: this is a Zustandt!
  if(x1+width-1 >= SCREEN_W) return 1;
  if(y1+height-1 >= SCREEN_H) return 1;

  if(x1+width >= SCREEN_W) width--;
  if(y1+height >= SCREEN_H) height--;
  
  if(x1<0) return 1;
  if(y1<0) return 1;

  // Fill the rects
  for(y=y1;y<y1+height;y++)
  {
    for(x=x1;x<x1+width;x++)
    {
      framebuffer[y*SCREEN_W+x] = color;
    }
  }
  return 0;
}

// Draw a line
// This functions is not very good and its only desingt for the 'font'
int draw_line(int x1, int y1, int step, int len, char color)
{
  int x,y;
  if(x1*step+len>SCREEN_W) return 1;
  if(y1+len>SCREEN_H) return 1;
  if(x1<0) return 1;
  if(y1<0) return 1;
  x=x1;
  y=y1;
  for(;len>0;len-=2)
  {
    framebuffer[y*SCREEN_W+x] = color;
    framebuffer[(y+1)*SCREEN_W+x] = color;
    y+=2;
    x+=step;
  }
  return 0;
}

// Draw a seg of the 'font'
// This font is very similar to the font on my phone
int draw_seg(int x, int y, int size, char color, unsigned int out)
{
  int width = size/6;
  if(out & bit(0))
    if(draw_rect(x,y,size/2,width,color)) return 1;
  if(out & bit(1))
    if(draw_rect(x+size/2,y,size/2,width,color)) return 1;
  if(out & bit(2))
    if(draw_rect(x+size,y,width,size,color)) return 1;
  if(out & bit(3))
    if(draw_rect(x+size,y+size,width,size,color)) return 1;
  if(out & bit(4))
    if(draw_rect(x+size/2,y+size*2,size/2,width,color)) return 1;
  if(out & bit(5))
    if(draw_rect(x,y+size*2,size/2,width,color)) return 1;
  if(out & bit(6))
    if(draw_rect(x,y+size, width, size, color)) return 1;
  if(out & bit(7))
    if(draw_rect(x,y,width,size,color)) return 1;
  if(out & bit(8))
    if(draw_rect(x,y+size,size/2, width, color)) return 1;
  if(out & bit(9))
    if(draw_rect(x+size/2,y+size,size/2, width, color)) return 1;
  if(out & bit(10))
    if(draw_rect(x+size/2, y+size, width, size, color)) return 1;
  if(out & bit(11))
    if(draw_rect(x+size/2, y, width, size, color)) return 1;
  if(out & bit(12))
    if(draw_line(x,y,1,size,color)) return 1;
  if(out & bit(13))
    if(draw_line(x+size, y, -1, size, color)) return 1;
  if(out & bit(14))
    if(draw_line(x+size/2, y+size, 1, size, color)) return 1;
  if(out & bit(15))
    if(draw_line(x+size/2, y+size, -1, size, color)) return 1;
  if(out & bit(16))
    if(draw_rect(x+size+width, y+size*2, width, width, color)) return 1;
  if(out & bit(17))
    if(draw_rect(x+size+width*2, y+size-size/3, width, width, color) ||
      draw_rect(x+size+width*2, y+size+size/3, width, width, color)) return 1;
  return 0;
}

// Draw a char of the font
// ToDo: Support more chars like: '- > < + ='
int draw_char(int x, int y, int size, char color, char c)
{
  switch(c)
  {
  case '0':
    return draw_seg(x,y,size,color, 0xFF);
  case '1':
    return draw_seg(x,y,size,color, bit(10) | bit(11));
  case '2':
    return draw_seg(x,y,size,color, bit(0) | bit(1) | bit(2) | bit(9) |
     bit(8) | bit(6) | bit(5) | bit(4));
  case '3':
    return draw_seg(x,y,size,color, bit(0) | bit(1) | bit(2) | bit(3) |
     bit(4) | bit(5) | bit(9) | bit(8));   
  case '4':
    return draw_seg(x,y,size,color, bit(7) | bit(8) | bit(9) | bit(2) |
     bit(3));
  case '5':
    return draw_seg(x,y,size,color, bit(0) | bit(1) | bit(7) | bit(8) |
     bit(9) | bit(3) | bit(4) | bit(5));
  case '6':
    return draw_seg(x,y,size,color, bit(0) | bit(1) | bit(7) | bit(6) | bit(5) | bit(4) |
     bit(3) | bit(9) | bit(8));
  case '7':
    return draw_seg(x,y,size,color, bit(7) | bit(0) | bit(1) | bit(2) |
     bit(3));
  case '8':
    return draw_seg(x,y,size,color, bit(0) | bit(1) | bit(2) | bit(3) |
     bit(4) | bit(5) | bit(6) | bit(7) | bit(8) | bit(9));
  case '9':
    return draw_seg(x,y,size,color, bit(5) | bit(4) | bit(3) | bit(2) |
     bit(1) | bit(0) | bit(7) | bit(8) | bit(9));
  case 'A':
    return draw_seg(x,y,size,color, bit(6) | bit(7) | bit(0) | bit(1) | bit(2) |
     bit(3) | bit(8) | bit(9));
  case 'B':
    return draw_seg(x,y,size,color, bit(6) | bit(7) | bit(0) | bit(5) | bit(10) |
     bit(11) | bit(8));
  case 'C':
    return draw_seg(x,y,size,color, bit(0) | bit(1) | bit(6) | bit(7) | bit(4) |
     bit(5));
  case 'D':
    return draw_seg(x,y,size,color, bit(6) | bit(8) | bit(5) | bit(10) | bit(11));
  case 'E':
    return draw_seg(x,y,size,color, bit(6) | bit(7) | bit(0) | bit(8) | bit(5));
  case 'F':
    return draw_seg(x,y,size,color, bit(6) | bit(7) | bit(0) | bit(8));
  case 'G':
    return draw_seg(x,y,size,color, bit(0) | bit(1) | bit(6) | bit(7) | bit(4) |
     bit(5) | bit(3) | bit(9));
  case 'H':
    return draw_seg(x,y,size,color, bit(6) | bit(7) | bit(8) | bit(9) | bit(2) |
     bit(3));
  case 'I':
    return draw_seg(x,y,size,color, bit(10) | bit(11));
  case 'J':
    return draw_seg(x,y,size,color, bit(10) | bit(11) | bit(5) | bit(6));
  case 'K':
    return draw_seg(x,y,size,color, bit(10) | bit(11) | bit(13) | bit(14));
  case 'L':
    return draw_seg(x,y,size,color, bit(6) | bit(7) | bit(5));
  case 'M':
    return draw_seg(x,y,size,color, bit(6) | bit(7) | bit(12) | bit(13) | bit(2) |
     bit(3));
  case 'N':
    return draw_seg(x,y,size,color, bit(6) | bit(7) | bit(12) | bit(14) | bit(2) |
     bit(3));
  case 'O':
    return draw_seg(x,y,size,color, bit(0) | bit(1) | bit(2) | bit(3) | bit(4) |
     bit(5) | bit(6) | bit(7));
  case 'P':
    return draw_seg(x,y,size,color, bit(6) | bit(7) | bit(0) | bit(11) | bit(8));
  case 'Q':
    return draw_seg(x,y,size,color, bit(0) | bit(1) | bit(2) | bit(3) | bit(4) |
     bit(5) | bit(6) | bit(7) | bit(14));
  case 'R':
    return draw_seg(x,y,size,color, bit(10) | bit(11) | bit(1) | bit(2) | bit(9) |
     bit(14));
  case 'S':
    return draw_seg(x,y,size,color, bit(0) | bit(7) | bit(8) | bit(10) | bit(5));
  case 'T':
    return draw_seg(x,y,size,color, bit(0) | bit(1) | bit(10) | bit(11));
  case 'U':
    return draw_seg(x,y,size,color, bit(6) | bit(7) | bit(5) | bit(10) | bit(11));
  case 'V':
    return draw_seg(x,y,size,color, bit(6) | bit(7) | bit(15) | bit(11));
  case 'W':
    return draw_seg(x,y,size,color, bit(6) | bit(7) | bit(15) | bit(14) | bit(2) |
     bit(3));
  case 'X':
    return draw_seg(x,y,size,color, bit(12) | bit(13) | bit(14) | bit(15));
  case 'Y':
    return draw_seg(x,y,size,color, bit(12) | bit(13) | bit(10));
  case 'Z':
    return draw_seg(x,y,size,color, bit(0) | bit(1) | bit(13) | bit(15) | bit(4) |
     bit(5));
  case '.':
    return draw_seg(x,y,size,color, bit(16));
  case ':':
    return draw_seg(x,y,size,color, bit(17));
  }
  return 1;
}

// Draw a complete string
// ToDo: support \t
int draw_string(int x, int y, int size, char color, char* str)
{
  while(*str!='\0')
  {
    if(*str=='\n')
    {
      str++;
      x=0;
      y+=size*2+size/3;
      continue;
    }
    if(*str==' ')
    {
      x+=size+size/3;
      str++;
      continue;
    }
    if(draw_char(x,y,size,color,*str)) return 1;
    str++;
    x+=size+size/3;
  }
  return 0;
}

// Draw the framebuffer to the screen
void draw()
{
  dosmemput(framebuffer, 320*200, 0xA0000);
  memset(framebuffer, 0, sizeof(framebuffer));
}

