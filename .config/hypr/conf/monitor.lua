-- Monitor configuration

hl.monitor({
  output = "eDP-1",
  mode = "1920x1080@60",
  position = "0x0",
  scale = 1
})

hl.monitor({
  output = "HDMI-A-2",
  mode = "1920x1080@60",
  position = "0x0",
  scale = 1,
  mirror = "eDP-1"
})

hl.monitor({ output = "HDMI-A-2", mode = "1920x1080@60", position = "0x0", scale = 1, mirror = "eDP-1" })

-- xrandr --output HDMI-1 --same-as eDP-1
