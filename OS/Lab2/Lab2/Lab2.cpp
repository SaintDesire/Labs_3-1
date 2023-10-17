#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {
    for (int i = 1; i <= 1000; i++) {
        pid_t pid = getpid();
        printf("PID: %d, Номер сообщения: %d\n", pid, i);
        fflush(stdout); // Очистить буфер вывода
        sleep(2); // Задержка в 2 секунды
    }
    return 0;
}
