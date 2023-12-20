#include <iostream>
#include <winsock2.h>
#include <ws2tcpip.h>

#pragma comment(lib, "ws2_32.lib")

#define DEFAULT_PORT "3000"
#define BUFFER_SIZE 1024

int main() {
    setlocale(LC_ALL, "Russian");
    WSADATA wsaData;
    if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0) {
        std::cerr << "Failed to initialize Winsock" << std::endl;
        return 1;
    }

    struct addrinfo* result = NULL, hints;
    ZeroMemory(&hints, sizeof(hints));
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = IPPROTO_TCP;
    hints.ai_flags = AI_PASSIVE;

    if (getaddrinfo(NULL, DEFAULT_PORT, &hints, &result) != 0) {
        std::cerr << "Failed to get address information" << std::endl;
        WSACleanup();
        return 1;
    }

    SOCKET listenSocket = socket(result->ai_family, result->ai_socktype, result->ai_protocol);
    if (listenSocket == INVALID_SOCKET) {
        std::cerr << "Failed to create socket" << std::endl;
        freeaddrinfo(result);
        WSACleanup();
        return 1;
    }

    if (bind(listenSocket, result->ai_addr, (int)result->ai_addrlen) == SOCKET_ERROR) {
        std::cerr << "Failed to bind socket" << std::endl;
        freeaddrinfo(result);
        closesocket(listenSocket);
        WSACleanup();
        return 1;
    }

    freeaddrinfo(result);

    if (listen(listenSocket, SOMAXCONN) == SOCKET_ERROR) {
        std::cerr << "Failed to set socket to listening mode" << std::endl;
        closesocket(listenSocket);
        WSACleanup();
        return 1;
    }

    std::cout << "Server started, waiting for connections..." << std::endl;

    SOCKET clientSocket = INVALID_SOCKET;
    char buffer[BUFFER_SIZE];
    int bytesRead;

    while (true) {
        clientSocket = accept(listenSocket, NULL, NULL);
        if (clientSocket == INVALID_SOCKET) {
            std::cerr << "Failed to accept client" << std::endl;
            closesocket(listenSocket);
            WSACleanup();
            return 1;
        }

        while (true) {
            bytesRead = recv(clientSocket, buffer, BUFFER_SIZE, 0);
            if (bytesRead > 0) {
                std::string message(buffer, bytesRead);
                std::cout << "Received message from client: " << message << std::endl;

                std::string response = "ECHO: " + message;
                if (send(clientSocket, response.c_str(), response.length(), 0) == SOCKET_ERROR) {
                    std::cerr << "Failed to send data to client" << std::endl;
                    closesocket(clientSocket);
                    WSACleanup();
                    return 1;
                }

                std::cout << "Sent message to client: " << response << std::endl;

                if (message == "exit") {
                    break;
                }
            }
            else if (bytesRead == 0) {
                std::cout << "Client disconnected" << std::endl;
                break;
            }
            else {
                std::cerr << "Failed to receive data from client" << std::endl;
                closesocket(clientSocket);
                WSACleanup();
                return 1;
            }
        }

        closesocket(clientSocket);
    }

    closesocket(listenSocket);
    WSACleanup();

    return 0;
}