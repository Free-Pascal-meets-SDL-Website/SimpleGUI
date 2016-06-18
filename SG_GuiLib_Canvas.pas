unit SG_GuiLib_Canvas;
{:< The Canvas object (base of drawable widgets) and its support }

{

  Simple GUI is based upon Lachlans GUI (LK GUI). LK GUI's original source code
  remark is shown below.

  Written permission to re-license the library has been granted to me by the
  original author.

}

{*******************************************************}
{                                                       }
{       Lachlans GUI Library                            }
{       Base object of TGUI_Canvas                      }
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

uses SDL2, SDL2_TTF, SysUtils, SG_GuiLib_Base, SG_GuiLib_Element;

type
  //A Canvas is the generic drawable control. Most things come from Canvas.
  //I['ve] [plan to] include[d] a chunk of drawing and text routines to make
  //this an effective base as well as unifying BackColor, Caption etc...
  PGUI_Canvas = ^TGUI_Canvas;

  TGUI_Canvas = object(TGUI_Element)
  public
    procedure Render; virtual;

    procedure SetBackColor(InColor: tRGBA);
    function GetBackColor: tRGBA;

    procedure SetActiveColor(InColor: tRGBA);
    function GetActiveColor: tRGBA;

    procedure SetForeColor(InColor: tRGBA);
    function GetForeColor: tRGBA;

    procedure SetFont(InFont: pTTF_Font);
    function GetFont: pTTF_Font;

    procedure SetBorderStyle(NewStyle: tBorderStyle);
    function GetBorderStyle: tBorderStyle;

    procedure SetBorderColor(InColor: tRGBA);
    function GetBorderColor: tRGBA;

    procedure SetFillStyle(NewStyle: tFillStyle);
    function GetFillStyle: tFillStyle;

    procedure SetCaption(InCaption: string);
    function GetCaption: string;
    function GetPCharCaption: PChar;

    procedure DoDoneStuff; virtual;

    procedure ctrl_FontChanged; virtual;

    constructor Init_Canvas;
    destructor Done_Canvas;

  protected
    BackColor: tRGBA;
    ForeColor: tRGBA;
    ActiveColor: tRGBA;
    CurFillColor: tRGBA;
    CurBorderColor: tRGBA;
    FillStyle: tFillStyle;
    Caption: PChar;
    BorderStyle: tBorderStyle;
    BorderColor: tRGBA;
    Font: pTTF_Font;
    FontHeight, FontAscent, FontDescent, FontLineSkip: integer;
    FontMonospace: integer;
    procedure DrawText(Textin: PChar; X, Y: word; Alignment: tTextAlign);
    procedure DrawText(Textin: string; X, Y: word; Alignment: tTextAlign);
  private
  end;

implementation

uses
  SDL_Tools, Strings;

var
  Exceptn: Exception;

{//
TGUI_Canvas
//}

procedure TGUI_Canvas.Render;
begin
  if Visible then
  begin
    case FillStyle of
      FS_Filled:
      begin
        fillrect(Renderer, Texture, nil, CurFillColor);
      end;
      FS_None:
      begin
        fillrect(Renderer, Texture, nil, GUI_FullTrans);
      end;
    end;

    //Draw Borders
    case borderstyle of
      bs_single:
      begin
        drawline(Renderer, Texture, 0, 0, Width, 0, CurBorderColor);
        drawline(Renderer, Texture, Width - 1, 0, Width - 1, Height, CurBorderColor);
        drawline(Renderer, Texture, 0, Height - 1, Width, Height - 1, CurBorderColor);
        drawline(Renderer, Texture, 0, 0, 0, Height, CurBorderColor);
      end;
    end;

    (*SDL2 conv.: ?? why still in code?? *)
    (*
    DrawText( 'Left Test', 0, 0, Align_Left);
    DrawText( 'Center Test', width div 2 , 20, Align_Center);
    DrawText( 'Right Test', width, 40, Align_Right);
    *)

  end;
end;

procedure TGUI_Canvas.SetBackColor(InColor: tRGBA);
begin
  BackColor := InColor;
  CurFillColor := InColor;
end;

function TGUI_Canvas.GetBackColor: tRGBA;
begin
  GetBackColor := BackColor;
end;

procedure TGUI_Canvas.SetActiveColor(InColor: tRGBA);
begin
  ActiveColor := InColor;
end;

function TGUI_Canvas.GetActiveColor: tRGBA;
begin
  GetActiveColor := ActiveColor;
end;

procedure TGUI_Canvas.SetForeColor(InColor: tRGBA);
begin
  ForeColor := InColor;
end;

function TGUI_Canvas.GetForeColor: tRGBA;
begin
  GetForeColor := ForeColor;
end;

procedure TGUI_Canvas.SetFont(InFont: pTTF_Font);
begin
  Font := InFont;
  FontHeight := TTF_FontHeight(Font);
  FontAscent := TTF_FontAscent(Font);
  FontDescent := TTF_FontDescent(Font);
  FontLineSkip := TTF_FontLineSkip(Font);
  FontMonospace := TTF_FontFaceIsFixedWidth(Font);
  ctrl_FontChanged;
end;

function TGUI_Canvas.GetFont: pTTF_Font;
begin
  GetFont := Font;
end;

constructor TGUI_Canvas.Init_Canvas;
begin
  inherited init;
  SetForeColor(GUI_DefaultForeColor);
  SetBackColor(GUI_DefaultBackColor);
  Width := 256;
  Height := 256;
  Visible := True;
  BorderStyle := BS_None;
  SetBorderColor(GUI_DefaultBorderColor);
  SetActiveColor(GUI_DefaultActiveColor);
  SetFillStyle(FS_Filled);
end;

procedure TGUI_Canvas.DoDoneStuff;
begin
  if Caption <> nil then
    StrDispose(Caption);
end;

destructor TGUI_Canvas.Done_Canvas;
begin
  inherited done;
end;

procedure TGUI_Canvas.SetBorderColor(InColor: tRGBA);
begin
  BorderColor := InColor;
  CurBorderColor := InColor;
end;

function TGUI_Canvas.GetBorderColor: tRGBA;
begin
  GetBorderColor := BorderColor;
end;

procedure TGUI_Canvas.SetBorderStyle(NewStyle: tBorderStyle);
begin
  BorderStyle := NewStyle;
end;

function TGUI_Canvas.GetBorderStyle: tBorderStyle;
begin
  GetBorderStyle := BorderStyle;
end;

procedure TGUI_Canvas.SetFillStyle(NewStyle: tFillStyle);
begin
  FillStyle := NewStyle;
end;

function TGUI_Canvas.GetFillStyle: tFillStyle;
begin
  GetFillStyle := FillStyle;
end;


procedure TGUI_Canvas.DrawText(Textin: string; X, Y: word; Alignment: tTextAlign);
var
  Pcharstring: PChar;
begin
  PCharString := StrAlloc(Length(TextIn) + 1);
  StrPCopy(PCharString, TextIn);
  DrawText(PCharString, X, Y, Align_Left);
  StrDispose(PCHarString);
end;


procedure TGUI_Canvas.DrawText(TextIn: PChar; X, Y: word; Alignment: tTextAlign);
var
  loc: TSDL_Rect;
  tempw, temph: longint;
  msgsfc: PSDL_Surface;
  (*
    SDL2 conv.: Don't think about using Texture directly, because the text
                created often combined with other textures; temporary "msgtex"
                necessary!
  *)
  msgtex: PSDL_Texture;
  Color: TSDL_Color;
begin
  if font = nil then
    Exceptn.Create('DrawText called on ' + DbgName + ' with no Font Set');

  if (Font <> nil) and (TextIn <> nil) then
  begin

    (* get width and height of text surface and texture *)
    TTF_SizeText(font, textin, @tempw, @temph);
    loc.w := tempw;
    loc.h := temph;

    (*
    SDL2 conv.: the x and y values are relative to element (this not the right
                place to ensure relative coordinates to parent element!)
                It is correct how it is here!
     *)
    case Alignment of
      Align_Left:
      begin
        loc.x := x;
        loc.y := Y;
      end;
      Align_Center:
      begin
        loc.x := x - (tempw div 2);
        loc.y := Y;
      end;
      Align_Right:
      begin
        loc.x := x - (tempw);
        loc.y := y;
      end;
    end;
    color.r := forecolor.r;
    color.g := forecolor.g;
    color.b := forecolor.b;

    (* create text surface and create text texture from surface *)
    msgsfc := TTF_RenderText_Blended(font, textin, color);
    msgtex := SDL_CreateTextureFromSurface(Renderer, msgsfc);

    (*
      SDL2 conv.: Not sure what is the difference between implementation in case
      of FS_None (seems wrong) and if not FS_None, so both are implemented
      the same for SDL2 version at the moment.
    *)
    if FillStyle = FS_None then
    begin

      (* original code *)
        (*
        SDL_SetAlpha(msgsfc, 0, surface^.format^.alpha);
        SDL_BlitSurface(msgsfc, nil, Surface, @Loc);
        SDL_SetAlpha(msgsfc, SDL_SRCALPHA, surface^.format^.alpha);
        *)
        (*
          SDL_SetAlpha with flag 0 will not change anything for blitting, but after
          blitting SetApha() is flagged SDL_SRCALPHA which would make alpha blitting
          possible. So it should be called before blitting and re-set by 0 afterwards.
          -- right??
        *)

      (* by analogy *)
      SDL_SetRenderTarget(Renderer, Texture);
      SDL_RenderCopy(Renderer,
        msgtex,
        nil, @Loc);
      SDL_SetRenderTarget(Renderer, nil);
    end
    else
    begin
      (* original code *)
        (*
        SDL_BlitSurface(msgsfc, nil, Surface, @Loc);
        *)

      (* by analogy *)
      SDL_SetRenderTarget(Renderer, Texture);
      SDL_RenderCopy(Renderer,
        msgtex,
        nil, @Loc);
      SDL_SetRenderTarget(Renderer, nil);
    end;

    SDL_FreeSurface(msgsfc);
    SDL_DestroyTexture(msgtex);
  end;
end;

procedure TGUI_Canvas.SetCaption(InCaption: string);
begin
  if Caption <> nil then
    StrDispose(Caption);

  Caption := StrAlloc(Length(InCaption) + 1);
  StrPCopy(Caption, InCaption);
end;

function TGUI_Canvas.GetCaption: string;
begin
  GetCaption := StrPas(Caption);
end;

function TGUI_Canvas.GetPCharCaption: PChar;
begin
  GetPCharCaption := Caption;
end;

procedure TGUI_Canvas.ctrl_FontChanged;
begin

end;

begin

end.
