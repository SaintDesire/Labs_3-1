#include <stdio.h>
#include <unistd.h>

int main() {
    for (int i = 0; i < 100; ++i) {
        printf("Process ID: %d\n", getpid());
        fflush(stdout);  // ������� ������ ������

        // ��������� �������� � ��������
        sleep(1);
    }

    return 0;
}
