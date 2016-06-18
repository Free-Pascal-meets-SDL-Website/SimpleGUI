unit SG_GuiLib_Form;
{:< The Form object and its supporting types}

{

  Simple GUI is based upon Lachlans GUI (LK GUI). LK GUI's original source code
  remark is shown below.

  Written permission to re-license the library has been granted to me by the
  original author.

}

{*******************************************************}
{                                                       }
{       Lachlans GUI Library                            }
{       Base object of TGUI_Form and its elements       }
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

uses SDL2, SDL2_TTF, SG_GuiLib_Base, SG_GuiLib_Element, SG_GuiLib_Canvas, Math;

type
  PGUI_TitleBar = ^TGUI_TitleBar;

  TGUI_TitleBar = object(TGUI_Canvas)
  public
    constructor Init_TB;
    destructor Done_TB;
    procedure Render; virtual;
    procedure ParentSizeCallback(NewWidth, NewHeight: word); virtual;
    procedure ctrl_MouseDown(X, Y: word; Button: UInt8); virtual;
    procedure ctrl_MouseUp(X, Y: word; Button: UInt8); virtual;
    procedure ctrl_MouseExit(); virtual;
    procedure ctrl_SDLPassthrough(e: PSDL_Event); virtual;
  protected
    Moving: boolean;
    InitMoveX, InitMoveY: word;
  private
  end;

  PGUI_Form = ^TGUI_Form;

  TGUI_Form = object(TGUI_Canvas)
  public
    constructor Init_Form;
    destructor Done_Form;

    //Sets if form can be dragger around the screen or not
    //defaults to True
    procedure SetMovable(NewState: boolean);
    function GetMovable: boolean;
  protected
    Movable: boolean;
  private
  end;

implementation

uses SDL_Tools;

//TGUI_TitleBar
constructor TGUI_TitleBar.Init_TB;
begin
  inherited init_canvas;
  left := 0;
  top := 0;
  SetBackColor(GUI_DefaultTitleBarBack);
  Moving := False;
end;

destructor TGUI_TitleBar.Done_TB;
begin
  inherited done_canvas;
end;

procedure TGUI_TitleBar.ctrl_MouseDown(X, Y: word; Button: UInt8);
begin
  inherited;
  if Button = 1 then
    Moving := True;
  InitMoveX := X;
  InitMoveY := Y;
end;

procedure TGUI_TitleBar.ctrl_MouseUp(X, Y: word; Button: UInt8);
begin
  inherited;
  if Moving and (Button = 1) then
    Moving := False;
end;

(*
  This is responsible for moving of form if mouse hold and moved at titlebar.
*)
procedure TGUI_TitleBar.ctrl_SDLPassthrough(e: PSDL_Event);
var
  AmtX, AmtY: integer;
  Next: PGUI_Element_LL;
begin
  //TCParent := PGUI_Canvas(Parent);
  if Moving and (parent <> nil) and (e^.type_ = SDL_MOUSEMOTION) then
  begin
    AmtX := E^.motion.X - GetAbsLeft - InitMoveX;
    AmtY := E^.motion.Y - GetAbsTop - InitMoveY;

    (* move Form *)
    Parent^.SetLeft(Max(Parent^.GetLeft + AmtX, 0));
    Parent^.SetTop(Max(Parent^.GetTop + AmtY, 0));
  end;
  if Moving and (e^.type_ = SDL_MOUSEBUTTONUP) then
  begin
    Moving := False;
  end;
end;

procedure TGUI_TitleBar.ctrl_MouseExit();
begin
  inherited;
  //Stop moving the folder if the person got a little excited...
  //if Moving then Moving := False;
end;

procedure TGUI_TitleBar.Render;
var
  TCParent: PGUI_Canvas;
begin

  if Parent^.GetSelected then
    CurFillColor := BackColor
  else
    CurFillColor := GUI_DefaultUnselectedTitleBarBack;
  inherited;
  TCParent := PGUI_Canvas(Parent);

  if font = nil then
    Font := TCParent^.GetFont;


  DrawText(TCParent^.GetPCharCaption, Width div 2,
    (GetHeight - TTF_FontHeight(Font)) div 2, Align_Center);

end;

procedure TGUI_TitleBar.ParentSizeCallback(NewWidth, NewHeight: word);
begin
  SetWidth(NewWidth);
  SetHeight(GUI_TitleBarHeight);
end;

//TGUI_Form
procedure TGUI_Form.SetMovable(NewState: boolean);
begin
  Movable := NewState;
end;

function TGUI_Form.GetMovable: boolean;
begin
  GetMovable := Movable;
end;

constructor TGUI_Form.Init_Form;
var
  TitleBar: pGUI_TitleBar;
begin
  inherited init_canvas;

  New(TitleBar, Init_TB);
  TitleBar^.SetBorderStyle(BS_Single);
  TitleBar^.SetBackColor(GUI_DefaultTitleBarBack);
  TitleBar^.SetLeft(0);
  TitleBar^.SetTop(0);
  TitleBar^.SetDbgName('TitleBar (local)');
  AddChild(TitleBar);

  SetBackColor(GUI_DefaultFormBack);
  Left := 100;
  Top := 100;
  SetMovable(True);

  SetBorderStyle(BS_Single);
end;

destructor TGUI_Form.Done_Form;
begin
  inherited done_canvas;
end;

begin

end.
