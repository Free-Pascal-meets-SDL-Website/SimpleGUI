unit SG_GuiLib_Base;
{:< Provides the common procedures and data that most units need }

{

  Simple GUI is based upon Lachlans GUI (LK GUI). LK GUI's original source code
  remark is shown below.

  Written permission to re-license the library has been granted to me by the
  original author.

}

{*******************************************************}
{                                                       }
{       Lachlans GUI Library                            }
{       Base Types etc for all units in GuiLib          }
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

uses
  SDL2;


type
  (* Necessary to pass typed array as func./proc. parameter. It contains the
     input information as returned by SDL event SDL_TextInput.       *)
  TSDLTextInputArray = array[0..SDL_TEXTINPUTEVENT_TEXT_SIZE] of char;

type
  tRGBA = record
    r: byte;
    g: byte;
    b: byte;
    a: byte;
  end;

  tTextAlign = (Align_Left, Align_Center, Align_Right);
  tVertAlign = (VAlign_Top, VAlign_Center, VAlign_Bottom);
  tDir = (Dir_Horizontal, Dir_Vertical);

  tBorderStyle = (BS_None, BS_Single);

  tFillStyle = (FS_None, FS_Filled);

//Default Colors and Consts
const
  GUI_DefaultBackColor: tRGBA = (R: 48; G: 48; B: 48; A: 255);
  GUI_DefaultTextBackColor: tRGBA = (R: 24; G: 24; B: 24; A: 255);
  GUI_DefaultForeColor: tRGBA = (R: 190; G: 190; B: 190; A: 255);
  GUI_DefaultBorderColor: tRGBA = (R: 64; G: 64; B: 64; A: 255);
  GUI_DefaultFormBack: tRGBA = (R: 32; G: 32; B: 32; A: 255);
  GUI_DefaultTitleBarBack: tRGBA = (R: 24; G: 24; B: 64; A: 255);
  GUI_DefaultUnselectedTitleBarBack: tRGBA = (R: 24; G: 24; B: 24; A: 255);
  GUI_SelectedColor: tRGBA = (R: 24; G: 24; B: 64; A: 255);
  GUI_DefaultActiveColor: tRGBA = (R: 24; G: 24; B: 64; A: 255);
  GUI_TitleBarHeight = 25;
  GUI_FullTrans: tRGBA = (R: 0; G: 0; B: 0; A: 0);
  GUI_ScrollbarSize = 11;
  GUI_DebugColor: tRGBA = (R: 0; G: 255; B: 0; A: 255);
  //Conv. SDL2: only for debug purposes

  {$ifdef ENDIAN_LITTLE}
  amask = $ff000000;
  {$else}
  amask = $000000ff;
  {$endif}


implementation

begin

end.
