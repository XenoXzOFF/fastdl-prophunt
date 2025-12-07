AddCSLuaFile()

-- Local math refs (kept for readability, but avoid math.pow except where it helps clarity)
local sin, cos, asin = math.sin, math.cos, math.asin
local pi, sqrt, abs = math.pi, math.sqrt, math.abs

-- Small helpers
local function sq(x)   return x * x end
local function cu(x)   return x * x * x end
local function qu(x)   return x * x * x * x end
local function qi(x)   return x * x * x * x * x end

-- Generic time normalizer (guards d == 0 just in case)
local function nrm(t, d)
  if d == 0 then return 0 end
  return t / d
end

-- Composers for common patterns
-- inOut: first half uses "in" ease; second half uses "out" ease
local function makeInOut(eIn, eOut)
  return function(t, b, c, d, ...)
    t = nrm(t, d) * 2
    if t < 1 then
      return eIn(t * (d / 2), b, c / 2, d, ...) -- scale time to half-duration
    else
      -- Map t in [1,2] to [0,1] half
      return eOut((t - 1) * (d / 2), b + c / 2, c / 2, d, ...)
    end
  end
end

-- outIn: first half uses "out"; second half uses "in"
local function makeOutIn(eOut, eIn)
  return function(t, b, c, d, ...)
    if t < d / 2 then
      return eOut(t * 2, b, c / 2, d, ...)
    else
      return eIn((t * 2) - d, b + c / 2, c / 2, d, ...)
    end
  end
end

-------------------------
-- Linear
-------------------------
local function linear(t, b, c, d)
  return c * nrm(t, d) + b
end

-------------------------
-- Quad
-------------------------
local function inQuad(t, b, c, d)
  t = nrm(t, d)
  return c * sq(t) + b
end

local function outQuad(t, b, c, d)
  t = nrm(t, d)
  return -c * t * (t - 2) + b
end

local inOutQuad  = makeInOut(inQuad, outQuad)
local outInQuad  = makeOutIn(outQuad, inQuad)

-------------------------
-- Cubic
-------------------------
local function inCubic(t, b, c, d)
  t = nrm(t, d)
  return c * cu(t) + b
end

local function outCubic(t, b, c, d)
  t = nrm(t, d) - 1
  return c * (cu(t) + 1) + b
end

local inOutCubic  = makeInOut(inCubic, outCubic)
local outInCubic  = makeOutIn(outCubic, inCubic)

-------------------------
-- Quart
-------------------------
local function inQuart(t, b, c, d)
  t = nrm(t, d)
  return c * qu(t) + b
end

local function outQuart(t, b, c, d)
  t = nrm(t, d) - 1
  return -c * (qu(t) - 1) + b
end

local inOutQuart  = makeInOut(inQuart, outQuart)
local outInQuart  = makeOutIn(outQuart, inQuart)

-------------------------
-- Quint
-------------------------
local function inQuint(t, b, c, d)
  t = nrm(t, d)
  return c * qi(t) + b
end

local function outQuint(t, b, c, d)
  t = nrm(t, d) - 1
  return c * (qi(t) + 1) + b
end

local inOutQuint  = makeInOut(inQuint, outQuint)
local outInQuint  = makeOutIn(outQuint, inQuint)

-------------------------
-- Sine
-------------------------
local function inSine(t, b, c, d)
  return -c * cos(nrm(t, d) * (pi / 2)) + c + b
end

local function outSine(t, b, c, d)
  return c * sin(nrm(t, d) * (pi / 2)) + b
end

local function inOutSine(t, b, c, d)
  return -c / 2 * (cos(pi * nrm(t, d)) - 1) + b
end

local outInSine = makeOutIn(outSine, inSine)

-------------------------
-- Exponential
-- Preserves tiny offsets from original for continuity
-------------------------
local function inExpo(t, b, c, d)
  if t == 0 then return b end
  return c * (2 ^ (10 * (nrm(t, d) - 1))) + b - c * 0.001
end

local function outExpo(t, b, c, d)
  if t == d then return b + c end
  return c * 1.001 * (-(2 ^ (-10 * nrm(t, d))) + 1) + b
end

local function inOutExpo(t, b, c, d)
  if t == 0 then return b end
  if t == d then return b + c end
  t = nrm(t, d) * 2
  if t < 1 then
    return c / 2 * (2 ^ (10 * (t - 1))) + b - c * 0.0005
  else
    t = t - 1
    return c / 2 * 1.0005 * (-(2 ^ (-10 * t)) + 2) + b
  end
end

local outInExpo = makeOutIn(outExpo, inExpo)

-------------------------
-- Circular
-------------------------
local function inCirc(t, b, c, d)
  t = nrm(t, d)
  return -c * (sqrt(1 - t * t) - 1) + b
end

local function outCirc(t, b, c, d)
  t = nrm(t, d) - 1
  return c * sqrt(1 - t * t) + b
end

local function inOutCirc(t, b, c, d)
  t = nrm(t, d) * 2
  if t < 1 then
    return -c / 2 * (sqrt(1 - t * t) - 1) + b
  else
    t = t - 2
    return c / 2 * (sqrt(1 - t * t) + 1) + b
  end
end

local outInCirc = makeOutIn(outCirc, inCirc)

-------------------------
-- Elastic
-- a: amplitude, p: period
-------------------------
local function inElastic(t, b, c, d, a, p)
  if t == 0 then return b end
  t = nrm(t, d)
  if t == 1 then return b + c end
  p = p or (d * 0.3)

  local s
  if not a or a < abs(c) then
    a = c
    s = p / 4
  else
    s = p / (2 * pi) * asin(c / a)
  end

  t = t - 1
  return -(a * (2 ^ (10 * t)) * sin((t * d - s) * (2 * pi) / p)) + b
end

local function outElastic(t, b, c, d, a, p)
  if t == 0 then return b end
  t = nrm(t, d)
  if t == 1 then return b + c end
  p = p or (d * 0.3)

  local s
  if not a or a < abs(c) then
    a = c
    s = p / 4
  else
    s = p / (2 * pi) * asin(c / a)
  end

  return a * (2 ^ (-10 * t)) * sin((t * d - s) * (2 * pi) / p) + c + b
end

local function inOutElastic(t, b, c, d, a, p)
  if t == 0 then return b end
  t = nrm(t, d) * 2
  if t == 2 then return b + c end

  p = p or (d * (0.3 * 1.5))
  a = a or 0

  local s
  if not a or a < abs(c) then
    a = c
    s = p / 4
  else
    s = p / (2 * pi) * asin(c / a)
  end

  if t < 1 then
    t = t - 1
    return -0.5 * (a * (2 ^ (10 * t)) * sin((t * d - s) * (2 * pi) / p)) + b
  else
    t = t - 1
    return a * (2 ^ (-10 * t)) * sin((t * d - s) * (2 * pi) / p) * 0.5 + c + b
  end
end

local outInElastic = makeOutIn(outElastic, inElastic)

-------------------------
-- Back
-- s: overshoot
-------------------------
local function inBack(t, b, c, d, s)
  s = s or 1.70158
  t = nrm(t, d)
  return c * t * t * ((s + 1) * t - s) + b
end

local function outBack(t, b, c, d, s)
  s = s or 1.70158
  t = nrm(t, d) - 1
  return c * (t * t * ((s + 1) * t + s) + 1) + b
end

local function inOutBack(t, b, c, d, s)
  s = (s or 1.70158) * 1.525
  t = nrm(t, d) * 2
  if t < 1 then
    return c / 2 * (t * t * ((s + 1) * t - s)) + b
  else
    t = t - 2
    return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b
  end
end

local outInBack = makeOutIn(outBack, inBack)

-------------------------
-- Bounce
-------------------------
local function outBounce(t, b, c, d)
  t = nrm(t, d)
  if t < 1 / 2.75 then
    return c * (7.5625 * t * t) + b
  elseif t < 2 / 2.75 then
    t = t - (1.5 / 2.75)
    return c * (7.5625 * t * t + 0.75) + b
  elseif t < 2.5 / 2.75 then
    t = t - (2.25 / 2.75)
    return c * (7.5625 * t * t + 0.9375) + b
  else
    t = t - (2.625 / 2.75)
    return c * (7.5625 * t * t + 0.984375) + b
  end
end

local function inBounce(t, b, c, d)
  return c - outBounce(d - t, 0, c, d) + b
end

local function inOutBounce(t, b, c, d)
  if t < d / 2 then
    return inBounce(t * 2, 0, c, d) * 0.5 + b
  else
    return outBounce(t * 2 - d, 0, c, d) * 0.5 + c * 0.5 + b
  end
end

local outInBounce = makeOutIn(outBounce, inBounce)

-- Public API (names preserved 1:1)
return {
  linear       = linear,

  inQuad       = inQuad,
  outQuad      = outQuad,
  inOutQuad    = inOutQuad,
  outInQuad    = outInQuad,

  inCubic      = inCubic,
  outCubic     = outCubic,
  inOutCubic   = inOutCubic,
  outInCubic   = outInCubic,

  inQuart      = inQuart,
  outQuart     = outQuart,
  inOutQuart   = inOutQuart,
  outInQuart   = outInQuart,

  inQuint      = inQuint,
  outQuint     = outQuint,
  inOutQuint   = inOutQuint,
  outInQuint   = outInQuint,

  inSine       = inSine,
  outSine      = outSine,
  inOutSine    = inOutSine,
  outInSine    = outInSine,

  inExpo       = inExpo,
  outExpo      = outExpo,
  inOutExpo    = inOutExpo,
  outInExpo    = outInExpo,

  inCirc       = inCirc,
  outCirc      = outCirc,
  inOutCirc    = inOutCirc,
  outInCirc    = outInCirc,

  inElastic    = inElastic,
  outElastic   = outElastic,
  inOutElastic = inOutElastic,
  outInElastic = outInElastic,

  inBack       = inBack,
  outBack      = outBack,
  inOutBack    = inOutBack,
  outInBack    = outInBack,

  inBounce     = inBounce,
  outBounce    = outBounce,
  inOutBounce  = inOutBounce,
  outInBounce  = outInBounce,
}
