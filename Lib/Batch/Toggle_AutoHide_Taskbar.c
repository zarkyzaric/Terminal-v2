#include <windows.h>
#include <shellapi.h>

// This isn't defined for me for some reason.
#ifndef ABM_SETSTATE
#define ABM_SETSTATE 0x0000000A
#endif

int main() {
    APPBARDATA abd = {sizeof abd};
    UINT uState = (UINT) SHAppBarMessage(ABM_GETSTATE, &abd);
    LPARAM param = uState & ABS_ALWAYSONTOP;
    if (uState & ABS_AUTOHIDE)
        abd.lParam = param;
    else
        abd.lParam = ABS_AUTOHIDE | param;
    SHAppBarMessage(ABM_SETSTATE, &abd);
    return 0;
}