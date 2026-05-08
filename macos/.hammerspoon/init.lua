local leftDown  = false
local rightDown = false
local fired     = false

local function fireMoom()
  if not fired then
    fired = true
    hs.eventtap.keyStroke({ "shift", "control", "cmd" }, "g", 0)
  end
end

local mouseWatcher = hs.eventtap.new({
  hs.eventtap.event.types.leftMouseDown,
  hs.eventtap.event.types.leftMouseUp,
  hs.eventtap.event.types.rightMouseDown,
  hs.eventtap.event.types.rightMouseUp,
}, function(e)
  local t = e:getType()

  -- LEFT DOWN
  if t == hs.eventtap.event.types.leftMouseDown then
    if rightDown then
      fireMoom()
      return true  -- swallow second click only
    end
    leftDown = true
    return false
  end

  -- RIGHT DOWN
  if t == hs.eventtap.event.types.rightMouseDown then
    if leftDown then
      fireMoom()
      return true  -- swallow second click only
    end
    rightDown = true
    return false
  end

  -- LEFT UP
  if t == hs.eventtap.event.types.leftMouseUp then
    leftDown = false
    fired = false
    return false
  end

  -- RIGHT UP
  if t == hs.eventtap.event.types.rightMouseUp then
    rightDown = false
    fired = false
    return false
  end

  return false
end)

mouseWatcher:start()

hs.alert.show("Left+Right click → Moom Grid (clean)")

