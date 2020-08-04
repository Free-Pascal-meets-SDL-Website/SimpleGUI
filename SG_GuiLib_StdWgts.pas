unit SG_GuiLib_StdWgts;
{:< The Standard Widgets Unit}

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
  SDL2, SDL2_TTF, Math, SG_GuiLib_Base, SG_GuiLib_Element, SG_GuiLib_Canvas;

type

  { TGUI_Button }
  {: Generic Button Class }
  TGUI_Button = class(TGUI_Canvas)
  public
    {: Render the button }
    procedure Render; override;
    {: Constructor for the button }
    constructor Create;
    {: Destructor for the button }
    destructor Destroy; override;

    {: Control mouse entry procedure }
    procedure ctrl_MouseEnter; override;
    {: Control mouse entry procedure }
    procedure ctrl_MouseExit; override;

  protected
  private
  end;

  { TGUI_CheckBox }
  {: Generic Checkbox Class. Click to change its value.
    Can also act as a radio button by changing the ExcGroup to be less then 0
    (and the same as the other now radio buttons). It only looks through one
    level of parent for siblings of a CheckBox type. }
  TGUI_CheckBox = class(TGUI_Canvas)
  public
    {: Checkbox Constructor }
    constructor Create;
    {: Checkbox Destructor }
    destructor Destroy; override;
    {: Set the value of the checkbox - true (Checked) or false (Unchecked) }
    procedure SetValue(NewValue: Boolean); virtual;
    {: Returns the value of the checkbox  - true (Checked) or false (Unchecked)
     }
    function GetValue: Boolean; virtual;
    {: Render the checkbox }
    procedure Render; override;
    {: Sets the Exclusive Group. If this is 0 (default) then the box operates
      as a normal checkbox. If it is non-zero then it operates as a radio button
      with all of the other checkboxes in the same Exclusive Group }
    procedure SetExcGroup(NewExcGroup: Word);
    {: Returns the Exclusive Group }
    function GetExcGroup: Word;
    {: Control Mouse Click Handler }
    procedure ctrl_MouseClick(X, Y: Word; Button: UInt8); override;
    {: Called when box is checked - should be overwritten by decendent
      controls }
    procedure ctrl_BoxChecked; virtual;
    {: Called when box is unchecked - should be overwritten by decendent
      controls }
    procedure ctrl_BoxUnchecked; virtual;
    {: Called when box is checked - should be overwritten by the actual
      controls }
    procedure BoxChecked; virtual;
    {: Called when box is unchecked - should be overwritten by the actual
      controls }
    procedure BoxUnchecked; virtual;
  protected
    Value: Boolean;
    ExcGroup: Word;
  private
  end;

  { TGUI_Label }
  {: Generic Label Class }
  TGUI_Label = class(TGUI_Canvas)
  public
    {: Label Constructor }
    constructor Create;
    {: Label Destructor }
    destructor Destroy; override;
    {: Render label }
    procedure Render; override;
    {: Set the Text Alignment }
    procedure SetTextA(NewTextA: tTextAlign);
    {: Get the Text Alignment }
    function GetTextA: tTextAlign;
    {: Set the Texts Vertical Alignment }
    procedure SetVertA(NewVertA: tVertAlign);
    {: Return the Texts Vertical Alignment }
    function GetVertA: tVertAlign;
  protected
    TextA: tTextAlign;
    VertA: tVertAlign;
  end;

  { TGUI_ScrollBar }
  {: Generic Scrollbar Class }
  TGUI_ScrollBar = class(TGUI_Canvas)
  public
    {: Scrollbar Constructor }
    constructor Create;
    {: Scrollbar Destructor }
    destructor Destroy; override;
    {: Render scrollbar }
    procedure Render; override;
    {: Sets minimum value of scrollbar }
    procedure SetMin(NewMinVal: Integer);
    {: Returns the minimum value of scrollbar }
    function GetMin: Integer;
    {: Sets maximum value of scrollbar }
    procedure SetMax(NewMaxVal: Integer);
    {: Returns maximum value of scrollbar }
    function GetMax: Integer;
    {: Sets the value of the scrollbar }
    procedure SetValue(NewValue: Integer);
    {: Returns the current value of scrollbar }
    function GetValue: Integer;
    {: Sets whether the scrollbar is horizontal or vertical }
    procedure SetDir(NewDir: TDirection);
    {: Returns whether the scrollbar is horizontal or vertical }
    function GetDir: TDirection;
    {: Sets whether the scrollbar automatically aligns itself to the right of
      its parent (for a vertical bar) or the bottom of its parent (for a
      horizontal bar). }
    procedure SetAutoAlign(NewValue: Boolean);
    {: Returns the whether the scrollbar automatically aligns itself. }
    function GetAutoAlign: Boolean;
    {: Sets whether the scrollbar accounts for a second scroll bar in the
      opposite direction hence leaving the bottom right corner free }
    procedure SetAutoAlignBoth(NewValue: Boolean);
    {: Returns autoalignboth }
    function GetAutoAlignBoth: Boolean;
    {: Called when parents size changes }
    procedure ParentSizeCallback(NewW, NewH: Word); override;
    {: Should be only called by parent control - Controls Mouse Down Handler }
    procedure ctrl_MouseDown(X, Y: Word; Button: UInt8); override;
    {: Should be only called by parent control - Controls Mouse Up Handler }
    procedure ctrl_MouseUp(X, Y: Word; Button: UInt8); override;
    {: Should be only called by control - Controls Value Changes Handler }
    procedure ctrl_ValueChanged(NewValue: Integer); virtual;
    {: Should be only called by parent control - SDL Event Handler }
    procedure ctrl_SDLPassthrough(e: PSDL_Event); override;
    {: Called when value of scroll bar has changed - should be overwritten
      by child controls }
    procedure ValueChanged(NewValue: Integer); virtual;
  protected
    MinVal, MaxVal, Value: Integer;
    InitX, InitY: Word;
    Dir: TDirection;
    Moving: Boolean;
    Autoalign, Autoalignboth: Boolean;
  private
  end;

  { TGUI_TextBox }
  {: Generic Testbox Class. It could probably still be classified as unfinished
    owing to the fact that its cursor is still a caret('^'), clicks don't move
    the cursor and it sticks to showing the left side of its contents }
  TGUI_TextBox = class(TGUI_Canvas)
  public
    constructor Create;
    destructor Destroy; override;
    procedure Render; override;
    procedure ctrl_Selected; override;
    procedure ctrl_LostSelected; override;

    procedure ctrl_KeyDown(KeySym: TSDL_KeySym); override;
    procedure ctrl_KeyUp(KeySym: TSDL_KeySym); override;
    procedure ctrl_TextInput(TextIn: TSDLTextInputArray); override;
    procedure KeyDown(KeySym: TSDL_KeySym); override;
    procedure KeyUp(KeySym: TSDL_KeySym); override;

    procedure ctrl_TextChanged(); virtual;
    procedure TextChanged; virtual;

    procedure SetText(InText: string);
    function GetText: string;
  protected
    Cursor: Integer;
    StrText: string;

    IsSelected: Boolean;

    procedure MoveCursor(Amt: Integer);
    procedure CursorInsert(Character: TSDLTextInputArray);
    procedure CursorBackspace;
    procedure CursorDelete;
    procedure CursorHome;
    procedure CursorEnd;
  private
  end;

  { TGUI_Image }
  {: Generic Image Class based upon SDL_Texture. Memory management? }
  TGUI_Image = class(TGUI_Canvas)
  public
    {: Constructor for Surface Widget. }
    constructor Create;
    {: Destructor for Surface Widget. }
    destructor Destroy; override;
    {: Allows for a surface to be transformed into texture after Renderer known
      to GUI element. }
    procedure ChildAddedCallback; override;
    {: Sets the source texture to draw from. }
    procedure SetSource(NewSrcTexture: PSDL_Texture);
    {: Sets the source surface to draw from. Is converted into a texture. }
    procedure SetSource(NewSrcSurface: PSDL_Surface); overload;
    {: Returns the current source surface. }
    function GetSource: PSDL_Texture;
    {: Sets the rectangle from where to draw from on the source surface. }
    procedure SetSrcRect(NewRect: TSDL_Rect); virtual;
    {: Returns the current source surface rectangle to draw from. }
    function GetSrcRect: TSDL_Rect; virtual;
    {: Sets whether or not the surface takes the full size of the source
    surface or uses the bounding rectangle.}
    procedure SetFullSrc(NewFullSrc: Boolean);
    {: Returns whether or not the surface takes the full size of the source
    surface or uses the bounding rectangle.}
    function GetFullSrc: Boolean;
    {: Sets if SrcTexture (SDL_Texture) is free'd automatically.
      - set to True if SetSource() is a SDL_Surface
      - set to False if SetSource() is a SDL_Texture
      - you may change it afterwards }
    procedure SetFreeAutomatically(NewFreeStatus: Boolean);
    {: Returns the current free setting for the Image texture. }
    function GetFreeAutomatically: Boolean;
    {: Renders the widget }
    procedure Render; override;
  protected
    {: This surface is a helper to store a surface which is set by SetSource()
      until AddChild() is called, because just then the Renderer is known. After
      that is not used anymore and also not free'd. }
    StoredSurface: PSDL_Surface;
    {: This is the image represented as a SDL2 texture. }
    SrcTexture: PSDL_Texture;
    SrcRect: TSDL_Rect;
    DstRect: TSDL_Rect;
    FullSrc: Boolean;
    IsFreed: Boolean;
  private
  end;

  { TGUI_Listbox_Item }
  {: Linked list of items in the Listbox or Dropbox. }
  TGUI_Listbox_Item = class
  public
    {: Next item in list. }
    Next: TGUI_Listbox_Item;
    {: Previous item in list. }
    Prev: TGUI_Listbox_Item;
    NullFirst: Boolean;
    {: Returns the final item in the list. }
    function Last: TGUI_Listbox_Item;
    {: Returns the first item in the list. }
    function First: TGUI_Listbox_Item;
    {: Returns a string version of the item - could be changed by child
      classes to return something different. Essentially, this is the bit
      that is displayed. }
    function GetStr: string; virtual;
    {: Sets the string to display. }
    procedure SetStr(NewString: string); virtual;
    {: Returns the index of this item. }
    function GetIndex: Integer;
    {: Sets the index of this item. }
    procedure SetIndex(NewIndex: Integer);
    {: Adds a new listbox_item with the test NewText and index NewIndex. }
    procedure AddItem(NewStr: string; NewIndex: Integer);
    {: Makes this the final item in the Linked list. }
    procedure PushToLast;
    {: Initialises Linked List. }
    constructor Create;
    {: Destructor of Item. }
    destructor Destroy; override;
    {: Returns the item bearing the index number. Returns nil if there is
      no such item. }
    function ReturnItem(ItemIndex: Integer): TGUI_listbox_item;
    {: Sets whether the item is selected. If so, it will then unselect all
      other items in the list.}
    procedure SetSelected(NewSel: Boolean);
    {: Returns whether the item is selected}
    function GetSelected: Boolean;
    {: Returns the currently selected item }
    function GetSelectedItem: TGUI_Listbox_item;

    {: Dumps the contents of the Linked list to the console. For debugging
      purposes. }
    procedure Dump;

    function GetCount: Word;

  protected
    IndexNo: Integer;
    Caption: string;
    Selected: Boolean;
  end;

  { TGUI_Listbox }
  {: Widget that displays a listbox }
  TGUI_Listbox = class(TGUI_Canvas)
  public
    {: Listbox constructor }
    constructor Create;
    {: Listbox destructor - will probably never be called }
    destructor Destroy; override;
    {: Returns list of items }
    function GetItems: TGUI_Listbox_Item;
    {: Renders the widget }
    procedure Render; override;
    {: Called when the font changes }
    procedure ctrl_FontChanged; override;
    {: Called when the control is resized }
    procedure ctrl_Resize; override;
    {: Called when the control recieves a keypress }
    procedure ctrl_KeyDown(KeySym: TSDL_KeySym); override;
    {: Called when the listbox is clicked}
    procedure MouseDown(X, Y: Word; Button: UInt8); override;
    {: Should be overwritten by children. Will be called when the selection
      is changed }
    procedure ctrl_NewSelection(Selection: TGUI_Listbox_Item); virtual;
    {: Will be called when the selection is changed }
    procedure NewSelection(Selection: TGUI_Listbox_Item); virtual;
    {: Returns the currently selected item }
    function GetSelectedItem: TGUI_Listbox_Item;
  protected
    Items: TGUI_Listbox_Item;
    ListCount: Word;
    ItemsToShow: Word;
    Scrollbar: TGUI_Scrollbar;
  private
  end;

implementation

uses
  SysUtils, SDL2_SimpleGUI;

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
  RenderText(GetCaption, Width div 2, (GetHeight - TTF_FontHeight(Font)) div 2,
    Align_Center);
end;

constructor TGUI_Button.Create;
begin
  inherited Create;
  SetBorderStyle(BS_Single);
end;

destructor TGUI_Button.Destroy;
begin
  inherited Destroy;
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

constructor TGUI_CheckBox.Create;
begin
  inherited Create;
  SetFillStyle(FS_None);
  ExcGroup := 0;
end;

destructor TGUI_CheckBox.Destroy;
begin
  inherited Destroy;
end;

procedure TGUI_CheckBox.SetValue(NewValue: Boolean);
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

function TGUI_CheckBox.GetValue: Boolean;
begin
  getvalue := Value;
end;

procedure TGUI_CheckBox.Render;
var
  r: TSDL_Rect;
begin
  with r do
  begin
    w := 20;
    h := 20;
    x := GetAbsLeft + 3;
    y := GetAbsTop + 3;
  end;
  if GetMouseEntered then
    RenderFilledRect(@r, GUI_SelectedColor)
  else
    RenderFilledRect(@r, backcolor);
  RenderRect(@r, CurBorderColor);
  with r do
  begin
    w := 11;
    h := 11;
    x := GetAbsLeft + 8;
    y := GetAbsTop + 8;
  end;
  if Value then
    RenderFilledRect(@r, forecolor);
  RenderText(GetCaption, 30, 5, Align_Left);
end;

procedure TGUI_CheckBox.ctrl_MouseClick(X, Y: Word; Button: UInt8);
var
  Next: TGUI_Element_LL;
  Data: TGUI_Checkbox;
begin
  if ExcGroup = 0 then
  // Do this if its just a checkbox
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
  // But do this if its an option box
  begin
    if not (Value) then
    begin
      SetValue(True);
      // Traverse siblings to tell relevant siblings to be unselected
      Next := Parent.GetChildren.Next;
      while Assigned(Next) do
      begin
        if Next.Data is TGUI_Checkbox then
        begin
          Data := Next.Data as TGUI_Checkbox;
          if Next.Data <> Self then
            if Data.GetExcGroup = ExcGroup then
              Data.SetValue(False);
        end;
        Next := Next.Next;
      end;
    end;
  end;
end;

procedure TGUI_CheckBox.ctrl_BoxChecked();
begin
  BoxChecked;
end;

procedure TGUI_CheckBox.ctrl_BoxUnchecked();
begin
  BoxUnChecked;
end;

procedure TGUI_CheckBox.BoxChecked();
begin

end;

procedure TGUI_CheckBox.BoxUnchecked();
begin

end;

procedure TGUI_CheckBox.SetExcGroup(NewExcGroup: Word);
begin
  ExcGroup := NewExcGroup;
end;

function TGUI_CheckBox.GetExcGroup: Word;
begin
  GetExcGroup := ExcGroup;
end;


//*********************************************************
//TGUI_Label
//*********************************************************

constructor TGUI_Label.Create;
begin
  inherited Create;
  SetFillStyle(FS_None);
  SetSelectable(False);
  SetTextA(Align_Left);
  SetVertA(VAlign_Top);
end;

destructor TGUI_Label.Destroy;
begin
  inherited Destroy;
end;

procedure TGUI_Label.Render;
var
  LeftPoint, TopPoint: Word;
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
  RenderText(GetCaption, LeftPoint, TopPoint, TextA);
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

constructor TGUI_ScrollBar.Create;
begin
  inherited Create;
  SetFillStyle(FS_None);
  SetMin(0);
  SetMax(100); // SetValue(50); [Why this comment?]
end;

destructor TGUI_ScrollBar.Destroy;
begin
  inherited Destroy;
end;

procedure TGUI_ScrollBar.Render;
var
  r: TSDL_Rect;
begin
  case GetDir of
    Dir_Horizontal:
    begin
      RenderLine(GetAbsLeft, GetAbsTop + GetHeight div 2, GetAbsLeft +
        GetWidth - 1, GetAbsTop + GetHeight div 2, BorderColor);
      with r do
      begin
        w := GUI_ScrollbarSize;
        h := GUI_ScrollbarSize;
        x := GetAbsLeft + floor((Value * (GetWidth - w - 2)) / (MaxVal - MinVal)
          );
        y := GetAbsTop + (GetHeight - h) div 2;
      end;
    end;
    Dir_Vertical:
    begin
      RenderLine(GetAbsLeft + GetWidth div 2, GetAbsTop, GetAbsLeft +
        GetWidth div 2, GetAbsTop + GetHeight, BorderColor);
      with r do
      begin
        w := GUI_ScrollbarSize;
        h := GUI_ScrollbarSize;
        y := GetAbsTop + floor((Value * (GetHeight - h - 1)) / (MaxVal - MinVal)
          );
        x := GetAbsLeft + (GetWidth - w) div 2;
      end;
    end;
  end;
  if GetMouseEntered or Moving then
    RenderFilledRect(@r, GUI_SelectedColor)
  else
    RenderFilledRect(@r, BackColor);
  RenderRect(@r, CurBorderColor);
end;

procedure TGUI_ScrollBar.SetMin(NewMinVal: Integer);
begin
  MinVal := NewMinVal;
end;

function TGUI_ScrollBar.GetMin: Integer;
begin
  GetMin := MinVal;
end;

procedure TGUI_ScrollBar.SetMax(NewMaxVal: Integer);
begin
  MaxVal := NewMaxVal;
end;

function TGUI_ScrollBar.GetMax: Integer;
begin
  GetMax := MaxVal;
end;

procedure TGUI_ScrollBar.SetValue(NewValue: Integer);
begin
  Value := NewValue;
  ctrl_ValueChanged(NewValue);
end;

function TGUI_ScrollBar.GetValue: Integer;
begin
  Result := Value;
end;

procedure TGUI_ScrollBar.SetDir(NewDir: TDirection);
begin
  Dir := NewDir;
end;

function TGUI_ScrollBar.GetDir: TDirection;
begin
  GetDir := Dir;
end;

procedure TGUI_ScrollBar.SetAutoAlign(NewValue: Boolean);
begin
  Autoalign := NewValue;
  if AutoAlign then
    if Parent <> nil then
      ParentSizeCallback(Parent.GetWidth, Parent.GetHeight);
end;

function TGUI_ScrollBar.GetAutoAlign: Boolean;
begin
  GetAutoAlign := AutoAlign;
end;

procedure TGUI_ScrollBar.SetAutoAlignBoth(NewValue: Boolean);
begin
  AutoAlignBoth := NewValue;
  if AutoAlignBoth then
    if Parent <> nil then
      ParentSizeCallback(Parent.GetWidth, Parent.GetHeight);
end;

function TGUI_ScrollBar.GetAutoAlignBoth: Boolean;
begin
  GetAutoAlignBoth := AutoAlignBoth;
end;

procedure TGUI_ScrollBar.ParentSizeCallback(NewW, NewH: Word);
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

procedure TGUI_ScrollBar.ctrl_MouseDown(X, Y: Word; Button: UInt8);
var
  NewVal: Integer;
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

procedure TGUI_ScrollBar.ctrl_MouseUp(X, Y: Word; Button: UInt8);
begin
  inherited;
  if Button = 1 then
    Moving := False;
end;

procedure TGUI_ScrollBar.ctrl_SDLPassthrough(e: PSDL_Event);
var
  NewVal, X, Y: Integer;
begin
  inherited;
  case e^.type_ of
    SDL_MOUSEBUTTONUP:
    begin
      if Moving then
        if e^.button.button = 1 then
          Moving := False;
    end;
    SDL_MOUSEMOTION:
      if Moving then
      begin
        X := e^.motion.x - InitX;
        y := e^.motion.y - InitY;
        case Dir of
          Dir_Horizontal:
          begin
            NewVal := (X * (MaxVal - MinVal)) div (GetWidth - 6);
          end;
          Dir_Vertical:
          begin
            NewVal := (Y * (MaxVal - MinVal)) div (GetHeight - 6);
          end;
        end;
        NewVal := Max(MinVal, NewVal);
        NewVal := Min(MaxVal, NewVal);
        SetValue(NewVal);
      end;
  end;
end;

procedure TGUI_ScrollBar.ctrl_ValueChanged(NewValue: Integer);
begin
  ValueChanged(NewValue);
end;

procedure TGUI_ScrollBar.ValueChanged(NewValue: Integer);
begin

end;

//*********************************************************
//TGUI_TextBox
//*********************************************************

constructor TGUI_TextBox.Create;
begin
  inherited Create;
  SetBackColor(GUI_DefaultTextBackColor);
  SetBorderStyle(BS_Single);
  Cursor := 0;
  StrText := '';
  IsSelected := False;
end;

destructor TGUI_TextBox.Destroy;
begin
  inherited Destroy;
end;

procedure TGUI_TextBox.Render;
var
  TextToRender: string;
  ActiveToRender: string;
begin
  inherited;
  ActiveToRender := '';
  begin
    if CurSelected then
    begin
      ActiveToRender := GetText;
      ActiveToRender := LeftStr(GetText, Cursor) + '^' + RightStr(GetText,
        Length(GetText) - Cursor);
      TextToRender := ActiveToRender;    // optimise block? (re-str.)
    end
    else
    if GetText = '' then
      TextToRender := GetCaption
    else
      TextToRender := GetText;
  end;
  RenderText(TextToRender, 5, (GetHeight - TTF_FontHeight(Font)) div 2,
    Align_Left);
end;

procedure TGUI_TextBox.ctrl_Selected;
begin
  CurFillColor := GUI_SelectedColor;
  IsSelected := True;
  Cursor := Length(StrText);
  SDL_StartTextInput;
end;

procedure TGUI_TextBox.ctrl_LostSelected;
begin
  CurFillColor := BackColor;
  IsSelected := False;
  SDL_StopTextInput;
end;

procedure TGUI_TextBox.ctrl_KeyDown(KeySym: TSDL_KeySym);
begin
  inherited;

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
    { TODO : new feat.: exit on ENTER; doesn't work as expected, why? }
    //SDLK_RETURN:
    //begin
    //  ctrl_LostSelected;
    //end;
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

procedure TGUI_TextBox.SetText(InText: string);
begin
  StrText := InText;
end;

function TGUI_TextBox.GetText: string;
begin
  Result := StrText;
end;

procedure TGUI_TextBox.MoveCursor(Amt: Integer);
begin
  Cursor := Cursor + amt;
  if cursor < 0 then
    cursor := 0;
  if cursor > length(GetText) then
    cursor := length(GetText);
end;

procedure TGUI_TextBox.CursorInsert(Character: TSDLTextInputArray);
begin
  StrText := LeftStr(GetText, Cursor) + Character + RightStr(GetText, Length(
    GetText) - Cursor);
end;

procedure TGUI_TextBox.CursorBackspace;
begin
  if cursor <> 0 then
  begin
    StrText := LeftStr(GetText, Cursor - 1) + RightStr(GetText, Length(
      GetText) - Cursor);
    MoveCursor(-1);
  end;
end;

procedure TGUI_TextBox.CursorDelete;
begin
  if cursor <> length(GetText) then
  begin
    StrText := LeftStr(GetText, Cursor) + RightStr(GetText, Length(GetText) -
      Cursor - 1);
  end;
end;

procedure TGUI_TextBox.CursorHome;
begin
  Cursor := 0;
end;

procedure TGUI_TextBox.CursorEnd;
begin
  Cursor := Length(GetText);
end;


//*********************************************************
//TGUI_Image
//*********************************************************

constructor TGUI_Image.Create;
begin
  inherited Create;
  SetFillStyle(FS_None);
  SetFullSrc(True);
  SetFreeAutomatically(False);
end;

destructor TGUI_Image.Destroy;
begin
  inherited Destroy;
  if GetFreeAutomatically then
    SDL_DestroyTexture(SrcTexture);
end;

procedure TGUI_Image.ChildAddedCallback;
begin
  inherited;
  if Assigned(StoredSurface) then
    SrcTexture := SDL_CreateTextureFromSurface(Renderer, StoredSurface);
end;

procedure TGUI_Image.SetSource(NewSrcTexture: PSDL_Texture);
begin
  SrcTexture := NewSrcTexture;
end;

procedure TGUI_Image.SetSource(NewSrcSurface: PSDL_Surface);
begin
  StoredSurface := NewSrcSurface;
  SetFreeAutomatically(True);
end;

function TGUI_Image.GetSource: PSDL_Texture;
begin
  GetSource := SrcTexture;
end;

procedure TGUI_Image.SetSrcRect(NewRect: TSDL_Rect);
begin
  SrcRect := NewRect;
end;

function TGUI_Image.GetSrcRect: TSDL_Rect;
begin
  GetSrcRect := SrcRect;
end;

procedure TGUI_Image.SetFullSrc(NewFullSrc: Boolean);
begin
  FullSrc := NewFullSrc;
end;

function TGUI_Image.GetFullSrc: Boolean;
begin
  GetFullSrc := FullSrc;
end;

procedure TGUI_Image.SetFreeAutomatically(NewFreeStatus: Boolean);
begin
  IsFreed := NewFreeStatus;
end;

function TGUI_Image.GetFreeAutomatically: Boolean;
begin
  Result := IsFreed;
end;

procedure TGUI_Image.Render;
begin
  inherited Render;
  if Assigned(SrcTexture) then
  begin
    DstRect.x := GetAbsLeft;
    DstRect.y := GetAbsTop;
    DstRect.w := GetWidth;
    DstRect.h := GetHeight;

    if FullSrc then
      SDL_RenderCopy(Renderer, SrcTexture, nil, @DstRect)
    else
      SDL_RenderCopy(Renderer, SrcTexture, @SrcRect, @DstRect);
  end;
end;

//*********************************************************
//TGUI_Listbox_Item
//*********************************************************

function TGUI_Listbox_Item.Last: TGUI_Listbox_Item;
begin
  if Next <> nil then
    Last := Next.Last
  else
    Last := Self;
end;

function TGUI_Listbox_Item.First: TGUI_Listbox_Item;
begin
  if Prev <> nil then
    First := Next.Prev
  else
    First := Self;
end;

function TGUI_Listbox_Item.GetSelectedItem: TGUI_Listbox_item;
var
  NextItem: TGUI_Listbox_item;
begin
  NextItem := First;
  while (NextItem <> nil) and not (NextItem.GetSelected) do
    NextItem := NextItem.Next;
  GetSelectedItem := NextItem;
end;

function TGUI_Listbox_Item.GetStr: string;
begin
  GetStr := Caption;
end;

procedure TGUI_Listbox_Item.SetStr(NewString: string);
begin
  Caption := NewString;
end;

function TGUI_Listbox_Item.GetIndex: Integer;
begin
  GetIndex := IndexNo;
end;

procedure TGUI_Listbox_Item.SetIndex(NewIndex: Integer);
begin
  IndexNo := NewIndex;
end;

procedure TGUI_Listbox_Item.AddItem(NewStr: string; NewIndex: Integer);
var
  NewPrev: TGUI_Listbox_Item;
begin
  NewPrev := Last;
  Last.Next := TGUI_Listbox_Item.Create;
  Last.Next := nil;
  Last.Prev := NewPrev;
  Last.SetIndex(NewIndex);
  Last.SetStr(NewStr);
end;

procedure TGUI_Listbox_Item.Dump;
begin
  Write(GetStr, '(', GetIndex, ')');
  if Next <> nil then
  begin
    Write('->');
    Next.dump;
  end
  else
    Writeln;
end;

constructor TGUI_Listbox_Item.Create;
begin
  IndexNo := 0;
end;

destructor TGUI_Listbox_Item.Destroy;
begin
  if Assigned(Next) then
    FreeAndNil(Next);
  inherited Destroy;
end;

function TGUI_Listbox_Item.ReturnItem(ItemIndex: Integer): TGUI_listbox_item;
begin
  if IndexNo = ItemIndex then
    ReturnItem := Self
  else
  if Next <> nil then
    ReturnItem := Next.ReturnItem(ItemIndex)
  else
    ReturnItem := nil;
end;

procedure TGUI_Listbox_Item.PushToLast;
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

function TGUI_Listbox_Item.GetCount: Word;
begin
  if Assigned(Next) then
    GetCount := Next.GetCount + 1
  else
    GetCount := 1;
end;

procedure TGUI_Listbox_Item.SetSelected(NewSel: Boolean);
var
  NextItem: TGUI_Listbox_Item;
begin
  Selected := NewSel;
  if NewSel then
  begin
    NextItem := Next;
    while NextItem <> nil do
    begin
      NextItem.SetSelected(False);
      NextItem := NextItem.Next;
    end;
    NextItem := Prev;
    while NextItem <> nil do
    begin
      NextItem.SetSelected(False);
      NextItem := NextItem.Prev;
    end;
  end;
end;

function TGUI_Listbox_Item.GetSelected: Boolean;
begin
  GetSelected := Selected;
end;

//*********************************************************
//TGUI_Listbox
//*********************************************************

constructor TGUI_Listbox.Create;
begin
  inherited Create;
  SetBorderStyle(BS_Single);
  SetSelectable(True);
  Items := TGUI_Listbox_Item.Create;
  Items.NullFirst := True;
  Scrollbar := TGUI_Scrollbar.Create;
  with Scrollbar do
  begin
    SetMin(0);
    SetDir(DIR_VERTICAL);
    SetAutoAlign(True);
  end;
  AddChild(Scrollbar);
end;

destructor TGUI_Listbox.Destroy;
begin
  FreeAndNil(Items);
  inherited Destroy;
end;

function TGUI_Listbox.GetItems: TGUI_Listbox_Item;
begin
  Result := Items;
end;

procedure TGUI_Listbox.ctrl_FontChanged;
begin
  inherited;
  if FontLineSkip <> 0 then
  begin
    ItemsToShow := (GetHeight div FontLineSkip);
  end
  else
    ItemsToShow := 0;
end;

procedure TGUI_Listbox.ctrl_Resize;
begin
  inherited;
  if FontLineSkip <> 0 then
  begin
    ItemsToShow := (GetHeight div FontLineSkip);
  end
  else
    ItemsToShow := 0;
end;

procedure TGUI_Listbox.Render;
var
  NewCount: Word;
  i: Word;
  Next: TGUI_Listbox_Item;
  Rect: TSDL_Rect;
begin
  if CurSelected then
    CurBorderColor := GUI_DefaultForeColor
  else
    CurBorderColor := BorderColor;
  inherited;
  NewCount := Items.GetCount;
  if NewCount <> ListCount then
  begin
    ListCount := NewCount;
    if ItemsToShow <= NewCount then
    begin
      Scrollbar.Setmax(NewCount - ItemsToShow - 1);
      Scrollbar.SetVisible(True);
    end
    else
    begin
      Scrollbar.SetVisible(False);
    end;
  end;
  i := 0;
  Next := GetItems.Next;
  while (i < Scrollbar.GetValue) and (Next <> nil) do
  begin
    Next := Next.Next;
    Inc(i);
  end;
  i := 0;
  while (i < ItemsToShow) and (Next <> nil) do
  begin
    if Next.GetSelected then
    begin
      with Rect do
      begin
        x := GetAbsLeft + 1;
        w := getwidth - 2;
        y := GetAbsTop + i * FontLineSkip + 1;
        h := FontLineSkip - 2;
      end;
      if CurSelected then
        RenderFilledRect(@Rect, GUI_SelectedColor)
      else
        RenderFilledRect(@Rect, GUI_DefaultTextBackColor);
    end;
    RenderText(Next.Caption, 3, i * FontLineSkip, Align_Left);
    Next := Next.Next;
    Inc(i);
  end;
end;

procedure TGUI_Listbox.ctrl_KeyDown(KeySym: TSDL_KeySym);
var
  CurItem: TGUI_Listbox_Item;
begin
  CurItem := GetItems.GetSelectedItem;
  case KeySym.Sym of
    SDLK_UP:
    begin
      if CurItem.Prev <> nil then
      begin
        if not CurItem.Prev.NullFirst then
        begin
          CurItem.Prev.SetSelected(True);
          ctrl_NewSelection(CurItem.Prev);
        end;
      end;
    end;
    SDLK_DOWN:
    begin
      if CurItem.Next <> nil then
        CurItem.Next.SetSelected(True);
      ctrl_NewSelection(CurItem.Next);
    end;
  end;
end;

procedure TGUI_Listbox.MouseDown(X, Y: Word; Button: UInt8);
var
  ItemNo: Word;
  i: Integer;
  Next: TGUI_Listbox_Item;
begin
  inherited;
  ItemNo := y div FontLineSkip;
  if Button = 1 then
  begin
    i := 0;
    Next := GetItems.Next;
    while (i < Scrollbar.GetValue) and (Next <> nil) do
    begin
      Next := Next.Next;
      Inc(i);
    end;
    i := 0;
    while (i < ItemNo) and (Next <> nil) do
    begin
      Next := Next.Next;
      Inc(i);
    end;
  end;
  if Next <> nil then
  begin
    Next.setselected(True);
    ctrl_NewSelection(Next);
  end;
end;

procedure TGUI_Listbox.ctrl_NewSelection(Selection: TGUI_Listbox_Item);
begin
  NewSelection(Selection);
end;

procedure TGUI_Listbox.NewSelection(Selection: TGUI_Listbox_Item);
begin

end;

function TGUI_Listbox.GetSelectedItem: TGUI_Listbox_Item;
begin
  GetSelectedItem := GetItems.GetSelectedItem;
end;

begin

end.
