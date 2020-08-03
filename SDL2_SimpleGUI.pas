unit SDL2_SimpleGUI;
{:< The Library Unit}

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
  SDL2,
  SG_GuiLib_Master,
  SG_GuiLib_Form,
  SG_GuiLib_StdWgts;

type
  TGUI_Master = SG_GuiLib_Master.TGUI_Master;
  TGUI_Form = SG_GuiLib_Form.TGUI_Form;
  TGUI_Button = SG_GuiLib_StdWgts.TGUI_Button;
  TGUI_CheckBox = SG_GuiLib_StdWgts.TGUI_CheckBox;
  TGUI_Label = SG_GuiLib_StdWgts.TGUI_Label;
  TGUI_ScrollBar = SG_GuiLib_StdWgts.TGUI_ScrollBar;
  TGUI_TextBox = SG_GuiLib_StdWgts.TGUI_TextBox;
  TGUI_Image = SG_GuiLib_StdWgts.TGUI_Image;
  TGUI_Listbox = SG_GuiLib_StdWgts.TGUI_Listbox;

implementation

begin

end.
