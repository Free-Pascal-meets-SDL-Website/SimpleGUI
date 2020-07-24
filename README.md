# SimpleGUI
SimpleGUI is a native, SDL2 powered, object oriented Object Pascal graphical
user interface library.

It is based upon Lachlan Kingford's GUI (LK GUI) written for SDL 1.2.
(https://sourceforge.net/projects/lkgui)

# Changelog
## Releases
### v0.5.0
#### 2020-07-24
* library uses Classes now (instead of out-dated Object types)
* the whole rendering model changed now
  * every GUI element is rendered in corresponding Render method
  * before: every GUI element and its children have been drawn to a surface or
  texture (based in the out-dated blitting concept used by SDL 1.2)
  * change text system to use strings as long as possible and just then use
  PChars (less error prone)
  * a lot of code clean up
  * changed comment section to be more compact
  * merged all the md files for the git acc.
  * unit SDL_Tools got obsolete, while some functions are adapted as methods
### v0.1.0
#### 2016-06-19
* initial release
* translation of most units of LK GUI to SDL2
  * introducing renderer and window
  * use of textures instead of surfaces
  * use of new event SDL_TextInput for text input
* Condex.pas removed (unused)
* translation of example to SDL2
* re-build PasDoc documentation

## To-Do
* convert SG_GuiLib_Console.pas to SDL2 (low priority)
* finish Container feature (higher priority)
* finish image widget (ImageSfc)
* improve TextInput
* update docs

# License
## The MIT License (MIT)

Copyright (c) 2016-2020 Matthias J. Molski

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
