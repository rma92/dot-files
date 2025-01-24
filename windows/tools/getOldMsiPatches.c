#include <stdio.h>
#include <string.h>
#include <windows.h>
//tcc getOldMsiPatches.c -ladvapi32 -run
int verbose = 3;
void ReconstructProductCode(char *strMungedCode, char *strProductCode) {
  int arrSequence[] = {8, 7, 6, 5, 4, 3, 2, 1, 12, 11, 10, 9, 16, 15, 14, 13, 18, 17, 20, 19, 22, 21, 24, 23, 26, 25, 28, 27, 30, 29, 32, 31};
  int intArraySize = 32;
  int intIndex;

  strcpy(strProductCode, "{");

  for (intIndex = 0; intIndex < intArraySize; intIndex++) {
    strncat(strProductCode, &strMungedCode[arrSequence[intIndex] - 1], 1);
    if (intIndex == 7 || intIndex == 11 || intIndex == 15 || intIndex == 19) {
      strcat(strProductCode, "-");
    }
  }

  strcat(strProductCode, "}");
}

void GetOldPatches(BOOL bForce) {
  HKEY hKey;
  char instKey[] = "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Installer\\UserData\\S-1-5-18\\Products";
  char productKey[256], patchKey[256], productU[39], patchU[39], productN[256], patchN[256];
  DWORD sta, msi3, uninsta;
  DWORD bufSize;
  int i, j;

  if (RegOpenKeyEx(HKEY_LOCAL_MACHINE, instKey, 0, KEY_READ, &hKey) == ERROR_SUCCESS) {
    for (i = 0; RegEnumKey(hKey, i, productKey, sizeof(productKey)) == ERROR_SUCCESS; ++i) {
      if(verbose) printf("\n");
      HKEY hProductKey;
      char szProductKeyInstallProperties[4096];
      ReconstructProductCode(productKey, productU);
      sprintf(szProductKeyInstallProperties, "%s\\InstallProperties", productKey);
      if(verbose > 3) printf("ProductKey2 = %s\n", szProductKeyInstallProperties);
      if (RegOpenKeyEx(hKey, szProductKeyInstallProperties, 0, KEY_READ, &hProductKey) == ERROR_SUCCESS) {
        char szProductKeyPatches[4096];

        sprintf(szProductKeyPatches, "%s\\Patches", productKey);
        bufSize = sizeof(productN);
        RegQueryValueEx(hProductKey, "DisplayName", NULL, NULL, (LPBYTE)productN, &bufSize);

        //if(verbose > 2) printf("#Key: %s \nProduct ID:%s DisplayName: %s \n", szProductKey2, productKey, productN);
        if(verbose > 2) printf("#Product ID:%s DisplayName: %s \n", productKey, productN);
        if(verbose > 2) printf("#ProductKeyPatches: %s \n", szProductKeyPatches);
        HKEY hPatchesKey;

        if (RegOpenKeyEx(hKey, szProductKeyPatches, 0, KEY_READ, &hPatchesKey) == ERROR_SUCCESS) {
          if(verbose > 5) printf("Opened Patches Key\n");
          for (j = 0; RegEnumKey(hPatchesKey, j, patchKey, sizeof(patchKey)) == ERROR_SUCCESS; j++) {
            ReconstructProductCode(patchKey, patchU);
            HKEY hPatchKey;
            if (RegOpenKeyEx(hPatchesKey, patchKey, 0, KEY_READ, &hPatchKey) == ERROR_SUCCESS) {
              bufSize = sizeof(patchN);
              RegQueryValueEx(hPatchKey, "DisplayName", NULL, NULL, (LPBYTE)patchN, &bufSize);
              bufSize = sizeof(sta);
              RegQueryValueEx(hPatchKey, "State", NULL, NULL, (LPBYTE)&sta, &bufSize);
              bufSize = sizeof(msi3);
              RegQueryValueEx(hPatchKey, "MSI3", NULL, NULL, (LPBYTE)&msi3, &bufSize);
              bufSize = sizeof(uninsta);
              RegQueryValueEx(hPatchKey, "Uninstallable", NULL, NULL, (LPBYTE)&uninsta, &bufSize);

              if (sta == 2) {
                if (msi3 == 1) {
                  if (uninsta == 1) {
                    printf("REM #%s\n", patchKey);
                    printf("REM #%s : %s\n", productN, patchN);
                    printf("msiexec /package %s /uninstall %s /passive /qr /norestart\n", productU, patchU);
                  }
                  else if(bForce)
                  {
                    printf("REM #%s : %s\n", productN, patchN);
                    printf("REM #reg add \"%s\" /v Uninstallable /t REG_DWORD /d 1 /f\n", patchKey);
                    printf("msiexec /package %s /uninstall %s /passive /qr /norestart\n", productU, patchU);
                  }
                  else
                  {
                    printf("REM #cannot uninstall %s : %s - marked as not uninstallable.  Use force.\n", productN, patchN);
                  }
                } else {
                  printf("Cannot uninstall %s : %s — Patch removal is available starting with MSI 3.0\n", productN, patchN);
                }
              }
              RegCloseKey(hPatchKey);
            }
            else
            {
              if(verbose > 2) printf("#Failed to open individual patch key");
            }
          }
          RegCloseKey(hPatchesKey);
        }
        else
        {
          if(verbose > 2) printf("#Failed to open patches key");
        }
        RegCloseKey(hProductKey);
      }
      else
      {
        if(verbose > 2) printf("#Failed to open Product key");
      }
    }//for loop
    RegCloseKey(hKey);
  }
  else
  {
    if(verbose > 2) printf("#Failed to open Installer key");
  }
}

int main() {
  GetOldPatches(0);
  GetOldPatches(1);
  return 0;
}
