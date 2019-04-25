unit Model.Board;

interface

type
  TBoard = class // (TObject / TComponent)
  private
    FCount: integer;
    FMaxValue: UInt8;
  public
    { TODO Property? }
    FData: TArray<integer>;
    procedure GenerateData(AItems: integer);
    procedure Swap(AIdx1, AIdx2: integer);
    property Count: integer read FCount write FCount;
    property MaxValue: UInt8 read FMaxValue write FMaxValue;
  end;

implementation

uses Action.StartQuick, View.Board;

procedure TBoard.GenerateData(AItems: integer);
var
  idx: integer;
begin
  randomize;
  SetLength(FData, AItems);
  for idx := 0 to Length(FData) - 1 do
    FData[idx] := Random(MaxValue) + 1;
end;

procedure TBoard.Swap(AIdx1, AIdx2: integer);
var
  v: integer;
begin
  v := FData[AIdx1];
  FData[AIdx1] := FData[AIdx2];
  FData[AIdx2] := v;
end;

end.
