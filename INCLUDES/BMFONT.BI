$IncludeOnce

type TBMFontGlyph
  as integer id, x, y
  as integer width, height, xoffset, yoffset, xadvance
  ' as integer page, chnl
end type

type TBMFont
  face as string * 128
  filename as string * 32
  lineHeight as integer
  imgHandle as long
end type
