all: s21_cat test_cat

CC = gcc -Wall -Werror -Wextra

s21_cat: s21_cat.c
	$(CC) -o s21_cat s21_cat.c

test_cat:
	./test_func_cat.sh

clean:
	rm -rf *.o s21_cat

rebuild: clean all