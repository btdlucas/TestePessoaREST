unit uConfigService;

interface

type
  TConfigService = class
  private
    class function GetConfigFilePath: string;
  public
    class function GetDatabase: string;
    class function GetUsername: string;
    class function GetPassword: string;
    class function GetServer: string;
    class function GetPort: Integer;
    class function GetDriverID: string;
    class function GetVendorLib: string;
    class function GetServerPort: Integer;
  end;

implementation

uses
  System.SysUtils,
  System.IniFiles;

const
  SECTION_DATABASE = 'DATABASE';
  SECTION_SERVER = 'SERVER';

class function TConfigService.GetConfigFilePath: string;
begin
  Result := ExpandFileName(
    ExtractFilePath(ParamStr(0)) + '..\..\..\config.ini'
  );

  if not FileExists(Result) then
    raise Exception.CreateFmt(
      'Arquivo de configuração não encontrado: %s',
      [Result]
    );
end;

class function TConfigService.GetDatabase: string;
var
  oIni: TIniFile;
begin
  oIni := TIniFile.Create(GetConfigFilePath);
  try
    Result := oIni.ReadString(SECTION_DATABASE, 'Database', '');
  finally
    oIni.Free;
  end;
end;

class function TConfigService.GetUsername: string;
var
  oIni: TIniFile;
begin
  oIni := TIniFile.Create(GetConfigFilePath);
  try
    Result := oIni.ReadString(SECTION_DATABASE, 'Username', '');
  finally
    oIni.Free;
  end;
end;

class function TConfigService.GetPassword: string;
var
  oIni: TIniFile;
begin
  oIni := TIniFile.Create(GetConfigFilePath);
  try
    Result := oIni.ReadString(SECTION_DATABASE, 'Password', '');
  finally
    oIni.Free;
  end;
end;

class function TConfigService.GetServer: string;
var
  oIni: TIniFile;
begin
  oIni := TIniFile.Create(GetConfigFilePath);
  try
    Result := oIni.ReadString(SECTION_DATABASE, 'Server', 'localhost');
  finally
    oIni.Free;
  end;
end;

class function TConfigService.GetPort: Integer;
var
  oIni: TIniFile;
begin
  oIni := TIniFile.Create(GetConfigFilePath);
  try
    Result := oIni.ReadInteger(SECTION_DATABASE, 'Port', 5432);
  finally
    oIni.Free;
  end;
end;

class function TConfigService.GetDriverID: string;
var
  oIni: TIniFile;
begin
  oIni := TIniFile.Create(GetConfigFilePath);
  try
    Result := oIni.ReadString(SECTION_DATABASE, 'DriverID', 'PG');
  finally
    oIni.Free;
  end;
end;

class function TConfigService.GetVendorLib: string;
var
  oIni: TIniFile;
begin
  oIni := TIniFile.Create(GetConfigFilePath);
  try
    Result := oIni.ReadString(SECTION_DATABASE, 'VendorLib', '');
  finally
    oIni.Free;
  end;
end;

class function TConfigService.GetServerPort: Integer;
var
  oIni: TIniFile;
begin
  oIni := TIniFile.Create(GetConfigFilePath);
  try
    Result := oIni.ReadInteger(SECTION_SERVER, 'Port', 9000);
  finally
    oIni.Free;
  end;
end;

end.
