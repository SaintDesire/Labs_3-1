#include <iostream>
#include <string>
#include <cstring>
#include <winsock2.h>
#include <ws2tcpip.h>

#pragma comment(lib, "ws2_32.lib")

const int BUFFER_SIZE = 1024;
const int PORT = 4000;

int main() {
    WSADATA wsaData;
    if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0) {
        std::cerr << "Failed to initialize winsock" << std::endl;
        return 1;
    }

    SOCKET sockfd;
    char buffer[BUFFER_SIZE];
    sockaddr_in server_addr, client_addr;

    // Создание сокета
    if ((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) == INVALID_SOCKET) {
        std::cerr << "Socket creation failed: " << WSAGetLastError() << std::endl;
        WSACleanup();
        return 1;
    }

    // Настройка адреса сервера
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(PORT);
    server_addr.sin_addr.s_addr = INADDR_ANY;

    // Привязка сокета к адресу сервера
    if (bind(sockfd, (struct sockaddr*)&server_addr, sizeof(server_addr)) == SOCKET_ERROR) {
        std::cerr << "Socket binding failed: " << WSAGetLastError() << std::endl;
        closesocket(sockfd);
        WSACleanup();
        return 1;
    }

    std::cout << "Server listening on port " << PORT << std::endl;

    while (true) {
        int client_len = sizeof(client_addr);

        // Получение сообщения от клиента
        int bytes_received = recvfrom(sockfd, buffer, BUFFER_SIZE, 0, (struct sockaddr*)&client_addr, &client_len);
        if (bytes_received == SOCKET_ERROR) {
            std::cerr << "Error receiving message: " << WSAGetLastError() << std::endl;
            continue;
        }

        // Добавление префикса ECHO: к сообщению
        std::string response = "ECHO: " + std::string(buffer, bytes_received);

        // Отправка ответа клиенту
        int bytes_sent = sendto(sockfd, response.c_str(), response.length(), 0, (struct sockaddr*)&client_addr, client_len);
        if (bytes_sent == SOCKET_ERROR) {
            std::cerr << "Error sending response: " << WSAGetLastError() << std::endl;
            continue;
        }

        char client_ip[INET_ADDRSTRLEN];
        inet_ntop(AF_INET, &(client_addr.sin_addr), client_ip, INET_ADDRSTRLEN);

        std::cout << "Sent response to " << client_ip << ":" << ntohs(client_addr.sin_port) << std::endl;
    }

    closesocket(sockfd);
    WSACleanup();

    return 0;
}