unit SDL_Tools;
{:< Basic tools to make SDL Graphics programming easier}

{

  Simple GUI is based upon Lachlans GUI (LK GUI). LK GUI's original source code
  remark is shown below.

  Written permission to re-license the library has been granted to me by the
  original author.

}

{*******************************************************}
{                                                       }
{       Helper functions for drawing with SDL           }
{                                                       }
{       Copyright (c) 2009-10 Lachlan Kingsford         }
{                                                       }
{*******************************************************}

{

    Simple GUI
    **********

    Copyright (c) 2016 Matthias J. Molski

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to
    deal in the Software without restriction, including without limitation the
    rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
    sell copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
    IN THE SOFTWARE.

}

interface

uses Math, SDL2, SG_GuiLib_Base;

function calcdistance(x1, y1, x2, y2: extended): extended;
procedure drawpixel(x, y: Word; screen: PSDL_Surface; r, g, b: UInt8); inline;
procedure drawpixel(x, y: Word; screen: PSDL_Surface; r, g, b, a: UInt16); inline;
procedure drawalphapixel(x, y: Word; screen: PSDL_Surface; r, g, b: UInt8;
  a: extended); inline;
procedure drawline(x0, y0, x1, y1: Word; screen: PSDL_Surface; r, g, b: UInt16);
  inline; overload;

(*
  SDL2 conv.: new and overridden procedures
*)

procedure fillrect(renderer: PSDL_Renderer; targetTex: PSDL_Texture;
  rect: PSDL_Rect; color: tRGBA); inline;                 // obsolete

procedure drawline(renderer: PSDL_Renderer; targetTex: PSDL_Texture;
  x0, y0, x1, y1: Word; color: tRGBA); inline; overload;  // obsolete

implementation

function calcdistance(x1, y1, x2, y2: extended): extended; inline;
begin
  calcdistance := sqrt(sqr(max(x1, x2) - min(x1, x2)) + sqr(max(y1, y2) - min(y1, y2)));
end;

procedure drawpixel(x, y: Word; screen: PSDL_Surface; r, g, b: UInt8); inline;
var
  target: PUint32;
begin
  if ((y * screen^.w + x) < (screen^.h * screen^.w)) then
  begin
    target := (PUint32(screen^.pixels)) + Y * screen^.w + X;
    (Target)^ := UInt32(SDL_MapRGB(screen^.format, r, g, b));
  end;
end;

procedure drawpixel(x, y: Word; screen: PSDL_Surface; r, g, b, a: UInt16); inline;
var
  target: PUint32;
begin
  if ((y * screen^.w + x) < (screen^.h * screen^.w)) then
  begin
    target := (PUint32(screen^.pixels)) + Y * screen^.w + X;
    (Target)^ := UInt32(SDL_MapRGBA(screen^.format, r, g, b, a));
  end;
end;

procedure drawalphapixel(x, y: Word; screen: PSDL_Surface; r, g, b: UInt8;
  a: extended); inline;
var
  target: PUint32;
  oldr, oldg, oldb: PUint8;
begin
  if ((y * screen^.w + x) < (screen^.h * screen^.w)) then
  begin
    target := (PUint32(screen^.pixels)) + Y * screen^.w + X;
    new(oldr);
    new(oldg);
    new(oldb);
    SDL_GetRGB(target^, screen^.format, oldr, oldg, oldb);
    (Target)^ := UInt32(SDL_MapRGB(screen^.format, round((1 - a) * oldr^ + a * r),
      round((1 - a) * oldg^ + a * g), round((1 - a) * oldb^ + a * b)));
    dispose(oldr);
    dispose(oldg);
    dispose(oldb);
  end;
end;


//Based on http://freespace.virgin.net/hugo.elias/graphics/x_wuline.htm
procedure drawline(x0, y0, x1, y1: Word; screen: PSDL_Surface; r, g, b: UInt16);
var
  grad, xd, yd, xgap, xend, yend, xf, yf, brightness1, brightness2: extended;

  xtemp, ytemp, ix1, ix2, iy1, iy2: Integer;
  shallow: Boolean;

begin
  //Draw endpoints
  //Note: Maybe replace with 'point' style endpoints?
  {drawalphapixel(x0, y0, screen, r, g, b, 1);
  drawalphapixel(x1, y1, screen, r, g, b, 1);}

  //Why this code works...
  //I don't know! The steep code was largely trial and error...

  //Width and height of the line
  xd := (x1 - x0);
  yd := (y1 - y0);

  //Check line gradient
  if abs(xd) > abs(yd) then
    shallow := True
  else
    shallow := False;


  if x0 > x1 then
  begin
    xtemp := x0;
    x0 := x1;
    x1 := xtemp;
    xtemp := y0;
    y0 := y1;
    y1 := xtemp;
    xd := x1 - x0;
    yd := y1 - y0;
  end;

  if (shallow) then
    grad := yd / xd
  else
    grad := xd / yd;


  //End Point 1
  xend := trunc(x0 + 0.5);
  yend := y0 + grad * (xend - x0);
  xgap := 1 - frac(x0 + 0.5);

  ix1 := trunc(xend);
  iy1 := trunc(yend);

  brightness1 := (1 - frac(yend)) * xgap;
  brightness2 := frac(yend) * xgap;

  DrawAlphaPixel(ix1, iy1, screen, r, g, b, brightness1);
  DrawAlphaPixel(ix1, iy1 + 1, screen, r, g, b, brightness2);

  yf := yend + grad;
  xf := xend + grad;

  //End Point 2;
  xend := trunc(x1 + 0.5);
  yend := y1 + grad * (xend - x1);
  xgap := 1 - frac(x1 + 0.5);

  ix2 := trunc(xend);
  iy2 := trunc(yend);


  brightness1 := (1 - frac(yend)) * xgap;
  brightness2 := frac(yend) * xgap;

  DrawAlphaPixel(ix2, iy2, screen, r, g, b, brightness1);
  DrawAlphaPixel(ix2, iy2 + 1, screen, r, g, b, brightness2);

  if not (shallow) then
    if iy1 > iy2 then
    begin
      ytemp := iy2;
      iy2 := iy1;
      iy1 := ytemp;
      xtemp := ix2;
      ix2 := ix1;
      ix1 := xtemp;
      xf := xend + grad;
    end;

  //Main Loop
  if (shallow) then
    for xtemp := (ix1 + 1) to (ix2 - 1) do
    begin
      brightness1 := 1 - frac(yf);
      brightness2 := frac(yf);
      drawalphapixel(xtemp, trunc(yf), screen, r, g, b, brightness1);
      drawalphapixel(xtemp, trunc(yf) + 1, screen, r, g, b, brightness2);
      yf := yf + grad;

    end
  else
    for ytemp := (iy1 + 1) to (iy2 - 1) do
    begin
      brightness1 := 1 - frac(xf);
      brightness2 := frac(xf);
      drawalphapixel(trunc(xf), ytemp, screen, r, g, b, brightness1);
      drawalphapixel(trunc(xf) + 1, ytemp, screen, r, g, b, brightness2);
      xf := xf + grad;

    end;
end;

{
  SDL2 re-strct.: new functions and procedure for better performance
}

//function MakeRect(ax, ay, aw, ah: Word): PSDL_Rect;
//const
//  ARect: TSDL_Rect = (x: 0; y: 0; w: 0; h: 0);
//begin
//  with ARect do
//  begin
//    x := ax;
//    y := ay;
//    w := aw;
//    h := ah;
//  end;
//  Result := @ARect;
//end;

//procedure RenderFilledRect(renderer: PSDL_Renderer; rect: PSDL_Rect; color: tRGBA);
//begin
//  SDL_SetRenderDrawColor(renderer, color.r, color.g, color.b, color.a);
//  SDL_RenderFillRect(renderer, rect);
//end;
//
//procedure RenderLine(renderer: PSDL_Renderer; x0, y0, x1, y1: Word;
//  color: tRGBA);
//begin
//  SDL_SetRenderDrawColor(renderer, color.r, color.g, color.b, color.a);
//  SDL_RenderDrawLine(renderer, x0, y0, x1, y1);
//end;

(*
  SDL2 conv.: implemenetation of new and overridden procedures
*)

procedure drawline(renderer: PSDL_Renderer; targetTex: PSDL_Texture;
  x0, y0, x1, y1: Word; color: tRGBA);
begin
  SDL_SetRenderTarget(renderer, targetTex);
  SDL_SetRenderDrawColor(renderer, color.r, color.g, color.b, color.a);
  SDL_RenderDrawLine(renderer, x0, y0, x1, y1);
  SDL_SetRenderTarget(renderer, nil);
end;

procedure fillrect(renderer: PSDL_Renderer; targetTex: PSDL_Texture;
  rect: PSDL_Rect; color: tRGBA);
begin
  SDL_SetRenderTarget(renderer, targetTex);
  SDL_SetRenderDrawColor(renderer, color.r, color.g, color.b, color.a);

  if rect = nil then
    SDL_RenderClear(Renderer)
  else
    SDL_RenderDrawRect(renderer, rect);

  SDL_SetRenderTarget(renderer, nil);
end;


begin

end.
