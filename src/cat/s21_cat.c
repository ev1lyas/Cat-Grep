#include "s21_cat.h"

int main(int argc, char *argv[]) {
  Flags flags = {0};
  install_flags(&flags, argc, argv);

  for (int i = 1; i < argc; i++) {
    if (argv[i][0] != '-') {
      print_file(argv[i], flags);
    }
  }

  return 0;
}

void install_flags(Flags *flags, int argc, char **argv) {
  for (int i = 1; i < argc; i++) {
    if (argv[i][0] == '-') {
      if (argv[i][1] != '-') {
        for (int j = 1; argv[i][j] != '\0'; j++) {
          switch (argv[i][j]) {
            case 'b':
              flags->b = 1;
              break;
            case 'e':
              flags->v = 1;
              flags->e = 1;
              break;
            case 'n':
              flags->n = 1;
              break;
            case 's':
              flags->s = 1;
              break;
            case 't':
              flags->v = 1;
              flags->t = 1;
              break;
            case 'v':
              flags->v = 1;
              break;
            case 'E':
              flags->e = 1;
              break;
            case 'T':
              flags->t = 1;
              break;
            default:
              break;
          }
        }
      } else {
        if (strcmp(argv[i], "--number-nonblank") == 0) {
          flags->b = 1;
        } else if (strcmp(argv[i], "--squeeze-blank") == 0) {
          flags->s = 1;
        } else if (strcmp(argv[i], "--number") == 0) {
          flags->n = 1;
        }
      }
    }
  }
}

void print_file(char *file_name, Flags flags) {
  FILE *file = fopen(file_name, "r");
  if (file == NULL) {
    fprintf(stderr, "cat: %s: No such file or directory\n", file_name);
    exit(EXIT_FAILURE);
  }

  int prev_char = '\n';
  int curr_char;
  int empty_line_count = 0;
  int line_number = 1;

  while ((curr_char = fgetc(file)) != EOF) {
    if (flags.s && curr_char == '\n' && prev_char == '\n') {
      empty_line_count++;
    } else {
      empty_line_count = 0;
    }

    if (empty_line_count <= 1) {
      if (((flags.n && prev_char == '\n') && !flags.b) ||
          (flags.b && prev_char == '\n' && curr_char != '\n')) {
        printf("%6d\t", line_number++);
      }
      if (flags.v) {
        flag_v(&curr_char);
        if (flags.e) {
          if (curr_char == '\n') {
            putchar('$');
          }
          if (flags.v) {
            flag_v(&curr_char);
          }
        }
        if (flags.t && curr_char == '\t') {
          putchar('^');
          curr_char = 'I';
        }
      }

      putchar(curr_char);
      prev_char = curr_char;
    }
  }
  fclose(file);
}

void flag_v(int *symbol) {
  if ((*symbol >= 0 && *symbol <= 31 && *symbol != 9 && *symbol != 10)) {
    *symbol += 64;
    putchar('^');
  } else if (*symbol == 127) {
    *symbol -= 64;
    putchar('^');
  }
}