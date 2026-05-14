-- General configs for Hyprland

hl.config({
    general = {

    gaps_in = 4,
    gaps_out = 13,
    border_size = 2,

    -- Catppuccin active border
    col = {
        active_border = {
            colors = { "rgb(b4befe)", "rgb(89b4fa)" }, angle = 45 },
            -- Red active borders
            -- "rgba(ff6264d9)", "rgba(e4240deb)" 45deg,
            -- Deafault blue - greenish borders active
            -- active_border = "rgba(33ccffee)", "rgba(00ff99ee)" 45deg,

        inactive_border = {
            colors = { "rgb(6c7086)", "rgb(585b70)" }, angle = 45 }, -- catppuccin type of inactive border
            -- Inactive gray borders
            -- "rgba(595959aa)",
        },

    -- dwindle = {
        -- preserve_split = false,
        -- pseudotile = yes # master switch for pseudotiling. Enabling is bound to SUPER + P
    -- },

    layout = "dwindle",

    -- Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
    allow_tearing = false
    }
})
