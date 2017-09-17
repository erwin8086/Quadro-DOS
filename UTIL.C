/*
  Some util functions
*/
#include"go.h"
#include"util.h"
#include"const.h"
// The count of GameObejects
extern int count;
extern struct gameobject* go;

// Check if rectA and rectB colidates
int rect_col(int aleft, int aright, int atop, int abottom,
             int bleft, int bright, int btop, int bbottom)
{
  return aleft < bright && aright > bleft &&
         atop < bbottom && abottom > btop;
}

// Move Gameobject on x axis
// Not allow move inside of Walls
// dest = -1 or 1
int move_go_x(int dest, struct gameobject* g, int x)
{
  int i,c=0;
  g->x+=x*dest;
  // Check if move go inside of wall and undo it slow
  for(i=0;i<count;i++)
  {
    if(go[i].attr & ATTR_WALL)
    {
      while(go_col(g, &go[i])) {
        g->x-=dest;
        c=1;
      }
    }
  }
  return c;
}

// Jumps gameobject g: g->y+=y
int jump_go(struct gameobject* g, int y)
{
  int i;
  while(y)
  {
    g->y--;
    y--;
    for(i=0;i<count;i++)
    {
      if(go[i].attr & ATTR_WALL)
      {
        if(go_col(g, &go[i]))
        {
          g->y++;
          break;
        }
      }
    }
  }
  return 0;
}

// Checks if Gameobjects collidates
int go_col(struct gameobject* a, struct gameobject* b)
{
  return rect_col(a->x, a->x+10, a->y, a->y+10,
                  b->x, b->x+10, b->y, b->y+10);
}

// Check if a Wall is under x,y
int is_wall(int x, int y)
{
  int i;
  for(i=0;i<count;i++)
  {
    if(go[i].attr & ATTR_FOOD)
    {
      if(x < go[i].x+10 && x+10 > go[i].x && go[i].y <= y+10 && go[i].y+10 > y) return 1;
    }
  }
  return 0;
}
