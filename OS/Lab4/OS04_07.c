#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

// Структура для передачи данных в поток
struct ThreadData {
    pid_t processId;
};

// Потоковая функция
void* OS04_07_T1(void* arg) {
    struct ThreadData* data = (struct ThreadData*)arg;

    for (int i = 0; i < 75; ++i) {
        printf("Process ID: %d, Thread ID: %lu\n", data->processId, pthread_self());
        fflush(stdout);  // Очистка буфера вывода

        // Временная задержка в секундах
        sleep(1);
    }

    return NULL;
}

int main() {
    pid_t processId = getpid();
    printf("Process ID: %d\n", processId);

    // Инициализация структуры с данными для передачи в поток
    struct ThreadData data;
    data.processId = processId;

    // Создание потока
    pthread_t thread;
    if (pthread_create(&thread, NULL, OS04_07_T1, (void*)&data) != 0) {
        fprintf(stderr, "Error creating thread\n");
        return 1;
    }

    // Ожидание завершения потока
    if (pthread_join(thread, NULL) != 0) {
        fprintf(stderr, "Error joining thread\n");
        return 1;
    }

    return 0;
}
