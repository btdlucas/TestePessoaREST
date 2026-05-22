unit uPessoaLoteRoutes;

interface

procedure RegistrarRotasPessoaLote;

implementation

uses
  System.SysUtils,
  System.JSON,
  Horse,
  uDMConnection,
  uPessoa,
  uPessoaDTO,
  System.Generics.Collections,
  uPessoaService;

procedure RegistrarRotasPessoaLote;
begin
  THorse.Post('/pessoas/lote',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      oJSONValue: TJSONValue;
      oArray: TJSONArray;
      oPessoaJSON: TJSONObject;
      oPessoa: TPessoa;
      oService: TPessoaService;
      nIndex: Integer;
      nTotal: Integer;
    begin
      if Trim(Req.Body) = '' then
      begin
        Res.Status(400).Send('{"erro":"Body JSON não informado."}');
        Exit;
      end;

      oJSONValue := TJSONObject.ParseJSONValue(Req.Body);
      try
        if not (oJSONValue is TJSONArray) then
        begin
          Res.Status(400).Send('{"erro":"Body deve ser um array de pessoas."}');
          Exit;
        end;

        oArray := TJSONArray(oJSONValue);
        nTotal := 0;

        oService := TPessoaService.Create(dmConnection.FDConnection);
        try
          for nIndex := 0 to oArray.Count - 1 do
          begin
            oPessoaJSON := oArray.Items[nIndex] as TJSONObject;

            oPessoa := TPessoaDTO.FromJSON(oPessoaJSON);
            try
              oService.Insert(oPessoa);
              Inc(nTotal);
            finally
              oPessoa.Free;
            end;
          end;
        finally
          oService.Free;
        end;

        Res.Status(201).Send(
          Format('{"totalInserido":%d}', [nTotal])
        );
      finally
        oJSONValue.Free;
      end;
    end);
end;

end.
