all: s21_grep test_grep

CC = gcc -Wall -Werror -Wextra

s21_grep: s21_grep.c
	$(CC) -o s21_grep s21_grep.c

test_grep:
	./test_grep.sh

clean:
	rm -rf *.o s21_grep
	rm -rf logs

rebuild: clean all