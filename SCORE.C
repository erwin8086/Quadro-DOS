/*
   Functions for hiscore
*/
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#include"hi.h"
#include"color.h"
#include"vga.h"
#include"keyb.h"
#include"debug.h"

#define SCORE_FILE "score.hi"

struct hiscore* hi;

// Read player name in buffer
// buffer shold be min size 8 bytes
void readname(char* buffer)
{
  int i;
  int pos=0;
  for(i=0;i<8;i++) buffer[i] = ' ';
  buffer[0] = 'A';
  buffer[7] = '\0';
  while(1)
  {
    while(key_up || key_down || key_left || key_right);
    draw_string(0,0,10,1,"YOUR NAME:");
    draw_string(0,30,10,1, buffer);
    draw();
    // Next letter
    if(key_left)
    {
      if(buffer[pos]==' ') {
        buffer[pos]='Z';
      } else if(buffer[pos]=='A') {
        buffer[pos]=' ';
      } else {
        buffer[pos]--;
        if(buffer[pos]<'A') buffer[pos]='A';
      }
    // Preview letter
    } else if(key_right) {
      if(buffer[pos]==' ') {
        buffer[pos]='A';
      } else if(buffer[pos]=='Z') {
        buffer[pos]=' ';
      } else {
        buffer[pos]++;
        if(buffer[pos]>'Z') buffer[pos]='Z';
      }
    // Next char to read
    } else if(key_up) {
      pos++;
      if(pos<7) buffer[pos]='A';
      else break;
    // Preview char to read deletes current char
    } else if(key_down) {
      if(pos>0) {
        buffer[pos] = ' ';
        pos--;
      }
    }
  }
}

// Load in the hiscore file
int load_score()
{
  hi = malloc(sizeof(struct hiscore)*5);
  if(!hi)
  {
    LOG("Cold not alloc score.c: load_score: hi");
    exit(ERROR_MALLOC);
  }
  memset(hi, 0, sizeof(struct hiscore)*5);
  FILE *f = fopen(SCORE_FILE, "r");
  // If file not exist or cold not be read
  // create empty struct hiscore
  if(!f)
  {
    int i;
    for(i=0;i<5;i++) hi[i].score = -1;
    return 1;
  }

  fread(hi, sizeof(struct hiscore), 5, f);
  fclose(f);
  return 0;
}

// Add score for player:name with score:score
// If score is to low its not be added
int add_score(char* name, int score)
{
  int i,mi;
  for(i=0;i<5;i++)
  {
    if(hi[i].score==-1)
    {
      hi[i].score=score;
      strcpy(hi[i].name, name);
      break;
    } else {
      if(hi[i].score>score)
      {
        for(mi=4;mi>=i;mi--)
        {
          hi[mi+1] = hi[mi];
        }
        hi[i].score = score;
        strcpy(hi[i].name, name);
        break;
      }
    }
  }
  return 0;
}

// Save the hiscore file
int save_score()
{
  FILE *f = fopen(SCORE_FILE, "w");
  if(!f) return 1;
  fwrite(hi, sizeof(struct hiscore), 5, f);
  fclose(f);
  return 0;
}

// calc score for name
int calc_score(int s)
{
  if(s==-1) return 0;
  return s;
}

#define SCORE(a) hi[a].name, calc_score(hi[a].score)

// Print the hiscore screen
// TODO: better displaying of the scores
void print_score(char* name, int score)
{
  char* buffer=malloc(16*6 + 10);
  sprintf(buffer, "TOP 5:\n%s: %i\n%s: %i\n%s: %i\n%s: %i\n%s: %i\n%s: %i\nPRESS ESC...",
    SCORE(0), SCORE(1), SCORE(2), SCORE(3), SCORE(4), name, score);
  draw_string(0,0,8,COLOR_WHITE,buffer);
  draw();
  while(esc);
  while(!esc);
  while(esc);
  free(buffer);
}
