#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <winsock2.h>
#include <ws2tcpip.h>

//#pragma comment(lib, "Ws2_32.lib")
//\local\tcc32\tcc.exe web1.c ws2_32.def

#define PORT 29102
#define BACKLOG 10
#define BUFSIZE 1024

// File data
const char *filenames[] = {"/metrics"};
const char *filedata[] = {"server_requests_total 42\n"};

void handle_client(SOCKET client_socket) {
    char buffer[BUFSIZE];
    int bytes_received = recv(client_socket, buffer, BUFSIZE - 1, 0);

    if (bytes_received == SOCKET_ERROR) {
        perror("recv");
        closesocket(client_socket);
        return;
    }

    buffer[bytes_received] = '\0'; // Null-terminate the request
    printf("Received request:\n%s\n", buffer);

    // Parse the request to get the requested path
    char method[BUFSIZE], path[BUFSIZE], protocol[BUFSIZE];
    sscanf(buffer, "%s %s %s", method, path, protocol);

    // Only handle GET requests
    if (strcmp(method, "GET") != 0) {
        const char *response = "HTTP/1.1 405 Method Not Allowed\r\n\r\n";
        send(client_socket, response, strlen(response), 0);
        closesocket(client_socket);
        return;
    }

    // Check if the requested path matches the known filenames
    int found = 0;
    for (size_t i = 0; i < sizeof(filenames) / sizeof(filenames[0]); ++i) {
        if (strcmp(path, filenames[i]) == 0) {
            found = 1;
            const char *response_header = "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\n";
            send(client_socket, response_header, strlen(response_header), 0);
            send(client_socket, filedata[i], strlen(filedata[i]), 0);
            break;
        }
    }

    if (!found) {
        const char *response = "HTTP/1.1 404 Not Found\r\n\r\n";
        send(client_socket, response, strlen(response), 0);
    }

    closesocket(client_socket);
}

int main() {
    WSADATA wsaData;
    SOCKET server_socket;
    struct sockaddr_in server_addr;
    fd_set read_fds;

    // Initialize Winsock
    if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0) {
        fprintf(stderr, "WSAStartup failed.\n");
        return 1;
    }

    // Create a socket
    server_socket = socket(AF_INET, SOCK_STREAM, 0);
    if (server_socket == INVALID_SOCKET) {
        perror("socket");
        WSACleanup();
        return 1;
    }

    // Set up the server address
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
    server_addr.sin_port = htons(PORT);

    // Bind the socket
    if (bind(server_socket, (struct sockaddr *)&server_addr, sizeof(server_addr)) == SOCKET_ERROR) {
        perror("bind");
        closesocket(server_socket);
        WSACleanup();
        return 1;
    }

    // Listen for incoming connections
    if (listen(server_socket, BACKLOG) == SOCKET_ERROR) {
        perror("listen");
        closesocket(server_socket);
        WSACleanup();
        return 1;
    }

    printf("Server listening on http://127.0.0.1:%d\n", PORT);

    // Main loop
    while (1) {
        FD_ZERO(&read_fds);
        FD_SET(server_socket, &read_fds);

        // Wait for activity
        if (select(0, &read_fds, NULL, NULL, NULL) == SOCKET_ERROR) {
            perror("select");
            break;
        }

        // Check for new connections
        if (FD_ISSET(server_socket, &read_fds)) {
            struct sockaddr_in client_addr;
            int addr_len = sizeof(client_addr);
            SOCKET client_socket = accept(server_socket, (struct sockaddr *)&client_addr, &addr_len);

            if (client_socket == INVALID_SOCKET) {
                perror("accept");
                continue;
            }

            printf("New connection accepted.\n");
            handle_client(client_socket);
        }
    }

    // Cleanup
    closesocket(server_socket);
    WSACleanup();
    return 0;
}

