#ifndef SQLITE_WRAPPER_H
#define SQLITE_WRAPPER_H

#include <windows.h>
#include <stdint.h>
//Header file to use Windows System Sqlite from C programs
//
// Define function pointers for the SQLite functions
typedef int (*sqlite3_open16_t)(const wchar_t* filename, void** db);
typedef int (*sqlite3_prepare16_t)(void* db, const wchar_t* query, int len, void** stmt, void* dummy);
typedef int (*sqlite3_step_t)(void* stmt);
typedef int (*sqlite3_column_count_t)(void* stmt);
typedef const void* (*sqlite3_column_name16_t)(void* stmt, int col);
typedef int (*sqlite3_column_type_t)(void* stmt, int col);
typedef double (*sqlite3_column_double_t)(void* stmt, int col);
typedef int (*sqlite3_column_int_t)(void* stmt, int col);
typedef int64_t (*sqlite3_column_int64_t)(void* stmt, int col);
typedef const void* (*sqlite3_column_text16_t)(void* stmt, int col);
typedef const void* (*sqlite3_column_blob_t)(void* stmt, int col);
typedef int (*sqlite3_column_bytes_t)(void* stmt, int col);
typedef int (*sqlite3_finalize_t)(void* stmt);
typedef int (*sqlite3_close_v2_t)(void* db);

// Global variables to store function pointers
extern sqlite3_open16_t sqlite3_open16;
extern sqlite3_prepare16_t sqlite3_prepare16;
extern sqlite3_step_t sqlite3_step;
extern sqlite3_column_count_t sqlite3_column_count;
extern sqlite3_column_name16_t sqlite3_column_name16;
extern sqlite3_column_type_t sqlite3_column_type;
extern sqlite3_column_double_t sqlite3_column_double;
extern sqlite3_column_int_t sqlite3_column_int;
extern sqlite3_column_int64_t sqlite3_column_int64;
extern sqlite3_column_text16_t sqlite3_column_text16;
extern sqlite3_column_blob_t sqlite3_column_blob;
extern sqlite3_column_bytes_t sqlite3_column_bytes;
extern sqlite3_finalize_t sqlite3_finalize;
extern sqlite3_close_v2_t sqlite3_close_v2;

// Function to initialize SQLite dynamic loading
int init_sqlite();

sqlite3_open16_t sqlite3_open16 = NULL;
sqlite3_prepare16_t sqlite3_prepare16 = NULL;
sqlite3_step_t sqlite3_step = NULL;
sqlite3_column_count_t sqlite3_column_count = NULL;
sqlite3_column_name16_t sqlite3_column_name16 = NULL;
sqlite3_column_type_t sqlite3_column_type = NULL;
sqlite3_column_double_t sqlite3_column_double = NULL;
sqlite3_column_int_t sqlite3_column_int = NULL;
sqlite3_column_int64_t sqlite3_column_int64 = NULL;
sqlite3_column_text16_t sqlite3_column_text16 = NULL;
sqlite3_column_blob_t sqlite3_column_blob = NULL;
sqlite3_column_bytes_t sqlite3_column_bytes = NULL;
sqlite3_finalize_t sqlite3_finalize = NULL;
sqlite3_close_v2_t sqlite3_close_v2 = NULL;

int init_sqlite() {
    HMODULE hModule = LoadLibraryW(L"winsqlite3.dll");
    if (!hModule) {
        return -1; // Failed to load the library
    }

    sqlite3_open16 = (sqlite3_open16_t)GetProcAddress(hModule, "sqlite3_open16");
    sqlite3_prepare16 = (sqlite3_prepare16_t)GetProcAddress(hModule, "sqlite3_prepare16");
    sqlite3_step = (sqlite3_step_t)GetProcAddress(hModule, "sqlite3_step");
    sqlite3_column_count = (sqlite3_column_count_t)GetProcAddress(hModule, "sqlite3_column_count");
    sqlite3_column_name16 = (sqlite3_column_name16_t)GetProcAddress(hModule, "sqlite3_column_name16");
    sqlite3_column_type = (sqlite3_column_type_t)GetProcAddress(hModule, "sqlite3_column_type");
    sqlite3_column_double = (sqlite3_column_double_t)GetProcAddress(hModule, "sqlite3_column_double");
    sqlite3_column_int = (sqlite3_column_int_t)GetProcAddress(hModule, "sqlite3_column_int");
    sqlite3_column_int64 = (sqlite3_column_int64_t)GetProcAddress(hModule, "sqlite3_column_int64");
    sqlite3_column_text16 = (sqlite3_column_text16_t)GetProcAddress(hModule, "sqlite3_column_text16");
    sqlite3_column_blob = (sqlite3_column_blob_t)GetProcAddress(hModule, "sqlite3_column_blob");
    sqlite3_column_bytes = (sqlite3_column_bytes_t)GetProcAddress(hModule, "sqlite3_column_bytes");
    sqlite3_finalize = (sqlite3_finalize_t)GetProcAddress(hModule, "sqlite3_finalize");
    sqlite3_close_v2 = (sqlite3_close_v2_t)GetProcAddress(hModule, "sqlite3_close_v2");

    if (!sqlite3_open16 || !sqlite3_prepare16 || !sqlite3_step || !sqlite3_column_count ||
        !sqlite3_column_name16 || !sqlite3_column_type || !sqlite3_column_double ||
        !sqlite3_column_int || !sqlite3_column_int64 || !sqlite3_column_text16 ||
        !sqlite3_column_blob || !sqlite3_column_bytes || !sqlite3_finalize || !sqlite3_close_v2) {
        FreeLibrary(hModule);
        return -2; // Failed to get one or more functions
    }

    return 0; // Success
}
#endif // SQLITE_WRAPPER_H

