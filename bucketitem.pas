unit bucketitem;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, carditem;

type
  TCardBucket = record
    Count: integer;
    Index: TCardIndex;
  end;

  TCardBucketResult = record
    Buckets: array [1..4] of TCardBucket;
    Passed: boolean;
  end;

  function ProcessCards(list: TCardList): TCardBucketResult;

implementation

function ProcessCards(list: TCardList): TCardBucketResult;
var
  card: TCard;
  cardBuckets: TCardBucketResult;

begin
  cardBuckets.buckets[1].Count := 0;
  cardBuckets.buckets[1].Index := 0;

  cardBuckets.buckets[2].Count := 0;
  cardBuckets.buckets[2].Index := 0;

  cardBuckets.buckets[3].Count := 0;
  cardBuckets.buckets[3].Index := 0;

  cardBuckets.buckets[4].Count := 0;
  cardBuckets.buckets[4].Index := 0;

  for card in list do
  begin
    if (cardBuckets.buckets[1].Count = 0) and
       (cardBuckets.buckets[2].Count = 0) then
    begin
      cardBuckets.buckets[1].Count := 1;
      cardBuckets.buckets[1].Index := card.CardIndex;
      continue;
    end;

    if (cardBuckets.buckets[1].Index = card.CardIndex) and
       (cardBuckets.buckets[1].Count > 0) then
    begin
      inc(cardBuckets.buckets[1].Count);
      continue;
    end;

    if (cardBuckets.buckets[2].Count = 0) then
    begin
      cardBuckets.buckets[2].Count := 1;
      cardBuckets.buckets[2].Index := card.CardIndex;
      continue;
    end;

    if (cardBuckets.buckets[2].Index = card.CardIndex) and
       (cardBuckets.buckets[2].Count > 0) then
    begin
      inc(cardBuckets.buckets[2].Count);
      continue;
    end;

    if (cardBuckets.buckets[3].Count = 0) then
    begin
      cardBuckets.Buckets[3].Count := 1;
      cardBuckets.Buckets[3].Index := card.CardIndex;
      continue;
    end;

    if (cardBuckets.buckets[3].Index = card.CardIndex) then
    begin
      inc(cardBuckets.Buckets[3].Count);
      continue;
    end;

    if (cardBuckets.buckets[4].Count = 0) then
    begin
      cardBuckets.Buckets[4].Count := 1;
      cardBuckets.Buckets[4].Index := card.CardIndex;
      continue;
    end;

    if (cardBuckets.buckets[4].Index = card.CardIndex) then
    begin
      inc(cardBuckets.Buckets[4].Count);
      continue;
    end;

    cardBuckets.Passed := false;
    exit;
  end;

  cardBuckets.Passed := true;
  result := cardBuckets;
end;

end.

