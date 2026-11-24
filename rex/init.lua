-- Rex config: tmux/herdr-style prefix bindings.
-- Linked to ~/.config/rex/init.lua by install.sh.
-- Apply changes: prefix shift+r, or `rex config reload`. Check: `rex config check`.
-- The default Cmd shortcuts (Cmd+T, Cmd+D, ...) still work alongside these.
-- Shortcuts changed in the app UI override this file.

local PREFIX = "ctrl+a"

local function prefix(key, action, args)
  rex.bind(PREFIX .. ">" .. key, action, args)
end

-- Press the prefix twice to send a real Ctrl+A (start of line in the shell).
prefix("ctrl+a", "pane.send_key", { key = "ctrl+a" })

-- Last tab (tmux last-window). Rex's own client.tab.recent* actions do
-- nothing on build 2061, and init.lua can't listen for events, so the tab
-- keys below note which tab is active each time they're pressed.
-- Switching tabs with the mouse between presses can make it skip a step.
local tabs = {} -- per session: { cur = window_id, prev = window_id }

local function note(session_id)
  local view = rex.session.view{ session_id = session_id }
  if not view then return nil end
  local t = tabs[session_id] or {}
  if view.active_window_id ~= t.cur then
    t.prev, t.cur = t.cur, view.active_window_id
  end
  tabs[session_id] = t
  return t, view
end

local function select_tab(session_id, window_id)
  rex.client.queue("session.select", { session_id = session_id, window_id = window_id })
end

rex.action{
  name = "tab_switch",
  title = "Switch Tab (Remember Last)",
  category = "Tab",
  args = { action = "string?", index = "integer?" },
  run = function(ctx, args)
    local _, view = note(ctx.session_id)
    if args and args.index then
      -- Pick by this session's own tab list (client.tab.goto can count the
      -- wrong session's tabs right after a session switch).
      local w = view and (view.windows or {})[args.index]
      if w then select_tab(ctx.session_id, w.window_id) end
    elseif args and args.action then
      rex.client.queue(args.action)
    end
  end,
}

rex.action{
  name = "last_tab",
  title = "Last Tab",
  category = "Tab",
  keywords = "previous recent toggle alternate last-window",
  run = function(ctx)
    local t, view = note(ctx.session_id)
    if not (t and t.prev and view) then return end
    for _, w in ipairs(view.windows or {}) do
      if w.window_id == t.prev then return select_tab(ctx.session_id, t.prev) end
    end
  end,
}

local function tab_key(key, action)
  rex.bind(key, "tab_switch", { action = action })
end

-- Tabs (tmux windows / herdr tabs)
tab_key(PREFIX .. ">c", "client.tab.new")
tab_key(PREFIX .. ">n", "client.tab.next")
tab_key(PREFIX .. ">p", "client.tab.previous")
tab_key("ctrl+tab", "client.tab.next")           -- Rex default, now tracked
tab_key("ctrl+shift+tab", "client.tab.previous") -- Rex default, now tracked
for i = 1, 9 do
  prefix(tostring(i), "tab_switch", { index = i })
end
prefix("a", "last_tab") -- press again to return
prefix("shift+x", "client.tab.close")
prefix("shift+t", "client.tab.rename") -- herdr
prefix(",", "client.tab.rename")       -- tmux

-- Splits
prefix("v", "pane.split", { direction = "right" })       -- herdr: side by side
prefix("-", "pane.split", { direction = "down" })        -- herdr: stacked
prefix("shift+5", "pane.split", { direction = "right" }) -- tmux %
prefix("shift+'", "pane.split", { direction = "down" })  -- tmux "

-- Panes
for key, dir in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
  prefix(key, "pane.focus", { direction = dir })
end
prefix("tab", "pane.focus_next")
prefix("shift+tab", "pane.focus_previous")
prefix(";", "pane.focus_recent.in_tab") -- last pane (tmux last-pane)
prefix("x", "pane.close")
prefix("z", "pane.zoom")
prefix("[", "pane.copy_mode.enter")   -- tmux copy mode

-- Resize mode (herdr prefix+r): h/j/k/l resize, shift for bigger steps,
-- = balances splits, Enter or Escape leaves.
rex.mode("resize", { exclusive = true })
prefix("r", "client.mode.enter", { name = "resize" })
for key, dir in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
  rex.bind("resize/" .. key, "pane.resize", { direction = dir, amount = 2 })
  rex.bind("resize/shift+" .. key, "pane.resize", { direction = dir, amount = 10 })
end
rex.bind("resize/=", "pane.balance")
rex.bind("resize/enter", "client.mode.exit")

-- Sessions (herdr workspaces)
prefix("w", "session.switch")
prefix("s", "session.switch") -- tmux choose-session
prefix("shift+w", "session.new")

-- App
prefix("b", "client.sidebar.toggle")
prefix("shift+r", "client.config.reload")
prefix("shift+/", "client.palette.toggle") -- prefix ? : list every action and its keys
