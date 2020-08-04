unit SDL2_SimpleGUI_Form;
{:< The Form Class Unit and its supporting types}

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

uses
  SDL2, SDL2_TTF, Math, SDL2_SimpleGUI_Base, SDL2_SimpleGUI_Element, SDL2_SimpleGUI_Canvas;

type

  { TGUI_TitleBar }

  TGUI_TitleBar = class(TGUI_Canvas)
  public
    constructor Create;
    destructor Destroy; override;
    procedure Render; override;
    procedure ParentSizeCallback(NewWidth, NewHeight: Word); override;
    procedure ctrl_MouseDown(X, Y: Word; Button: UInt8); override;
    procedure ctrl_MouseUp(X, Y: Word; Button: UInt8); override;
    procedure ctrl_MouseExit(); override;
    {: This is responsible for moving of form if mouse hold and moved at
      titlebar. }
    procedure ctrl_SDLPassthrough(e: PSDL_Event); override;
  protected
    Moving: Boolean;
    InitMoveX, InitMoveY: Word;
  private
  end;

  PGUI_Form = ^TGUI_Form;

  { TGUI_Form }

  TGUI_Form = class(TGUI_Canvas)
  public
    constructor Create;
    destructor Destroy; override;

    {: Sets if form can be dragger around the screen or not
      defaults to True }
    procedure SetMovable(NewState: Boolean);
    function GetMovable: Boolean;
  protected
    Movable: Boolean;
  private
  end;

implementation

uses
  SDL2_SimpleGUI;

{ TGUI_TitleBar }

constructor TGUI_TitleBar.Create;
begin
  inherited Create;
  SetLeft(0);
  SetTop(0);
  SetBackColor(GUI_DefaultTitleBarBack);
  Moving := False;
end;

destructor TGUI_TitleBar.Destroy;
begin
  inherited Destroy;
end;

procedure TGUI_TitleBar.ctrl_MouseDown(X, Y: Word; Button: UInt8);
begin
  inherited;
  if Button = 1 then
    Moving := True;
  InitMoveX := X;
  InitMoveY := Y;
end;

procedure TGUI_TitleBar.ctrl_MouseUp(X, Y: Word; Button: UInt8);
begin
  inherited;
  if Moving and (Button = 1) then
    Moving := False;
end;

procedure TGUI_TitleBar.ctrl_SDLPassthrough(e: PSDL_Event);
var
  AmtX, AmtY: Integer;
  Next: TGUI_Element_LL;
begin
  if Moving and (Parent <> nil) and (e^.type_ = SDL_MOUSEMOTION) then
  begin
    AmtX := E^.motion.X - GetAbsLeft - InitMoveX;
    AmtY := E^.motion.Y - GetAbsTop - InitMoveY;

    // move Form
    Parent.SetLeft(Max(Parent.GetLeft + AmtX, 0));
    Parent.SetTop(Max(Parent.GetTop + AmtY, 0));
  end;
  if Moving and (e^.type_ = SDL_MOUSEBUTTONUP) then
  begin
    Moving := False;
  end;
end;

procedure TGUI_TitleBar.ctrl_MouseExit();
begin
  inherited;
  // Stop moving the form if the person got a little excited...
  if Moving then
    Moving := False;
end;

procedure TGUI_TitleBar.Render;
begin
  if Parent.GetSelected then
    CurFillColor := BackColor
  else
    CurFillColor := GUI_DefaultUnselectedTitleBarBack;

  if not Assigned(Font) then
    Font := (Parent as TGUI_Canvas).GetFont;

  // This setting of width and height in the render procedure is
  // necessary, since its parents width and font are not known at
  // creation (as it gets created in Form constructor). Any better solution?
  { TODO : Add a TGUI_Titlebar to the Form widget? Comp. Listbox and Scrollbar.
    }
  Width := Parent.GetWidth;
  Height := TTF_FontHeight(Font);
  inherited Render;

  RenderText(
    (Parent as TGUI_Canvas).GetCaption,
    Width div 2,
    (GetHeight - TTF_FontHeight(Font)) div 2,
    Align_Center
  );
end;

procedure TGUI_TitleBar.ParentSizeCallback(NewWidth, NewHeight: Word);
begin
  SetWidth(NewWidth);
  SetHeight(GUI_TitleBarHeight);
end;

{ TGUI_Form }

constructor TGUI_Form.Create;
var
  TitleBar: TGUI_TitleBar;
begin
  inherited Create;

  TitleBar := TGUI_TitleBar.Create;
  TitleBar.SetBorderStyle(BS_Single);
  TitleBar.SetBackColor(GUI_DefaultTitleBarBack);
  TitleBar.SetLeft(0);
  TitleBar.SetTop(0);
  TitleBar.SetDbgName('TitleBar (local)');
  AddChild(TitleBar);

  SetBackColor(GUI_DefaultFormBack);
  SetLeft(100);
  SetTop(100);
  SetMovable(True);

  SetBorderStyle(BS_Single);

end;

destructor TGUI_Form.Destroy;
begin
  inherited Destroy;
end;

procedure TGUI_Form.SetMovable(NewState: Boolean);
begin
  Movable := NewState;
end;

function TGUI_Form.GetMovable: Boolean;
begin
  GetMovable := Movable;
end;

begin

end.
