#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
  int b;
  int e;
  int n;
  int s;
  int t;
  int v;
} Flags;

void install_flags(Flags *flags, int argc, char **argv);
void print_file(char *file, Flags flags);
void flag_v(int *c);