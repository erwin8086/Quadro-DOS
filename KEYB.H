void keyb_handler();
void install_keyb();
void remove_keyb();
#ifndef KEYB_C
  extern volatile int esc;
  extern volatile int key_up;
  extern volatile int key_down;
  extern volatile int key_left;
  extern volatile int key_right;
  extern volatile int key_e;
  extern volatile int key_p;
#else
  volatile int esc = 0;
  volatile int key_up=0;
  volatile int key_down=0;
  volatile int key_left=0;
  volatile int key_right=0;
  volatile int key_e=0;
  volatile int key_p=0;
#endif

