/*
  Read Level txt files in
*/
#include<stdio.h>
#include<stdlib.h>

#include"level.h"
#include"debug.h"

char* level;
// When you use this function you have to free level after use
int read_level(char* file)
{
  LOG("Loading level\n");
  level = malloc(20*32);
  if(!level)
  {
    LOG("Error alloc level.c: read_level: level");
    exit(ERROR_MALLOC);
  }
  
  char* buffer = malloc(64);
  if(!buffer)
  {
    LOG("Error alloc level.c: read_level: buffer");
    exit(ERROR_MALLOC);
  }
  
  FILE *f = fopen(file, "r");
  if(f == NULL) return 0;
  int y=0, x, count=0;
  while(!feof(f))
  {
    if(!fgets(buffer, 64, f)) break;
    for(x=0;x<32;x++)
    {
      if(buffer[x]==' ' || buffer[x] =='\n' || buffer[x]=='\t' || buffer[x]=='\r')
      {
        level[y*32+x] = 0;
      } else if(buffer[x]) {
        level[y*32+x] = buffer[x];
        count++;
      } else {
        for(;x<32;x++) level[y*32+x] = 0;
        break;
      }
    }
    y++;
    if(y>=20) break;
  }
  // Clear unused spots in level
  for(;y<20;y++) for(x=0;x<32;x++) level[y*32+x] = 0;
  
  fclose(f);
  free(buffer);
  LOG("Level Loaded\n");
  return count;
}
