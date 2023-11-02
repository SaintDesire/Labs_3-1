#include <iostream>
#include <ctime>

int main() {
    // �������� ������� ��������� ���� � �����
    time_t currentTime = time(nullptr);
    struct tm localTimeInfo;
    localtime_r(&currentTime, &localTimeInfo);

    // ����������� � ������� ���� � �����
    char buffer[80];
    strftime(buffer, sizeof(buffer), "%d.%m.%Y %H:%M:%S", &localTimeInfo);
    std::cout << "������� ��������� ���� � �����: " << buffer << std::endl;

    return 0;
}
