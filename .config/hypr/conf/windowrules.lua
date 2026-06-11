-- See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({ match = { title = "(.*)(Code)$" }, opaque = true })
hl.window_rule({ match = { title = "(.*)(Brave)$" }, opaque = true })
hl.window_rule({ match = { title = "(.*)(Weather)$" }, opaque = true })
hl.window_rule({ match = { title = "(.*)(Firefox)$" }, opaque = true })
hl.window_rule({ match = { title = "(.*)(RLCraft)$" }, opaque = true })

hl.window_rule({
    match = { class = "org.nicotine_plus.Nicotine" },
    opaque = true,
})

hl.window_rule({
    match = { class = "org.gnome.Loupe" },
    opaque = true,
})

hl.window_rule({
    name = "brave-on-ws2",
    match = { title = "(.*)(Brave)$" },
    workspace = "2 silent"
})

-- Won't really work, cant get the correct name
hl.window_rule({ match = { title = "(.*)(Factorio)$" }, opaque = true })
hl.window_rule({ match = { title = "(.*)(eclipse-java-bin)$" }, opaque = true })

hl.window_rule({ match = { class = "clipse" }, float = true })
hl.window_rule({ match = { class = "clipse" }, size = { 622, 652 } })
