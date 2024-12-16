program gameloading;

//note: copy the raylib.dll file from the 'ray4laz/libs/x86_64-windows' folder to your project folder.
{$mode objfpc}{$H+}

uses 
  cmem,
  {uncomment if necessary}
  //raymath,
  //rlgl,
  raygui,
  raylib, loading;

const
  screenWidth = 800;
  screenHeight = 450;

var
  value: single;
  load: TLoading;

begin
  value := 0.0;

  load := TLoading.Create;

  // Initialization
  InitWindow(screenWidth, screenHeight, 'raylib - simple project');
  SetTargetFPS(60);// Set our game to run at 60 frames-per-second

  load.Start;

  // Main game loop
  while not WindowShouldClose() do
    begin
      // Update
      // TODO: Update your variables here
      value := load.Progress;

      // Draw
      BeginDrawing();
        ClearBackground(RAYWHITE);
        DrawText('Poker: loading cards...', 190, 200, 20, LIGHTGRAY);
        GuiProgressBar(RectangleCreate(100, 300, 400, 20), nil, nil, @value, 0.0, 1.0);
      EndDrawing();
    end;

  // De-Initialization
  CloseWindow();        // Close window and OpenGL context

  load.Free;
end.

