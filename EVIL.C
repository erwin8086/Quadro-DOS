#include<stdlib.h>

#include"go.h"
#include"const.h"
#include"evil.h"
#include"util.h"
#include"color.h"
#include"vga.h"

int get_evil_stats(struct gameobject* g)
{
  if(g==NULL) return 0;
  
  int stats=0;
  switch(g->type)
  {
    case KROT_EVIL:
      stats |= EVIL_IS_KROT;
      break;
    case SIMPLE_EVIL:
      break;
  }
  return stats;
}


int calc_evil(struct gameobject* g)
{
  if(g==NULL) return 1;
  
  int stats = get_evil_stats(g);
  // Let evil fall Down
  int wall;
  wall = is_wall(g->x, g->y+1);
  if(!wall) g->y+=EVIL_MOVE;
  while(is_wall(g->x, g->y)) g->y--;

  // Move evil x axis
  if(g->attr & ATTR_DEST) {
    // Krot evil keep on Platform
    if((stats & EVIL_IS_KROT) && !is_wall(g->x-EVIL_MOVE-10, g->y+1)) g->attr &= ~ATTR_DEST;
    else if(move_go_xm(g, EVIL_MOVE)) g->attr &= ~ATTR_DEST;
  } else {
    if((stats & EVIL_IS_KROT) && !is_wall(g->x+EVIL_MOVE+10, g->y+1)) g->attr |= ATTR_DEST;
    else if(move_go_xp(g, EVIL_MOVE)) g->attr |= ATTR_DEST;
  }

  // Dont move out of the Screen
  if(g->x<0)
  {
     g->x=0;
     g->attr &= ~ATTR_DEST;
   } else if (g->x>309) {
     g->x=309;
     g->attr |= ATTR_DEST;
   }

   // Dont fall out of the Screen
   if(g->y>189) g->y=189;
   return 0;
}

int paint_evil(struct gameobject *g)
{
  if(g==NULL) return 1;
  
  int color;
  switch(g->type)
  {
    case KROT_EVIL:   color=COLOR_KEVIL;  break;
    case SIMPLE_EVIL: color=COLOR_SEVIL;  break;
    default:          color=COLOR_WHITE;  break;
  }
  // Evils are simple rects
  return draw_rect(g->x, g->y, 10, 10, color);
}
