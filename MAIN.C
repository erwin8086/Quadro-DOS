#define MAIN_C
#include<dos.h>
#include<stdlib.h>
#include<stdio.h>
#include<string.h>

#include"go.h"
#include"hi.h"
#include"const.h"
#include"util.h"
#include"evil.h"
#include"color.h"
#include"keyb.h"
#include"timer.h"
#include"score.h"
#include"level.h"
#include"debug.h"
#include"vga.h"
#include"edit.h"
#include"main.h"

//unsigned _stklen = 1048576;


extern volatile int tick;
extern char* level;
extern struct hiscore *hi;

int gameover=0;
int evils=0;
int lose_life=0;

struct gameobject *go;
// Count of GameObjects
int count;

void calc()
{
  int i, ci, wall;
  for(i=0;i<count;i++)
  {
    if(go[i].attr & ATTR_DEAD) continue;
    switch(go[i].type)
    {
      case WALL:
        // The Wall: do noting
        break;
      case PLAYER: // TODO: Move player in its own file
        // The Player: calc
        wall = is_wall(go[i].x, go[i].y+1);
        // Let player fall if is no wall under it
        if(!wall) go[i].y+=PLAYER_MOVE;
        while(is_wall(go[i].x, go[i].y)) go[i].y--;
        // Move player x axis
        if(key_left) move_go_xm(&go[i], PLAYER_MOVE);
        if(key_right) move_go_xp(&go[i], PLAYER_MOVE);
        //go[i].x+=PLAYER_MOVE;
        if(go[i].x<0) go[i].x=0;
        if(go[i].x>309) go[i].x=309;
        // Player can jump if is standing on wall
        if(wall && key_up) jump_go(&go[i], 75);
        if(go[i].y<0) go[i].y=0;
        if(go[i].y>189) go[i].y=189;
        // Check evil colisions
        for(ci=0;ci<count;ci++)
        {
          if(ci == i) continue;
          
          if(!(go[ci].attr & ATTR_DEAD) && (go[ci].attr & ATTR_EVIL) && go_col(&go[ci], &go[i])) {
            if(go[ci].y <= go[i].y) {
              lose_life=1;
            } else {
              if(go[ci].attr & ATTR_EVJUMP) {
                evils--;
                go[ci].attr |= ATTR_DEAD;
              } else {
                lose_life=1;
              }
            }
          }
        }
        break;
      case SIMPLE_EVIL:
      case KROT_EVIL:
        calc_evil(&go[i]);
        break;
    }
  }
}

void paint()
{
  int i;
  for(i=0;i<count;i++)
  {
   if(go[i].attr & ATTR_DEAD) continue;
   switch(go[i].type)
   {
     case WALL:
       draw_rect(go[i].x, go[i].y, 10, 10, COLOR_WALL);
       break;
     case PLAYER:
       draw_rect(go[i].x, go[i].y, 10, 10, COLOR_QUADRO);
       break;
     case SIMPLE_EVIL:
     case KROT_EVIL:
       paint_evil(&go[i]);
       break;
   }
  }
}
// The levels from level?.o
extern int binary_level1_bin_start;
extern int binary_level2_bin_start;
extern int binary_level3_bin_start;

static void *bin_levels[] = { &binary_level1_bin_start, &binary_level2_bin_start, &binary_level3_bin_start };

// Use read_level to load a level ready for calc
// Resolv all GameObjects to create go
void load_level(char* file)
{
  // if file starts with ! this means that the level is included in the binary
  // in this case file[1] holds the element id of bin_levels
  // The binary level starts with an int: the count, followed by the level
  // in the same format as read_level return it.
  // To Add a level:
  // * Use the exe with -c <level.dat> <level.bin> to get the binary
  // * Use objcopy -I binary -O coff-go32 -B i386 <level.bin> <level.o>
  // * Add level.o to the Project and set local options to use no compiler
  // * Add &<binary_level_bin_start> to the bin_levels array
  if(file[0] == '!')
  {
    int l = (int) file[1];
    if(l>=sizeof(bin_levels)) {
      LOG("Unknown level at load_level.c: bin_levels");
      exit(ERROR_OVERFLOW);
    }
    int *bin_count = bin_levels[l];
    count = *bin_count;
    bin_count++;
    level = (char*) bin_count;
  } else {
    count = read_level(file);
  }
  count++;
  go=malloc(sizeof(struct gameobject)*count);
  if(!go)
  {
    LOG("Malloc cannot alloc go");
    exit(ERROR_MALLOC);
  }
  int x, y, c=0;
  // Check all posible GameObjects
  for(y=0;y<20;y++)
  {
    for(x=0;x<32;x++)
    {
      if(!level[y*32+x]) continue; // If is zero there is Noting
      if(c>=count) {
        LOG("Count to Big");
        exit(ERROR_COUNT);
      }
      switch(level[y*32+x])
      {
      case '#': // Wall
        go[c].y=y*10;
        go[c].x=x*10;
        go[c].type = WALL;
        go[c].attr = ATTR_FOOD | ATTR_WALL;
        c++;
        break;
      case 'G': // Simple Evil
        go[c].y=y*10;
        go[c].x=x*10;
        go[c].type=SIMPLE_EVIL;
        go[c].attr = ATTR_EVIL | ATTR_EVJUMP;
        evils++;
        c++;
        break;
      case 'K': // Krot Evil
        go[c].y=y*10;
        go[c].x=x*10;
        go[c].type=KROT_EVIL;
        go[c].attr = ATTR_EVIL | ATTR_EVJUMP;
        evils++;
        c++;
        break;
      default: // Unknown char in level file
        LOG("Unknown char in level\n");
        char* b = malloc(64);
        if(b) {
          sprintf(b, "Char was %c (int: %i) at %i, %i\n", level[y*32+x], level[y*32+x], x, y);
          LOG(b);
          free(b);
        }
        if(file[0] != '!')
          free(level);
        exit(ERROR_UNKNOWN_ENTITY);
      }
    }
  }
  if(file[0] != '!')
    free(level);
  // Add the Player
  go[c].x=0;
  go[c].y=0;
  go[c].type=PLAYER;
  go[c].attr=0;
  c++;

  // Num evils added to go shold be num evils read by read_level()
  // If the not equal something is going wrong
  if(c!=count) {
    char* b = malloc(64);
    if(b)
    {
      sprintf(b, "Invalid Count at line %i, count=%i, c=%i", __LINE__, count, c);
      LOG(b);
      free(b);
    } else {
      LOG("Invalid Count better information cold not provided(malloc)");
    }
    exit(ERROR_COUNT);
  }
}

// Buffer for different purposes in main
// Alloc'd with 33 bytes length
static char* buffer;

// Run specified level file used in the editor
// Not as complete as the loop in main
void run_level(char* file)
{
  // Calc nops per 55ms/2
  int nops=timer_calc_nops()/2;
  
  int start_time=timer_gettime();
  int lifes=3;

  load_level(file);

  while(1)
  {
    if(esc)
    {
      break;
    }
    calc();
    paint();

    // Paint the score and the lifes
    itoa((timer_gettime()-start_time)/1000,buffer, 10);
    draw_string(290,0,6,COLOR_WHITE,buffer);
    sprintf(buffer, "LIVES: %i", lifes);
    draw_string(0,0,6,COLOR_WHITE,buffer);
    
    draw();
    // lose_life is set to 1 if player colidates with evil and die
    if(lose_life)
    {
      lose_life=0;
      lifes--;
      evils=0;
      // Player is GameOver
      if(lifes<=0) break;

      // Load level again for next run
      free(go);
      load_level(file);
    }

    // Player has won
    if(evils<=0) break;

    timer_nop(nops);
  }

  free(go);
  
}

// The levels of the main game if you change the count of levels
// You must change NUM_LEVELS in const.h
// Binary level start with '!', followed by '\x??': ?? -> selector(hex) in bin_levels
char *levels[] = {"!\x00", "!\x01", "!\x02"};

// Remove ints before exit and free some Memory
// Also switch back to textmode
static void cleanup()
{
  #ifdef DEBUG
    fclose(debug);
  #endif
  save_score();
  free(hi);
  free(buffer);
  remove_timer();
  remove_keyb();
  set_mode_text();
}



int main(int argc, char* argv[])
{
  #ifdef DEBUG
    // The Logfile for debug messages
    // Used because of the screen is gfx mode
    debug = fopen("log.txt", "w");
  #endif
  
  // Here is the converter for the level
  // TODO: move it into a seperate function
  if(argc>1)
  {
    if(argc==4)
    {
      if(strcmp(argv[1], "-c")==0)
      {
        printf("Convert level %s -> %s", argv[2], argv[3]);
        FILE* f = fopen(argv[3], "w");
        int count = read_level(argv[2]);
        fwrite(&count, sizeof(int), 1, f);
        fwrite(level, 32, 20, f);
        fclose(f);
        free(level);
        exit(0);
      }
    }
  }
  
  int difi=2;
  int start_time;
  
  buffer = malloc(33);
  if(!buffer)
  {
    LOG("main: buffer cold not been malloc'd");
    exit(ERROR_MALLOC);
  }
  
  if(atexit(cleanup)) {
    LOG("At exit error");
    #ifdef DEBUG
      fclose(debug);
    #endif
    exit(ERROR_ATEXIT);
  }
  // Install all the drivers and switch to gfx mode
  install_timer();
  set_mode_13h();
  install_keyb();
  init_color();
  
  load_score();
  
  draw_string(0,0,10,COLOR_WHITE,"WELCOME TO QUADRO\nBY HENRY8086\nTHIS IS A PORT TO DOS\nHAVE FUN\nPRESS UP TO CONTINUE...");
  draw();
  // Wait for key_up
  // P = Play editor level
  // E = Editor
  while(!key_up) {
    if(esc) exit(0);
    if(key_e) {
      go_edit();
      while(esc);
    }
    if(key_p) {
      run_level("newlvl.txt");
      while(esc);
    }
    draw_string(0,0,10,COLOR_WHITE,"WELCOME TO QUADRO\nBY HENRY8086\nTHIS IS A PORT TO DOS\nHAVE FUN\nPRESS UP TO CONTINUE...");
    draw();
  }
  
  draw_string(0,0,10,COLOR_WHITE,"CONTROLS:\nMOVE WITH THE ARROW KEYS\nPRESS ESC TO EXIT\nPRESS UP TO CONTINUE...");
  draw();
  while(key_up);
  while(!key_up) if(esc) exit(0);

  // Print the hiscore
  print_score("", 0);
  while(esc);
  
restart:
  // Ask player for Dificulty and set difi
  draw_string(0,0,10,COLOR_WHITE, "DIFICULTI:\nUP: EASY\nRIGHT: MEDIUM\nLEFT: HARD\nDOWN: EXTREME\n\nESC TO EXIT");
  draw();
  while(key_up);
  while(!key_up && !key_left && !key_right && !key_down) if(esc) exit(0);
  if(key_up) difi=2;
  else if(key_right) difi=4;
  else if(key_left) difi=6;
  else if(key_down) difi=8;
  // Calc nops per 55ms/difi
  int nops=timer_calc_nops()/difi;
  
  start_time=timer_gettime();

  // The current level num -> l
  int l=0;
  int lifes=3;
  gameover=0;
  load_level(levels[l]);

  while(1)
  {
    //while(!tick);
    //tick=0;
    if(esc)
    {
      free(go);
      break;
    }
    calc();
    paint();
    // Draw score and lifes
    itoa((timer_gettime()-start_time)/1000,buffer, 10);
    draw_string(290,0,6,COLOR_WHITE,buffer);
    sprintf(buffer, "LIVES: %i", lifes);
    draw_string(0,0,6,COLOR_WHITE,buffer);
    
    draw();
    // If the player lose life by evil -> lose_life=1
    if(lose_life)
    {
      lose_life=0;
      evils=0;
      free(go);
      lifes--;
      if(lifes)
        load_level(levels[l]);
      else
        gameover=1;
    }
    // The player has losed all lifes -> gameover=1
    if(gameover)
    {
      draw_string(0,0,10,COLOR_RED,"GAME OVER\n\nPRESS ESC");
      draw();
      while(!esc);
      while(esc);
      print_score("", 0);
      // Allow player to restart the Game
      goto restart;
    }
    // No more evils player win
    if(!evils)
    {
      free(go);
      l++;
      // If there is no next level the player wins
      if(l>=NUM_LEVELS) {
        int score = (timer_gettime()-start_time)/1000;
        sprintf(buffer, "YOU WIN\n\nSCORE: %i\nPRESS ESC", score);
        draw_string(0,0,10,COLOR_GREEN,buffer);
        draw();
        while(!esc);
        while(esc);
        readname(buffer);
        add_score(buffer, score);
        // Print the hiscore
        print_score(buffer, score);
        break;
      }
      load_level(levels[l]);
    }
    timer_nop(nops);
  }
  return 0;
}
