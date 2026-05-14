# See https://wiki.hyprland.org/Configuring/Master-Layout/ for more 

hl.config({
    misc = {
        force_default_wallpaper = 1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = false, -- If true disables the random hyprland logo / anime girl background. :(
    },

    master = {
        -- See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        -- new_is_master = true
    },

    -- Example per-device config
    -- See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more

    -- device = {
        -- name = epic-mouse-v1
        -- sensitivity = -0.5
    -- },

    -- See https://wiki.hyprland.org/Configuring/Keywords/ for more
    -- cursor {
        -- sync_gsettings_theme = true
    -- }
})
