#include <iostream>
#include <cstring>
#include <winsock2.h>
#include <ws2tcpip.h>

#pragma comment(lib, "ws2_32.lib")

const int BUFFER_SIZE = 1024;
const int PORT = 4000;
const char* HOST = "127.0.0.1";

int main() {
    WSADATA wsaData;
    if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0) {
        std::cerr << "Failed to initialize winsock" << std::endl;
        return 1;
    }

    SOCKET sockfd;
    char buffer[BUFFER_SIZE];
    sockaddr_in server_addr;

    // Создание сокета
    if ((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) == INVALID_SOCKET) {
        std::cerr << "Socket creation failed: " << WSAGetLastError() << std::endl;
        WSACleanup();
        return 1;
    }

    // Настройка адреса сервера
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(PORT);
    inet_pton(AF_INET, HOST, &(server_addr.sin_addr));

    const char* message = "Hello, server!";

    // Отправка сообщения серверу
    int bytes_sent = sendto(sockfd, message, strlen(message), 0, (struct sockaddr*)&server_addr, sizeof(server_addr));
    if (bytes_sent == SOCKET_ERROR) {
        std::cerr << "Error sending message: " << WSAGetLastError() << std::endl;
        closesocket(sockfd);
        WSACleanup();
        return 1;
    }

    std::cout << "Sent message to server at " << HOST << ":" << PORT << std::endl;

    sockaddr_in response_addr;
    int response_len = sizeof(response_addr);

    // Получение ответа от сервера
    int bytes_received = recvfrom(sockfd, buffer, BUFFER_SIZE, 0, (struct sockaddr*)&response_addr, &response_len);
    if (bytes_received == SOCKET_ERROR) {
        std::cerr << "Error receiving response: " << WSAGetLastError() << std::endl;
        closesocket(sockfd);
        WSACleanup();
        return 1;
    }

    buffer[bytes_received] = '\0';

    char response_ip[INET_ADDRSTRLEN];
    inet_ntop(AF_INET, &(response_addr.sin_addr), response_ip, INET_ADDRSTRLEN);

    std::cout << "Received response: " << buffer << " from " << response_ip << ":" << ntohs(response_addr.sin_port) << std::endl;

    closesocket(sockfd);
    WSACleanup();

    return 0;
}