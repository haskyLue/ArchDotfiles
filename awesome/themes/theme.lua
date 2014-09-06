-- dir {{{
local awful   = require("awful")
awful.util    = require("awful.util")
shared        = "/usr/share/awesome"
config        = awful.util.getdir("config")

sharedthemes  = shared .. "themes"
themedir      = config .. "/themes"
buttons	      = themedir .. "/buttons/"
layouts	      = themedir .. "/layouts/"
-- }}}

theme                          = {}
theme.wallpaper                = "/home/hasky/Downloads/Image/background.jpg"
theme.tasklist_plain_task_name = true -- 终于找到你了,去掉tasklist name前的符号
theme.tasklist_disable_icon = false

theme.font          = "WenQuanYi Bitmap Song 9"
-- theme.font          = "Droid Sans Mono 8"

--// Colors
theme.fg_normal     = "#ffffff"
theme.fg_focus      = "#66d9ef"
theme.fg_urgent     = "#ffcb00"

theme.bg_normal     = "#333333"
theme.bg_focus      = "#404040" 
theme.bg_urgent     = "#b80000"
theme.bg_systray    = theme.bg_normal

--// Borders
theme.border_width  = "1"
theme.border_normal = "#333333"
theme.border_focus  = theme.bg_focus
theme.border_marked = theme.fg_urgent

--// Titlebars
theme.titlebar_fg_normal  = "#808080"
theme.titlebar_fg_focus   = "#ff1717"
theme.titlebar_bg_normal  = "#363636"
theme.titlebar_bg_focus   = "#000000"

-- // taglist
theme.taglist_bg_focus = theme.bg_focus
theme.taglist_fg_focus = theme.fg_focus

--// Menu
theme.menu_bg_normal = "#000000"
theme.menu_bg_focus  = "#eeeeee"
theme.menu_fg_normal = theme.fg_normal
theme.menu_fg_focus  = theme.fg_focus
theme.menu_border_width = "0"
theme.menu_height = "20"
theme.menu_width  = "150"

-- Icons {{{
--// Taglist
theme.taglist_squares_sel   = themedir .. "/taglist/squarefz.png"
theme.taglist_squares_unsel = themedir .. "/taglist/squarez.png"
theme.taglist_squares_resize = "false"

--// Misc
theme.awesome_icon           = "/home/hasky/Downloads/Image/awesome-icon-l.png"
-- theme.menu_submenu_icon      = sharedthemes .. "/default/submenu.png"
theme.tasklist_floating_icon = sharedthemes .. "/default/tasklist/floatingw.png"

--// Layout
theme.layout_tile       = layouts .. "tile.png"
theme.layout_tileleft   = layouts .. "tileleft.png"
theme.layout_tilebottom = layouts .. "tilebottom.png"
theme.layout_tiletop    = layouts .. "tiletop.png"
theme.layout_fairv      = layouts .. "fairv.png"
theme.layout_fairh      = layouts .. "fairh.png"
theme.layout_spiral     = layouts .. "spiral.png"
theme.layout_dwindle    = layouts .. "dwindle.png"
theme.layout_max        = layouts .. "max.png"
theme.layout_fullscreen = layouts .. "fullscreen.png"
theme.layout_magnifier  = layouts .. "magnifier.png"
theme.layout_floating   = layouts .. "floating.png"

--// Titlebar
theme.titlebar_close_button_focus  = buttons .. "/close-focused.png"
theme.titlebar_close_button_normal = buttons .. "/close-unfocused.png"
theme.titlebar_maximized_button_focus_active  = buttons .. "/maximize-focused.png"
theme.titlebar_maximized_button_normal_active = buttons .. "/maximize-unfocused.png"
theme.titlebar_maximized_button_focus_inactive  = buttons .. "/maximize-focused.png"
theme.titlebar_maximized_button_normal_inactive = buttons .. "/maximize-unfocused.png"
-- }}}

return theme
