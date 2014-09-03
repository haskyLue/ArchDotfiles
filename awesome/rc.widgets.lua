-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
local vicious = require("vicious")
local drop = require("drop")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Autostart applications
-- function run_once(cmd)
-- 	findme = cmd
-- 	firstspace = cmd:find(" ")
-- 	if firstspace then
-- 		findme = cmd:sub(0, firstspace-1)
-- 	end
-- 	awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
-- end
--
-- run_once("unclutter")
-- run_once("checkgmail -numbers -private -no_cookies")
-- run_once("stardict -h")
-- run_once("xflux -l 32.054829 -g 118.795193")
-- }}}

-- {{{ Variable definitions
os.setlocale(os.getenv("LANG"))

-- Themes define colours, icons, font and wallpapers.
local themedir= "sunjack"
beautiful.init("/home/hasky/.config/awesome/themes/" .. themedir .. "/theme.lua")
awful.util.spawn_with_shell("ln -sf /home/hasky/.config/awesome/themes/" .. themedir .. "/theme.lua " .. "/home/hasky/.config/awesome/theme.lua") 

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
browser    = os.getenv("BROWSER") 
gui_editor = "subl"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.centered(beautiful.wallpaper, s)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
	names = {"①","②","③","④","⑤"},
	layout = { layouts[2],layouts[4], layouts[1], layouts[1], layouts[1] }
}
for s = 1, screen.count() do
-- Each screen has its own tag table.
   tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- 插件载入{{{

local separator = wibox.widget.textbox()
separator:set_markup('<span color="grey" > :: </span>')

-- cpu 占用
cpuwidget = wibox.widget.textbox()
vicious.cache(vicious.widgets.cpu)
-- $1 usage of all CPU/CORES -- $2 first CPU core -- $3 second CPU core -- $4 third CPU core -- $5 fourth CPU core
vicious.register(cpuwidget, vicious.widgets.cpu,
'<span color="white" >CPU: <span color="red">$2%/<span color="#888888">·</span>$3% </span></span>', 3)
-- cpu 温度
local thermalwidget = wibox.widget.textbox()
vicious.cache(vicious.widgets.thermal)
vicious.register(thermalwidget, vicious.widgets.thermal, '<span color="yellow" >$1°C</span>', 20, {"thermal_zone0", "sys"})


-- 网络流量
netwidget = wibox.widget.textbox()
vicious.cache(vicious.widgets.net)
vicious.register(netwidget, vicious.widgets.net, function(widget, args)
	local interface = ""
	if args["{wlp3s0 carrier}"] == 1 then
		interface = "wlp3s0"
	elseif args["{enp7s0f5 carrier}"] == 1 then
		interface = "enp7s0f5"
	else
		return ""
	end
	return '<span color="white" >Traffic: <span color="cyan">'..args["{"..interface.." down_kb}"]..'kbps/'..args["{"..interface.." up_kb}"].."kbps "..'</span></span>' end )

-- 声音
volume = wibox.widget.textbox()
-- $1 is the volume level of channel; $2 is the mute state of the channel ;"Master" is my channel, to find out your ALSA channel
vicious.cache(vicious.widgets.volume)
vicious.register(volume, vicious.widgets.volume,
'<span color="white" >Volume: <span  color="orange">$2/$1%</span></span>', 0.2, "Master")

-- mpd
mpdwidget = wibox.widget.textbox()
vicious.cache(vicious.widgets.mpd)
vicious.register(mpdwidget, vicious.widgets.mpd,
function (mpdwidget, args)
	if args["{state}"] == "Stop" then 
		return " - "
	else 
		-- return args["{Artist}"]..'-'.. args["{Title}"]..":"..args["{state}"]
		return '<span color="white" >MPD: {'..args["{Artist}"]..'} - <span  color="pink">'..args["{Title}"]..'<span color="red"> ('..args["{state}"]..')</span></span></span>'
	end
end)


-- os info.
local osinfo = wibox.widget.textbox()
vicious.register(osinfo, vicious.widgets.os, '<span color="steelblue" font="URW Palladio L italic bold">$1 $2</span>')

-- }}}
	
-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock("%b%d日周%a %H:%M")

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s ,height = "18",border_width=0})

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(osinfo)
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
		right_layout:add(separator)
	right_layout:add(mpdwidget)
		right_layout:add(separator)
	right_layout:add(netwidget)
		right_layout:add(separator)
	right_layout:add(cpuwidget)
	right_layout:add(thermalwidget)
		right_layout:add(separator)
	right_layout:add(volume)
		right_layout:add(separator)
    right_layout:add(mytextclock)
		right_layout:add(separator)
    right_layout:add(mytaglist[s])
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    -- layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)

	-- Create the bottom wibox
	mybottomwibox={}
    mybottomwibox[s] = awful.wibox({ position = "bottom", screen = s, border_width = 0, height = 20})
    bottom_left_layout = wibox.layout.fixed.horizontal()
    if s == 1 then bottom_left_layout:add(wibox.widget.systray()) end
    bottom_right_layout = wibox.layout.fixed.horizontal()
    -- Now bring it all together (with the tasklist in the middle)
    bottom_layout = wibox.layout.align.horizontal()
    bottom_layout:set_left(bottom_left_layout)
    bottom_layout:set_middle(mytasklist[s])
    mybottomwibox[s]:set_widget(bottom_layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    -- 浏览 {{{
	awful.key({ modkey,           }, "Left",   awful.tag.viewprev		),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext		),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    awful.key({ modkey,			  }, "j",
        function()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,			  }, "k",
        function()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,			  }, "h",
        function()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,			 }, "l",
        function()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end),
	awful.key({ modkey,           }, "Tab",
		function ()
			-- awful.client.focus.history.previous()
			awful.client.focus.byidx(-1)
			if client.focus then
				client.focus:raise()
			end
		end),
	awful.key({ modkey, "Shift"   }, "Tab",
		function ()
			-- awful.client.focus.history.previous()
			awful.client.focus.byidx(1)
			if client.focus then
				client.focus:raise()
			end
		end),
	-- }}}		
 
    -- 布局{{{
    awful.key({ modkey, "Control" }, "j",	  function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k",	  function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u",	  awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "]",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "[",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle                ),
    awful.key({ modkey,           }, "o",     awful.client.movetoscreen                   ),
    awful.key({ modkey, "Control" }, "n",	  awful.client.restore					      ),
	-- }}}

    -- 多媒体按键绑定 {{{
    -- ALSA volume control
    awful.key({}, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer -q set Master 1%+") end),
    awful.key({}, "XF86AudioLowerVolume", function () awful.util.spawn("amixer -q set Master 1%-") end),
    awful.key({}, "XF86AudioMute", function () awful.util.spawn("amixer -q set Master playback toggle") end),
    -- MPD control
    awful.key({}, "XF86AudioStop", function () awful.util.spawn_with_shell("mpc toggle || ncmpcpp toggle || ncmpc toggle || pms toggle") end),
    awful.key({}, "XF86AudioPlay", function () awful.util.spawn_with_shell("mpc stop || ncmpcpp stop || ncmpc stop || pms stop")  end),
    awful.key({}, "XF86AudioPrev", function () awful.util.spawn_with_shell("mpc prev || ncmpcpp prev || ncmpc prev || pms prev")  end),
    awful.key({}, "XF86AudioNext", function () awful.util.spawn_with_shell("mpc next || ncmpcpp next || ncmpc next || pms next")  end),	
	-- 切换触控板
    awful.key({}, "XF86ScreenSaver", function () awful.util.spawn_with_shell("sh /home/hasky/Documents/dotfiles/script/toggle_psmouse.sh") end),
    -- awful.key({}, "XF86Launch1", function () awful.util.spawn_with_shell("vboxmanage startvm xp") end),
    awful.key({}, "XF86Launch1", function () awful.util.spawn_with_shell("vmware  -X '/home/hasky/vmware/Windows XP Professional/Windows XP Professional.vmx'") end),
    -- }}}

    -- 用户程序{{{
    awful.key({ modkey,	          }, "z",      function () drop(terminal) end),
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey,			  }, "q",	   function () awful.util.spawn(browser) end),
    awful.key({ modkey,			  }, "e",	   function () awful.util.spawn(gui_editor) end),
	--}}}

    -- 拷贝剪贴板
    awful.key({ modkey,			  }, "c",	   function () os.execute("xsel -p -o | xsel -i -b") end),
	
    -- awesome
    awful.key({ modkey,			  }, "r",	   function () mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey,			  }, "p",	   function() menubar.show() end),
    awful.key({ modkey, "Control" }, "r",      awesome.restart),
    awful.key({ modkey, "Shift"   }, "q",      awesome.quit)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),
	awful.key({ modkey, "Control" }, "Down",  function () awful.client.moveresize(  0,  20,   0,   0) end),
    awful.key({ modkey, "Control" }, "Up",    function () awful.client.moveresize(  0, -20,   0,   0) end),
    awful.key({ modkey, "Control" }, "Left",  function () awful.client.moveresize(-20,   0,   0,   0) end),
    awful.key({ modkey, "Control" }, "Right", function () awful.client.moveresize( 20,   0,   0,   0) end),
    awful.key({ modkey, "Control" }, "Next",  function () awful.client.moveresize( 20,  20, -40, -40) end),
    awful.key({ modkey, "Control" }, "Prior", function () awful.client.moveresize(-20, -20,  40,  40) end),
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
					 size_hints_honor = false } },--这个diao东西貌似是消除窗口全屏留下的空隙
								 
    { rule = { class = "URxvt" }, properties = { opacity = 0.8 } },
	{ rule = { class = "VirtualBox" }, properties = { tag = tags[1][5]}},
	{ rule = { instance = "vmware" }, properties = { tag = tags[1][5]}},
    { rule = { class = "Gimp", role = "gimp-image-window" }, properties = { maximized_horizontal = true, maximized_vertical = true } },

	{ rule_any = { class = {"Firefox","Chromium" }}, properties = { tag = tags[1][3], switchtotag = true} },
	{ rule_any = { class = {"LibreOffice","Subl3","Gvim","FoxitReader"} }, properties = { tag = tags[1][4], switchtotag = true} },

	{ rule = {}, except_any = { class = { "URxvt", "Vim" } ,instance = {"mupdf"} }, properties = { floating = true } }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
