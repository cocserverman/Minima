-- Minima: HWiNFO reader, GPU picker and widget resizer.
--
-- Mode option on the Script measure:
--   Read (default)  find a HWiNFO reading by label (+ optional sensor filter)
--   Pick            return one of two other measures, chosen by a selector
--   None            no value; used only to host the Scale functions
--
-- Read options:
--   Slots    number of mHwLabelN / mHwSensorN / mHwValueN sets   default 10
--   Labels   reading labels separated by | (priority order)
--   Sensor   sensor-name substrings separated by | (optional filter)
--   Clamp    upper limit (0 = none)                              default 0
--   Fallback measure to use when nothing usable was found (optional)
--
-- Pick options:
--   Select   measure name; a value >= 1 picks B, otherwise A
--   A, B     measure names to pick from
--   TagA/B   text returned by Tag()   defaults iGPU / dGPU
--
-- Functions for meters:
--   Num()   "37" or "--"          Temp()  "52 C" or "--"      Tag()  "iGPU"/"dGPU"
-- Functions for mouse actions:
--   ScaleBy(step)   ScaleTo(value)

local function trim(s)
  return (s:match('^%s*(.-)%s*$'))
end

local function splitList(s)
  local t = {}
  for item in s:gmatch('[^|]+') do
    item = trim(item):lower()
    if item ~= '' then t[#t + 1] = item end
  end
  return t
end

-- First number in a string; accepts "55", "55.5" and "55,5" (EU locale).
local function firstNumber(text)
  local num = text:match('%d+[%.,]?%d*')
  if not num then return nil end
  return tonumber((num:gsub(',', '.')))
end

local function measureValue(name)
  if name == '' then return -1 end
  local m = SKIN:GetMeasure(name)
  if m then return m:GetValue() end
  return -1
end

local function sensorOk(sensorText)
  if #sensors == 0 then return true end
  local s = sensorText:lower()
  for _, pat in ipairs(sensors) do
    if s:find(pat, 1, true) then return true end
  end
  return false
end

function Initialize()
  mode       = SELF:GetOption('Mode', 'Read'):lower()
  slots      = tonumber(SELF:GetOption('Slots', '10')) or 10
  clamp      = tonumber(SELF:GetOption('Clamp', '0')) or 0
  wanted     = splitList(SELF:GetOption('Labels', ''))
  sensors    = splitList(SELF:GetOption('Sensor', ''))
  fallback   = SELF:GetOption('Fallback', '')
  selectName = SELF:GetOption('Select', '')
  nameA      = SELF:GetOption('A', '')
  nameB      = SELF:GetOption('B', '')
  tagA       = SELF:GetOption('TagA', 'iGPU')
  tagB       = SELF:GetOption('TagB', 'dGPU')
  current    = -1
  usingB     = false
end

local function readHwinfo()
  local rows = {}
  for i = 0, slots - 1 do
    local lm = SKIN:GetMeasure('mHwLabel' .. i)
    local vm = SKIN:GetMeasure('mHwValue' .. i)
    local sm = SKIN:GetMeasure('mHwSensor' .. i)
    if lm and vm then
      rows[#rows + 1] = {
        label  = trim(lm:GetStringValue() or ''):lower(),
        value  = vm:GetStringValue() or '',
        sensor = sm and (sm:GetStringValue() or '') or '',
      }
    end
  end
  for _, w in ipairs(wanted) do
    for _, r in ipairs(rows) do
      if r.label == w and sensorOk(r.sensor) then
        local v = firstNumber(r.value)
        if v then return v end
      end
    end
  end
  return nil
end

function Update()
  if mode == 'none' then
    return 0
  end

  if mode == 'pick' then
    usingB = measureValue(selectName) >= 1
    current = measureValue(usingB and nameB or nameA)
    return current
  end

  local v = readHwinfo()
  if (v == nil or v <= 0) and fallback ~= '' then
    local fv = measureValue(fallback)
    if fv > 0 then v = fv end
  end
  if v == nil then
    current = -1
  else
    if clamp > 0 and v > clamp then v = clamp end
    current = v
  end
  return current
end

-- [&mGPU:Num()]
function Num()
  if current < 0 then return '--' end
  return string.format('%d', math.floor(current + 0.5))
end

-- [&mGPUTemp:Temp()]
-- A reading of 0 means the sensor is asleep (idle dGPU), not 0 degrees.
function Temp()
  if current <= 0 then return '--' end
  return string.format('%d C', math.floor(current + 0.5))
end

-- [&mGPU:Tag()]
function Tag()
  return usingB and tagB or tagA
end

-- ----- widget resizing -----
local function writeScale(v)
  v = math.max(0.6, math.min(2.5, v))
  v = math.floor(v * 100 + 0.5) / 100
  local s = (string.format('%.2f', v):gsub(',', '.'))
  SKIN:Bang('!WriteKeyValue', 'Variables', 'Scale', s, SKIN:ReplaceVariables('#@#Variables.inc'))
  SKIN:Bang('!Refresh')
end

function ScaleBy(step)
  writeScale((tonumber(SKIN:GetVariable('Scale')) or 1) + step)
end

function ScaleTo(v)
  writeScale(tonumber(v) or 1)
end