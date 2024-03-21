#ifndef S21_GREP_H
#define S21_GREP_H

#include <getopt.h>
#include <regex.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

typedef struct {
  int e;
  int i;
  int v;
  int c;
  int l;
  int n;
  int h;
  int s;
  int count_files;
} Flags;

void install_flags(int *argc, char *argv[], char *pattern[], Flags *flags);
int print_regex(int count_string_match, int *match_result, regex_t regex,
                int len, char *argv[], int *stopper, int *curr_string_number,
                char *ch, Flags flags);
void print_match(char *argv[], int stopper, int *curr_string_number, char *ch,
                 Flags flags);
void print_count(char *argv[], int *count_string_match, Flags flags);
void print_v(char *argv[], char *ch, Flags flags);
void output(int argc, char *argv[], char *pattern[], Flags flags);

#endif
