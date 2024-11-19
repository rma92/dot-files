#include <stdio.h>
#include "winsqlite-portable.h"

int create_types_table() {
    const wchar_t *db_filename = L"database.db";
    const wchar_t *create_table_query = 
        L"CREATE TABLE IF NOT EXISTS types (K INTEGER PRIMARY KEY, V TEXT);";

    void *db = NULL;
    void *stmt = NULL;
    int result;

    // Initialize SQLite dynamic functions
    if (init_sqlite() != 0) {
        fprintf(stderr, "Failed to initialize SQLite functions.\n");
        return -1;
    }

    // Open the database
    result = sqlite3_open16(db_filename, &db);
    if (result != 0) {
        fprintf(stderr, "Failed to open database: %d\n", result);
        return -2;
    }

    // Prepare the CREATE TABLE query
    result = sqlite3_prepare16(db, create_table_query, -1, &stmt, NULL);
    if (result != 0) {
        fprintf(stderr, "Failed to prepare statement: %d\n", result);
        sqlite3_close_v2(db);
        return -3;
    }

    // Execute the query
    result = sqlite3_step(stmt);
    if (result != 101) { // SQLITE_DONE is typically 101
        fprintf(stderr, "Failed to execute query: %d\n", result);
        sqlite3_finalize(stmt);
        sqlite3_close_v2(db);
        return -4;
    }

    // Finalize the statement and close the database
    sqlite3_finalize(stmt);
    sqlite3_close_v2(db);

    printf("Table 'types' ensured to exist successfully.\n");
    return 0; // Success
}

int main()
{
  printf("Test1\n");
  init_sqlite();
  create_types_table();
  printf("Test2\n");
  return 0;
}
