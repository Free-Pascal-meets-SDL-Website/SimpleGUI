unit SDL2_SimpleGUI_Element;
{:< The Element Class Unit and its supporting types }

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

uses Classes, SysUtils, SDL2, SDL2_SimpleGUI_Base;

type
  TGUI_Element = class; // forward declaration

  { TGUI_Element_LL }
  {: Linked list of GUI Elements - used to store the list of children in
    TGUI_Element }
  TGUI_Element_LL = class
  public
    Next: TGUI_Element_LL;
    Prev: TGUI_Element_LL;
    Data: TGUI_Element;
    {: Check for last element.
      If the next element to the current element is not nil,
      check the next element with last-function. If the next element is nil, the
      current element is last (last element found). }
    function Last: TGUI_Element_LL;
    {: A new GUI element LL is added as "last".
      The former "last" is the new previous element ("NewPrev"). }
    procedure AddItem(InData: TGUI_Element);
    procedure PushToLast;
    constructor Create;
    destructor Destroy; override;

    procedure Dump; //< For Debugging
  end;

  {: Basic GUI element from which others are derived }
  TGUI_Element = class
  public

    {: Renders controls to rendering target - but is really designed to _not_
      be overwritten by children - controls should render themselves in
      'Render'
      The Render is done in the order of the ElementLL with the last item
      in the LL being the last item rendered (ie - on top)

      It renders all children contained in the linked list (GUI_Element_LL)
      of ONE specific gui element (GUI_Element). The PGUI_Element data is stored
      in the field "data" for each element of the linked list.
      ATTENTION: The child gui element may also contain some own children
      (likely) which also will be rendered.

      Since the calling gui element is master, ALL children in existence are
      drawn. }
    procedure Paint; virtual;
    {: Renders GUI element to rendering target. Should be overwritten by actual
      GUI element class. }
    procedure Render; virtual;

    {: Constructor - empty for basic GUI element. }
    constructor Create;
    {: Destructor is recursive - it will call its children. }
    destructor Destroy; override;
    {: Adds a child element
    The child GUI_Element is added to the children field of calling GUI_Element.
    The child's parent is set to calling GUI_Element. }
    procedure AddChild(Child: TGUI_Element); virtual;
    {: Sets the parent of the element }
    procedure SetParent(NewParent: TGUI_Element); virtual;
    {: Returns the parent of the element }
    function GetParent: TGUI_Element;

    {: Get the SDL2 window that the control is associated with }
    function GetWindow: PSDL_Window;
    {: SDL2: Get the renderer that the control is associated with }
    function GetRenderer: PSDL_Renderer;

    //Accessors for the generic properties
    { TODO : introduce _real_ properties }
    procedure SetWidth(NewWidth: Word); virtual;
    function GetWidth: Word; virtual;

    procedure SetHeight(NewHeight: Word); virtual;
    function GetHeight: Word; virtual;

    procedure SetLeft(NewLeft: Word); virtual;
    function GetLeft: Word; virtual;

    procedure SetTop(NewTop: Word); virtual;
    function GetTop: Word; virtual;

    procedure SetLL(NewLL: TGUI_Element_LL);
    function GetLL: TGUI_Element_LL;

    procedure SetEnabled(NewEnabled: Boolean); virtual;
    function GetEnabled: Boolean; virtual;

    // Push to front and change to look selected if necessary
    { TODO : introduce _real_ properties }
    procedure SetSelected(NewState: Boolean); virtual;
    function GetSelected: Boolean;
    procedure UnselectChildren; virtual;

    procedure SetSelectable(NewState: Boolean);
    function GetSelectable: Boolean;

    function GetChildren: TGUI_Element_LL;

    // Gets absolute coordinates of control recursively
    { TODO : introduce _real_ properties }
    function GetAbsLeft: Word; virtual;
    function GetAbsTop: Word; virtual;

    //Whether or not the control sends the 'normal' events to itself
    //when it passes them to children too. By default false
    procedure SetRecieveAllEvents(NewState: Boolean);
    function GetRecieveAllEvents: Boolean;

    procedure SetVisible(NewVisible: Boolean); virtual;
    function GetVisible: Boolean; virtual;

    {: Called when size of a parent changes in case control needs to make
      adjustments of its own. }
    procedure ParentSizeCallback(NewW, NewH: Word); virtual;
    {: SendSizeCallback is called when those messages need to be sent by this
      control }
    procedure SendSizeCallback(NewW, NewH: Word);
    {: This callback routine is executed once after a child got added to its
      parent. This allows childs to react to their addition, e.g. the Image
      element can render texture after the parents Renderer is known to it. }
    procedure ChildAddedCallback; virtual;

    {: Returns true if MouseEnter has been called and MouseExit hasn't yet
      been }
    function GetMouseEntered: Boolean;

    {: Returns true if X, Y is in the control. Mostly to neaten up code
      but could be used to implement non-rectangular controls }
    function InControl(X, Y: Integer): Boolean; virtual;

    { There are two types of events:
      - Ctrl events which are used by the controls themselves - these should
        only really be overwritten by new or modified widgets. Even then,
        the should still call the inherited procedures. Some (like setting)
        the mouseentered variable in ctrl_MouseEnter() are particularly
        important.
      - Normal events which are the ones that should be overwritten on a
        per control basis. The Ctrl events call the necessary normal ones. }
    procedure ctrl_MouseEnter(); virtual;
    procedure ctrl_MouseExit(); virtual;
    procedure ctrl_MouseDown(X, Y: Word; Button: UInt8); virtual;
    procedure ctrl_MouseUp(X, Y: Word; Button: UInt8); virtual;
    procedure ctrl_MouseMotion(X, Y: Word; ButtonState: UInt8); virtual;
    procedure ctrl_TextInput(TextIn: TSDLTextInputArray); virtual;
    procedure ctrl_MouseClick(X, Y: Word; Button: UInt8); virtual;
    procedure ctrl_Selected; virtual;
    procedure ctrl_LostSelected; virtual;
    procedure ctrl_KeyDown(KeySym: TSDL_KeySym); virtual;
    procedure ctrl_KeyUp(KeySym: TSDL_KeySym); virtual;
    procedure ctrl_Resize; virtual;

    {: SDL_Passthrough passes raw SDL events to every control on
      the form - even invisible/inactive ones }
    procedure ctrl_SDLPassthrough(e: PSDL_Event); virtual;

    procedure MouseEnter(); virtual;
    procedure MouseExit(); virtual;
    procedure MouseDown(X, Y: Word; Button: UInt8); virtual;
    procedure MouseUp(X, Y: Word; Button: UInt8); virtual;
    procedure MouseMotion(X, Y: Word; ButtonState: UInt8); virtual;
    procedure TextInput(TextIn: TSDLTextInputArray); virtual;
    procedure MouseClick(X, Y: Word; Button: UInt8); virtual;
    procedure Selected; virtual;
    procedure LostSelected; virtual;
    procedure KeyDown(KeySym: TSDL_KeySym); virtual;
    procedure KeyUp(KeySym: TSDL_KeySym); virtual;
    procedure Resize; virtual;

    procedure SetDbgName(Name: string);
    function GetDbgName: string;
  protected
    DbgName: string;
    Window: PSDL_Window;
    Renderer: PSDL_Renderer;
    RecieveAllEvents, CurSelected, Selectable: Boolean;
    Children, MyLL: TGUI_Element_LL;
    Parent: TGUI_Element;
    //Generic properties of any GUI element. These are all relative to their
    //respective parents
    { TODO : introduce _real_ properties }
    Width, Height: Word;
    Left, Top: Word;
    //Visible effects whether or not the element is RenderAbsed, AS WELL as
    //whether or not it will recieve events
    { TODO : introduce _real_ properties }
    Visible: Boolean;
    Enabled: Boolean;

    MouseEntered: Boolean;
    ButtonStates: array[0..7] of Boolean;
  private
  end;


implementation

{ TGUI_Element_LL }

function TGUI_Element_LL.Last: TGUI_Element_LL;
begin
  if Next <> nil then
    Last := Next.Last
  else
    Last := Self;
end;

procedure TGUI_Element_LL.AddItem(InData: TGUI_Element);
var
  NewPrev: TGUI_Element_LL;
begin
  NewPrev := Last;
  Last.Next := TGUI_Element_LL.Create;
  Last.Data := InData;
  Last.Data.SetLL(Last);
  Last.Next := nil;
  Last.Prev := NewPrev;
end;

procedure TGUI_Element_LL.Dump;
begin
  if Data <> nil then
    Write(Data.GetDbgName)
  else
    Write('nil');
  if Next <> nil then
  begin
    Write('->');
    Next.Dump;
  end
  else
    writeln;
end;

constructor TGUI_Element_LL.Create;
begin

end;

destructor TGUI_Element_LL.Destroy;
begin
  if Data <> nil then
  begin
    FreeAndNil(Data);
    inherited Destroy;
  end;
  if Next <> nil then
    FreeAndNil(Next);
end;

procedure TGUI_Element_LL.PushToLast;
begin
  if Next <> nil then
  begin
    Prev.Next := Next;
    Next.Prev := Prev;
    Prev := Last;
    Prev.Next := Self;
    Next := nil;
  end;
end;

{ TGUI_Element }

procedure TGUI_Element.SetEnabled(NewEnabled: Boolean);
begin
  Enabled := NewEnabled;
end;

function TGUI_Element.GetEnabled: Boolean;
begin
  GetEnabled := Enabled;
end;

procedure TGUI_Element.AddChild(Child: TGUI_Element);
var
  Next: TGUI_Element_LL;
begin
  GetChildren.AddItem(Child);
  Child.SetParent(Self);

  { SDL2 conv.: VERY IMPORTANT

    If a child is added by AddChild() while it's parent hasn't been set
    (see e.g. Titlebar for Form), the Renderer and window aren't available
    to the child. - Hence, if the parent gets added by AddChild() itself
    to its parent (see e.g. Form gets added to Master), the following checks if
    it has children (Titlebar) and if so, if their Renderer and window are set,
    if not, re-set parent.

    This makes dynamic addition of subchilds from within the elements possible
    (like adding the Titlebar for a Form element); the alternative would be the
    programmer to request to add the Titlebar manually (ugly). }
  if Assigned(Child.GetChildren.Next) then
  begin
    Next := Child.GetChildren.Next;
    while Assigned(Next) do
    begin
      if (not Assigned(Next.Data.GetRenderer)) or (not Assigned(
        Next.Data.GetWindow)) then
        Next.Data.SetParent(Child);
      Next := Next.Next;
    end;
  end;
  Child.ChildAddedCallback;
end;

procedure TGUI_Element.SetParent(NewParent: TGUI_Element);
begin
  Parent := NewParent;
  if (not Assigned(Parent.Renderer)) or (not Assigned(Parent.Window)) then
    Exit
  else
  begin
    Window := Parent.Window;
    Renderer := Parent.Renderer;
    ParentSizeCallback(Parent.GetWidth, Parent.GetHeight);
  end;
end;

function TGUI_Element.GetParent: TGUI_Element;
begin
  GetParent := Parent;
end;

procedure TGUI_Element.Paint;
var
  Next: TGUI_Element_LL;
  Dest: TSDL_Rect;
begin
  if Assigned(Renderer) and Visible then
  begin

    //This renders the individual elements according to their render
    //implementation.
    Render;

    Next := Children.Next;
    while Assigned(Next) do
    begin
      Next.Data.Paint;
      Next := Next.Next;
    end;
  end;
end;

procedure TGUI_Element.ParentSizeCallback(NewW, NewH: Word);
begin

end;

procedure TGUI_Element.Render;
begin

  { nothing to render here, because abstract class }

end;

constructor TGUI_Element.Create;
begin
  Children := TGUI_Element_LL.Create;
  // Just to stop any dodginess when creating surfaces
  Height := 50;
  Width := 50;
  Window := nil;
  Renderer := nil;
  SetRecieveAllEvents(False);
  Selectable := True;
  SetEnabled(True);
  SetVisible(True);
end;

destructor TGUI_Element.Destroy;
begin
  if Assigned(Renderer) then
    SDL_DestroyRenderer(Renderer);
  if Assigned(Window) then
    SDL_DestroyWindow(Window);
  FreeAndNil(Children);
  inherited Destroy;
end;

procedure TGUI_Element.SetWidth(NewWidth: Word);
begin
  Width := NewWidth;
  ctrl_Resize;
  SendSizeCallback(NewWidth, Height);
end;

function TGUI_Element.GetWidth: Word;
begin
  Getwidth := Width;
end;

procedure TGUI_Element.SetHeight(NewHeight: Word);
begin
  Height := NewHeight;
  ctrl_Resize;
  SendSizeCallback(Width, NewHeight);
end;

function TGUI_Element.GetHeight: Word;
begin
  GetHeight := Height;
end;

procedure TGUI_Element.SetLeft(NewLeft: Word);
begin
  Left := NewLeft;
end;

function TGUI_Element.GetLeft: Word;
begin
  GetLeft := Left;
end;

procedure TGUI_Element.SetTop(NewTop: Word);
begin
  Top := NewTop;
end;

function TGUI_Element.GetTop: Word;
begin
  GetTop := Top;
end;

procedure TGUI_Element.SetLL(NewLL: TGUI_Element_LL);
begin
  MyLL := NewLL;
end;

function TGUI_Element.GetLL: TGUI_Element_LL;
begin
  GetLL := MyLL;
end;

function TGUI_Element.GetAbsLeft: Word;
begin
  if Parent = nil then
    GetAbsLeft := 0
  else
    GetAbsLeft := Parent.GetAbsLeft + Left;
end;

function TGUI_Element.GetAbsTop: Word;
begin
  if Parent = nil then
    GetAbstop := 0
  else
    GetAbstop := Parent.GetAbstop + Top;
end;

procedure TGUI_Element.SetVisible(NewVisible: Boolean);
begin
  Visible := NewVisible;
end;

function TGUI_Element.GetVisible: Boolean;
begin
  GetVisible := Visible;
end;

procedure TGUI_Element.SetSelected(NewState: Boolean);
begin
  //write (newstate, ' called ', getdbgname, ' ');
  //Parent^.Children^.Dump;
  if NewState then
  begin
    if (not curselected) and selectable then
    begin
      Parent.UnSelectChildren;
      CurSelected := True;
      ctrl_Selected;
      MyLL.PushToLast;
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

function TGUI_Element.GetSelected: Boolean;
begin
  GetSelected := CurSelected;
end;

procedure TGUI_Element.UnselectChildren;
var
  Next: TGUI_Element_LL;
begin
  Next := Children.Next;
  while Next <> nil do
  begin
    Next.Data.SetSelected(False);
    Next := Next.Next;
  end;
end;

function TGUI_Element.GetChildren: TGUI_Element_LL;
begin
  GetChildren := Children;
end;

procedure TGUI_Element.SetSelectable(NewState: Boolean);
begin
  Selectable := NewState;
end;

function TGUI_Element.GetSelectable: Boolean;
begin
  GetSelectable := Selectable;
end;

procedure TGUI_Element.SetRecieveAllEvents(NewState: Boolean);
begin
  RecieveAllEvents := NewState;
end;

function TGUI_Element.GetRecieveAllEvents: Boolean;
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

procedure TGUI_Element.SendSizeCallback(NewW, NewH: Word);
var
  Next: TGUI_Element_LL;
begin
  Next := Children.Next;
  while Next <> nil do
  begin
    Next.Data.ParentSizeCallback(NewW, NewH);
    Next := Next.Next;
  end;
end;

procedure TGUI_Element.ChildAddedCallback;
begin

end;

function TGUI_Element.InControl(X, Y: Integer): Boolean;
begin
  if (getleft <= X) and (getwidth + getleft >= X) and (gettop <= Y) and
    (gettop + getheight >= Y) then
    InControl := True
  else
    InControl := False;
end;

function TGUI_Element.GetMouseEntered: Boolean;
begin
  GetMouseEntered := MouseEntered;
end;

procedure TGUI_Element.ctrl_MouseEnter();
var
  Next: TGUI_Element_LL;
begin
  //writeln(dbgname, ' received MouseEnter event');
  Next := Children;
  while Next <> nil do
  begin
    if Next.Data <> nil then
      if Next.Data.GetMouseEntered then
        Next.Data.ctrl_MouseExit;
    Next := Next.Next;
  end;
  Next := Parent.Children;

  while Next <> nil do
  begin
    if Next.Data <> nil then
      if Next.Data.GetMouseEntered then
        Next.Data.ctrl_MouseExit;
    Next := Next.Next;
  end;
  MouseEntered := True;
end;

procedure TGUI_Element.ctrl_MouseExit();
var
  Next: TGUI_Element_LL;
  curbutton: Word;
begin
  //writeln(dbgname, ' received MouseExit event');
  MouseEntered := False;
  Next := Children;
  while Next <> nil do
  begin
    if Next.Data <> nil then
      if Next.Data.GetMouseEntered then
        Next.Data.ctrl_MouseExit;
    Next := Next.Next;
  end;

  for curbutton := low(ButtonStates) to High(ButtonStates) do
    ButtonStates[CurButton] := False;
end;

procedure TGUI_Element.ctrl_MouseDown(X, Y: Word; Button: UInt8);
var
  Prev: TGUI_Element_LL;
  passed: Boolean;
begin
  //writeln(dbgname, ' recieved MouseDown event ', x, ',', y, ',', Button);
  Prev := Children.Last;
  passed := False;
  // Pass the event to children if required
  while (Prev <> nil) and (passed = False) do
  begin
    if Prev.Data <> nil then
      with Prev.Data do
      begin
        // If the mouse motion is within the control
        if InControl(X, Y) and Visible then
        begin
          passed := True;
          // Pass translated mouse movement to control
          ctrl_MouseDown(X - getleft, Y - gettop, Button);
          SetSelected(True);
        end;
      end;
    Prev := Prev.Prev;
  end;

  if (not passed) or RecieveAllEvents then
  begin
    UnselectChildren;
    ButtonStates[Button] := True;
    MouseDown(X, Y, Button);
  end;
end;

procedure TGUI_Element.ctrl_MouseUp(X, Y: Word; Button: UInt8);
var
  Prev: TGUI_Element_LL;
  passed: Boolean;
begin
  //writeln(dbgname, ' recieved MouseUp event ', x, ',', y, ',', Button);
  Prev := Children.Last;
  passed := False;
  // Pass the event to children if required
  while (Prev <> nil) and (passed = False) do
  begin
    if Prev.Data <> nil then
      with Prev.Data do
      begin
        // If the mouse motion is within the control
        if InControl(X, Y) and Visible then
        begin
          passed := True;
          // Pass translated mouse movement to control
          ctrl_MouseUp(X - getleft, Y - gettop, Button);
        end;
      end;
    Prev := Prev.Prev;
  end;

  // If it hasn't been passed, or the element will recieve it regardless,
  // do what the control does
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

procedure TGUI_Element.ctrl_MouseClick(X, Y: Word; Button: UInt8);
begin
  MouseClick(X, Y, Button);
end;

procedure TGUI_Element.ctrl_MouseMotion(X, Y: Word; ButtonState: UInt8);
var
  Prev, Next: TGUI_Element_LL;
  passed: Boolean;
begin
  // Check if MouseMotion needs to go to any children
  //writeln(dbgname, ' received MouseMotion event ', x, ',', y, ',', ButtonState);

  Prev := Children.Last;
  passed := False;
  while (Prev <> nil) and (passed = False) do
  begin
    if Prev.Data <> nil then
      with Prev.Data do
      begin
        // If the mouse motion is within the control
        if InControl(X, Y) and Visible then
        begin
          passed := True;
          // Pass a mouse entered event if appropriate
          if not GetMouseEntered then
            ctrl_MouseEnter;
          // Pass translated mouse movement to control
          ctrl_MouseMotion(X - getleft, Y - gettop, ButtonState);
        end
        else
        begin
          // If the mouse is outside the control and it still thinks its within
          // the control, issue the MouseExit event
          if GetMouseEntered then
            ctrl_MouseExit;
          // Issue mouse exits to children too
          Next := Self.Children.Next;
          while Next <> nil do
          begin
            if Next.Data.GetMouseEntered then
              Next.Data.ctrl_MouseExit;
            Next := Next.Next;
          end;
        end;
      end;
    Prev := Prev.Prev;

  end;
  if not passed then
    MouseMotion(X, Y, ButtonState);
end;

procedure TGUI_Element.ctrl_TextInput(TextIn: TSDLTextInputArray);
var
  Next: TGUI_Element_LL;
begin
  //writeln(dbgname, ' received TextInput event ', TextIn);

  TextInput(TextIn);

  Next := Children.Next;
  while (Next <> nil) do
  begin
    if Next.Data.GetSelected then
      Next.Data.ctrl_TextInput(TextIn);

    Next := Next.Next;
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
  Next: TGUI_Element_LL;
begin
  KeyDown(KeySym);
  Next := Children.Next;
  while (Next <> nil) do
  begin
    if Next.Data.GetSelected then
      Next.Data.ctrl_KeyDown(KeySym);
    Next := Next.Next;
  end;
end;

procedure TGUI_Element.ctrl_KeyUp(KeySym: TSDL_KeySym);
var
  Next: TGUI_Element_LL;
begin
  KeyUp(KeySym);
  Next := Children.Next;
  while (Next <> nil) do
  begin
    if Next.Data.GetSelected then
      Next.Data.ctrl_KeyUp(KeySym);
    Next := Next.Next;
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
  Next: TGUI_Element_LL;
begin
  Next := Children.Next;
  while (Next <> nil) do
  begin
    Next.Data.ctrl_SDLPassthrough(e);
    Next := Next.Next;
  end;
end;

procedure TGUI_Element.MouseEnter();
begin

end;

procedure TGUI_Element.MouseExit();
begin

end;

procedure TGUI_Element.MouseDown(X, Y: Word; Button: UInt8);
begin

end;

procedure TGUI_Element.MouseUp(X, Y: Word; Button: UInt8);
begin

end;

procedure TGUI_Element.MouseMotion(X, Y: Word; ButtonState: UInt8);
begin

end;

procedure TGUI_Element.TextInput(TextIn: TSDLTextInputArray);
begin

end;

procedure TGUI_Element.MouseClick(X, Y: Word; Button: UInt8);
begin
  //writeln(dbgname, ' issued unhandled MouseClick event ', x, ',', y, ',', Button);
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
