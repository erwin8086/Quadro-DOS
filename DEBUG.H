#define DEBUG
#ifdef DEBUG
  #ifdef MAIN_C
    FILE* debug;
  #else
    extern FILE* debug;
  #endif
  #define LOG(s) fputs(s, debug)
#else
  #define LOG(s)
#endif

#define ERROR_UNKNOWN_ENTITY 5
#define ERROR_COUNT 6
#define ERROR_ATEXIT 7
#define ERROR_MOUSE 8
#define ERROR_OVERFLOW 9
#define ERROR_MALLOC 10
#define ERROR_FOPEN 11
