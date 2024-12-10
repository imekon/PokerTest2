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
  cardBuckets.buckets[1].Cards := TCardList.Create;
  cardBuckets.buckets[1].Index := 0;

  cardBuckets.buckets[2].Cards := TCardList.Create;
  cardBuckets.buckets[2].Index := 0;

  cardBuckets.buckets[3].Cards := TCardList.Create;
  cardBuckets.buckets[3].Index := 0;

  cardBuckets.buckets[4].Cards := TCardList.Create;
  cardBuckets.buckets[4].Index := 0;

  for card in list do
  begin
    if (cardBuckets.buckets[1].Cards.Count = 0) and
       (cardBuckets.buckets[2].Cards.Count = 0) then
    begin
      cardBuckets.buckets[1].Cards.Add(card);
      cardBuckets.buckets[1].Index := card.CardIndex;
      continue;
    end;

    if (cardBuckets.buckets[1].Index = card.CardIndex) and
       (cardBuckets.buckets[1].Cards.Count > 0) then
    begin
      cardBuckets.buckets[1].Cards.Add(card);
      continue;
    end;

    if (cardBuckets.buckets[2].Cards.Count = 0) then
    begin
      cardBuckets.buckets[2].Cards.Add(card);
      cardBuckets.buckets[2].Index := card.CardIndex;
      continue;
    end;

    if (cardBuckets.buckets[2].Index = card.CardIndex) and
       (cardBuckets.buckets[2].Cards.Count > 0) then
    begin
      cardBuckets.buckets[2].Cards.Add(card);
      continue;
    end;

    if (cardBuckets.buckets[3].Cards.Count = 0) then
    begin
      cardBuckets.Buckets[3].Cards.Add(card);
      cardBuckets.Buckets[3].Index := card.CardIndex;
      continue;
    end;

    if (cardBuckets.buckets[3].Index = card.CardIndex) then
    begin
      cardBuckets.Buckets[3].Cards.Add(card);
      continue;
    end;

    if (cardBuckets.buckets[4].Cards.Count = 0) then
    begin
      cardBuckets.Buckets[4].Cards.Add(card);
      cardBuckets.Buckets[4].Index := card.CardIndex;
      continue;
    end;

    if (cardBuckets.buckets[4].Index = card.CardIndex) then
    begin
      cardBuckets.Buckets[4].Cards.Add(card);
      continue;
    end;

    cardBuckets.Passed := false;
    exit;
  end;

  cardBuckets.Passed := true;
  result := cardBuckets;
end;

end.

