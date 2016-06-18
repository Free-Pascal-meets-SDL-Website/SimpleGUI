unit SG_GuiLib_Console;
{:< The console object and its supporting types}

{

  Simple GUI is based upon Lachlans GUI (LK GUI). LK GUI's original source code
  remark is shown below.

  Written permission to re-license the library has been granted to me by the
  original author.

}

{*******************************************************}
{                                                       }
{       SDL Console Library for LK_GUI                  }
{       Pretty much written for RL development          }
{       but could be used for other TUIs                }
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

uses SDL2, SDL2_TTF, SG_GuiLib_Canvas, SG_GuiLib_Base, SDL_Tools;

const
{$WARNINGS OFF}
  Color_Black: TSDL_Color = (R: 0; G: 0; B: 0);
  Color_Blue: TSDL_Color = (R: 0; G: 0; B: 170);
  Color_Green: TSDL_Color = (R: 0; G: 170; B: 0);
  Color_Cyan: TSDL_Color = (R: 0; G: 170; B: 170);
  Color_Red: TSDL_Color = (R: 170; G: 0; B: 0);
  Color_Magenta: TSDL_Color = (R: 170; G: 0; B: 170);
  Color_Brown: TSDL_Color = (R: 170; G: 85; B: 0);
  Color_LI_White: TSDL_Color = (R: 170; G: 170; B: 170);
  Color_Gray: TSDL_Color = (R: 85; G: 85; B: 85);
  Color_LightBlue: TSDL_Color = (R: 85; G: 85; B: 255);
  Color_LighGreen: TSDL_Color = (R: 85; G: 255; B: 85);
  Color_LighCyan: TSDL_Color = (R: 85; G: 255; B: 255);
  Color_LightRed: TSDL_Color = (R: 255; G: 85; B: 85);
  Color_LightMagenta: TSDL_Color = (R: 255; G: 85; B: 255);
  Color_LightBrown: TSDL_Color = (R: 255; G: 170; B: 85);
  Color_White: TSDL_Color = (R: 255; G: 255; B: 255);
 {$WARNINGS ON}

type

  pXYWord = ^tXYWord;

  tXYWord = record
    X, Y: word;
  end;

  pVideoCell = ^tVideoCell;

  tVideoCell = record
    Character: word;
    fore: TSDL_Color;
    back: TSDL_Color;
    transback: boolean;
  end;

  pVidArray = ^tVidArray;
  tVidArray = array [0..32767] of tVideoCell;

  PGUI_Console = ^TGUI_Console;

  TGUI_Console = object(TGUI_Canvas)
  public
    Display: tVidArray;
    AARender: boolean;

    constructor Init_Console;
    destructor Done_Console;

    function GetCursor: tXYWord;
    procedure SetCursor(X, Y: word);

    function GetTransBackDefault: boolean;
    procedure SetTransBackDefault(NewDefault: boolean);

    function GetConsoleSize: tXYWord;
    procedure SetConsoleSize(X, Y: word);
    procedure SetConsoleSize(Size: tXYWord);

    procedure SetForeColor(NewSDLColor: TSDL_Color);
    procedure SetBackColor(NewSDLColor: TSDL_Color);

    procedure Render; virtual;
    procedure ClearScr;

    function GetRef(X, Y: word): word; inline;

    procedure Write(InStr: string);
  protected
    Cursor: tXYWord;
    Dimensions: tXYWord;

    TransBackDefault: boolean;
  end;

implementation

constructor TGUI_Console.Init_Console;
begin
  inherited Init_Canvas;
  SetConsoleSize(80, 25);
  SetCursor(0, 0);
  SetForeColor(Color_Li_White);
  SetBackColor(Color_Black);
  SetTransBackDefault(True);
  SetFillStyle(FS_None);
  ClearScr;
end;

destructor TGUI_Console.Done_Console;
begin
  inherited Done_Canvas;
end;

//Accessors for Cursor Functions
function TGUI_Console.GetCursor: tXYWord;
begin
  GetCursor.X := Cursor.X;
  GetCursor.Y := Cursor.Y;
end;

procedure TGUI_Console.SetCursor(X, Y: word);
begin
  Cursor.X := X;
  Cursor.Y := Y;
end;

function TGUI_Console.GetTransBackDefault: boolean;
begin
  GetTransBackDefault := TransBackDefault;
end;

procedure TGUI_Console.SetTransBackDefault(NewDefault: boolean);
begin
  TransBackDefault := NewDefault;
end;

//Accessors for Console Size
//(TODO) - Console Size's should rearrange the display
function TGUI_Console.GetConsoleSize: tXYWord;
begin
  GetConsoleSize := Dimensions;
end;

procedure TGUI_Console.SetConsoleSize(X, Y: word);
begin
  Dimensions.X := X;
  Dimensions.Y := Y;
end;

procedure TGUI_Console.SetConsoleSize(Size: tXYWord);
begin
  Dimensions := Size;
end;

function TGUI_Console.GetRef(X, Y: word): word; inline;
begin
  GetRef := X + Y * Dimensions.X;
end;

procedure TGUI_Console.SetForeColor(NewSDLColor: TSDL_Color);
begin
  ForeColor.R := NewSDLColor.R;
  ForeColor.G := NewSDLColor.G;
  ForeColor.B := NewSDLColor.B;
end;

procedure TGUI_Console.SetBackColor(NewSDLColor: TSDL_Color);
begin
  BackColor.R := NewSDLColor.R;
  BackColor.G := NewSDLColor.G;
  BackColor.B := NewSDLColor.B;
end;

//Writes a line of text
procedure TGUI_Console.Write(InStr: string);
var
  i: word;
begin
  for i := 1 to length(InStr) do
    with display[GetRef(Cursor.X + i - 1, Cursor.Y)] do
    begin
      Character := word(InStr[i]);
      Fore.r := ForeColor.r;
      Fore.g := ForeColor.g;
      Fore.b := ForeColor.b;
      Back.r := BackColor.r;
      Back.g := BackColor.g;
      Back.b := BackColor.b;
      TransBack := TransBackDefault;
    end;
end;

//Draws the console to the surface
procedure TGUI_Console.Render;
var
  CurX, CurY, FWidth: longint;
  MinX, MaxX, MinY, MaxY, d: longint;
  curglyph: pSDL_Surface;
  Loc: SDL_Rect;
begin
  inherited Render;
  if font <> nil then
  begin
    TTF_GlyphMetrics(Font, word('w'), MinX, FWidth, MinY, MaxY, d);
    for CurX := 0 to (Dimensions.x - 1) do
    begin
      for CurY := 0 to (Dimensions.y) do
        with Display[GetRef(CurX, CurY)] do
        begin
          //CurGlyph := TTF_RenderGlyph_Solid(font, Character, fore);
          if not (transback) then
            CurGlyph := TTF_RenderGlyph_Shaded(font, Character, fore, back)
          else
            CurGlyph := TTF_RenderGlyph_Blended(font, Character, fore);

          TTF_GlyphMetrics(Font, Character, MinX, MaxX, MinY, MaxY, d);
          loc.x := CurX * FWidth;
          loc.y := (CurY * FontHeight) - MaxY + FontAscent;
          //SDL_BlitSurface(CurGlyph, nil, Surface, @Loc);
          if FillStyle = FS_None then
          begin
            SDL_SetAlpha(CurGlyph, 0, surface^.format^.alpha);
            SDL_BlitSurface(CurGlyph, nil, Surface, @Loc);
            SDL_SetAlpha(CurGlyph, SDL_SRCALPHA, surface^.format^.alpha);
          end
          else
          begin
            SDL_BlitSurface(CurGlyph, nil, Surface, @Loc);
          end;
          SDL_freesurface(CurGlyph);
        end;
    end;
    if GetSelected then
    begin
      drawline(Cursor.X * Fwidth, (Cursor.Y * FontHeight) - MaxY + FontAscent,
        (Cursor.X + 1) * Fwidth, (Cursor.Y * FontHeight) - MaxY + FontAscent, surface,
        ForeColor.r, ForeColor.G, ForeColor.B);
    end;
  end;
end;

//Clears every character
procedure TGUI_Console.ClearScr;
var
  i: word;
begin
  for i := 0 to high(Display) do
    with display[i] do
    begin
      character := $20;
      fore.r := forecolor.r;
      fore.g := forecolor.g;
      fore.b := forecolor.b;
      back.r := backcolor.r;
      back.g := backcolor.g;
      back.b := backcolor.b;
      transback := transbackdefault;
    end;
end;

begin

end.
