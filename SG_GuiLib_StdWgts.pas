unit SG_GuiLib_StdWgts;
{:< The Standard Widgets Library}

{

  Simple GUI is based upon Lachlans GUI (LK GUI). LK GUI's original source code
  remark is shown below.

  Written permission to re-license the library has been granted to me by the
  original author.

}

{*******************************************************}
{                                                       }
{       Lachlans GUI Library                            }
{       Standard Widgets Library                        }
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

uses SDL2, SDL2_TTF, SDL_Tools, Math,
  SG_GuiLib_Base, SG_GuiLib_Element, SG_GuiLib_Canvas;

type
  PGUI_Button = ^TGUI_Button;
  {:Generic Button Object}
  TGUI_Button = object(TGUI_Canvas)
  public
    {: Render the button }
    procedure Render; virtual;
    {: Constructor for the button }
    constructor Init_Button;
    {: Destructor for the button }
    destructor Done_Button;

    {: Control mouse entry procedure}
    procedure ctrl_MouseEnter(); virtual;
    {: Control mouse entry procedure}
    procedure ctrl_MouseExit(); virtual;

  protected
  private
  end;

  PGUI_CheckBox = ^TGUI_CheckBox;
  {:Generic Checkbox Object. Click to change its value.
  Can also act as a radio button by changing the ExcGroup to be less then 0
  (and the same as the other now radio buttons). It only looks through one
  level of parent for siblings of a CheckBox type.}
  TGUI_CheckBox = object(TGUI_Canvas)
  public
    {: Checkbox Constructor }
    constructor Init_Checkbox;
    {: Checkbox Destructor }
    destructor Done_Checkbox;
    {: Set the value of the checkbox - true (Checked) or false (Unchecked) }
    procedure SetValue(NewValue: boolean); virtual;
      {: Returns the value of the checkbox  - true (Checked) or
      false (Unchecked) }
    function GetValue: boolean; virtual;
    {: Render the checkbox}
    procedure Render; virtual;
      {: Sets the Exclusive Group. If this is 0 (default) then the box operates
      as a normal checkbox. If it is non-zero then it operates as a radio button
      with all of the other checkboxes in the same Exclusive Group}
    procedure SetExcGroup(NewExcGroup: word);
    {: Returns the Exclusive Group }
    function GetExcGroup: word;
    {: Control Mouse Click Handler}
    procedure ctrl_MouseClick(X, Y: word; Button: UInt8); virtual;
      {: Called when box is checked - should be overwritten by decendent
      controls}
    procedure ctrl_BoxChecked(); virtual;
      {: Called when box is unchecked - should be overwritten by decendent
      controls}
    procedure ctrl_BoxUnchecked(); virtual;
      {: Called when box is checked - should be overwritten by the actual
      controls}
    procedure BoxChecked(); virtual;
      {: Called when box is unchecked - should be overwritten by the actual
      controls}
    procedure BoxUnchecked(); virtual;
  protected
    Value: boolean;
    ExcGroup: word;
  private
  end;

  PGUI_Label = ^TGUI_Label;
  {:Generic Label Object}
  TGUI_Label = object(TGUI_Canvas)
  public
    {: Label Constructor}
    constructor Init_Label;
    {: Label Destructor (probably not needed}
    destructor Done_Label;
    {: Render control to its surface}
    procedure Render; virtual;
    {: Set the Text Alignment}
    procedure SetTextA(NewTextA: tTextAlign);
    {: Get the Text Alignment}
    function GetTextA: tTextAlign;
    {: Set the Texts Vertical Alignment}
    procedure SetVertA(NewVertA: tVertAlign);
    {: Return the Texts Vertical Alignment}
    function GetVertA: tVertAlign;
  protected
    TextA: tTextAlign;
    VertA: tVertAlign;
  end;

  PGUI_ScrollBar = ^TGUI_Scrollbar;
  {: Generic Scrollbar Object}
  TGUI_ScrollBar = object(TGUI_Canvas)
  public
    {: Scrollbar Constructor}
    constructor Init_ScrollBar;
    {: Scrollbar Destructor (probably not needed)}
    destructor Done_ScrollBar;
    {: Render scrollbar}
    procedure Render; virtual;
    {: Sets minimum value of scrollbar}
    procedure SetMin(NewMinVal: integer);
    {: Returns the minimum value of scrollbar}
    function GetMin: integer;
    {: Sets maximum value of scrollbar}
    procedure SetMax(NewMaxVal: integer);
    {: Returns maximum value of scrollbar}
    function GetMax: integer;
    {: Sets the value of the scrollbar}
    procedure SetValue(NewValue: integer);
    {: Returns the current value of scrollbar}
    function GetValue: integer;
    {: Sets whether the scrollbar is horizontal or vertical}
    procedure SetDir(NewDir: TDir);
    {: Returns whether the scrollbar is horizontal or vertical}
    function GetDir: TDir;
      {: Sets whether the scrollbar automatically aligns itself to the right of
      its parent (for a vertical bar) or the bottom of its parent (for a
      horizontal bar). }
    procedure SetAutoAlign(NewValue: boolean);
    {: Returns the whether the scrollbar automatically aligns itself.}
    function GetAutoAlign: boolean;
      {: Sets whether the scrollbar accounts for a second scroll bar in the
      opposite direction hence leaving the bottom right corner free }
    procedure SetAutoAlignBoth(NewValue: boolean);
    {: Returns autoalignboth }
    function GetAutoAlignBoth: boolean;
    {: Called when parents size changes }
    procedure ParentSizeCallback(NewW, NewH: word); virtual;
    {: Should be only called by parent control - Controls Mouse Down Handler}
    procedure ctrl_MouseDown(X, Y: word; Button: UInt8); virtual;
    {: Should be only called by parent control - Controls Mouse Up Handler}
    procedure ctrl_MouseUp(X, Y: word; Button: UInt8); virtual;
    {: Should be only called by control - Controls Value Changes Handler}
    procedure ctrl_ValueChanged(NewValue: integer); virtual;
    {: Should be only called by parent control - SDL Event Handler}
    procedure ctrl_SDLPassthrough(e: PSDL_Event); virtual;
      {: Called when value of scroll bar has changed - should be overwritten
      by child controls}
    procedure ValueChanged(NewValue: integer); virtual;
  protected
    MinVal, MaxVal, Value: integer;
    InitX, InitY: word;
    Dir: TDir;
    Moving: boolean;
    Autoalign, Autoalignboth: boolean;
  private
  end;

  PGUI_TextBox = ^TGUI_TextBox;
  {:Generic Testbox Object. It could probably still be classified as unfinished
  owing to the fact that its cursor is still a caret('^'), clicks don't move
  the cursor and it sticks to showing the left side of its contents}
  TGUI_TextBox = object(TGUI_Canvas)
  public
    constructor Init_TextBox;
    destructor Done_TextBox;
    procedure Render; virtual;
    procedure ctrl_Selected; virtual;
    procedure ctrl_LostSelected; virtual;

    procedure ctrl_KeyDown(KeySym: TSDL_KeySym); virtual;
    procedure ctrl_KeyUp(KeySym: TSDL_KeySym); virtual;
    procedure ctrl_TextInput(TextIn: TSDLTextInputArray); virtual;
    procedure KeyDown(KeySym: TSDL_KeySym); virtual;
    procedure KeyUp(KeySym: TSDL_KeySym); virtual;

    procedure ctrl_TextChanged(); virtual;
    procedure TextChanged; virtual;

    procedure SetText(InText: string);
    function GetText: string;
    function GetPCharText: PChar;

    procedure DoDoneStuff; virtual;
  protected
    Cursor: integer;
    Text: PChar;
    StrText: string;

    IsSelected: boolean;

    procedure MoveCursor(Amt: integer);
    procedure CursorInsert(Character: TSDLTextInputArray);
    procedure CursorBackspace;
    procedure CursorDelete;
    procedure CursorHome;
    procedure CursorEnd;
  private
  end;

  PGUI_Surface = ^TGUI_Surface;
  {:Object which draws another surface to the screen}
  TGUI_Surface = object(TGUI_Canvas)
  public
    {: Constructor for Surface Widget. }
    constructor Init_Surface;
    {: Destructor for Surface Widget. }
    destructor Done_Surface;
    {: Sets the source surface to draw from. }
    procedure SetSource(NewSrcSurface: pSDL_Surface);
    {: Returns the current source surface. }
    function GetSource: pSDL_Surface;
    {: Sets the rectangle from where to draw from on the source surface. }
    procedure SetSrcRect(NewRect: TSDL_Rect); virtual;
    {: Returns the current source surface rectangle to draw from. }
    function GetSrcRect: TSDL_Rect; virtual;
      {: Sets whether or not the surface takes the full size of the source
      surface or uses the bounding rectangle.}
    procedure SetFullSrc(NewFullSrc: boolean);
      {: Returns whether or not the surface takes the full size of the source
      surface or uses the bounding rectangle.}
    function GetFullSrc: boolean;
    {: Renders the widget }
    procedure Render; virtual;
  protected
    SrcSurface: PSDL_Surface;

    SrcRect: TSDL_Rect;
    FullSrc: boolean;
  private
  end;

  PGUI_Listbox = ^TGUI_Listbox;
  PGUI_Listbox_Item = ^TGUI_Listbox_Item;

  {: Linked list of items in the Listbox or Dropbox. }
  TGUI_Listbox_Item = object
  public
    {: Next item in list. }
    Next: PGUI_Listbox_Item;
    {: Previous item in list. }
    Prev: PGUI_Listbox_Item;
    nullfirst: boolean;
    {: Returns the final item in the list. }
    function Last: PGUI_Listbox_Item;
    {: Returns the first item in the list. }
    function First: PGUI_Listbox_Item;
      {: Returns a string version of the item - could be changed by child
      objects to return something different. Essentially, this is the bit
      that is displayed. }
    function GetStr: string; virtual;
    {: Sets the string to display. }
    procedure SetStr(NewString: string); virtual;
    {: Returns the index of this item. }
    function GetIndex: integer;
    {: Sets the index of this item. }
    procedure SetIndex(NewIndex: integer);
    {: Adds a new listbox_item with the test NewText and index NewIndex. }
    procedure AddItem(NewStr: string; NewIndex: integer);
    {: Makes this the final item in the Linked list. }
    procedure PushToLast;
    {: Initialises Linked List. }
    constructor init;
    {: Destructor of Item. }
    destructor done;
      {: Returns the item bearing the index number. Returns nil if there is
      no such item. }
    function ReturnItem(ItemIndex: integer): PGUI_listbox_item;
      {: Sets whether the item is selected. If so, it will then unselect all
      other items in the list.}
    procedure SetSelected(NewSel: boolean);
    {: Returns whether the item is selected}
    function GetSelected: boolean;
    {: Returns the currently selected item }
    function GetSelectedItem: PGUI_Listbox_item;

      {: Dumps the contents of the Linked list to the console. For debugging
      purposes. }
    procedure Dump;

    function GetCount: word;

  protected
    indexno: integer;
    Caption: string;
    selected: boolean;
  end;

  {: Widget that displays a listbox }
  TGUI_Listbox = object(TGUI_Canvas)
  public
    {: Listbox constructor }
    constructor Init_Listbox;
    {: Listbox destructor - will probably never be called }
    destructor Done_Listbox;
    {: Actual destructor stuff that is guaranteed to be called}
    procedure DoDoneStuff; virtual;
    {: Returns list of items }
    function GetItems: PGUI_Listbox_Item;
    {: Renders the widget }
    procedure Render; virtual;
    {: Called when the font changes }
    procedure ctrl_FontChanged; virtual;
    {: Called when the control is resized }
    procedure ctrl_Resize; virtual;
    {: Called when the control recieves a keypress }
    procedure ctrl_KeyDown(KeySym: TSDL_KeySym); virtual;
    {: Called when the listbox is clicked}
    procedure MouseDown(X, Y: word; Button: UInt8); virtual;
      {: Should be overwritten by children. Will be called when the selection
      is changed }
    procedure ctrl_NewSelection(Selection: PGUI_Listbox_Item); virtual;
    {: Will be called when the selection is changed }
    procedure NewSelection(Selection: PGUI_Listbox_Item); virtual;
    {: Returns the currently selected item }
    function GetSelectedItem: PGUI_Listbox_Item;
  protected
    Items: PGUI_Listbox_Item;
    ListCount: word;
    ItemsToShow: word;
    Scrollbar: PGUI_Scrollbar;
  private
  end;

implementation

uses SysUtils;

//*********************************************************
//TGUI_Button
//*********************************************************
procedure TGUI_Button.Render;
begin
  if ButtonStates[1] then
    CurFillColor := ActiveColor
  else
    CurFillColor := BackColor;
  inherited;
  DrawText(Caption, Width div 2, (GetHeight - TTF_FontHeight(Font)) div 2,
    Align_Center);
end;

constructor TGUI_Button.Init_Button;
begin
  inherited Init_Canvas;
  SetBorderStyle(BS_Single);
end;

destructor TGUI_Button.Done_Button;
begin
  inherited Done_Canvas;
end;

procedure TGUI_Button.ctrl_MouseEnter();
begin
  inherited;
  CurBorderColor := ForeColor;
end;

procedure TGUI_Button.ctrl_MouseExit();
begin
  inherited;
  CurBorderColor := BorderColor;
end;

//*********************************************************
//TGUI_Checkbox
//*********************************************************
constructor TGUI_Checkbox.Init_Checkbox;
begin
  inherited Init_Canvas;
  SetFillStyle(FS_None);
  ExcGroup := 0;
end;

destructor TGUI_Checkbox.Done_Checkbox;
begin
  inherited Done_Canvas;
end;

procedure TGUI_Checkbox.SetValue(NewValue: boolean);
begin
  if Value <> newvalue then
  begin
    Value := newvalue;
    if NewValue then
      ctrl_BoxChecked
    else
      ctrl_BoxUnchecked;
  end;
end;

function TGUI_Checkbox.GetValue: boolean;
begin
  getvalue := Value;
end;

procedure TGUI_Checkbox.Render;
var
  r: TSDL_Rect;
begin
  inherited;
  with r do
  begin
    w := 20;
    h := 20;
    x := 3;
    y := 3;
  end;
  if GetMouseEntered then
  (* SDL2 conv.: Original code, for ref.

    SDL_FillRect(surface, @r, maprgb(GUI_SelectedColor.r, GUI_SelectedColor.g,
      GUI_SelectedColor.b))

  *)
  begin
    fillrect(Renderer, Texture, @r, GUI_SelectedColor);
  end
  else
  (* SDL2 conv.: Original code, for ref.

    SDL_FillRect(surface, @r, maprgb(backcolor.r, backcolor.g, backcolor.b));

  *)
  begin
    (*SDL_SetRenderTarget( Renderer, Texture );
    SDL_SetRenderDrawColor( Renderer, backcolor.R,
      backcolor.G, backcolor.B, backcolor.A );
    SDL_RenderClear( Renderer );
    SDL_SetRenderTarget( Renderer, nil );*)
    fillrect(Renderer, Texture, @r, backcolor);
  end;


  (* SDL2 conv.: Original code, for ref.

  drawline(r.x, r.y, r.x+r.w, r.y, surface,CurBordercolor.r, CurBorderColor.g,
    CurBorderColor.b);
  drawline(r.x, r.y+r.h, r.x+r.w, r.y+r.h, surface,CurBordercolor.r,
    CurBorderColor.g, CurBorderColor.b);
  drawline(r.x+r.w, r.y, r.x+r.w, r.y+r.h, surface,CurBordercolor.r,
    CurBorderColor.g, CurBorderColor.b);
  drawline(r.x, r.y, r.x, r.y+r.h, surface,CurBordercolor.r,
    CurBorderColor.g, CurBorderColor.b);

  *)

  drawline(Renderer, Texture, r.x, r.y, r.x + r.w, r.y, CurBorderColor);
  drawline(Renderer, Texture, r.x, r.y + r.h, r.x + r.w, r.y + r.h, CurBorderColor);
  drawline(Renderer, Texture, r.x + r.w, r.y, r.x + r.w, r.y + r.h, CurBorderColor);
  drawline(Renderer, Texture, r.x, r.y, r.x, r.y + r.h, CurBorderColor);

  with r do
  begin
    w := 11;
    h := 11;
    x := 8;
    y := 8;
  end;

  if Value then
  (* SDL2 conv.: Original code, for ref.

     SDL_FillRect(surface, @r, maprgb(forecolor.r, forecolor.g, forecolor.b));

  *)
  begin
    fillrect(Renderer, Texture, @r, forecolor);
  end;

  DrawText(GetPCharCaption, 30, 5, Align_Left);
end;

procedure TGUI_Checkbox.ctrl_MouseClick(X, Y: word; Button: UInt8);
var
  Next: PGUI_Element_LL;
  Data: PGUI_Checkbox;
begin
  if excgroup = 0 then
    //Do this if its just a checkbox
  begin
    if Value then
    begin
      SetValue(False);
    end
    else
    begin
      SetValue(True);
    end;
  end
  else
    //But do this if its an option box
  begin
    if not (Value) then
    begin
      SetValue(True);
      //Traverse siblings to tell relevant siblings to be unselected
      Next := parent^.getchildren^.Next;
      while Next <> nil do
      begin
        //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        //I don't know why this typecast works without crashing, but it seems to
        //It is a danger point in the code I believe
        Data := PGUI_Checkbox(Next^.Data);
        //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        if Next^.Data <> @self then
          if Data^.GetExcGroup = ExcGroup then
            Data^.SetValue(False);
        Next := Next^.Next;
      end;
    end;
  end;
end;

procedure TGUI_Checkbox.ctrl_BoxChecked();
begin
  BoxChecked;
end;

procedure TGUI_Checkbox.ctrl_BoxUnchecked();
begin
  BoxUnChecked;
end;

procedure TGUI_Checkbox.BoxChecked();
begin

end;

procedure TGUI_Checkbox.BoxUnchecked();
begin

end;

procedure TGUI_Checkbox.SetExcGroup(NewExcGroup: word);
begin
  ExcGroup := NewExcGroup;
end;

function TGUI_Checkbox.GetExcGroup: word;
begin
  GetExcGroup := ExcGroup;
end;


//*********************************************************
//TGUI_Label
//*********************************************************

constructor TGUI_Label.Init_Label;
begin
  inherited Init_Canvas;
  SetFillStyle(FS_None);
  SetSelectable(False);
  SetTextA(Align_Left);
  SetVertA(VAlign_Top);
end;

destructor TGUI_Label.Done_Label;
begin
  inherited Done_Canvas;
end;

procedure TGUI_Label.Render;
var
  LeftPoint, TopPoint: word;
begin
  case TextA of
    Align_Left:
      LeftPoint := 0;
    Align_Right:
      LeftPoint := GetWidth;
    Align_Center:
      LeftPoint := GetWidth div 2;
  end;
  case VertA of
    VAlign_Top:
      TopPoint := 0;
    VAlign_Bottom:
      TopPoint := GetHeight - TTF_FontHeight(Font);
    VAlign_Center:
      TopPoint := (GetHeight - TTF_FontHeight(Font)) div 2;
  end;

  drawtext(GetPCharCaption, LeftPoint, TopPoint, TextA);
end;

procedure TGUI_Label.SetTextA(NewTextA: tTextAlign);
begin
  TextA := NewTextA;
end;

function TGUI_Label.GetTextA: tTextAlign;
begin
  GetTextA := TextA;
end;

procedure TGUI_Label.SetVertA(NewVertA: tVertAlign);
begin
  VertA := NewVertA;
end;

function TGUI_Label.GetVertA: tVertAlign;
begin
  GetVertA := VertA;
end;

//*********************************************************
//TGUI_Scrollbar
//*********************************************************
constructor TGUI_Scrollbar.Init_ScrollBar;
begin
  inherited Init_Canvas;
  SetFillStyle(FS_None);
  SetMin(0);
  SetMax(100); //SetValue(50);
end;

destructor TGUI_Scrollbar.Done_ScrollBar;
begin
  inherited Done_Canvas;
end;

procedure TGUI_Scrollbar.Render;
var
  r: TSDL_Rect;
begin
  inherited;
  case GetDir of
    Dir_Horizontal:
    begin
      (*
      DrawLine(0, GetHeight div 2, GetWidth-1, GetHeight div 2, Surface,
        BorderColor.r, BorderColor.g, BorderColor.b);
      *)
      drawline(Renderer, Texture, 0, GetHeight div 2, GetWidth - 1,
        GetHeight div 2, BorderColor);
      with r do
      begin
        w := GUI_ScrollbarSize;
        h := GUI_ScrollbarSize;
        x := floor((Value * (Width - w - 2)) / (MaxVal - MinVal));
        y := (GetHeight - h) div 2;
      end;
    end;
    Dir_Vertical:
    begin
      drawline(Renderer, Texture, GetWidth div 2, 0, GetWidth div 2,
        GetHeight, BorderColor);
      with r do
      begin
        w := GUI_ScrollbarSize;
        h := GUI_ScrollbarSize;
        y := floor((Value * (Height - h - 1)) / (MaxVal - MinVal));
        x := (GetWidth - w) div 2;
      end;
    end;
  end;
  if GetMouseEntered or Moving then
      (*
      SDL_FillRect(surface, @r, maprgb(GUI_SelectedColor.r, GUI_SelectedColor.g,
      GUI_SelectedColor.b))
      *)
    fillrect(Renderer, Texture, @r, GUI_SelectedColor)
  else
      (*
      SDL_FillRect(surface, @r, maprgb(backcolor.r, backcolor.g, backcolor.b));
      *)
    fillrect(Renderer, Texture, @r, GUI_SelectedColor);
    (*
    drawline(r.x, r.y, r.x+r.w, r.y, surface,CurBordercolor.r, CurBorderColor.g,
      CurBorderColor.b);
    drawline(r.x, r.y+r.h, r.x+r.w, r.y+r.h, surface,CurBordercolor.r,
      CurBorderColor.g, CurBorderColor.b);
    drawline(r.x+r.w, r.y, r.x+r.w, r.y+r.h, surface,CurBordercolor.r,
      CurBorderColor.g, CurBorderColor.b);
    drawline(r.x, r.y, r.x, r.y+r.h, surface,CurBordercolor.r,
      CurBorderColor.g, CurBorderColor.b);
    *)
  drawline(Renderer, Texture, r.x, r.y, r.x + r.w, r.y, CurBorderColor);
  drawline(Renderer, Texture, r.x, r.y + r.h, r.x + r.w, r.y + r.h, CurBorderColor);
  drawline(Renderer, Texture, r.x + r.w, r.y, r.x + r.w, r.y + r.h, CurBorderColor);
  drawline(Renderer, Texture, r.x, r.y, r.x, r.y + r.h, CurBorderColor);

end;

procedure TGUI_Scrollbar.SetMin(NewMinVal: integer);
begin
  MinVal := NewMinVal;
end;

function TGUI_Scrollbar.GetMin: integer;
begin
  GetMin := MinVal;
end;

procedure TGUI_Scrollbar.SetMax(NewMaxVal: integer);
begin
  MaxVal := NewMaxVal;
end;

function TGUI_Scrollbar.GetMax: integer;
begin
  GetMax := MaxVal;
end;

procedure TGUI_Scrollbar.SetValue(NewValue: integer);
begin
  Value := NewValue;
  CTRL_ValueChanged(NewValue);
end;

function TGUI_Scrollbar.GetValue: integer;
begin
  GetValue := Value;
end;

procedure TGUI_Scrollbar.SetDir(NewDir: TDir);
begin
  Dir := NewDir;
end;

function TGUI_Scrollbar.GetDir: TDir;
begin
  GetDir := Dir;
end;

procedure TGUI_Scrollbar.SetAutoAlign(NewValue: boolean);
begin
  Autoalign := NewValue;
  if AutoAlign then
    if Parent <> nil then
      ParentSizeCallback(Parent^.GetWidth, Parent^.GetHeight);
end;

function TGUI_Scrollbar.GetAutoAlign: boolean;
begin
  GetAutoAlign := AutoAlign;
end;

procedure TGUI_Scrollbar.SetAutoAlignBoth(NewValue: boolean);
begin
  AutoAlignBoth := NewValue;
  if AutoAlignBoth then
    if Parent <> nil then
      ParentSizeCallback(Parent^.GetWidth, Parent^.GetHeight);
end;

function TGUI_Scrollbar.GetAutoAlignBoth: boolean;
begin
  GetAutoAlignBoth := AutoAlignBoth;
end;

procedure TGUI_Scrollbar.ParentSizeCallback(NewW, NewH: word);
begin
  if AutoAlign then
  begin
    case Dir of
      Dir_Horizontal:
      begin
        SetLeft(2);
        SetWidth(NewW - ifthen(AutoAlignBoth, Gui_ScrollbarSize) - 4);
        SetTop(NewH - Gui_ScrollBarSize - 4);
        SetHeight(Gui_ScrollBarSize + 1);
      end;
      Dir_Vertical:
      begin
        SetTop(2);
        SetHeight(NewH - ifthen(AutoAlignBoth, Gui_ScrollbarSize) - 4);
        SetLeft(NewW - Gui_ScrollBarSize - 4);
        SetWidth(Gui_ScrollBarSize + 1);
      end;
    end;
  end;
end;

procedure TGUI_Scrollbar.ctrl_MouseDown(X, Y: word; Button: UInt8);
var
  NewVal: integer;
begin
  inherited;
  if Button = 1 then
  begin
    case Dir of
      Dir_Horizontal:
      begin
        NewVal := (X * (MaxVal - MinVal)) div Width;
        InitX := GetAbsLeft;
      end;
      Dir_Vertical:
      begin
        NewVal := (Y * (MaxVal - MinVal)) div Height;
        InitY := GetAbsTop;
      end;
    end;
    NewVal := Max(MinVal, NewVal);
    NewVal := Min(MaxVal, NewVal);
    SetValue(NewVal);
    Moving := True;
  end;
end;

procedure TGUI_Scrollbar.ctrl_MouseUp(X, Y: word; Button: UInt8);
begin
  inherited;
  if Button = 1 then
    Moving := False;
end;

procedure TGUI_Scrollbar.ctrl_SDLPassthrough(e: PSDL_Event);
var
  NewVal, X, Y: integer;
begin
  inherited;
  case e^.type_ of
    SDL_MOUSEBUTTONUP:
    begin
      if moving then
        if e^.button.button = 1 then
          moving := False;
    end;
    SDL_MOUSEMOTION:
      if Moving then
      begin
        X := e^.motion.x - initx;
        y := e^.motion.y - inity;
        case Dir of
          Dir_Horizontal:
          begin
            NewVal := (X * (MaxVal - MinVal)) div (Width - 6);
          end;
          Dir_Vertical:
          begin
            NewVal := (Y * (MaxVal - MinVal)) div (Height - 6);
          end;
        end;
        NewVal := Max(MinVal, NewVal);
        NewVal := Min(MaxVal, NewVal);
        SetValue(NewVal);

      end;
  end;
end;

procedure TGUI_Scrollbar.ctrl_ValueChanged(NewValue: integer);
begin
  ValueChanged(NewValue);
end;

procedure TGUI_Scrollbar.ValueChanged(NewValue: integer);
begin

end;

//*********************************************************
//TGUI_TextBox
//*********************************************************
constructor TGUI_TextBox.Init_TextBox;
begin
  inherited Init_Canvas;
  SetBackColor(GUI_DefaultTextBackColor);
  SetBorderStyle(BS_Single);
  Cursor := 0;
  Text := nil;
  StrText := '';
  IsSelected := False;
end;

destructor TGUI_TextBox.Done_TextBox;
begin

end;

procedure TGUI_TextBox.Render;
var
  TextToRender: PChar;
  ActiveToRender: PChar;
begin
  inherited;
  ActiveToRender := nil;
  begin
    if CurSelected then
    begin
      ActiveToRender := StrAlloc(Length(GetText) + 2);
      StrPCopy(ActiveToRender, LeftStr(GetText, Cursor) + '^' +
        RightStr(GetText, Length(GetText) - Cursor));
      TextToRender := ActiveToRender;
    end
    else
    if GetText = '' then
      TextToRender := GetPCharCaption
    else
      TextToRender := GetPCharText;
  end;
  DrawText(TextToRender, 5, (GetHeight - TTF_FontHeight(Font)) div 2,
    Align_Left);

  if ActiveToRender <> nil then
    StrDispose(ActiveToRender);

end;

procedure TGUI_TextBox.ctrl_Selected;
begin
  CurFillColor := GUI_SelectedColor;
  IsSelected := True;
  Cursor := Length(Text);

  (* SDL2. conv.: Start TextInput mode *)
  SDL_StartTextInput;
end;

procedure TGUI_TextBox.ctrl_LostSelected;
begin
  CurFillColor := BackColor;
  IsSelected := False;

  (* SDL2. conv.: Stop TextInput mode *)
  SDL_StopTextInput;
end;

procedure TGUI_TextBox.ctrl_KeyDown(KeySym: TSDL_KeySym);
begin
  inherited;
  (* original code *)

  case KeySym.Sym of
    SDLK_LEFT:
    begin
      MoveCursor(-1);
    end;
    SDLK_RIGHT:
    begin
      MoveCursor(1);
    end;
    SDLK_BACKSPACE:
    begin
      CursorBackspace;
    end;
    SDLK_DELETE:
    begin
      CursorDelete;
    end;
    SDLK_HOME:
    begin
      CursorHome;
    end;
    SDLK_END:
    begin
      CursorEnd;
    end;
  end;
end;

procedure TGUI_TextBox.ctrl_KeyUp(KeySym: TSDL_KeySym);
begin

end;

procedure TGUI_TextBox.ctrl_TextInput(TextIn: TSDLTextInputArray);
begin
  inherited;
  CursorInsert(TextIn);
  MoveCursor(1);
end;

procedure TGUI_TextBox.KeyDown(KeySym: TSDL_KeySym);
begin

end;

procedure TGUI_TextBox.KeyUp(KeySym: TSDL_KeySym);
begin

end;

procedure TGUI_TextBox.ctrl_TextChanged();
begin

end;

procedure TGUI_TextBox.TextChanged;
begin

end;

procedure TGUI_Textbox.DoDoneStuff;
begin
  inherited;
  if Text <> nil then
    strdispose(Text);
end;

procedure TGUI_Textbox.SetText(InText: string);
begin
  if Text <> nil then
    strdispose(Text);
  Text := StrAlloc(Length(InText) + 1);
  StrPCopy(Text, InText);
end;

function TGUI_Textbox.GetText: string;
begin
  GetText := StrPas(Text);
end;

function TGUI_Textbox.GetPCharText: PChar;
begin
  GetPCharText := Text;
end;

procedure TGUI_Textbox.MoveCursor(Amt: integer);
begin
  Cursor := Cursor + amt;
  if cursor < 0 then
    cursor := 0;
  if cursor > length(GetText) then
    cursor := length(GetText);
end;

procedure TGUI_Textbox.CursorInsert(Character: TSDLTextInputArray);
var
  NewText: PChar;
begin
  NewText := StrAlloc(Length(GetText) + Length(Character) + 2);
  StrPCopy(NewText, LeftStr(GetText, Cursor) + Character +
    RightStr(GetText, Length(GetText) - Cursor));
  StrDispose(Text);
  Text := NewText;
end;

procedure TGUI_Textbox.CursorBackspace;
var
  NewText: PChar;
begin
  if cursor <> 0 then
  begin
    NewText := StrAlloc(Length(GetText));
    StrPCopy(NewText, LeftStr(GetText, Cursor - 1) +
      RightStr(GetText, Length(GetText) - Cursor));
    StrDispose(Text);
    Text := NewText;
    MoveCursor(-1);
  end;
end;

procedure TGUI_Textbox.CursorDelete;
var
  NewText: PChar;
begin
  if cursor <> length(GetText) then
  begin
    NewText := StrAlloc(Length(GetText));
    StrPCopy(NewText, LeftStr(GetText, Cursor) +
      RightStr(GetText, Length(GetText) - Cursor - 1));
    StrDispose(Text);
    Text := NewText;
  end;
end;

procedure TGUI_Textbox.CursorHome;
begin
  Cursor := 0;
end;

procedure TGUI_Textbox.CursorEnd;
begin
  Cursor := Length(GetText);
end;


//*********************************************************
//TGUI_Surface
//*********************************************************

constructor TGUI_Surface.Init_Surface;
begin
  inherited Init_Canvas;
  SetFillStyle(FS_None);
  SetFullSrc(True);
end;

destructor TGUI_Surface.Done_Surface;
begin
  inherited Done_Canvas;
end;

procedure TGUI_Surface.SetSource(NewSrcSurface: pSDL_Surface);
begin
  SrcSurface := NewSrcSurface;
end;

function TGUI_Surface.GetSource: pSDL_Surface;
begin
  GetSource := SrcSurface;
end;

procedure TGUI_Surface.SetSrcRect(NewRect: TSDL_Rect);
begin
  SrcRect := NewRect;
end;

function TGUI_Surface.GetSrcRect: TSDL_Rect;
begin
  GetSrcRect := SrcRect;
end;

procedure TGUI_Surface.SetFullSrc(NewFullSrc: boolean);
begin
  FullSrc := NewFullSrc;
end;

function TGUI_Surface.GetFullSrc: boolean;
begin
  GetFullSrc := FullSrc;
end;

procedure TGUI_Surface.Render;
var
  tempTex: PSDL_Texture;
begin
  inherited;
  if SrcSurface <> nil then
  begin
    tempTex := SDL_CreateTextureFromSurface(Renderer, SrcSurface);
    SDL_SetRenderTarget(Renderer, Texture);

    if FullSrc then
      //SDL_BlitSurface(SrcSurface, nil, Surface, nil)
      SDL_RenderCopy(Renderer, tempTex, nil, nil)
    else
      //SDL_BlitSurface(SrcSurface, @SrcRect, Surface, nil);
      SDL_RenderCopy(Renderer, tempTex, @SrcRect, nil);

    SDL_SetRenderTarget(Renderer, nil);
    SDL_DestroyTexture(tempTex);
  end;
end;

//*********************************************************
//TGUI_Listbox_Item
//*********************************************************

function TGUI_Listbox_Item.Last: PGUI_Listbox_Item;
begin
  if Next <> nil then
    Last := Next^.Last
  else
    Last := @self;
end;

function TGUI_Listbox_Item.First: PGUI_Listbox_Item;
begin
  if Prev <> nil then
    First := Next^.Prev
  else
    First := @self;
end;

function TGUI_Listbox_Item.GetSelectedItem: PGUI_Listbox_item;
var
  nextitem: PGUI_Listbox_item;
begin
  nextitem := First;
  while (nextitem <> nil) and not (nextitem^.GetSelected) do
    nextitem := nextitem^.Next;
  GetSelectedItem := nextitem;
end;

function TGUI_Listbox_Item.GetStr: string;
begin
  GetStr := Caption;
end;

procedure TGUI_Listbox_Item.SetStr(NewString: string);
begin
  Caption := NewString;
end;

function TGUI_Listbox_Item.GetIndex: integer;
begin
  getindex := indexno;
end;

procedure TGUI_Listbox_Item.SetIndex(NewIndex: integer);
begin
  indexno := newindex;
end;

procedure TGUI_Listbox_Item.AddItem(NewStr: string; NewIndex: integer);
var
  NewPrev: PGUI_Listbox_Item;
begin
  NewPrev := Last;
  new(Last^.Next, init);
  Last^.Next := nil;
  Last^.Prev := NewPrev;
  Last^.SetIndex(NewIndex);
  Last^.SetStr(NewStr);
end;

procedure TGUI_Listbox_Item.Dump;
begin
  Write(GetStr, '(', GetIndex, ')');
  if Next <> nil then
  begin
    Write('->');
    Next^.dump;
  end
  else
    writeln;
end;

constructor TGUI_Listbox_Item.init;
begin
  indexno := 0;
end;

destructor TGUI_Listbox_Item.done;
begin
  if Next <> nil then
    dispose(Next, done);
end;

function TGUI_Listbox_Item.ReturnItem(ItemIndex: integer): PGUI_listbox_item;
begin
  if indexno = ItemIndex then
    ReturnItem := @Self
  else
  if Next <> nil then
    ReturnItem := Next^.ReturnItem(ItemIndex)
  else
    ReturnItem := nil;
end;

procedure TGUI_Listbox_Item.PushToLast;
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

function TGUI_Listbox_Item.GetCount: word;
begin
  if Next <> nil then
    GetCount := Next^.GetCount + 1
  else
    GetCount := 1;
end;

procedure TGUI_Listbox_Item.SetSelected(NewSel: boolean);
var
  nextitem: PGUI_Listbox_Item;
begin
  Selected := NewSel;
  if NewSel then
  begin
    nextitem := Next;
    while nextitem <> nil do
    begin
      nextitem^.SetSelected(False);
      nextitem := nextitem^.Next;
    end;
    nextitem := Prev;
    while nextitem <> nil do
    begin
      nextitem^.SetSelected(False);
      nextitem := nextitem^.Prev;
    end;
  end;
end;

function TGUI_Listbox_Item.GetSelected: boolean;
begin
  GetSelected := Selected;
end;

//*********************************************************
//TGUI_Listbox
//*********************************************************

{type
  PListbox_Scrollbar = ^TListbox_Scrollbar;
  TListbox_Scrollbar = object(TGUI_Scrollbar)
    public
      constructor Init_Listbox_scrollbar;
      destructor Done_Listbox_scrollbar;
      procedure ValueChanged(NewValue: Integer); virtual;
    protected
    private
    end;

constructor TListbox_Scrollbar.Init_Listbox_scrollbar;
begin

  end;

destructor TListbox_Scrollbar.Done_Listbox_scrollbar;
begin

  end;

procedure TListbox_Scrollbar.ValueChanged(NewValue: Integer);
begin

  end; }

constructor TGUI_Listbox.Init_Listbox;
begin
  inherited Init_Canvas;
  SetBorderStyle(BS_Single);
  SetSelectable(True);
  New(Items, Init);
  Items^.nullfirst := True;
  New(Scrollbar, Init_Scrollbar);
  with scrollbar^ do
  begin
    setmin(0);
    setdir(DIR_VERTICAL);
    setautoalign(True);
  end;
  AddChild(Scrollbar);
end;

destructor TGUI_Listbox.Done_Listbox;
begin
  inherited Done_Canvas;
end;

procedure TGUI_Listbox.DoDoneStuff;
begin
  inherited;
  Dispose(Items, Done);
end;

function TGUI_Listbox.GetItems: PGUI_Listbox_Item;
begin
  GetItems := Items;
end;

procedure TGUI_Listbox.ctrl_FontChanged;
begin
  inherited;
  if fontlineskip <> 0 then
  begin
    ItemsToShow := (GetHeight div FontLineSkip);
  end
  else
    ItemsToShow := 0;
end;

procedure TGUI_Listbox.ctrl_Resize;
begin
  inherited;
  if fontlineskip <> 0 then
  begin
    ItemsToShow := (GetHeight div FontLineSkip);
  end
  else
    ItemsToShow := 0;
end;

procedure TGUI_Listbox.Render;
var
  NewCount: word;
  i: word;
  Next: PGUI_Listbox_Item;
  rect: TSDL_Rect;
begin
  if CurSelected then
    CurBorderColor := GUI_DefaultForeColor
  else
    CurBorderColor := BorderColor;
  inherited;
  NewCount := items^.GetCount;
  //writeln(ItemsToShow, ' ', ListCount, ' ', NewCount);
  if NewCount <> ListCount then
  begin
    ListCount := NewCount;
    if itemstoshow <= newcount then
    begin
      Scrollbar^.Setmax(NewCount - ItemsToShow - 1);
      Scrollbar^.SetVisible(True);
    end
    else
    begin
      Scrollbar^.SetVisible(False);
    end;
  end;
  i := 0;
  Next := GetItems^.Next;
  while (i < Scrollbar^.GetValue) and (Next <> nil) do
  begin
    Next := Next^.Next;
    Inc(i);
  end;
  i := 0;
  while (i < ItemsToShow) and (Next <> nil) do
  begin
    if Next^.GetSelected then
    begin
      (* SDL2 conv.: necesary?
      if SDL_MUSTLOCK(surface) then
      begin
        SDL_LockSurface(surface);
      end;
      *)

      with rect do
      begin
        x := 1;
        w := getwidth - 2;
        y := i * fontlineskip + 1;
        h := fontlineskip - 2;
      end;
      if CurSelected then
      begin
        (* SDL2 conv.
        SDL_FillRect(Surface, @Rect, MapRGBA(GUI_SelectedColor.R,
          GUI_SelectedColor.G, GUI_SelectedColor.B, GUI_SelectedColor.A));
        *)
        fillrect(Renderer, Texture, @Rect, GUI_SelectedColor);
      end
      else
      begin
        (* SDL2 conv.
        SDL_FillRect(Surface, @Rect, MapRGBA(GUI_DefaultTextBackColor.R,
          GUI_DefaultTextBackColor.G, GUI_DefaultTextBackColor.B,
          GUI_DefaultTextBackColor.A));
        *)
        fillrect(Renderer, Texture, @Rect, GUI_DefaultTextBackColor);
      end;
      (* SDL2 conv.
      if SDL_MUSTLOCK(surface) then
      begin
        SDL_UnlockSurface(surface);
      end;
      *)
    end;
    DrawText(Next^.GetStr, 3, i * FontLineSkip, Align_Left);
    Next := Next^.Next;
    Inc(i);
  end;
end;

procedure TGUI_Listbox.ctrl_KeyDown(KeySym: TSDL_KeySym);
var
  CurItem: PGUI_Listbox_Item;
begin
  CurItem := GetItems^.GetSelectedItem;
  case KeySym.Sym of
    SDLK_UP:
    begin
      if CurItem^.Prev <> nil then
      begin
        if not CurItem^.Prev^.NullFirst then
        begin
          CurItem^.Prev^.SetSelected(True);
          ctrl_NewSelection(CurItem^.Prev);
        end;
      end;
    end;
    SDLK_DOWN:
    begin
      if CurItem^.Next <> nil then
        CurItem^.Next^.SetSelected(True);
      ctrl_NewSelection(CurItem^.Next);
    end;
  end;
end;

procedure TGUI_Listbox.MouseDown(X, Y: word; Button: UInt8);
var
  itemno: word;
  i: integer;
  Next: PGUI_Listbox_Item;
begin
  inherited;
  itemno := y div FontLineSkip;
  if button = 1 then
  begin
    i := 0;
    Next := GetItems^.Next;
    while (i < Scrollbar^.GetValue) and (Next <> nil) do
    begin
      Next := Next^.Next;
      Inc(i);
    end;
    i := 0;
    while (i < ItemNo) and (Next <> nil) do
    begin
      Next := Next^.Next;
      Inc(i);
    end;
  end;
  if Next <> nil then
  begin
    Next^.setselected(True);
    ctrl_NewSelection(Next);
  end;
end;

procedure TGUI_Listbox.ctrl_NewSelection(Selection: PGUI_Listbox_Item);
begin
  NewSelection(Selection);
end;

procedure TGUI_Listbox.NewSelection(Selection: PGUI_Listbox_Item);
begin

end;

function TGUI_Listbox.GetSelectedItem: PGUI_Listbox_Item;
begin
  GetSelectedItem := GetItems^.GetSelectedItem;
end;

begin

end.
