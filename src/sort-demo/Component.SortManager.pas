{ * ------------------------------------------------------------------------
  * ♥ ♥ ♥  Akademia BSC © 2019
  * Informacja:
  *   Kod źródłowy stworzony na potrzeby ćwiczeniowe
  * Autor:
  *   Bogdan Polak
  *  ----------------------------------------------------------------------- * }
unit Component.SortManager;

interface

uses
  System.Classes,
  Vcl.ExtCtrls,
  View.Board,
  Model.Board,
  Thread.Sort;

type
  TSortAlgorithm = (saBubbleSort, saQuickSort, saInsertionSort);

  TThreadSortClass = class of TSortThread;

  TSortManager = class(TComponent)
  private
    initialized: boolean;
    FSortAlgorithm: TSortAlgorithm;
    FView: TBoardView;
    FBoard: TBoard;
    FThread: TSortThread;
    FSwapTime: double;
  protected
    procedure Init(APaintBox: TPaintBox; ASortAlgorithm: TSortAlgorithm); virtual;
    function GetAlgorithmName: string; virtual;
  public
    constructor CreateAndInit(AOwner: TComponent; APaintBox: TPaintBox;
      ASortAlgorithm: TSortAlgorithm); virtual;
    destructor Destroy; override;
    procedure ChangeSwapTime (Value: double);
    procedure Execute;
    function IsBusy: boolean;
  end;

implementation

uses
  System.SysUtils,
  Thread.BubbleSort,
  Thread.InsertionSort,
  Thread.QuickSort;

procedure TSortManager.Init(APaintBox: TPaintBox;
  ASortAlgorithm: TSortAlgorithm);
begin
  FSortAlgorithm := ASortAlgorithm;
  FSwapTime := 1.3; // milliseconds
  FBoard := TBoard.Create;
  FView := TBoardView.Create(FBoard, APaintBox);
  FView.FAlgorithmName := GetAlgorithmName;
  initialized := True;
end;

procedure TSortManager.ChangeSwapTime(Value: double);
begin
  FSwapTime := Value;
end;

constructor TSortManager.CreateAndInit(AOwner: TComponent; APaintBox: TPaintBox;
  ASortAlgorithm: TSortAlgorithm);
begin
  inherited Create(AOwner);
  Init(APaintBox, ASortAlgorithm);
end;

destructor TSortManager.Destroy;
begin
  if FView <> nil then
    FView.Free;
  if FBoard <> nil then
    FBoard.Free;
  inherited;
end;

procedure TSortManager.Execute;
var
  VisibleItems: Integer;
begin
  if not(initialized) then
    exit;
  VisibleItems := FView.CalculateTotalVisibleItems;
  FBoard.GenerateData(VisibleItems);
  FView.DrawBoard;
  if FThread <> nil then
    FreeAndNil(FThread);
  case FSortAlgorithm of
    saBubbleSort:
      FThread := TBubbleThread.Create(FBoard, FView, FSwapTime);
    saQuickSort:
      FThread := TQuickThread.Create(FBoard, FView, FSwapTime);
    saInsertionSort:
      FThread := TInsertionThread.Create(FBoard, FView, FSwapTime);
  else
    raise Exception.Create('[Internal] Not supported algorithm');
  end;
end;

function TSortManager.GetAlgorithmName: string;
begin
  case FSortAlgorithm of
    saBubbleSort:
      Result := 'Bubble Sort';
    saQuickSort:
      Result := 'Quick Sort';
    saInsertionSort:
      Result := 'Insertion Sort';
  else
    Result := 'Nieznane sotrowanie';
  end;
end;

function TSortManager.IsBusy: boolean;
begin
  Result := (FThread <> nil) and not(FThread.Finished);
end;

end.
