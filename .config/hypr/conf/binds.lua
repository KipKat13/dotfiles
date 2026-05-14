-- All my Hyprland keybinds

-- SUPER key and import programs
-- local mainMod = "SUPER"
require("conf.programs")

-- Actions
hl.bind("SUPER + Q", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + W", hl.dsp.exec_cmd("~/scripts/wall.sh"))
hl.bind("SUPER + C", hl.dsp.window.close())
hl.bind("SUPER + M", hl.dsp.exit())
hl.bind("SUPER + E", hl.dsp.exec_cmd(fileManager))
hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + R", hl.dsp.exec_cmd(menu))
hl.bind("SUPER + P", hl.dsp.exec_cmd("~/scripts/restart.sh"))
-- hl.bind("SUPER, P", hl.dsp.pseudo()); -- dwindle
-- hl.bind("SUPER, J", hl.dsp.togglesplit()); -- togglesplit have been finally removed. Please use layoutmsg now.

-- Move focus with mainMod + arrow keys
hl.bind("SUPER + right", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))

-- Move window with mainMod + shift + arrow keys
hl.bind("SUPER + left", hl.dsp.window.move({ direction = "left", true }))
hl.bind("SUPER + right", hl.dsp.window.move({ direction = "right", true }))
hl.bind("SUPER + up", hl.dsp.window.move({ direction = "up", true }))
hl.bind("SUPER + down", hl.dsp.window.move({ direction = "down", true }))

-- Switch workspaces or move them around
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0

    -- Switch workspaces with mainMod + [0-9]
    hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))

    -- Move active window to a workspace with mainMod + SHIFT + [0-9]
    hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("SUPER + CTRL + left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }))
hl.bind("SUPER + CTRL + right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }))
hl.bind("SUPER + CTRL + up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }))
hl.bind("SUPER + CTRL + down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }))

-- Ajust brightness with brightnessctl
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 set 5%-"), { locked = true, repeating = true })

-- Ajust volume with keys (use wpctl, pactl is the old one)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })

-- Screenshot making with hyprshot
hl.bind("SUPER + Print", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -c -m output"))
hl.bind("SUPER + SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m region"))
