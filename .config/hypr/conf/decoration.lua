-- See https://wiki.hyprland.org/Configuring/Variables/ for more

hl.config({
    decoration = {
        rounding = 8,

        blur = {
            enabled = false,
            xray = true,
            size = 8,
            passes = 3,
            new_optimizations = true,
        },

        active_opacity = 0.90,
        inactive_opacity = 0.95,
        fullscreen_opacity = 1.0,

        shadow = {
            enabled = true,
            range = 20,
            render_power = 5,
            color = "rgba(1a1a1aee)",
        },
    }
})
