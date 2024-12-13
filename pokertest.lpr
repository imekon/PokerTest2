program pokertest;

{$mode objfpc}{$H+}

uses 
  cmem,
  {uncomment if necessary}
  //raymath,
  //rlgl,
  raylib, gamemain, carditem, deckitem, handitem, rulesitem, scoreitem,
  elementitem;

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
        ClearBackground(DARKGREEN);
        game.Draw;
      EndDrawing();
    end;

  // De-Initialization
  game.Free;
  CloseWindow();        // Close window and OpenGL context
end.

