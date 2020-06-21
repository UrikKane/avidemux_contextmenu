# avidemux_contextmenu
avidemux context menu scripts

TL;DR: if you have regular Avidemux version installed to C:\Program files , use 
add_open_in_avidemux_win64.bat to add "Open in Avidemux" option.
If want to remove, use remove_open_in_avidemux_win64.bat


add_open_in_avidemux_win64 - finds avidemux folders in C:\Program Files and lets you choose which one of them to add as "open in Avidemux" context menu entry for given extensions (asks user input for extensions, or uses default list)

add_open_in_avidemux_win64_manual - same, but with manual folder input for portable and custom installations

remove_open_in_avidemux_win64 - removes "open in avidemux" entries

fix_avidemux_location_registry_win64 - finds avidemux folders in C:\Program Files and lets you choose which one of them to use for "Open With..." option in context menu entry, by writing to registry HKCR\Applications\avidemux.exe\shell\open\command

open_avidemux_location_registry_win64 - opens regedit at HKCR\Applications\avidemux.exe\shell\open\command


made and tested for Win10 64bit
