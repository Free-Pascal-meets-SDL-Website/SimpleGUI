unit SG_GuiLib_Canvas;
{:< The Canvas Class (base of drawable widgets) Unit and its support }

{ Simple GUI is a generic SDL2/Pascal GUI library by Matthias J. Molski,
  get more infos here:
    https://github.com/Free-Pascal-meets-SDL-Website/SimpleGUI.

  It is based upon LK GUI by Lachlan Kingsford for SDL 1.2/Free Pascal,
  get it here: https://sourceforge.net/projects/lkgui.

  Written permission to re-license the library has been granted to me by the
  original author.

  Copyright (c) 2016-2020 Matthias J. Molski

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
  IN THE SOFTWARE. }

interface

uses SDL2, SDL2_TTF, SysUtils, SG_GuiLib_Element, SG_GuiLib_Base;

type
  { TGUI_Canvas }
  {: A Canvas is the generic drawable control. Most things come from Canvas. }
  TGUI_Canvas = class(TGUI_Element)
  public
    procedure Render; override;

    procedure SetBackColor(InColor: TRGBA);
    function GetBackColor: TRGBA;

    procedure SetActiveColor(InColor: TRGBA);
    function GetActiveColor: TRGBA;

    procedure SetForeColor(InColor: TRGBA);
    function GetForeColor: TRGBA;

    procedure SetFont(InFont: PTTF_Font);
    function GetFont: PTTF_Font;

    procedure SetBorderStyle(NewStyle: TBorderStyle);
    function GetBorderStyle: TBorderStyle;

    procedure SetBorderColor(InColor: TRGBA);
    function GetBorderColor: TRGBA;

    procedure SetFillStyle(NewStyle: TFillStyle);
    function GetFillStyle: TFillStyle;

    procedure SetCaption(InCaption: string);
    function GetCaption: string;

    procedure ctrl_FontChanged; virtual;

    constructor Create;
    destructor Destroy; override;

  protected
    BackColor: TRGBA;
    ForeColor: TRGBA;
    ActiveColor: TRGBA;
    CurFillColor: TRGBA;
    CurBorderColor: TRGBA;
    FillStyle: TFillStyle;
    Caption: string;
    BorderStyle: TBorderStyle;
    BorderColor: TRGBA;
    Font: PTTF_Font;
    FontHeight, FontAscent, FontDescent, FontLineSkip: Integer;
    FontMonospace: Integer;
    { Helper procedures/functions }
    function MakeRect(ax, ay, aw, ah: Word): PSDL_Rect;
    procedure RenderRect(Rect: PSDL_Rect; Color: TRGBA);
    procedure RenderFilledRect(Rect: PSDL_Rect; Color: TRGBA);
    procedure RenderLine(x0, y0, x1, y1: Word; Color: TRGBA);
    procedure RenderText(TextIn: string; x, y: Word; Alignment: TTextAlign);
  private
  end;

implementation

uses
  SDL2_SimpleGUI;

var
  Exceptn: Exception;

{ TGUI_Canvas }

procedure TGUI_Canvas.Render;
begin
  if Visible then
  begin
    case FillStyle of
      FS_Filled:
      begin
        RenderFilledRect(
          MakeRect(GetAbsLeft, GetAbsTop, GetWidth, GetHeight),
          CurFillColor
        );
      end;
      FS_None:
      begin
        RenderFilledRect(
          MakeRect(GetAbsLeft, GetAbsTop, GetWidth, GetHeight),
          GUI_FullTrans
        );
      end;
    end;

    // Draw Borders
    case BorderStyle of
      BS_Single:
      begin
        RenderRect(
          MakeRect(GetAbsLeft, GetAbsTop, GetWidth, GetHeight),
          CurBorderColor
        );
      end;
    end;
  end;
end;

procedure TGUI_Canvas.SetBackColor(InColor: TRGBA);
begin
  BackColor := InColor;
  CurFillColor := InColor;
end;

function TGUI_Canvas.GetBackColor: TRGBA;
begin
  GetBackColor := BackColor;
end;

procedure TGUI_Canvas.SetActiveColor(InColor: TRGBA);
begin
  ActiveColor := InColor;
end;

function TGUI_Canvas.GetActiveColor: TRGBA;
begin
  GetActiveColor := ActiveColor;
end;

procedure TGUI_Canvas.SetForeColor(InColor: TRGBA);
begin
  ForeColor := InColor;
end;

function TGUI_Canvas.GetForeColor: TRGBA;
begin
  GetForeColor := ForeColor;
end;

procedure TGUI_Canvas.SetFont(InFont: PTTF_Font);
begin
  Font := InFont;
  FontHeight := TTF_FontHeight(Font);
  FontAscent := TTF_FontAscent(Font);
  FontDescent := TTF_FontDescent(Font);
  FontLineSkip := TTF_FontLineSkip(Font);
  FontMonospace := TTF_FontFaceIsFixedWidth(Font);
  ctrl_FontChanged;
end;

function TGUI_Canvas.GetFont: PTTF_Font;
begin
  GetFont := Font;
end;

procedure TGUI_Canvas.SetBorderColor(InColor: TRGBA);
begin
  BorderColor := InColor;
  CurBorderColor := InColor;
end;

function TGUI_Canvas.GetBorderColor: TRGBA;
begin
  GetBorderColor := BorderColor;
end;

procedure TGUI_Canvas.SetBorderStyle(NewStyle: TBorderStyle);
begin
  BorderStyle := NewStyle;
end;

function TGUI_Canvas.GetBorderStyle: TBorderStyle;
begin
  GetBorderStyle := BorderStyle;
end;

procedure TGUI_Canvas.SetFillStyle(NewStyle: TFillStyle);
begin
  FillStyle := NewStyle;
end;

function TGUI_Canvas.GetFillStyle: TFillStyle;
begin
  GetFillStyle := FillStyle;
end;

procedure TGUI_Canvas.RenderRect(Rect: PSDL_Rect; Color: TRGBA);
begin
  SDL_SetRenderDrawColor(GetRenderer, Color.r, Color.g, Color.b, Color.a);
  SDL_RenderDrawRect(GetRenderer, Rect);
end;

procedure TGUI_Canvas.RenderFilledRect(Rect: PSDL_Rect; Color: TRGBA);
begin
  SDL_SetRenderDrawColor(GetRenderer, Color.r, Color.g, Color.b, Color.a);
  SDL_RenderFillRect(GetRenderer, Rect);
end;

procedure TGUI_Canvas.RenderLine(x0, y0, x1, y1: Word; Color: TRGBA);
begin
  SDL_SetRenderDrawColor(GetRenderer, Color.r, Color.g, Color.b, Color.a);
  SDL_RenderDrawLine(GetRenderer, x0, y0, x1, y1);
end;

procedure TGUI_Canvas.RenderText(TextIn: string; x, y: Word;
  Alignment: TTextAlign);
var
  ASurface: PSDL_Surface;
  ATexture: PSDL_Texture;
  Color: TSDL_Color;
  ARect: TSDL_Rect;
  TempW, TempH: LongInt;
begin
  if (not(TextIn <> '')) then
    Exit;
  if not Assigned(Font) then
    Exceptn.Create('RenderText called on ' + DbgName + ' with no Font Set');

  // Get width and height of text
  TTF_SizeText(Font, PChar(TextIn), @TempW, @TempH);
  ARect.w := TempW;
  ARect.h := TempH;

  case Alignment of
    Align_Left:
    begin
      ARect.x := GetAbsLeft + x;
      ARect.y := GetAbsTop + Y;
    end;
    Align_Center:
    begin
      ARect.x := GetAbsLeft + x - (TempW div 2);
      ARect.y := GetAbsTop + Y;
    end;
    Align_Right:
    begin
      ARect.x := GetAbsLeft + x - (TempW);
      ARect.y := GetAbsTop + y;
    end;
  end;
  Color.r := ForeColor.r;
  Color.g := ForeColor.g;
  Color.b := ForeColor.b;
  ASurface := TTF_RenderUTF8_Blended(Font, PChar(TextIn), Color);
  ATexture := SDL_CreateTextureFromSurface(Renderer, ASurface);
  if Assigned(ASurface) then
    SDL_FreeSurface(ASurface);
  SDL_RenderCopy(Renderer, ATexture, nil, @ARect);
  SDL_DestroyTexture(ATexture);
end;

procedure TGUI_Canvas.SetCaption(InCaption: string);
begin
  Caption := InCaption;
end;

function TGUI_Canvas.GetCaption: string;
begin
  GetCaption := Caption;
end;

procedure TGUI_Canvas.ctrl_FontChanged;
begin

end;

constructor TGUI_Canvas.Create;
begin
  inherited Create;
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

destructor TGUI_Canvas.Destroy;
begin
  inherited Destroy;
end;

function TGUI_Canvas.MakeRect(ax, ay, aw, ah: Word): PSDL_Rect;
const
  ARect: TSDL_Rect = (x: 0; y: 0; w: 0; h: 0);
begin
  with ARect do
  begin
    x := ax;
    y := ay;
    w := aw;
    h := ah;
  end;
  Result := @ARect;
end;

begin

end.
