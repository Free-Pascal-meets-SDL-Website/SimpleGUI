unit SG_GuiLib_Element;
{:< The Element object and its supporting types }

{

  Simple GUI is based upon Lachlans GUI (LK GUI). LK GUI's original source code
  remark is shown below.

  Written permission to re-license the library has been granted to me by the
  original author.

}

{*******************************************************}
{                                                       }
{       Lachlans GUI Library                            }
{       Base object of TGUI_Element                     }
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

uses SDL2, SDL2_TTF, SG_GuiLib_Base, Math;

type
  PGUI_Element = ^TGui_Element;

  {: Pointer to PGUI_Element_LL}
  PGUI_Element_LL = ^TGUI_Element_LL;
  {: Linked list of GUI Elements - used to store the list of children in
  TGUI_Element}
  TGUI_Element_LL = object
  public
    Next: PGUI_Element_LL;
    Prev: PGUI_Element_LL;
    Data: PGUI_Element;
    function Last: PGUI_Element_LL;
    procedure AddItem(InData: PGUI_Element);
    procedure PushToLast;
    constructor init;
    destructor done;

    procedure Dump; //For Debugging
  end;

  {: Basic GUI element from which others are derived}
  TGUI_Element = object
  public

    {: Draws controls on parent surface - but is really designed to _not_
    be overwritten by children - controls should draw themselves in
    'Render'
    The Render is done in the order of the ElementLL with the last item
    in the LL being the last item rendered (ie - on top) }
    procedure Paint; virtual;
    procedure Render; virtual;

    {: Dummy init for virtual methods - but might end up being used}
    constructor init;
    {: Destructor is recursive - it will call its children}
    destructor done;


    (*: Adds a child element
    The child GUI_Element is added to the children field of calling GUI_Element.
    The child's parent is set to calling GUI_Element.        *)
    procedure AddChild(Child: PGUI_Element); virtual;
    {: Sets the parent of the element }
    procedure SetParent(NewParent: PGUI_Element); virtual;
    {: Returns the parent of the element }
    function GetParent: PGUI_Element;

    {: SDL2: Get the window that the control is associated with }
    function GetWindow: PSDL_Window;
    {: SDL2: Get the renderer that the control is associated with }
    function GetRenderer: PSDL_Renderer;
    {: SDL2: Get the texture that graphically represents the control }
    function GetTexture: PSDL_Texture;

    //Accessors for the generic properties
    procedure SetWidth(NewWidth: word); virtual;
    function GetWidth: word; virtual;

    procedure SetHeight(NewHeight: word); virtual;
    function GetHeight: word; virtual;

    procedure SetLeft(NewLeft: word); virtual;
    function GetLeft: word; virtual;

    procedure SetTop(NewTop: word); virtual;
    function GetTop: word; virtual;

    procedure SetLL(NewLL: PGUI_Element_LL);
    function GetLL: PGUI_Element_LL;

    procedure SetEnabled(NewEnabled: boolean); virtual;
    function GetEnabled: boolean; virtual;

    //Push to front and change to look selected if necessary
    procedure SetSelected(NewState: boolean); virtual;
    function GetSelected: boolean;
    procedure UnselectChildren; virtual;

    procedure SetSelectable(NewState: boolean);
    function GetSelectable: boolean;

    function GetChildren: PGUI_Element_LL;

    //Gets absolute coordinates of control recursively
    function GetAbsLeft: word; virtual;
    function GetAbsTop: word; virtual;

    //Whether or not the control sends the 'normal' events to itself
    //when it passes them to children too. By default false
    procedure SetRecieveAllEvents(NewState: boolean);
    function GetRecieveAllEvents: boolean;

    {: Called by the destructor of element - should be treated almost like
    a normal destructor. Child elements should overwrite this as it will
    be called by the destructor }
    procedure DoDoneStuff; virtual;

    procedure SetVisible(NewVisible: boolean); virtual;
    function GetVisible: boolean; virtual;

    //Called when size of a parent changes in case control needs to make
    //adjustments of its own. SendSizeCallback is called when those messages
    //need to be sent by this control
    procedure ParentSizeCallback(NewW, NewH: word); virtual;
    procedure SendSizeCallback(NewW, NewH: word);

    //Returns true if MouseEnter has been called and MouseExit hasn't yet
    //been
    function GetMouseEntered: boolean;

    //Returns true if X, Y is in the control. Mostly to neaten up code
    //but could be used to implement non-rectangular controls
    function InControl(X, Y: integer): boolean; virtual;

    //There are two types of events:
    //- Ctrl events which are used by the controls themselves - these should
    //  only really be overwritten by new or modified widgets. Even then,
    //  the should still call the inherited procedures. Some (like setting)
    //  the mouseentered variable in ctrl_MouseEnter() are particularly
    //  important.
    //- Normal events which are the ones that should be overwritten on a
    //  per control basis. The Ctrl events call the necessary normal ones.
    procedure ctrl_MouseEnter(); virtual;
    procedure ctrl_MouseExit(); virtual;
    procedure ctrl_MouseDown(X, Y: word; Button: UInt8); virtual;
    procedure ctrl_MouseUp(X, Y: word; Button: UInt8); virtual;
    procedure ctrl_MouseMotion(X, Y: word; ButtonState: UInt8); virtual;
    procedure ctrl_TextInput(TextIn: TSDLTextInputArray); virtual;
    procedure ctrl_MouseClick(X, Y: word; Button: UInt8); virtual;
    procedure ctrl_Selected; virtual;
    procedure ctrl_LostSelected; virtual;
    procedure ctrl_KeyDown(KeySym: TSDL_KeySym); virtual;
    procedure ctrl_KeyUp(KeySym: TSDL_KeySym); virtual;
    procedure ctrl_Resize; virtual;

    //SDL_Passthrough passes raw SDL events to every control on
    //the form - even invisible/inactive ones
    procedure ctrl_SDLPassthrough(e: PSDL_Event); virtual;

    procedure MouseEnter(); virtual;
    procedure MouseExit(); virtual;
    procedure MouseDown(X, Y: word; Button: UInt8); virtual;
    procedure MouseUp(X, Y: word; Button: UInt8); virtual;
    procedure MouseMotion(X, Y: word; ButtonState: UInt8); virtual;
    procedure TextInput(TextIn: TSDLTextInputArray); virtual;
    procedure MouseClick(X, Y: word; Button: UInt8); virtual;
    procedure Selected; virtual;
    procedure LostSelected; virtual;
    procedure KeyDown(KeySym: TSDL_KeySym); virtual;
    procedure KeyUp(KeySym: TSDL_KeySym); virtual;
    procedure Resize; virtual;

    procedure SetDbgName(Name: string);
    function GetDbgName: string;



  protected
    DbgName: string;


    (*
      ATTENTION: Window and renderer can only be
      accessed by master functions (SetWindow, SetRenderer) and
      should be the same for all elements!
    *)
    Window: PSDL_Window;
    Renderer: PSDL_Renderer;
    Texture: PSDL_Texture;  // SDL_TEXTUREACCESS_TARGET for direct rendering

    RecieveAllEvents, CurSelected, Selectable: boolean;

    Children, MyLL: PGUI_Element_LL;
    Parent: PGUI_Element;

    //Generic properties of any GUI element. These are all relative to their
    //respective parents
    Width, Height: word;
    Left, Top: word;
    //Visible effects whether or not the element is RenderAbsed, AS WELL as
    //whether or not it will recieve events
    Visible: boolean;
    Enabled: boolean;

    MouseEntered: boolean;
    ButtonStates: array[0..7] of boolean;
  private
  end;


implementation

{//
TGUI_Element_LL
//}

(*
  Check for last element.

  If the next element to the current element is not nil,
  check the next element with last-function. If the next element is nil, the
  current element is last (last element found).
*)
function TGUI_Element_LL.Last: PGUI_Element_LL;
begin
  if Next <> nil then
    Last := Next^.Last
  else
    Last := @self;
end;

(*
  A new GUI element LL is added as "last".

  The former "last" is the new previous
  element ("NewPrev").
*)
procedure TGUI_Element_LL.AddItem(InData: PGUI_Element);
var
  NewPrev: PGUI_Element_LL;
begin
  NewPrev := Last;
  new(Last^.Next, init);
  Last^.Data := InData;
  Last^.Data^.SetLL(Last);
  Last^.Next := nil;
  Last^.Prev := NewPrev;
end;

procedure TGUI_Element_LL.Dump;
begin
  if Data <> nil then
    Write(Data^.GetDbgName)
  else
    Write('nil');
  if Next <> nil then
  begin
    Write('->');
    Next^.dump;
  end
  else
    writeln;
end;

constructor TGUI_Element_LL.init;
begin

end;

destructor TGUI_Element_LL.done;
begin
  if Data <> nil then
  begin
    Data^.DoDoneStuff;
    dispose(Data, done);
  end;
  if Next <> nil then
    dispose(Next, done);
end;

procedure TGUI_Element_LL.PushToLast;
begin
  if Next <> nil then
  begin
    Prev^.Next := Next;
    Next^.Prev := Prev;
    Prev := Last;
    Prev^.Next := @self;
    Next := nil;
  end;
end;

{//
TGUI_Element
//}

procedure TGUI_Element.SetEnabled(NewEnabled: boolean);
begin
  Enabled := NewEnabled;
end;

function TGUI_Element.GetEnabled: boolean;
begin
  GetEnabled := Enabled;
end;

procedure TGUI_Element.AddChild(Child: PGUI_Element);
var
  Next: PGUI_Element_LL;
begin
  GetChildren^.AddItem(Child);
  Child^.SetParent(@Self);

  (*
    SDL2 conv.: VERY IMPORTANT

    If a child is added by AddChild() while it's parent hasn't
    been set (see e.g. Titlebar for Form), the renderer and window aren't
    available to the child. - Hence, if the parent gets added by AddChild() itself
    to its parent (see e.g. Form gets added to Master), the following checks if
    it has children (Titlebar) and if so, if their renderer and window are set,
    if not, re-set parent.

    This makes dynamic addition of subchilds from within the elements possible
    (like adding the Titlebar for a Form element); the alternative would be the
    programmer to request to add the Titlebar manually (ugly).
  *)
  if Child^.GetChildren^.Next <> nil then
  begin
    Next := Child^.GetChildren^.Next;
    while Next <> nil do
    begin
      if ((Next^.Data^.GetRenderer = nil) or (Next^.Data^.GetWindow = nil)) then
        Next^.Data^.SetParent(Child);
      //write( GetDbgName, ' called Children of ', Child^.GetDbgName ); writeln;
      Next := Next^.Next;
    end;
  end;
end;

(*
  SDL2 conv.: surfaces are used for screen and gui elements in SDL 1.2,
  but for SDL 2.0 screen is represented by window, elements should be
  represented by textures
*)
procedure TGUI_Element.SetParent(NewParent: PGUI_Element);
begin
  Parent := NewParent;
  if ((Parent^.Renderer = nil) or (Parent^.Window = nil)) then
    exit
  else
  begin
    (*
      SDL2 conv.: make sure, window and renderer are gotten from parent
                  ATTENTION: In contrast to surface, texture cannot be created
                  without renderer!
    *)
    Window := Parent^.Window;
    Renderer := Parent^.Renderer;

    if Texture <> nil then
      SDL_DestroyTexture(Texture);

    Texture := SDL_CreateTexture(Renderer, SDL_PIXELFORMAT_RGBA8888,
      SDL_TEXTUREACCESS_TARGET, Width, Height);

    (* make alpha channel available *)
    SDL_SetTextureBlendMode(Texture, SDL_BLENDMODE_BLEND);

    ParentSizeCallback(Parent^.GetWidth, Parent^.GetHeight);
  end;
end;

function TGUI_Element.GetParent: PGUI_Element;
begin
  GetParent := Parent;
end;

(***
  This function renders all children contained in the linked list (PGUI_Element_LL)
  of ONE specific gui element (PGUI_Element). The PGUI_Element data is stored in
  the field "data" for each element of the linked list. CAREFUL: The child gui element
  may also contain some own children (likely) which also will be rendered.

  Since the calling gui element is master, ALL children in existence are drawn.
***)
procedure TGUI_Element.Paint;
var
  Next: PGUI_Element_LL;
  dest: TSDL_Rect;
begin
  if (Renderer <> nil) and Visible then
  begin
    (*
      This renders the individual elements according to their render
      implementation.
    *)
    Render;

    Next := Children^.Next;
    while Next <> nil do
    begin
      dest.x := Next^.Data^.GetAbsLeft;
      dest.y := Next^.Data^.GetAbsTop;
      dest.w := Next^.Data^.GetWidth;
      dest.h := Next^.Data^.GetHeight;

      SDL_RenderCopy(Renderer, Next^.Data^.GetTexture, nil, @dest);

      Next^.Data^.Paint;

      Next := Next^.Next;
    end;
  end;
end;

procedure TGUI_Element.ParentSizeCallback(NewW, NewH: word);
begin

end;

procedure TGUI_Element.Render;
begin

  (*
    nothing to render here, because abstract class
  *)

end;

constructor TGUI_Element.Init;
begin
  new(Children, Init);
  //Just to stop any dodginess when creating surfaces;
  Height := 50;
  Width := 50;
  Texture := nil;
  Window := nil;
  Renderer := nil;

  SetRecieveAllEvents(False);
  Selectable := True;
  SetEnabled(True);
  SetVisible(True);
end;

destructor TGUI_Element.Done;
begin
  if parent = nil then
    DoDoneStuff;
  if Texture <> nil then
    SDL_DestroyTexture(Texture);
  if Renderer <> nil then
    SDL_DestroyRenderer(Renderer);
  if Window <> nil then
    SDL_DestroyWindow(Window);
  dispose(Children, Done);
end;

procedure TGUI_Element.SetWidth(NewWidth: word);
begin
  Width := NewWidth;
  if Texture <> nil then
    SDL_DestroyTexture(Texture);

  Texture := SDL_CreateTexture(Renderer, SDL_PIXELFORMAT_RGBA8888,
    SDL_TEXTUREACCESS_TARGET, Width, Height);

  Ctrl_Resize;
  SendSizeCallback(NewWidth, Height);
end;

function TGUI_Element.GetWidth: word;
begin
  Getwidth := Width;
end;

procedure TGUI_Element.SetHeight(NewHeight: word);
begin
  Height := NewHeight;
  if Texture <> nil then
    SDL_DestroyTexture(Texture);

  Texture := SDL_CreateTexture(Renderer, SDL_PIXELFORMAT_RGBA8888,
    SDL_TEXTUREACCESS_TARGET, Width, Height);

  Ctrl_Resize;
  SendSizeCallback(Width, NewHeight);
end;

function TGUI_Element.GetHeight: word;
begin
  GetHeight := Height;
end;

procedure TGUI_Element.SetLeft(NewLeft: word);
begin
  Left := NewLeft;
end;

function TGUI_Element.GetLeft: word;
begin
  GetLeft := Left;
end;

procedure TGUI_Element.SetTop(NewTop: word);
begin
  Top := NewTop;
end;

function TGUI_Element.GetTop: word;
begin
  GetTop := Top;
end;

procedure TGUI_Element.SetLL(NewLL: PGUI_Element_LL);
begin
  MyLL := NewLL;
end;

function TGUI_Element.GetLL: PGUI_Element_LL;
begin
  GetLL := MyLL;
end;

function TGUI_Element.GetAbsLeft: word; inline;
begin
  if parent = nil then
    GetAbsLeft := 0
  else
    GetAbsLeft := Parent^.GetAbsLeft + Left;
end;

function TGUI_Element.GetAbsTop: word; inline;
begin
  if parent = nil then
    GetAbstop := 0
  else
    GetAbstop := Parent^.GetAbstop + top;
end;

procedure TGUI_Element.SetVisible(NewVisible: boolean);
begin
  Visible := NewVisible;
end;

function TGUI_Element.GetVisible: boolean;
begin
  GetVisible := Visible;
end;

procedure TGUI_Element.SetSelected(NewState: boolean);
begin
  //write (newstate, ' called ', getdbgname, ' ');
  //Parent^.Children^.Dump;
  if NewState then
  begin
    if (not curselected) and selectable then
    begin
      Parent^.UnSelectChildren;
      CurSelected := True;
      ctrl_Selected;
      MyLL^.PushToLast;
    end;
  end
  else
  begin
    if curselected and selectable then
    begin
      ctrl_LostSelected;
      UnSelectChildren;
      CurSelected := False;
    end;
  end;
  //Parent^.Children^.Dump;
end;

function TGUI_Element.GetSelected: boolean;
begin
  GetSelected := CurSelected;
end;

procedure TGUI_Element.UnselectChildren;
var
  Next: PGUI_Element_LL;
begin
  Next := Children^.Next;
  while Next <> nil do
  begin
    Next^.Data^.SetSelected(False);
    Next := Next^.Next;
  end;
end;

function TGUI_Element.GetChildren: PGUI_Element_LL;
begin
  GetChildren := Children;
end;

procedure TGUI_Element.SetSelectable(NewState: boolean);
begin
  Selectable := NewState;
end;

function TGUI_Element.GetSelectable: boolean;
begin
  GetSelectable := Selectable;
end;

procedure TGUI_Element.DoDoneStuff;
begin

end;

procedure TGUI_Element.SetRecieveAllEvents(NewState: boolean);
begin
  RecieveAllEvents := NewState;
end;

function TGUI_Element.GetRecieveAllEvents: boolean;
begin
  GetRecieveAllEvents := RecieveAllEvents;
end;

function TGUI_Element.GetWindow: PSDL_Window;
begin
  GetWindow := Window;
end;

function TGUI_Element.GetRenderer: PSDL_Renderer;
begin
  GetRenderer := Renderer;
end;

function TGUI_Element.GetTexture: PSDL_Texture;
begin
  GetTexture := Texture;
end;

procedure TGUI_Element.SendSizeCallback(NewW, NewH: word);
var
  Next: PGUI_Element_LL;
begin
  Next := Children^.Next;
  while Next <> nil do
  begin
    Next^.Data^.ParentSizeCallback(NewW, NewH);
    Next := Next^.Next;
  end;
end;

function TGUI_Element.InControl(X, Y: integer): boolean;
begin
  if (getleft <= X) and (getwidth + getleft >= X) and (gettop <= Y) and
    (gettop + getheight >= Y) then
    InControl := True
  else
    InControl := False;
end;

function TGUI_Element.GetMouseEntered: boolean;
begin
  GetMouseEntered := MouseEntered;
end;

procedure TGUI_Element.ctrl_MouseEnter();
var
  Next: PGUI_Element_LL;
begin
  //writeln(dbgname, ' received MouseEnter event');
  Next := Children;
  while Next <> nil do
  begin
    if Next^.Data <> nil then
      if Next^.Data^.GetMouseEntered then
        Next^.Data^.ctrl_MouseExit;
    Next := Next^.Next;
  end;
  Next := parent^.Children;

  while Next <> nil do
  begin
    if Next^.Data <> nil then
      if Next^.Data^.GetMouseEntered then
        Next^.Data^.ctrl_MouseExit;
    Next := Next^.Next;
  end;
  MouseEntered := True;
end;

procedure TGUI_Element.ctrl_MouseExit();
var
  Next: PGUI_Element_LL;
  curbutton: word;
begin
  //writeln(dbgname, ' received MouseExit event');
  MouseEntered := False;
  Next := Children;
  while Next <> nil do
  begin
    if Next^.Data <> nil then
      if Next^.Data^.GetMouseEntered then
        Next^.Data^.ctrl_MouseExit;
    Next := Next^.Next;
  end;

  for curbutton := low(ButtonStates) to High(ButtonStates) do
    ButtonStates[CurButton] := False;
end;

procedure TGUI_Element.ctrl_MouseDown(X, Y: word; Button: UInt8);
var
  Prev: PGUI_Element_LL;
  passed: boolean;
begin
  //writeln(dbgname, ' recieved MouseDown event ', x, ',', y, ',', Button);
  Prev := Children^.Last;
  passed := False;
  //Pass the event to children if required
  while (Prev <> nil) and (passed = False) do
  begin
    if Prev^.Data <> nil then
      with Prev^.Data^ do
      begin
        //If the mouse motion is within the control
        if InControl(X, Y) and Visible then
        begin
          passed := True;
          //Pass translated mouse movement to control
          ctrl_MouseDown(X - getleft, Y - gettop, Button);
          SetSelected(True);
        end;
      end;
    Prev := Prev^.Prev;
  end;

  if (not passed) or RecieveAllEvents then
  begin
    UnselectChildren;
    ButtonStates[Button] := True;
    MouseDown(X, Y, Button);
  end;
end;

procedure TGUI_Element.ctrl_MouseUp(X, Y: word; Button: UInt8);
var
  Prev: PGUI_Element_LL;
  passed: boolean;
begin
  //writeln(dbgname, ' recieved MouseUp event ', x, ',', y, ',', Button);
  Prev := Children^.Last;
  passed := False;
  //Pass the event to children if required
  while (Prev <> nil) and (passed = False) do
  begin
    if Prev^.Data <> nil then
      with Prev^.Data^ do
      begin
        //If the mouse motion is within the control
        if InControl(X, Y) and Visible then
        begin
          passed := True;
          //Pass translated mouse movement to control
          ctrl_MouseUp(X - getleft, Y - gettop, Button);
        end;
      end;
    Prev := Prev^.Prev;
  end;

  //If it hasn't been passed, or the element will recieve it regardless,
  //do what the control does
  if (not passed) or RecieveAllEvents then
    if ButtonStates[Button] then
    begin
      MouseUp(X, Y, Button);
      ctrl_MouseClick(X, Y, Button);
      ButtonStates[Button] := False;
    end
    else
      MouseUp(X, Y, Button);
end;

procedure TGUI_Element.ctrl_MouseClick(X, Y: word; Button: UInt8);
begin
  MouseClick(X, Y, Button);
end;

procedure TGUI_Element.ctrl_MouseMotion(X, Y: word; ButtonState: UInt8);
var
  Prev, Next: PGUI_Element_LL;
  passed: boolean;
begin
  //Check if MouseMotion needs to go to any children
  //writeln(dbgname, ' received MouseMotion event ', x, ',', y, ',', ButtonState);

  Prev := Children^.Last;
  passed := False;
  while (Prev <> nil) and (passed = False) do
  begin
    if Prev^.Data <> nil then
      with Prev^.Data^ do
      begin
        //If the mouse motion is within the control
        if InControl(X, Y) and Visible then
        begin
          passed := True;
          //Pass a mouse entered event if appropriate
          if not GetMouseEntered then
            ctrl_MouseEnter;
          //Pass translated mouse movement to control
          ctrl_MouseMotion(X - getleft, Y - gettop, ButtonState);
        end
        else
        begin
          //If the mouse is outside the control and it still thinks its within the
          //control, issue the MouseExit event
          if GetMouseEntered then
            ctrl_MouseExit;
          //Issue mouse exits to children too
          Next := Self.Children^.Next;
          while Next <> nil do
          begin
            if Next^.Data^.GetMouseEntered then
              Next^.Data^.ctrl_MouseExit;
            Next := Next^.Next;
          end;
        end;
      end;
    Prev := Prev^.Prev;

  end;
  if not passed then
    MouseMotion(X, Y, ButtonState);
end;

procedure TGUI_Element.ctrl_TextInput(TextIn: TSDLTextInputArray);
var
  Next: PGUI_Element_LL;
begin
  //writeln(dbgname, ' received TextInput event ', TextIn);

  TextInput(TextIn);

  Next := Children^.Next;
  while (Next <> nil) do
  begin
    if Next^.Data^.GetSelected then
      Next^.Data^.ctrl_TextInput(TextIn);

    Next := Next^.Next;
  end;
end;

procedure TGUI_Element.ctrl_Selected;
begin
  selected;
end;

procedure TGUI_Element.ctrl_LostSelected;
begin
  lostselected;
end;

procedure TGUI_Element.ctrl_KeyDown(KeySym: TSDL_KeySym);
var
  Next: PGUI_Element_LL;
begin
  KeyDown(KeySym);
  Next := Children^.Next;
  while (Next <> nil) do
  begin
    if Next^.Data^.GetSelected then
      Next^.Data^.ctrl_KeyDown(KeySym);
    Next := Next^.Next;
  end;
end;

procedure TGUI_Element.ctrl_KeyUp(KeySym: TSDL_KeySym);
var
  Next: PGUI_Element_LL;
begin
  KeyUp(KeySym);
  Next := Children^.Next;


  while (Next <> nil) do
  begin
    if Next^.Data^.GetSelected then
      Next^.Data^.ctrl_KeyUp(KeySym);
    Next := Next^.Next;
  end;
end;

procedure TGUI_Element.ctrl_Resize;
begin
  Resize;
end;

procedure TGUI_Element.Selected;
begin

end;

procedure TGUI_Element.LostSelected;
begin

end;

procedure TGUI_Element.ctrl_SDLPassthrough(e: PSDL_Event);
var
  Next: PGUI_Element_LL;
begin
  Next := Children^.Next;
  while (Next <> nil) do
  begin
    Next^.Data^.ctrl_SDLPassthrough(e);
    Next := Next^.Next;
  end;
end;

procedure TGUI_Element.MouseEnter();
begin

end;

procedure TGUI_Element.MouseExit();
begin

end;

procedure TGUI_Element.MouseDown(X, Y: word; Button: UInt8);
begin

end;

procedure TGUI_Element.MouseUp(X, Y: word; Button: UInt8);
begin

end;

procedure TGUI_Element.MouseMotion(X, Y: word; ButtonState: UInt8);
begin

end;

procedure TGUI_Element.TextInput(TextIn: TSDLTextInputArray);
begin

end;

procedure TGUI_Element.MouseClick(X, Y: word; Button: UInt8);
begin
  //  writeln(dbgname, ' issued unhandled MouseClick event ', x, ',', y, ',', Button);
end;

procedure TGUI_Element.KeyDown(KeySym: TSDL_KeySym);
begin

end;

procedure TGUI_Element.KeyUp(KeySym: TSDL_KeySym);
begin

end;

procedure TGUI_Element.Resize;
begin

end;

procedure TGUI_Element.SetDbgName(Name: string);
begin
  DbgName := Name;
end;

function TGUI_Element.GetDbgName: string;
begin
  GetDbgName := DbgName;
end;

begin

end.
