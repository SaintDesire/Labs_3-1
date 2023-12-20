#include <iostream>
#include <winsock2.h>
#include <ws2tcpip.h>

#pragma comment(lib, "ws2_32.lib")

#define DEFAULT_PORT "3000"
#define DEFAULT_BUFFER_SIZE 1024

int main() {
    setlocale(LC_ALL, "Russian");
    WSADATA wsaData;
    if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0) {
        std::cerr << "Failed to initialize Winsock" << std::endl;
        return 1;
    }
    struct addrinfo* result = NULL, * ptr = NULL, hints;
    ZeroMemory(&hints, sizeof(hints));
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = IPPROTO_TCP;

    if (getaddrinfo("localhost", DEFAULT_PORT, &hints, &result) != 0) {
        std::cerr << "Failed to get address information" << std::endl;
        WSACleanup();
        return 1;
    }

    SOCKET connectSocket = INVALID_SOCKET;
    for (ptr = result; ptr != NULL; ptr = ptr->ai_next) {
        connectSocket = socket(ptr->ai_family, ptr->ai_socktype, ptr->ai_protocol);
        if (connectSocket == INVALID_SOCKET) {
            std::cerr << "Failed to create socket" << std::endl;
            WSACleanup();
            return 1;
        }

        if (connect(connectSocket, ptr->ai_addr, (int)ptr->ai_addrlen) == SOCKET_ERROR) {
            std::cerr << "Failed to connect to server" << std::endl;
            closesocket(connectSocket);
            connectSocket = INVALID_SOCKET;
            continue;
        }

        break;
    }

    freeaddrinfo(result);

    if (connectSocket == INVALID_SOCKET) {
        std::cerr << "Failed to connect to server" << std::endl;
        WSACleanup();
        return 1;
    }

    std::cout << "Successfully connected to server" << std::endl;

    char buffer[DEFAULT_BUFFER_SIZE];
    int bytesRead;

    while (true) {
        std::cout << "Enter a message to send to the server: ";
        std::cin.getline(buffer, DEFAULT_BUFFER_SIZE);

        if (send(connectSocket, buffer, strlen(buffer), 0) == SOCKET_ERROR) {
            std::cerr << "Failed to send data to server" << std::endl;
            closesocket(connectSocket);
            WSACleanup();
            return 1;
        }

        if (strcmp(buffer, "exit") == 0) {
            std::cout << "Disconnecting from server..." << std::endl;
            break;
        }

        while (true) {
            bytesRead = recv(connectSocket, buffer, DEFAULT_BUFFER_SIZE, 0);
            if (bytesRead > 0) {
                std::string response(buffer, bytesRead);
                std::cout << "Received message from server: " << response << std::endl;
                break;
            }
            else if (bytesRead == 0) {
                std::cout << "Connection to server closed" << std::endl;
                closesocket(connectSocket);
                WSACleanup();
                return 0;
            }
            else {
                std::cerr << "Failed to receive data from server" << std::endl;
                closesocket(connectSocket);
                WSACleanup();
                return 1;
            }
        }
    }

    closesocket(connectSocket);
    WSACleanup();

    return 0;
}