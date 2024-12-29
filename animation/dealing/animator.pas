unit animator;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fgl, coord, raylib;

type
  TAnimateType = (ANIM_LINEAR, ANIM_EASEIN, ANIM_EASEOUT, ANIM_EASEINOUT, ANIM_FLIP, ANIM_SPIKE);

  { TAnimation }

  TAnimation = class
  private
    m_type: TAnimateType;
    m_texture: TTexture2D;
    m_start: TCoordF;
    m_finish: TCoordF;
    m_where: TCoordF;
    m_when: double;
    m_duration: double;
    m_running: boolean;
    m_finished: boolean;
    m_time: double;
  public
    constructor Create(anim: TAnimateType; astart, afinish: TCoordF;
      awhen, aduration: double; atexture: TTexture2D);
    procedure Update(delta: double);
    procedure Draw;
  end;

  TAnimationList = specialize TFPGList<TAnimation>;

  { TAnimator }

  TAnimator = class
  private
    m_list: TAnimationList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(anim: TAnimateType; astart, afinish: TCoordF;
      awhen, aduration: double; atexture: TTexture2D);
    procedure Update(delta: double);
    procedure Draw;
  end;

  function Lerp(start, finish, where: double): double;
  function EaseIn(t: double): double;
  function EaseOut(t: double): double;
  function EaseInOut(t: double): double;
  function Spike(t: double): double;
  function Flip(t: double): double;

implementation

function Lerp(start, finish, where: double): double;
begin
  result := (finish - start) * where + start;
end;

function EaseIn(t: double): double;
begin
  result := sqr(t);
end;

function EaseOut(t: double): double;
begin
  result := Flip(sqr(Flip(t)))
end;

function EaseInOut(t: double): double;
begin
  result := Lerp(EaseIn(t), EaseOut(t), t);
end;

function Spike(t: double): double;
begin
  if t < 0.5 then
  begin
    result := EaseIn(t / 0.5);
    exit;
  end;

  result := EaseIn(Flip(t) / 0.5);
end;

function Flip(t: double): double;
begin
  result := 1.0 - t;
end;

{ TAnimation }

constructor TAnimation.Create(anim: TAnimateType; astart, afinish: TCoordF;
  awhen, aduration: double; atexture: TTexture2D);
begin
  m_type := anim;
  m_start := aStart;
  m_finish := aFinish;
  m_where := aStart;
  m_texture := atexture;
  m_when := awhen;
  m_duration := aduration;
  m_running := false;
  m_finished := false;
  m_time := 0.0;
end;

procedure TAnimation.Update(delta: double);
var
  factor: double;

begin
  if m_when <= 0.0 then
    m_running := true
  else
    m_when := m_when - delta;

  if m_running and not m_finished then
  begin
    if m_time < m_duration then
      m_time := m_time + delta
    else
    begin
      m_running := false;
      m_finished := true;
    end;

    case m_type of
      ANIM_LINEAR: factor := m_time / m_duration;
      ANIM_EASEIN: factor := EaseIn(m_time / m_duration);
      ANIM_EASEOUT: factor := EaseOut(m_time / m_duration);
      ANIM_EASEINOUT: factor := EaseInOut(m_time / m_duration);
      ANIM_FLIP: factor := Flip(m_time / m_duration);
      ANIM_SPIKE: factor := Spike(m_time / m_duration);
    end;

    m_where.x := lerp(m_start.x, m_finish.x, factor);
    m_where.y := lerp(m_start.y, m_finish.y, factor);
  end;
end;

procedure TAnimation.Draw;
begin
  DrawTexture(m_texture, round(m_where.x), round(m_where.y), WHITE);
end;

{ TAnimator }

constructor TAnimator.Create;
begin
  m_list := TAnimationList.Create;
end;

destructor TAnimator.Destroy;
var
  anim: TAnimation;

begin
  for anim in m_list do
    anim.Free;

  m_list.Free;
  inherited Destroy;
end;

procedure TAnimator.Add(anim: TAnimateType; astart, afinish: TCoordF; awhen,
  aduration: double; atexture: TTexture2D);
var
  animate: TAnimation;

begin
  animate := TAnimation.Create(anim, astart, afinish, awhen, aduration, atexture);
  m_list.Add(animate);
end;

procedure TAnimator.Update(delta: double);
var
  anim: TAnimation;

begin
  for anim in m_list do
    anim.Update(delta);
end;

procedure TAnimator.Draw;
var
  anim: TAnimation;

begin
  for anim in m_list do
    anim.Draw;
end;

end.

