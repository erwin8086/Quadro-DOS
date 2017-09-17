/*
  The driver for the timer
*/
#include<dpmi.h>
#include<pc.h>
#include<dos.h>
#include<go32.h>

#include"timer.h"

volatile int runtime_ms=0;
int nops_per_55=0;
int nops_per_ms;
volatile int tick=0;

_go32_dpmi_seginfo old_timer, new_timer;

void timer_int()
{
  runtime_ms+=55;
  tick=1;
  outportb(0x20, 0x20); // Reset timer int
}

void install_timer()
{
  _go32_dpmi_get_protected_mode_interrupt_vector(8, &old_timer);
  new_timer.pm_offset = (int)timer_int;
  new_timer.pm_selector = _go32_my_cs();
  // We not run the old timer but this cold cause problems with systime
  _go32_dpmi_allocate_iret_wrapper(&new_timer);
  _go32_dpmi_set_protected_mode_interrupt_vector(8, &new_timer);
}

void remove_timer()
{
  _go32_dpmi_set_protected_mode_interrupt_vector(8, &old_timer);
  _go32_dpmi_free_iret_wrapper(&new_timer);

  struct time t;
  gettime(&t);
  // Added the runtime of the program to the systime
  t.ti_sec  += timer_gettime()/1000;
  t.ti_min  += t.ti_sec/60;
  t.ti_hour += t.ti_min/60;
  t.ti_sec  %= 60;
  t.ti_min  %= 60;
  t.ti_hour %= 60;
  settime(&t);
}

// Sleep for ms
// Note that the minimum sleep is ca. 55ms
void timer_sleep(int ms)
{
  ms+=runtime_ms;
  while(runtime_ms<ms);
}

int timer_gettime()
{
  return runtime_ms;
}

// Calc nops per 55ms
int timer_calc_nops()
{
  int c=0;
  tick=0;
  while(!tick);
  tick=0;
  while(!tick)
  {
    asm("nop");
    c++;
  }
  return c;
}

// Sleep given nops:count
void timer_nop(int count)
{
  while(count)
  {
    asm("nop");
    count--;
  }
}

