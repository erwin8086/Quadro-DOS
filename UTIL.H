#define move_go_xp(a,b) move_go_x(1,a,b)
#define move_go_xm(a,b) move_go_x(-1,a,b)

int rect_col(int aleft, int aright, int atop, int abottom,
             int bleft, int bright, int btop, int bbottom);

int move_go_x(int dest, struct gameobject* g, int x);

int jump_go(struct gameobject* g, int y);

int go_col(struct gameobject* a, struct gameobject* b);

int is_wall(int x, int y);
