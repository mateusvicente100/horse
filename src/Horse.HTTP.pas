unit Horse.HTTP;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, Web.HTTPApp;

type

  THorseParams = TDictionary<string, string>;

  THorseRequest = class
  private
    FWebRequest: TWebRequest;
    FQuery: THorseParams;
    FParams: THorseParams;
    procedure InitializeQuery;
    procedure InitializeParams;
  public
    function Body: string;
    function Query: THorseParams;
    function Params: THorseParams;
    constructor Create(AWebRequest: TWebRequest);
    destructor Destroy; override;
  end;

  THorseHackRequest = class(THorseRequest)
  public
    function GetParams: THorseParams;
  end;

  THorseResponse = class
  private
    FWebResponse: TWebResponse;
  public
    function Send(AContent: string): THorseResponse;
    function Status(AStatus: Integer): THorseResponse;
    constructor Create(AWebResponse: TWebResponse);
    destructor Destroy; override;
  end;

  THorseHackResponse = class(THorseResponse)
  end;

  THorseCallback = reference to procedure(ARequest: THorseRequest;
    AResponse: THorseResponse; ANext: TProc);

implementation

{ THorseRequest }

function THorseRequest.Body: string;
begin
  Result := FWebRequest.Content;
end;

constructor THorseRequest.Create(AWebRequest: TWebRequest);
begin
  FWebRequest := AWebRequest;
  InitializeQuery;
  InitializeParams;
end;

destructor THorseRequest.Destroy;
begin
  FQuery.Free;
  FParams.Free;
  inherited;
end;

procedure THorseRequest.InitializeParams;
begin
  FParams := THorseParams.Create;
end;

procedure THorseRequest.InitializeQuery;
const
  KEY = 0;
  VALUE = 1;
var
  LParam: TArray<string>;
  LItem: string;
begin
  FQuery := THorseParams.Create;
  for LItem in FWebRequest.QueryFields do
  begin
    LParam := LItem.Split(['=']);
    FQuery.Add(LParam[KEY], LParam[VALUE]);
  end;
end;

function THorseRequest.Params: THorseParams;
begin
  Result := FParams;
end;

function THorseRequest.Query: THorseParams;
begin
  Result := FQuery;
end;

{ THorseResponse }

constructor THorseResponse.Create(AWebResponse: TWebResponse);
begin
  FWebResponse := AWebResponse;
end;

destructor THorseResponse.Destroy;
begin
  inherited;
end;

function THorseResponse.Send(AContent: string): THorseResponse;
begin
  FWebResponse.StatusCode := 200;
  FWebResponse.Content := AContent;
  Result := Self;
end;

function THorseResponse.Status(AStatus: Integer): THorseResponse;
begin
  FWebResponse.StatusCode := AStatus;
  Result := Self;
end;

{ THorseHackRequest }

function THorseHackRequest.GetParams: THorseParams;
begin
  Result := FParams;
end;

end.
