# avidemux_contextmenu
avidemux context menu scripts

Basically, there are two pairs of scripts (with _add and _remove suffixes):

"open_in" - adds custom entry in context menu that is quickly accessible
"open_with" - modifies/updates registry key for the standard Windows Explorer "Open with" submenu

Both scripts search for avidemux.exe and avidemux_portable.exe as proof-of-installation.
All files must be run elevated (right click >"Run as administrator"). It's required for script to be able to make changes in registry.

Description:

open_in_avidemux_win64_add.bat - Adds "Open in Avidemux" entries. Searches for Avidemux installations in C:\Program Files  (folders with "avidemux" in their name) and also in the same folder the script is placed. If multiple installations found, will ask which one to choose. It can also accept full manual path entry (from user input). Before adding entries, asks for which file extensions to add for.

open_in_avidemux_win64_remove.bat - Removes previously added "Open in Avidemux" entries.

open_with_avidemux_registry_win64_add - Adds/Updates registry entry for "Open with" submenu. Function-wise, works similar to as open_in_avidemux_win64_add.bat

open_with_avidemux_registry_win64_remove - Deletes registry entry for "Open with" submenu

Made and tested in Win10 64bit.
