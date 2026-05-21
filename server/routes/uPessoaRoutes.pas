unit uPessoaRoutes;

interface

procedure RegistrarRotasPessoa;

implementation

uses
  System.SysUtils,
  System.JSON,
  Horse,
  uDMConnection,
  uPessoa,
  uPessoaDTO,
  uPessoaService;

procedure RegistrarRotasPessoa;
begin
  THorse.Post('/pessoas',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      oJSON: TJSONObject;
      oPessoa: TPessoa;
      oPessoaService: TPessoaService;
      nIdPessoa: Int64;
    begin
      oJSON := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;
      try
        oPessoa := TPessoaDTO.FromJSON(oJSON);
        try
          oPessoaService := TPessoaService.Create(dmConnection.FDConnection);
          try
            nIdPessoa := oPessoaService.Insert(oPessoa);

            Res.Status(201)
              .Send(
                Format(
                  '{"idpessoa":%d}',
                  [nIdPessoa]
                )
              );
          finally
            oPessoaService.Free;
          end;
        finally
          oPessoa.Free;
        end;
      finally
        oJSON.Free;
      end;
    end);

  THorse.Put('/pessoas/:id',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      oJSON: TJSONObject;
      oPessoa: TPessoa;
      oPessoaService: TPessoaService;
      nIdPessoa: Int64;
    begin
      nIdPessoa := StrToInt64(Req.Params['id']);

      oJSON := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;
      try
        oPessoa := TPessoaDTO.FromJSON(oJSON);
        try
          oPessoa.IdPessoa := nIdPessoa;

          oPessoaService := TPessoaService.Create(dmConnection.FDConnection);
          try
            oPessoaService.Update(oPessoa);
            Res.Status(200).Send('{"status":"updated"}');
          finally
            oPessoaService.Free;
          end;
        finally
          oPessoa.Free;
        end;
      finally
        oJSON.Free;
      end;
    end);

  THorse.Delete('/pessoas/:id',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      oPessoaService: TPessoaService;
      nIdPessoa: Int64;
    begin
      nIdPessoa := StrToInt64(Req.Params['id']);

      oPessoaService := TPessoaService.Create(dmConnection.FDConnection);
      try
        oPessoaService.Delete(nIdPessoa);
        Res.Status(200).Send('{"status":"deleted"}');
      finally
        oPessoaService.Free;
      end;
    end);
end;

end.
