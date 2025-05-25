// MIT License
//
// Copyright (c) 2024 Pete Goodwin
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

program pokertest;

{$mode objfpc}{$H+}

uses 
  cmem,
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {uncomment if necessary}
  //raymath,
  //rlgl,
  raylib, gamemain, carditem, deckitem, handitem, rulesitem, scoreitem,
  elementitem, overrideitem, abilityitem, utilities, bonuscarditem;

const
  screenWidth = 1024;
  screenHeight = 768;

var
  game: TGame;

{$R *.res}

begin
  // Initialization
  Randomize;

  InitWindow(screenWidth, screenHeight, 'Poker Test');
  SetTargetFPS(60);// Set our game to run at 60 frames-per-second

  game := TGame.Create;

  // Main game loop
  while not WindowShouldClose do
  begin
    // Update
    game.Update(GetFrameTime);

    // Draw
    BeginDrawing();
    game.Draw;
    EndDrawing();
  end;

  // De-Initialization
  game.Free;
  CloseWindow();        // Close window and OpenGL context
end.

