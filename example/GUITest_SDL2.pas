program GUITest_SDL2;
{ Test 1 program for the Simple GUI Library. }

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

uses
  SDL2,
  SDL2_TTF,
  SDL2_Image,
  SG_GuiLib_Base,
  SG_GuiLib_Canvas,
  SG_GuiLib_Form,
  SG_GuiLib_StdWgts,
  SG_GuiLib_Master,
  SysUtils;

var
  Renderer: PSDL_Renderer;
  Window: PSDL_Window;
  Logo: PSDL_Surface;
  Font: PTTF_Font;

  BorderColor: TRGBA;

  Form1, Form2, Form3, Form4: TGUI_Form;
  Button1, Button2: TGUI_Button;
  Chkbox1: TGUI_CheckBox;
  Chkbox2, Chkbox3: TGUI_CheckBox;
  Label1: TGUI_Label;
  Textbox1: TGUI_Textbox;
  Image1: TGUI_Image;
  Listbox: TGUI_Listbox;

  Master: TGUI_Master;

  Event: TSDL_Event;
  StillGoing: Boolean;

const
  ResourcesDir = 'resources\';

begin
  SetHeapTraceOutput('trace.log'); // For debug, ignore or delete line!
  // Initialise SDL
  SDL_Init(SDL_INIT_EVERYTHING);
  Window := SDL_CreateWindow('Window', 10, 10, 1024, 768, SDL_WINDOW_SHOWN);
  Renderer := SDL_CreateRenderer(Window, -1, SDL_RENDERER_ACCELERATED);

  // Initialise TTF and load Logo
  TTF_Init;
  Font := TTF_OpenFont(ResourcesDir + 'DejaVuSansMono.ttf', 15);
  Logo := SDL_LoadBMP(PChar(ResourcesDir + 'SGLogo.bmp'));

  // Create master GUI element
  Master := TGUI_Master.Create;
  Master.SetWindow(Window);
  Master.SetRenderer(Renderer);
  Master.SetDbgName('Master');

  // Add children GUI elements
  Form1 := TGUI_Form.Create;
  Form1.SetFont(Font);
  Form1.SetCaption('Form1');
  Form1.SetDbgName('Form 1');
  Form1.SetWidth(250);
  // Form1.SetFillStyle(FS_None); { TODO : Treat FillStyle correctly. }
  Master.AddChild(Form1);

  Form2 := TGUI_Form.Create;
  Form2.SetFont(Font);
  Form2.SetCaption('Form2');
  Form2.SetDbgName('Form 2');
  Form2.SetWidth(400);
  Form2.SetHeight(200);
  Form2.SetTop(400);
  Form2.SetLeft(500);
  Master.AddChild(Form2);

  Form3 := TGUI_Form.Create;
  Form3.SetFont(Font);
  Form3.SetCaption('Form3');
  Form3.SetDbgName('Form 3');
  Form3.SetWidth(400);
  Form3.SetHeight(325);
  Form3.SetTop(400);
  Master.AddChild(Form3);

  Form4 := TGUI_Form.Create;
  Form4.SetFont(Font);
  Form4.SetCaption('Form4');
  Form4.SetDbgName('Form 4');
  Form4.SetWidth(300);
  Form4.SetHeight(300);
  Form4.SetTop(0);
  Form4.SetLeft(600);
  Master.AddChild(Form4);

  ListBox := TGUI_ListBox.Create;
  with Listbox do
  begin
    SetLeft(10);
    SetTop(30);
    SetWidth(200);
    SetHeight(200);
    SetDbgName('Listbox');
    SetFont(Font);
    with GetItems do
    begin
      additem('Item 1', 1);
      additem('Item 2', 2);
      additem('Item 3', 3);
      additem('Item 4', 4);
      additem('Item 5', 5);
      additem('Item 6', 6);
      additem('Item 7', 7);
      additem('Item 8', 8);
      additem('Item 9', 9);
      additem('Item 10', 10);
      additem('Item 11', 11);
      additem('Item 12', 12);
    end;
  end;
  form4.AddChild(Listbox);

  Chkbox1 := TGUI_CheckBox.Create;
  with ChkBox1 do
  begin
    SetCaption('Check 1');
    SetDbgName('Check 1');
    SetHeight(30);
    SetWidth(150);
    SetLeft(10);
    SetTop(40);
    SetFont(Font);
  end;
  Form2.AddChild(ChkBox1);

  Chkbox2 := TGUI_CheckBox.Create;
  with ChkBox2 do
  begin
    SetCaption('Exclusive 1');
    SetDbgName('Check 2');
    SetHeight(30);
    SetWidth(150);
    SetLeft(10);
    SetTop(80);
    SetFont(Font);
    SetExcGroup(1);
  end;
  Form2.AddChild(ChkBox2);

  Chkbox3 := TGUI_CheckBox.Create;
  with ChkBox3 do
  begin
    SetCaption('Exclusive 2');
    SetDbgName('Check 3');
    SetHeight(30);
    SetWidth(150);
    SetLeft(160);
    SetTop(80);
    SetFont(Font);
    SetExcGroup(1);
  end;
  Form2.AddChild(ChkBox3);

  Button1 := TGUI_Button.Create;
  with Button1 do
  begin
    SetFont(Font);
    SetWidth(100);
    SetHeight(20);
    SetLeft(10);
    SetTop(100);
    SetCaption('Button 1');
    SetDbgName('Button 1');
  end;
  Form1.AddChild(Button1);

  Button2 := TGUI_Button.Create;
  with Button2 do
  begin
    SetFont(Font);
    SetWidth(100);
    SetHeight(20);
    SetLeft(140);
    SetTop(100);
    SetCaption('Button 2');
    SetDbgName('Button 2');
  end;

  Label1 := TGUI_Label.Create;
  with Label1 do
  begin
    SetFont(Font);
    SetWidth(200);
    SetHeight(30);
    SetLeft(10);
    SetTop(40);
    SetCaption('Press ESC to quit.');
    SetDbgName('Label 1');
  end;
  Form1.AddChild(Label1);


  TextBox1 := TGUI_TextBox.Create;
  with TextBox1 do
  begin
    SetFont(Font);
    SetWidth(230);
    SetHeight(25);
    SetLeft(10);
    SetTop(150);
    SetCaption('Textbox 1');
    SetDbgName('Textbox 1');
  end;
  Form1.AddChild(TextBox1);

  Image1 := TGUI_Image.Create;
  with Image1 do
  begin
    SetWidth(400-2);
    SetHeight(300-2);
    SetLeft(1);
    SetTop(25);
    SetSource(Logo);
    SetDbgName('Image1');
  end;
  Form3.AddChild(Image1);

  Form1.AddChild(Button2);
  stillgoing := True;
  while StillGoing = True do
  begin
    while SDL_PollEvent(@Event) > 0 do
    begin
      case Event.Type_ of
        SDL_QUITEV:
        begin
          stillgoing := False;
        end;
        SDL_KEYDOWN, SDL_KEYUP, SDL_MOUSEMOTION, SDL_MOUSEBUTTONDOWN,
        SDL_MOUSEBUTTONUP, SDL_TEXTINPUT:
        begin
          if Event.key.keysym.sym = SDLK_ESCAPE then
            StillGoing := False;
          Master.InjectSDLEvent(@Event);
        end;
      end;
    end;

    Master.Paint;

    SDL_RenderPresent(Renderer);
  end;

  FreeAndNil(Master);
  SDL_FreeSurface(Logo);
  SDL_DestroyRenderer(Renderer);
  SDL_DestroyWindow(Window);
  TTF_CloseFont(Font);
  SDL_Quit;
end.
