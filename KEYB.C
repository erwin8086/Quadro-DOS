/*
  A Minimal Keyboard driver for the Game
*/
#define KEYB_C
#include<dpmi.h>
#include<pc.h>
#include<go32.h>

#include"keyb.h"


_go32_dpmi_seginfo old_handler, new_handler;


void keyb_handler()
{
  unsigned char key = inportb(0x60);
  switch(key)
  {
    case 0x01: // ESC
      esc=1;
      break;
    case 0x4b: // LEFT
      key_left=1;
      break;
    case 0x4d: // RIGHT
      key_right=1;
      break;
    case 0x50: // DOWN
      key_down=1;
      break;
    case 0x48: // UP
      key_up=1;
      break;
    case 0x12: // E
      key_e=1;
      break;
    case 0x19: // P
      key_p=1;
      break;
      
    case 0x81: // Release ESC
      esc=0;
      break;
    case 0xCB: // Release LEFT
      key_left=0;
      break;
    case 0xCD: // Release RIGHT
      key_right=0;
      break;
    case 0xD0: // Release DOWN
      key_down=0;
      break;
    case 0xC8: // Release UP
      key_up=0;
      break;
    case 0x92: // Release E
      key_e=0;
      break;
    case 0x99: // Release P
      key_p=0;
      break;
  }
  // Report the interrupt again
  outportb(0x20, 0x20);
}


void install_keyb()
{
  _go32_dpmi_get_protected_mode_interrupt_vector(9, &old_handler);
  new_handler.pm_offset = (int)keyb_handler;
  new_handler.pm_selector = _go32_my_cs();
  // Whe dont call the bios handler
  _go32_dpmi_allocate_iret_wrapper(&new_handler);
  _go32_dpmi_set_protected_mode_interrupt_vector(9, &new_handler);
}

void remove_keyb()
{
  _go32_dpmi_set_protected_mode_interrupt_vector(9, &old_handler);
  _go32_dpmi_free_iret_wrapper(&new_handler);
}
