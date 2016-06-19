{

  Simple GUI is based upon Lachlans GUI (LK GUI). LK GUI's original source code
  remark is shown below.

  Written permission to re-license the library has been granted to me by the
  original author.

}
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

  PGUI_Container_Scrollbar = ^TGUI_Container_Scrollbar;
  {: The scrollbars for the container - not for general use }
  TGUI_Container_Scrollbar = object(TGUI_Scrollbar)
    public
      constructor Init_Container_ScrollBar;
      destructor Done_Container_ScrollBar;
      procedure ValueChanged(NewValue: Integer); virtual;             
    end;
    
  PGUI_Container = ^TGUI_Container;
  {: Widget Container - can be used (for instance) to contain a bunch of similar
     widgets in a scrollable box }
  TGUI_Container = object(TGUI_Canvas)
    public    
      {: Container constructor }
      constructor Init_Container;
      {: Container destructor - but probably not needed}
      destructor Done_Container;
      {: The actual destructor stuff - called by destructor }
      procedure DoDoneStuff; virtual;
      {: Set the width of the container itself}      
      procedure SetContainerWidth(NewWidth: Word); virtual;
      {: Returns the width of the container itself}
      function GetContainerWidth: Word; virtual;
      {: Set the height of the container itself}
      procedure SetContainerHeight(NewHeight: Word); virtual;
      {: Returns the height of the container itself}
      function GetContainerHeight: Word; virtual;   
      {: Altered 'paint' routine - paints all controls in the container
      surface and renders it and its scrollbars onto its own surface }
      procedure Paint; virtual;     
      {: Altered SetWidth - doesn't send changes to children }
      procedure SetWidth(NewWidth: Word); virtual;
      {: Altered SetHeight - doesn't send changes to children }
      procedure SetHeight(NewHeight: Word); virtual;
      
      {: Resize Control Event Handler - overrides @inherited }
      procedure CTRL_Resize; virtual;
      {Code for these events is lifted almost directly from LK_GuiLib_Element
      and any changed there may want to be replicated here. However, they
      differ in how they pass x and y's}
      {: Control Mouse Button Down event handler - overrides @inherited }
      procedure ctrl_MouseDown(X, Y: Word; Button: UInt8); virtual;
      {: Control Mouse Button Up event handler - overrides @inherited }
      procedure ctrl_MouseUp(X, Y: Word; Button: UInt8); virtual;
      {: Control Mouse Motion event handler - overrides @inherited }
      procedure ctrl_MouseMotion(X, Y: Word; ButtonState: UInt8); virtual;
      {: Control Mouse Click event handler - overrides @inherited }
      procedure ctrl_MouseClick(X, Y: Word; Button: UInt8); virtual;
      
      {: Procedure called by Scrollbars when their values change such that
      this controls moves the container} 
      procedure Scrollbar_ValChanged(NewVal: Word; Dir: TDir);
    protected
      ContainerWidth, ContainerHeight: Word;
      ContainerSurface: PSDL_Surface;
      ContainerLeft, ContainerTop: Word;
      
    private
      Hscrollbar, Vscrollbar: PGUI_Container_Scrollbar;
      procedure UpdateScrollbars;
    end;
 



//*********************************************************
//TGUI_Container
//*********************************************************  

//  
//TGUI_Container_Scrollbar
//

constructor TGUI_Container_Scrollbar.Init_Container_Scrollbar;
begin  
  inherited Init_Scrollbar;  
  end;

destructor TGUI_Container_Scrollbar.Done_Container_Scrollbar;
begin
  inherited Done_Scrollbar;  
  end;  
  
procedure TGUI_Container_Scrollbar.ValueChanged(NewValue: Integer); 
var
  TCParent: PGUI_Container;
begin
  TCParent := PGUI_Container(Parent); 
  TCParent^.Scrollbar_ValChanged(NewValue, Dir);
  end;
  
//  
//TGUI_Container Proper
//
constructor TGUI_Container.Init_Container;
begin
  inherited Init_Canvas;
  new(HScrollBar, Init_Container_Scrollbar);
  new(VScrollbar, Init_Container_Scrollbar);
  With HScrollBar^ do 
  begin
    SetVisible(True);
    SetWidth(10);
    SetHeight(10);
    SetLeft(0);    
    SetDir(Dir_Horizontal);
    SetDbgName('Container HScroll');
    end;
  With VScrollBar^ do 
  begin
    SetVisible(True);
    SetWidth(10);
    SetHeight(10);    
    SetDir(Dir_Vertical);
    SetDbgName('Container VScroll');
    end;  
  AddChild(HScrollBar);
  AddChild(VScrollBar);
  updatescrollbars;
  SetContainerWidth(1000);
  SetContainerHeight(1000);
  end;
  
destructor TGUI_Container.Done_Container;
begin
  inherited Done_Canvas;
  end;
  
procedure TGUI_Container.DoDoneStuff;
begin
  inherited DoDoneStuff;
 {Dispose(HScrollbar, Done_Scrollbar);
  DisposeVScrollbar, Done_Scrollbar);}
  end;
  
procedure TGUI_Container.SetContainerWidth(NewWidth: Word); 
begin
  ContainerWidth := NewWidth;
  if ContainerSurface <> nil then
    SDL_FreeSurface(ContainerSurface);
  ContainerSurface :=  SDL_CreateRGBSurface(SDL_SWSURFACE, ContainerWidth,
    ContainerHeight, 32, SDL_GetVideoSurface^.format^.RMask,
    SDL_GetVideoSurface^.format^.GMask, SDL_GetVideoSurface^.format^.BMask,
    amask);  
  SendSizeCallback(NewWidth, ContainerHeight);
  UpdateScrollbars;    
  end;
  
function TGUI_Container.GetContainerWidth: Word; 
begin
  GetContainerWidth := ContainerWidth;
  end;

procedure TGUI_Container.SetContainerHeight(NewHeight: Word); 
begin
  ContainerHeight := NewHeight;
  if ContainerSurface <> nil then
    SDL_FreeSurface(ContainerSurface);
  ContainerSurface := SDL_CreateRGBSurface(SDL_SWSURFACE, ContainerWidth,
    ContainerHeight, 32, SDL_GetVideoSurface^.format^.RMask,
    SDL_GetVideoSurface^.format^.GMask, SDL_GetVideoSurface^.format^.BMask, 
    amask);    
  SendSizeCallback(ContainerWidth, NewHeight);
  UpdateScrollbars;
  end;

function TGUI_Container.GetContainerHeight: Word; 
begin
  GetContainerHeight := ContainerHeight;
  end;  

procedure TGUI_Container.SetWidth(NewWidth: Word); 
begin
  Width := NewWidth;
  updatescrollbars;
  if surface <> nil then
    SDL_FreeSurface(Surface);
  Surface :=  SDL_CreateRGBSurface(SDL_SWSURFACE, Width, Height, 32,
    SDL_GetVideoSurface^.format^.RMask, SDL_GetVideoSurface^.format^.GMask,
    SDL_GetVideoSurface^.format^.BMask, amask);  
  Ctrl_Resize;
  //SendSizeCallback(NewWidth, Height);  
  end;

procedure TGUI_Container.SetHeight(NewHeight: Word); 
begin
  Height := NewHeight;
  updatescrollbars;
  if surface <> nil then
    SDL_FreeSurface(Surface);
  Surface := SDL_CreateRGBSurface(SDL_SWSURFACE, Width, Height, 32,
    SDL_GetVideoSurface^.format^.RMask, SDL_GetVideoSurface^.format^.GMask,
    SDL_GetVideoSurface^.format^.BMask, amask);  
  Ctrl_Resize;
  //SendSizeCallback(Width, NewHeight);
  end;  
  
procedure TGUI_Container.Paint; 
//still needs to paint container surface onto normal surface
var next: PGUI_Element_LL;
    dest, src: TSDL_Rect;
begin   
  render;
  if (surface <> nil) and visible then
  begin
    if ContainerSurface <> nil then
    begin  
      //Draw Children as normal but on the Container Surface
      //except draw Scrollbars seperately (which are still listed in children)
      next := children^.next;
      while next <> nil do
      begin        
        if (next^.data <> PGUI_Element(HScrollbar)) and
          (next^.data <> PGUI_Element(VScrollbar)) then
        begin
          next^.data^.Paint;        
          dest.x := Next^.Data^.GetLeft;
          dest.y := Next^.Data^.GetTop;           
          SDL_BlitSurface(next^.data^.getsurface, nil, ContainerSurface, @dest);                
          end;
        next := next^.next;
        end;
      //Draw Container
      dest.x := 1;
      dest.w := Width-2;
      dest.h := Height-2;
      dest.y := 1;
      src.x := ContainerLeft;
      src.y := ContainerTop;
      src.w := ContainerWidth-ContainerLeft;
      src.h := ContainerHeight-ContainerTop;
      SDL_BlitSurface(ContainerSurface, @src, Surface, @dest);
      
      //Draw Scrollbars
      if HScrollBar <> nil then
      begin
        HScrollBar^.Paint;        
        dest.x := HScrollBar^.GetLeft;
        dest.y := HScrollBar^.GetTop;      
        dest.w := HScrollBar^.GetWidth;
        dest.h := HScrollBar^.GetHeight;
        SDL_BlitSurface(HScrollBar^.getsurface, nil, Surface, @dest);                
        end;
      if VScrollBar <> nil then
      begin
        VScrollBar^.Paint;        
        dest.x := VScrollBar^.GetLeft;
        dest.y :=VScrollBar^.GetTop;
        dest.w := VScrollBar^.GetWidth;
        dest.h := VScrollBar^.GetHeight;
        SDL_BlitSurface(VScrollBar^.getsurface, nil, Surface, @dest);                
        end;
      end;
    end;
  end;  

procedure TGUI_Container.CTRL_Resize;
begin
  UpdateScrollbars;
  end;

procedure TGUI_Container.UpdateScrollbars;
begin
  //Align Scrollbars as needed
  if (ContainerWidth > Width) or (ContainerHeight > Height) then
  begin
    VScrollBar^.SetLeft(Width-13);
    VScrollBar^.SetHeight(Height-13);
    VScrollBar^.SetWidth(10);
    VScrollBar^.SetVisible(True);
    VScrollBar^.SetTop(2);
    VScrollBar^.SetMin(0);
    if ContainerWidth > Width then
      VScrollBar^.SetMax(ContainerWidth-Width)
    else
      VScrollBar^.SetMax(0);
      
    HScrollBar^.SetWidth(Width-13);
    HScrollBar^.SetTop(Height-13);
    HScrollBar^.SetHeight(10);
    HScrollBar^.SetVisible(True);
    HScrollBar^.SetLeft(2);      
    If ContainerHeight > Height then
      VScrollBar^.SetMax(ContainerHeight-Height)
    else
      VScrollBar^.SetMax(0);
    end
  else
  begin
    HScrollBar^.SetVisible(False);
    VScrollBar^.SetVisible(False);
    end;  
  end;

procedure TGUI_Container.Scrollbar_ValChanged(NewVal: Word; Dir: TDir);
begin
  case dir of
    Dir_Vertical:
    begin
      ContainerLeft := NewVal;
      end;
    
    Dir_Horizontal:
    begin
      ContainerTop := NewVal;
      end;
    end;
  end;

  
procedure TGUI_Container.ctrl_MouseDown(X, Y: Word; Button: UInt8);
var
  prev: PGUI_Element_LL;
  passed: boolean;  
begin
  //writeln(dbgname, ' recieved MouseDown event ', x, ',', y, ',', Button);
  prev := Children^.last;
  passed := false;
  //Pass the event to children if required
  while (prev <> nil) and (passed = false) do
  begin
    if prev^.data <> nil then with prev^.data^ do 
    begin
      //If the mouse motion is within the control
      if InControl(X+ContainerLeft,Y+ContainerTop) and Visible then
      begin
        passed := true;              
        //Pass translated mouse movement to control
        ctrl_MouseDown(X - getleft-containerleft,
          Y - gettop-containertop, Button);   
        SetSelected(true);     
        end;
      end;
    prev := prev^.prev;        
    end;
  if (not passed) or RecieveAllEvents then
  begin
    UnselectChildren;
    ButtonStates[Button] := True;
    MouseDown(X, Y, Button);
    end;  
  end;
  
procedure TGUI_Container.ctrl_MouseUp(X, Y: Word; Button: UInt8);
var
  prev: PGUI_Element_LL;
  passed: boolean;
begin   
  //writeln(dbgname, ' recieved MouseUp event ', x, ',', y, ',', Button);
  prev := Children^.last;
  passed := false;
  //Pass the event to children if required
  while (prev <> nil) and (passed = false) do
  begin
    if prev^.data <> nil then with prev^.data^ do 
    begin
      //If the mouse motion is within the control
      if InControl(X,Y) and Visible then
      begin
        passed := true;              
        //Pass translated mouse movement to control
        ctrl_MouseUp(X - getleft, Y - gettop, Button);        
        end;
      end;
    prev := prev^.prev;        
    end;
  //If it hasn't been passed, or the element will recieve it regardless,
  //do what the control does    
  if (not passed) or RecieveAllEvents then
    If ButtonStates[Button] then 
    begin
      MouseUp(X, Y, Button);  
      ctrl_MouseClick(X,Y,Button);
      ButtonStates[Button] := False;
      end
    else
      MouseUp(X, Y, Button);  
  end;

procedure TGUI_Container.ctrl_MouseClick(X, Y: Word; Button: UInt8); 
begin
  MouseClick(X, Y, Button);
  end;

procedure TGUI_Container.ctrl_MouseMotion(X, Y: Word; ButtonState: UInt8); 
var
  prev, next: PGUI_Element_LL;
  passed: boolean;
begin   
  //Check if MouseMotion needs to go to any children
  //writeln(dbgname, ' recieved MouseMotion event ', x, ',', y, ',', ButtonState);
  prev := Children^.last;
  passed := false;
  while (prev <> nil) and (passed = false) do
  begin
    if prev^.data <> nil then with prev^.data^ do 
    begin
      //If the mouse motion is within the control
      if InControl(X+ContainerLeft,Y+ContainerTop) and Visible then
      begin
        passed := true;
        //Pass a mouse entered event if appropriate
        if not GetMouseEntered then
          ctrl_MouseEnter;                 
        //Pass translated mouse movement to control
        ctrl_MouseMotion(X - getleft - ContainerLeft,
          Y - gettop - ContainerTop, ButtonState);        
        end
      else
      begin
        //If the mouse is outside the control and it still thinks its within the
        //control, issue the MouseExit event
        if GetMouseEntered then
          ctrl_MouseExit;
        //Issue mouse exits to children too
        next := Self.Children^.next;
        while next<>nil do
        begin
          if next^.data^.getmouseentered then
            next^.data^.ctrl_MouseExit;
          next := next^.next;
          end;
        end;    
      end;
    prev := prev^.prev;        
    end;
  if not passed then MouseMotion(X, Y, ButtonState);  
  end;
 
  
