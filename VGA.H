#define SCREEN_W 320
#define SCREEN_H 200

void set_mode_13h();
void set_mode_text();
int draw_rect(int x1, int y1, int width, int height, char color);
int draw_line(int x1, int y1, int step, int len, char color);
int draw_seg(int x, int y, int size, char color, unsigned int out);
int draw_char(int x, int y, int size, char color, char c);
int draw_string(int x, int y, int size, char color, char* str);
void draw();
