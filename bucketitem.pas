unit bucketitem;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, carditem;

type
  TCardBucket = record
    Cards: TCardList;
    Index: TCardIndex;
  end;

  { TCardBucketResult }

  TCardBucketResult = class
  public
    Buckets: array [1..4] of TCardBucket;
    Passed: boolean;

    constructor Create;
    destructor Destroy; override;
    procedure ProcessCards(list: TCardList);
  end;

implementation

procedure TCardBucketResult.ProcessCards(list: TCardList);
var
  card: TCard;

begin
  buckets[1].Cards := TCardList.Create;
  buckets[1].Index := 0;

  buckets[2].Cards := TCardList.Create;
  buckets[2].Index := 0;

  buckets[3].Cards := TCardList.Create;
  buckets[3].Index := 0;

  buckets[4].Cards := TCardList.Create;
  buckets[4].Index := 0;

  for card in list do
  begin
    if (buckets[1].Cards.Count = 0) and
       (buckets[2].Cards.Count = 0) then
    begin
      buckets[1].Cards.Add(card);
      buckets[1].Index := card.CardIndex;
      continue;
    end;

    if (buckets[1].Index = card.CardIndex) and
       (buckets[1].Cards.Count > 0) then
    begin
      buckets[1].Cards.Add(card);
      continue;
    end;

    if (buckets[2].Cards.Count = 0) then
    begin
      buckets[2].Cards.Add(card);
      buckets[2].Index := card.CardIndex;
      continue;
    end;

    if (buckets[2].Index = card.CardIndex) and
       (buckets[2].Cards.Count > 0) then
    begin
      buckets[2].Cards.Add(card);
      continue;
    end;

    if (buckets[3].Cards.Count = 0) then
    begin
      Buckets[3].Cards.Add(card);
      Buckets[3].Index := card.CardIndex;
      continue;
    end;

    if (buckets[3].Index = card.CardIndex) then
    begin
      Buckets[3].Cards.Add(card);
      continue;
    end;

    if (buckets[4].Cards.Count = 0) then
    begin
      Buckets[4].Cards.Add(card);
      Buckets[4].Index := card.CardIndex;
      continue;
    end;

    if (buckets[4].Index = card.CardIndex) then
    begin
      Buckets[4].Cards.Add(card);
      continue;
    end;

    Passed := false;
    exit;
  end;

  Passed := true;
end;

{ TCardBucketResult }

constructor TCardBucketResult.Create;
begin
  buckets[1].Cards := TCardList.Create;
  buckets[1].Index := 0;

  buckets[2].Cards := TCardList.Create;
  buckets[2].Index := 0;

  buckets[3].Cards := TCardList.Create;
  buckets[3].Index := 0;

  buckets[4].Cards := TCardList.Create;
  buckets[4].Index := 0;
end;

destructor TCardBucketResult.Destroy;
var
  i: integer;

begin
  for i := 1 to 4 do
    buckets[i].Cards.Free;

  inherited Destroy;
end;

end.

