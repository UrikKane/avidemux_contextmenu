# avidemux_contextmenu
avidemux context menu scripts

add_open_in_avidemux_win64 - finds latest avidemux folder (reverse alphabetical order) in C:\Program Files and adds "open in Avidemux"
context menu entry for given extensions (asks user input for extensions, or uses default list)

add_open_in_avidemux_win64_manual - same, but with manual folder input for portable and custom installations

remove_open_in_avidemux_win64 - removes "open in avidemux" entries

fix_avidemux_location_registry_win64 - finds latest avidemux folder (reverse alphabetical order) in C:\Program Files and saves it to 
HKCR\Applications\avidemux.exe\shell\open\command

open_avidemux_location_registry_win64 - opens regedit at HKCR\Applications\avidemux.exe\shell\open\command




made and tested for Win10 64bit
