#include <stdio.h>
#include <unistd.h>

int main() {
    for (int i = 0; i < 100; ++i) {
        printf("Process ID: %d\n", getpid());
        fflush(stdout);  // Очистка буфера вывода

        // Временная задержка в секундах
        sleep(1);
    }

    return 0;
}
