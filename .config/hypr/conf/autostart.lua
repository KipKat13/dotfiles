-- Execute your favorite apps at launch

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("wofi")
    hl.exec_cmd("awww & awww-daemon")
    hl.exec_cmd("clipse -listen") -- Start clipse daemon for clipboard management
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    -- hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
end)
