return {
  -- Gruvbox-inspired palette from your shell config
  black = 0xff1d2021,
  white = 0xfffbf1c7,        -- Gruvbox retro orangey white
  red = 0xffcc241d,
  green = 0xff98971a,
  blue = 0xff458588,
  yellow = 0xffd79921,
  orange = 0xffd65d0e,
  magenta = 0xffb16286,
  grey = 0xff928374,
  transparent = 0x00000000,

  bar = {
    bg = 0x00000000,         -- Fully transparent bar
    border = 0x00000000,
  },
  popup = {
    bg = 0xe01d2021,         -- Semi-transparent dark popup
    border = 0xff928374
  },
  bg1 = 0xff3c3836,          -- Gruvbox bg1
  bg2 = 0xff504945,          -- Gruvbox bg2

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
