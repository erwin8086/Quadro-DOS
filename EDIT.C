#include<dpmi.h>
#include<stdio.h>
#include<stdlib.h>

#include"color.h"
#include"debug.h"
#include"vga.h"
#include"main.h"
#include"edit.h"


static int mouse_x, mouse_y, mouse_btn;
extern volatile int esc;
extern volatile int key_p;
extern char framebuffer[320*200];

static int init_mouse()
{
  __dpmi_regs r;
  r.x.ax = 0x0;
  __dpmi_int(0x33, &r);
  if(r.x.ax == 0xFFFF) return 0;
  r.x.ax = 3;
  r.x.cx = 0;
  r.x.dx = 0;
  return 1;
}

static void update_mouse()
{
  __dpmi_regs r;
  r.x.ax = 0x3;
  __dpmi_int(0x33, &r);
  mouse_x = (r.x.cx/2) % 320;
  mouse_y = r.x.dx % 200;
  mouse_btn = r.x.bx;
}

static void draw_grid()
{
  int x,y;
  // Draw vertical lines
  for(x=0;x<32;x++) {
    for(y=0;y<200;y++) {
      framebuffer[y*320+x*10] = COLOR_WHITE;
    }
  }

  // Draw horizontal lines
  for(y=0;y<20;y++) {
    for(x=0;x<320;x++) {
      framebuffer[y*3200+x] = COLOR_WHITE;
    }
  }
}

// The level objects and ther colors
static char lo[] = { 'K', 'G', '#', ' '};
static char lo_colors[] = { COLOR_KEVIL, COLOR_SEVIL, COLOR_WALL, COLOR_BLACK };

// The level static to avoid colision
// with level in level.c
static int *level;

static void edit_save_level()
{
  int x,y;
  char *buffer = malloc(34);
  if(!buffer)
  {
    LOG("Error Malloc: edit.c: save_level: buffer");
    exit(ERROR_MALLOC);
  }
  FILE *f = fopen("newlvl.txt", "w");
  if(!f)
  {
    LOG("File for saving level cold not been opened");
    exit(ERROR_FOPEN);
  }
  for(y=0;y<20;y++)
  {
    for(x=0;x<32;x++)
    {
      buffer[x] = lo[level[y*32+x]];
    }
    buffer[32] = '\n';
    buffer[33] = '\0';
    fputs(buffer, f);
  }
  fclose(f);
  free(buffer);
}

static void edit_load_level()
{
  FILE* f = fopen("newlvl.txt", "r");
  int x, y, x2;
  char* buffer = malloc(64);
  if(!buffer)
  {
    LOG("Error buffer cold not been malloc'd edit.c: load_level: buffer");
    exit(ERROR_MALLOC);
  }
  if(f)
  {
    y=0;
    while(!feof(f))
    {
      if(!fgets(buffer, 64, f)) break;
      for(x=0;x<32;x++)
      {
        if(buffer[x])
        {
          for(x2=0;x2<4;x2++)
          {
            if(lo[x2] == buffer[x])
            {
              level[y*32+x] = x2;
            }
          }
        } else {
          break;
        }
      }
      y++;
      if(y>=20) break;
    }
    fclose(f);
  }
  free(buffer);
}

// The "main" for the editor
void go_edit()
{
start_edit:
  if(init_mouse()) exit(ERROR_MOUSE);
  level = malloc(sizeof(int)*32*20);
  if(!level)
  {
    LOG("level cold not been malloc'd at edit.c: go_edit: level");
    exit(ERROR_MALLOC);
  }
  int sel = 0;
  int x, y, x2, y2;
  char col;
  // The level is filled with ' '
  for(x=0;x<32*20;x++) level[x] = 3;

  edit_load_level();
  
  while(!esc)
  {
    // Draw the current level
    for(y=0;y<20;y++)
    {
      for(x=0;x<32;x++)
      {
        if(level[y*32+x] > 3)
        {
          LOG("edit.c: Invalid content of level!");
          col=COLOR_BLACK;
        } else {
          col = lo_colors[level[y*32+x]];
        }
        for(y2=0;y2<10;y2++)
        {
          for(x2=0;x2<10;x2++)
          {
            if((y*10+y2)*320+x*10+x2 >= 320*200) {
              LOG("Framebuffer to small");
              exit(ERROR_OVERFLOW);
            }
            framebuffer[(y*10+y2)*320+x*10+x2] = col;
          }
        }
      }
    }
    draw_grid();
    update_mouse();

    // Right Click switch sel color
    if(mouse_btn & 2)
    {
      sel++;
      if(sel>3) sel=0;
      while(mouse_btn & 2) update_mouse();
    }

    // Left Click set tile to sel
    if(mouse_btn & 1)
    {
      x = mouse_x/10;
      y = mouse_y/10;
      x %= 32;
      y %= 20;
      level[y*32+x] = sel;
      while(mouse_btn & 1) update_mouse();
    }

    // Draw the mouse cursor
    if(mouse_x>2 && mouse_y>2)
    {
      if(mouse_x+2<SCREEN_W && mouse_y+2<SCREEN_H)
      {
        draw_rect(mouse_x-2, mouse_y-2, 4, 4, lo_colors[sel]);
      } else {
        draw_rect(mouse_x-2, mouse_y-2, 2, 2, lo_colors[sel]);
      }
    } else {
      if(mouse_y+2<SCREEN_H && mouse_x+2<SCREEN_W) {
        draw_rect(mouse_x, mouse_y, 2, 2, lo_colors[sel]);
      } else {
        if(mouse_y+2>=SCREEN_H) {
          draw_rect(mouse_x, mouse_y-2, 2, 2, lo_colors[sel]);
        } else {
          draw_rect(mouse_x-2, mouse_y, 2, 2, lo_colors[sel]);
        }
      }
    }
    
    draw();

    // KEY_P Pressed play current level
    if(key_p)
    {
      edit_save_level();
      free(level);
      run_level("newlvl.txt");
      while(esc);
      goto start_edit;
    }
  }

  edit_save_level();
  free(level);
}
