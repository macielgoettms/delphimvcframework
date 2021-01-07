unit EnumSerializer;

interface

uses
  DUnitX.TestFramework,
  MVCFramework.Commons,
  MVCFramework.Serializer.Intf,
  MVCFramework.Serializer.Commons,
  MVCFramework.Serializer.JsonDataObjects,
  Serializer.JsonDataObjects;

type

  [TestFixture]
  TMVCTestSerializerEnums = class(TObject)
  private
    fSerializer: IMVCSerializer;
    fMVCSerializer: IMVCSerializer;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestMySerializeEnum;
    [Test]
    procedure TestBaseSerializeEnum;
  end;

  TMonthEnum = (meJanuary, meFebruary, meMarch, meApril);

  TEntityWithEnums = class
  private
    FMonth: TMonthEnum;
    FMonthName: TMonthEnum;
    FMonthOrder: TMonthEnum;
    FMonthName2: TMonthEnum;
  public
    property Month: TMonthEnum read FMonth write FMonth;
    [MVCEnumSerialization(estEnumMappedValues, 'January,February,March,April')]
    property MonthName: TMonthEnum read FMonthName write FMonthName;
    [MVCEnumSerialization(estEnumName)]
    property MonthName2: TMonthEnum read FMonthName2 write FMonthName2;
    [MVCEnumSerialization(estEnumOrd)]
    property MonthOrder: TMonthEnum read FMonthOrder write FMonthOrder;
  end;

implementation

{ TMVCTestSerializerEnums }

procedure TMVCTestSerializerEnums.Setup;
begin
  fSerializer := TJsonDataObjectsSerializer.Create;
  fMVCSerializer := TMVCJsonDataObjectsSerializer.Create;
end;

procedure TMVCTestSerializerEnums.TearDown;
begin
  inherited;
  fSerializer := nil;
  fMVCSerializer := nil;
end;

procedure TMVCTestSerializerEnums.TestBaseSerializeEnum;
const
  JSON = '{' + '"Month":"meJanuary",' + '"MonthName":"January",' + '"MonthName2":"meFebruary",' +
    '"MonthOrder":0' + '}';
var
  O: TEntityWithEnums;
  S: string;
begin
  O := TEntityWithEnums.Create;
  try
    O.Month := TMonthEnum.meJanuary;
    O.MonthName := TMonthEnum.meJanuary;
    O.MonthName2 := TMonthEnum.meFebruary;
    O.MonthOrder := TMonthEnum.meJanuary;
    S := fMVCSerializer.SerializeObject(O);
    Assert.areEqual(JSON, S);
  finally
    O.Free;
  end;

  O := TEntityWithEnums.Create;
  try
    fMVCSerializer.DeserializeObject(S, O);
    Assert.areEqual(Ord(TMonthEnum.meJanuary), Ord(O.Month));
    Assert.areEqual(Ord(TMonthEnum.meJanuary), Ord(O.MonthName));
    Assert.areEqual(Ord(TMonthEnum.meFebruary), Ord(O.MonthName2));
    Assert.areEqual(Ord(TMonthEnum.meJanuary), Ord(O.MonthOrder));
  finally
    O.Free;
  end;
end;

procedure TMVCTestSerializerEnums.TestMySerializeEnum;
const
  JSON = '{' + '"Month":0,' + '"MonthName":"January",' + '"MonthName2":"meFebruary",' +
    '"MonthOrder":0' + '}';
var
  O: TEntityWithEnums;
  S: string;
begin
  O := TEntityWithEnums.Create;
  try
    O.Month := TMonthEnum.meJanuary;
    O.MonthName := TMonthEnum.meJanuary;
    O.MonthName2 := TMonthEnum.meFebruary;
    O.MonthOrder := TMonthEnum.meJanuary;
    S := fSerializer.SerializeObject(O);
    Assert.areEqual(JSON, S);
  finally
    O.Free;
  end;

  O := TEntityWithEnums.Create;
  try
    fSerializer.DeserializeObject(S, O);
    Assert.areEqual(Ord(TMonthEnum.meJanuary), Ord(O.Month));
    Assert.areEqual(Ord(TMonthEnum.meJanuary), Ord(O.MonthName));
    Assert.areEqual(Ord(TMonthEnum.meFebruary), Ord(O.MonthName2));
    Assert.areEqual(Ord(TMonthEnum.meJanuary), Ord(O.MonthOrder));
  finally
    O.Free;
  end;
end;

end.
