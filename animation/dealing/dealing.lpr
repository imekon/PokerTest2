program dealing;

//note: copy the raylib.dll file from the 'ray4laz/libs/x86_64-windows' folder to your project folder.
{$mode objfpc}{$H+}

uses 
  cmem,
  {uncomment if necessary}
  //raymath,
  //rlgl,
  raylib,
  animator, coord;

const
  screenWidth = 800;
  screenHeight = 450;

var
  i: integer;
  delta: double;
  background: TTexture2D;
  anim: TAnimator;

begin
  // Initialization
  InitWindow(screenWidth, screenHeight, 'raylib - dealing cards animation');
  SetTargetFPS(60);// Set our game to run at 60 frames-per-second

  background := LoadTexture('blue_green.png');

  anim := TAnimator.Create;
  for i := 0 to 51 do
    anim.Add(ANIM_EASEOUT, CreateCoord(100, 100), CreateCoord(600 - i * 1.1, 100), 0.2 * i, 0.7, background);

  // Main game loop
  while not WindowShouldClose do
    begin
      // Update
      delta := GetFrameTime;
      anim.Update(delta);

      // Draw
      BeginDrawing;
        ClearBackground(RAYWHITE);
        DrawTexture(background, 100, 100, WHITE);
        anim.Draw;
      EndDrawing;
    end;

  // De-Initialization
  anim.Free;

  UnloadTexture(background);

  CloseWindow;        // Close window and OpenGL context
end.

