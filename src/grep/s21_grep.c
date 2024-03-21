#include "s21_grep.h"
#define MAX_PATTERNS 1024

int main(int argc, char *argv[]) {
  char *pattern[1024];
  Flags flags = {0};
  install_flags(&argc, argv, pattern, &flags);
  output(argc, argv, pattern, flags);
  return 0;
}

void install_flags(int *argc, char *argv[], char *pattern[], Flags *flags) {
  int opt, i = 0;
  while ((opt = getopt_long(*argc, argv, "e:ivclnhs", 0, 0)) != -1) {
    switch (opt) {
      case 'e':
        flags->e = 1;
        pattern[i++] = optarg;
        break;
      case 'i':
        flags->i = 1;
        break;
      case 'v':
        flags->v = 1;
        break;
      case 'c':
        flags->c = 1;
        break;
      case 'l':
        flags->l = 1;
        break;
      case 'n':
        flags->n = 1;
        break;
      case 'h':
        flags->h = 1;
        break;
      case 's':
        flags->s = 1;
        break;
    }
  }
  if (flags->e && optind + 1 < *argc) {
    flags->count_files = 1;
  }
  if (optind + 2 < *argc) {
    flags->count_files = 1;
  }
  if (flags->l) {
    flags->v = 0;
  }
}

void output(int argc, char *argv[], char *pattern[], Flags flags) {
  char ch[1024];
  int flag = REG_EXTENDED, len = 0, count_string_match = 0, stopper = 0,
      curr_string_number = 1, match_result = 0;
  int count_match[MAX_PATTERNS] = {0};
  int count_files = argc - optind;
  int show_filename = count_files > 1;
  regex_t regex;

  if (flags.i) {
    flag = REG_ICASE;
  }

  for (int j = 0; j < flags.e; j++) {
    for (int i = optind; i < argc; i++) {
      FILE *file = fopen(argv[i], "r");
      if (file != NULL) {
        match_result = regcomp(&regex, pattern[j], flag);
        while (fgets(ch, 1024, file) != NULL) {
          match_result = regexec(&regex, ch, 0, NULL, 0);
          len = strlen(ch);
          if (ch[len - 1] == '\n') {
            ch[len - 1] = '\0';
          }
          if (!match_result && flags.v == 0) {
            if (show_filename) {
              printf("%s:", argv[i]);
            }
            printf("%s\n", ch);
            count_match[j]++;
          }
        }
        fseek(file, 0, SEEK_SET);
        stopper = 0;
        fclose(file);
      } else {
        if (flags.s != 1) {
          printf("grep: %s: No such file or directory\n", argv[i]);
        }
      }
      regfree(&regex);
    }
  }

  regcomp(&regex, argv[optind], flag);
  optind++;

  for (; optind < argc; optind++) {
    FILE *file = fopen(argv[optind], "r");
    if (file != NULL) {
      while (fgets(ch, 1024, file) != NULL && stopper == 0) {
        count_string_match =
            print_regex(count_string_match, &match_result, regex, len, argv,
                        &stopper, &curr_string_number, ch, flags);
        curr_string_number++;
      }
      if (flags.c) {
        print_count(argv, &count_string_match, flags);
      }
      stopper = 0;
      curr_string_number = 1;
      fclose(file);
    }
    if (file == NULL && flags.s == 0) {
      printf("s21_grep: %s: No such file or directory\n", argv[optind]);
    }
  }
  regfree(&regex);
}

int print_regex(int count_string_match, int *match_result, regex_t regex,
                int len, char *argv[], int *stopper, int *curr_string_number,
                char *ch, Flags flags) {
  *match_result = regexec(&regex, ch, 0, NULL, 0);
  len = strlen(ch);
  if (ch[len - 1] == '\n') {
    ch[len - 1] = '\0';
  }
  if (*match_result) {
    print_v(argv, ch, flags);
  }
  if (!(*match_result) && flags.v == 0) {
    if (flags.l) {
      printf("%s\n", argv[optind]);
      *stopper = 1;
    }
    if (*stopper == 0) {
      print_match(argv, *stopper, curr_string_number, ch, flags);
    }
    count_string_match++;
  }
  if (flags.v && *match_result) {
    count_string_match++;
  }
  return count_string_match;
}

void print_match(char *argv[], int stopper, int *curr_string_number, char *ch,
                 Flags flags) {
  if (flags.n && stopper == 0) {
    if (flags.count_files) {
      printf("%s:", argv[optind]);
    }
    printf("%d:%s\n", *curr_string_number, ch);
  }
  if (flags.h && flags.c == 0) {
    printf("%s\n", ch);
  }
  if (flags.count_files && !flags.c && !flags.n && !flags.h && flags.e == 0) {
    printf("%s:", argv[optind]);
  }
  if (!flags.c && !flags.n && !flags.h && flags.e == 0) {
    printf("%s\n", ch);
  }
}

void print_count(char *argv[], int *count_string_match, Flags flags) {
  if (flags.count_files && flags.h == 0) {
    printf("%s:", argv[optind]);
  }
  printf("%d\n", *count_string_match);
  *count_string_match = 0;
}

void print_v(char *argv[], char *ch, Flags flags) {
  if (flags.v) {
    if (flags.count_files && flags.c == 0) {
      printf("%s:", argv[optind]);
    }
    if (flags.c == 0) {
      printf("%s\n", ch);
    }
  }
}
