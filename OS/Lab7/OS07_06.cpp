#include <iostream>
#include <chrono>
#include <unistd.h>

int main() {
    using namespace std::chrono;

    int iterations = 0;
    auto startTime = high_resolution_clock::now();
    auto startTimeSecondTimer = high_resolution_clock::now();

    while (true) {
        // �������� ������������ ����� ������ 2 �������
        auto currentTime = high_resolution_clock::now();
        auto elapsedSeconds = duration_cast<seconds>(currentTime - startTime).count();
        auto elapsedSecondsFromStart = duration_cast<seconds>(currentTime - startTimeSecondTimer).count();

        if (elapsedSeconds >= 2) {
            std::cout << "�����: " << elapsedSecondsFromStart;
            std::cout << "\t�������� �������� ��������: " << iterations << std::endl;
            startTime = currentTime;
        }
        iterations++;

        // �������� ���������� ������� ��� �������� �������� ����������
        usleep(100000);  // ����� 100 ����������� (1 ������� ����������� = 1 �������)
    }

    return 0;
}