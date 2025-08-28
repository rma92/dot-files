#include <stdio.h>
#include <string.h>
#include <winsock2.h>
#include <ws2tcpip.h>

//#pragma comment(lib, "ws2_32.lib")
//\local\tcc32\tcc.exe web2.c ws2_32.def

#define PORT "29102"
#define BACKLOG 10

int main() {
    WSADATA wsaData;
    int iResult;

    // Initialize Winsock
    if ((iResult = WSAStartup(MAKEWORD(2, 2), &wsaData)) != 0) {
        printf("WSAStartup failed: %d\n", iResult);
        return 1;
    }

    // Prepare server address info
    struct addrinfo hints, *res = NULL;
    SOCKET listen_sock = INVALID_SOCKET;

    ZeroMemory(&hints, sizeof(hints));
    hints.ai_family = AF_INET;        // IPv4
    hints.ai_socktype = SOCK_STREAM;  // TCP socket
    hints.ai_flags = AI_PASSIVE;      // Listen on any IP

    if ((iResult = getaddrinfo(NULL, PORT, &hints, &res)) != 0) {
        printf("getaddrinfo failed: %d\n", iResult);
        WSACleanup();
        return 1;
    }

    // Create a listening socket
    listen_sock = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
    if (listen_sock == INVALID_SOCKET) {
        printf("Socket creation failed: %ld\n", WSAGetLastError());
        freeaddrinfo(res);
        WSACleanup();
        return 1;
    }

    // Bind the socket
    if (bind(listen_sock, res->ai_addr, (int)res->ai_addrlen) == SOCKET_ERROR) {
        printf("Bind failed: %d\n", WSAGetLastError());
        closesocket(listen_sock);
        freeaddrinfo(res);
        WSACleanup();
        return 1;
    }

    freeaddrinfo(res);

    // Start listening
    if (listen(listen_sock, BACKLOG) == SOCKET_ERROR) {
        printf("Listen failed: %d\n", WSAGetLastError());
        closesocket(listen_sock);
        WSACleanup();
        return 1;
    }

    // Initialize the master file descriptor set
    fd_set master_set, read_fds;
    FD_ZERO(&master_set);
    FD_SET(listen_sock, &master_set);
    int fdmax = listen_sock;

    // Define filenames and filedata arrays
    const char *filenames[] = {"/metrics"};
    const char *filedata[] = {"Hello, this is the /metrics endpoint.\n"};

    printf("Server is running on localhost:%s\n", PORT);

    // Main loop
    while (1) {
        read_fds = master_set; // Copy the master set
        if (select(fdmax + 1, &read_fds, NULL, NULL, NULL) == SOCKET_ERROR) {
            printf("Select failed: %d\n", WSAGetLastError());
            break;
        }

        // Iterate through file descriptors
        for (int i = 0; i <= fdmax; i++) {
            if (FD_ISSET(i, &read_fds)) {
                if (i == listen_sock) {
                    // Accept new connection
                    SOCKET client_sock;
                    struct sockaddr_storage client_addr;
                    int addr_len = sizeof(client_addr);

                    client_sock = accept(listen_sock, (struct sockaddr *)&client_addr, &addr_len);
                    if (client_sock == INVALID_SOCKET) {
                        printf("Accept failed: %d\n", WSAGetLastError());
                    } else {
                        FD_SET(client_sock, &master_set);
                        if (client_sock > fdmax) {
                            fdmax = client_sock;
                        }
                    }
                } else {
                    // Handle client data
                    char buf[1024];
                    int recv_bytes = recv(i, buf, sizeof(buf) - 1, 0);
                    if (recv_bytes <= 0) {
                        if (recv_bytes == 0) {
                            printf("Connection closed by client.\n");
                        } else {
                            printf("Recv failed: %d\n", WSAGetLastError());
                        }
                        closesocket(i);
                        FD_CLR(i, &master_set);
                    } else {
                        buf[recv_bytes] = '\0';
                        char method[8], path[256], protocol[16];
                        sscanf(buf, "%s %s %s", method, path, protocol);

                        printf("Request: %s %s %s\n", method, path, protocol);

                        // Search for the requested file
                        int found = 0;
                        for (int j = 0; j < sizeof(filenames) / sizeof(filenames[0]); j++) {
                            if (strcmp(path, filenames[j]) == 0) {
                                char response[1024];
                                int content_length = strlen(filedata[j]);
                                sprintf(response, "HTTP/1.1 200 OK\r\nContent-Length: %d\r\n\r\n%s", content_length, filedata[j]);
                                send(i, response, strlen(response), 0);
                                found = 1;
                                break;
                            }
                        }
                        if (!found) {
                            const char *not_found = "HTTP/1.1 404 Not Found\r\nContent-Length: 13\r\n\r\n404 Not Found";
                            send(i, not_found, strlen(not_found), 0);
                        }
                        closesocket(i);
                        FD_CLR(i, &master_set);
                    }
                }
            }
        }
    }

    // Cleanup
    closesocket(listen_sock);
    WSACleanup();
    return 0;
}

