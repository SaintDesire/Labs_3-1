#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

// ��������� ��� �������� ������ � �����
struct ThreadData {
    pid_t processId;
};

// ��������� �������
void* OS04_08_T1(void* arg) {
    struct ThreadData* data = (struct ThreadData*)arg;

    for (int i = 0; i < 75; ++i) {
        printf("Process ID: %d, Thread ID: %lu\n", data->processId, pthread_self());
        fflush(stdout);  // ������� ������ ������

        // �������� �� 50-� ��������
        if (i == 49) {
            printf("Thread OS04_08_T1 is sleeping for 10 seconds at iteration 50\n");
            fflush(stdout);
            sleep(10);
            printf("Thread OS04_08_T1 has awakened at iteration 51\n");
            fflush(stdout);
        }

        // ��������� �������� � ��������
        sleep(1);
    }

    return NULL;
}

int main() {
    pid_t processId = getpid();
    printf("Process ID: %d\n", processId);

    // ������������� ��������� � ������� ��� �������� � �����
    struct ThreadData data;
    data.processId = processId;

    for (int i = 0; i < 100; ++i) {
        printf("Main thread iteration: %d\n", i);
        fflush(stdout);

        // �������� �� 30-� ��������
        if (i == 29) {
            printf("Main thread is sleeping for 15 seconds at iteration 30\n");
            fflush(stdout);
            sleep(15);
            printf("Main thread has awakened at iteration 31\n");
            fflush(stdout);
        }

        // ��������� �������� � ��������
        sleep(1);
    }

    // �������� ������
    pthread_t thread;
    if (pthread_create(&thread, NULL, OS04_08_T1, (void*)&data) != 0) {
        fprintf(stderr, "Error creating thread\n");
        return 1;
    }

    // �������� ���������� ������
    if (pthread_join(thread, NULL) != 0) {
        fprintf(stderr, "Error joining thread\n");
        return 1;
    }

    return 0;
}
