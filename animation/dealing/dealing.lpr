program dealing;

//note: copy the raylib.dll file from the 'ray4laz/libs/x86_64-windows' folder to your project folder.
{$mode objfpc}{$H+}

uses 
  cmem,
  {uncomment if necessary}
  //raymath,
  //rlgl,
  raylib,
  animator, coord, cardanim;

const
  screenWidth = 800;
  screenHeight = 450;

var
  delta: double;
  background: TTexture2D;
  animate: TAnimator;
  cardAnimate: TCardAnimate;
  anim: TAnimate;

begin
  // Initialization
  InitWindow(screenWidth, screenHeight, 'raylib - dealing cards animation');
  SetTargetFPS(60);// Set our game to run at 60 frames-per-second

  background := LoadTexture('blue_green.png');

  animate := TAnimator.Create;
  cardAnimate := TCardAnimate.Create(background);
  anim := animate.AddAnimationCoord(ANIM_EASEINOUT, cardAnimate,
    CreateCoord(100, 100), CreateCoord(500, 100), 1.0);

  anim.Start;

  // Main game loop
  while not WindowShouldClose do
    begin
      // Update
      delta := GetFrameTime;
      animate.Update(delta);

      // Draw
      BeginDrawing;
        ClearBackground(RAYWHITE);
        DrawTexture(background, 100, 100, WHITE);
        animate.Draw;
      EndDrawing;
    end;

  // De-Initialization
  animate.Free;

  UnloadTexture(background);

  CloseWindow;        // Close window and OpenGL context
end.

