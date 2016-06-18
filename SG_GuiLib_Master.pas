unit SG_GuiLib_Master;
{:< The master parent object}

{

  Simple GUI is based upon Lachlans GUI (LK GUI). LK GUI's original source code
  remark is shown below.

  Written permission to re-license the library has been granted to me by the
  original author.

}

{*******************************************************}
{                                                       }
{       Lachlans GUI Library                            }
{       TGUI_Master Object                              }
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

uses SG_GuiLib_Element, SysUtils, SDL2;

//TGUI_Master is a special GUI_Element which is designed to be a parent
//and draw nothing but itself. Its a special case because it can be given
//a surface to draw upon

type
  PGUI_Master = ^TGUI_Master;

  TGUI_Master = object(TGUI_Element)
  public
    constructor Init_Master;
    destructor Done_Master;


    (*: Set the window for master and all children *)
    procedure SetWindow(NewWindow: PSDL_Window);

    (*: Set the renderer for master and all children *)
    procedure SetRenderer(NewRenderer: PSDL_Renderer);

    (*: Set the renderer for master and all children *)
    procedure SetParent(NewParent: PGUI_Element); virtual;

    procedure SetWidth(NewWidth: word); virtual;
    procedure SetHeight(NewHeight: word); virtual;
    procedure SetLeft(NewLeft: word); virtual;
    procedure SetTop(NewTop: word); virtual;

    (*: The master is represented by a background color (black) only. Except
    for this, it is kind of invisible (and should be).     *)
    procedure Render; virtual;

    (*: Inject/promote an SDL event to the master and its children.    *)
    procedure InjectSDLEvent(event: PSDL_Event);
  protected
  private
  end;

implementation

var
  Exceptn: Exception;


constructor TGUI_Master.Init_Master;
begin
  //inherited Init;
  new(Children, Init);
  SetVisible(True);

  (* turn TextInput off initially: don't catch SDL events of type SDL_TextInput *)
  SDL_StopTextInput;
end;

destructor TGUI_Master.Done_Master;
begin
  //inherited Done;
  dispose(Children, Done);
end;

procedure TGUI_Master.Render;
begin
  SDL_SetRenderDrawColor(Renderer, 0, 0, 0, SDL_ALPHA_OPAQUE);
  SDL_RenderClear(Renderer);
end;

procedure TGUI_Master.SetWindow(NewWindow: PSDL_Window);
begin
  Window := NewWindow;
  Width := Window^.w;
  Height := Window^.h;
  Left := 0;
  Top := 0;
end;

procedure TGUI_Master.SetRenderer(NewRenderer: PSDL_Renderer);
begin
  Renderer := NewRenderer;
end;

procedure TGUI_Master.SetParent(NewParent: PGUI_Element);
begin
  Exceptn.Create('SetParent called in TGUI_Element');
end;

procedure TGUI_Master.SetWidth(NewWidth: word);
begin
  Exceptn.Create('SetWidth called in TGUI_Master');
end;

procedure TGUI_Master.SetHeight(NewHeight: word);
begin
  Exceptn.Create('SetHeight called in TGUI_Master');
end;

procedure TGUI_Master.SetLeft(NewLeft: word);
begin
  Exceptn.Create('SetLeft called in TGUI_Master');
end;

procedure TGUI_Master.SetTop(NewTop: word);
begin
  Exceptn.Create('SetTop called in TGUI_Master');
end;

procedure TGUI_Master.InjectSDLEvent(event: PSDL_Event);
begin
  case event^.type_ of
    SDL_KEYDOWN:
    begin
      ctrl_KeyDown(Event^.Key.KeySym);
    end;

    SDL_KEYUP:
    begin
      ctrl_KeyUp(Event^.Key.KeySym);
    end;

    SDL_MOUSEMOTION:
    begin
      ctrl_MouseMotion(event^.motion.X, event^.motion.Y, event^.motion.state);
    end;

    SDL_MOUSEBUTTONDOWN:
    begin
      ctrl_MouseDown(event^.button.X, event^.button.Y, event^.button.button);
    end;

    SDL_MOUSEBUTTONUP:
    begin
      ctrl_MouseUp(event^.button.X, event^.button.Y, event^.button.button);
    end;

    SDL_TEXTINPUT:
    begin
      ctrl_TextInput(event^.Text.Text);
    end;
  end;

  ctrl_SDLPassthrough(event);
end;

begin

end.
