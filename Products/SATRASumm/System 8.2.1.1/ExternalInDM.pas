unit ExternalInDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, Data.DB,
  FireDAC.Comp.Client, FDQueryPlus, FireDAC.Comp.DataSet, Dialogs, DateUtils, FDConnectionPlus;

type
  TExternalInDM1 = class(TDataModule)
    tblStyles: TFDTable;
    tblStylesStyle: TStringField;
    tblStylesCurrentCon: TStringField;
    tblStylesPicture: TBlobField;
    tblConParts: TFDTable;
    tblConPartsConstruction: TStringField;
    tblParts: TFDTable;
    tblPartsCode: TStringField;
    tblPartsWidthRange: TStringField;
    tblWidths: TFDTable;
    tblWidthsNo: TSmallintField;
    tblWidthsWidth: TStringField;
    tblWidthRangeWidths: TFDTable;
    tblWidthRangeWidthsRange: TStringField;
    tblWidthRangeWidthsWidthNo: TSmallintField;
    tblPtWidKnf: TFDTable;
    tblSizeRangeSizes: TFDTable;
    tblSizeRangeSizesScale: TStringField;
    tblSizeRangeSizesRange: TStringField;
    tblSizeRangeSizesSize: TStringField;
    tblSizeRangeSizesSeq: TFloatField;
    tblConstructions: TFDTable;
    tblConstructionsConstruction: TStringField;
    tblConstructionsSizeRange: TStringField;
    tblConstructionsSizeScale: TStringField;
    qGet: TFDQueryPlus;
    qGetSequenceNo: TIntegerField;
    qCommonWidths: TFDQueryPlus;
    qCommonWidthsNo: TSmallintField;
    FDDataConn: TFDConnectionPlus;
    FDDataConnQ: TFDQueryPlus;
    dsStyles: TDataSource;
    dsConParts: TDataSource;
    mtblOutput: TFDMemTable;
    mtblOutputStyle: TStringField;
    mtblOutputWidth: TStringField;
    mtblOutputErrorStr: TStringField;
    tblPtWidKnfPart: TStringField;
    tblPtWidKnfWidthNo: TSmallintField;
    qCommonWidthsWidth: TStringField;
    tblConPartsPart: TStringField;
    tblConPartsID: TIntegerField;
    qTicketsInput: TFDQueryPlus;
    tblStylesDescription: TStringField;
    procedure FDDataConnBeforeConnect(Sender: TObject);
    procedure FDDataConnAfterConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function ExternalIn(var MyList: TStringList): TFDMemTable;
  end;

var
  ExternalInDM1: TExternalInDM1;

implementation

uses General;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure PostError(tblOutput: TFDMemTable;
                    Style, Width, ErrorStr: string);
begin
  tblOutput.Append;
  tblOutput.FieldByName('Style').AsString := Style;
  tblOutput.FieldByName('Width').AsString := Width;
  tblOutput.FieldByName('ErrorStr').AsString := ErrorStr;
  tblOutput.Post;
end;

function StripStringTrailingSpaces(InStr:string):string;
var
  i, LineLen: integer;

begin
  LineLen := length(InStr);

  if LineLen > 0 then
  begin
    i := LineLen + 1;
    repeat
      i := i - 1;
    until (i = 0) or (InStr[i] <> ' ');
    i := i + 1;
    if i <= LineLen then
      delete(InStr, i, LineLen - i + 1);
    result := InStr;
  end
  else
    result := '***Missing***';
end;

function TExternalInDM1.ExternalIn(var MyList: TStringList): TFDMemTable;
var
  i, j, NumberOfSizes, Pairage, PairsStart, SequenceNo, SizeLength, SizeStart, TagNoShift, WeekNumber: integer;
  CombineWidths, Customer, FileLine, PrevStyle, PrevWidth, Style, Size, TagNo, Temp, Width: String;
  FirstLine, CommonWidth, NextSeq, SizeBySize, StopNow, StyleExists: boolean;

begin
//  try
      PrevStyle := '';

      mtblOutput.Close;
      mtblOutput.Open;
      tblStyles.Open;
      tblConParts.Open;
      tblConstructions.Open;
      tblParts.Open;
      tblPtWidKnf.Open;
      tblWidths.Open;
      tblWidthRangeWidths.Open;
      tblSizeRangeSizes.Open;
//      tblTicketSequences.Open;
//      tblTicketsInput.Open;

//      tblInput.Open;
//      MyList := TStringList.Create;
//      MyList.Assign(tblInput.FieldByName('InFile') as TMemoField);

      if MyList[0] = '***Size By Size***' then
      begin
        FirstLine := True;
        SizeBySize := True;
        TagNoShift := 0;
        i := 1;
      end
      else if MyList[0] = '***Size By Size, Long Tag Number***' then
      begin
        FirstLine := True;
        SizeBySize := True;
        TagNoShift := 30;
        i := 1;
      end
      else if MyList[0] = '***Long Tag Number***' then
      begin
        FirstLine := True;
        SizeBySize := False;
        TagNoShift := 30;
        i := 1;
      end
      else
      begin
        FirstLine := False;
        SizeBySize := False;
        TagNoShift := 0;
        i := 0;
      end;

///      mtblOutput.Open;
      while i < MyList.Count do
      begin
        FileLine := MyList[i];

        if Pos('***Next Ticket Sequence***', FileLine) > 0 then
        begin
          inc(i);
          FileLine := MyList[i];
        end;

        FileLine := StripStringTrailingSpaces(FileLine);

        Temp := StripStringTrailingSpaces(Copy(FileLine, 1, 2));
        try
          WeekNumber := StrToInt(Temp);
        except
          WeekNumber := -1;
        end;

        if (WeekNumber < 1) or (WeekNumber > 53) then
          PostError(mtblOutput, '', '', IntToStr(WeekNumber) + ': Invalid Week Number');

        CombineWidths := StripStringTrailingSpaces(Copy(FileLine, 36, 1));

        if not((CombineWidths = 'N') or (CombineWidths = 'n') or (CombineWidths = 'Y') or (CombineWidths = 'y')) then
          PostError(mtblOutput, '', '', CombineWidths + ': Invalid Combine Widths Flag');

        if not SizeBySize then
        begin
          SizeLength := Length(FileLine) - (84 + TagNoShift);
          if SizeLength mod 2 = 1 then
            SizeLength := SizeLength + 1;
          NumberOfSizes := SizeLength div 5;

          PairsStart := 85 + TagNoShift;
          for j := 1 to NumberOfSizes do
          begin
            Temp := StripStringTrailingSpaces(Copy(FileLine, PairsStart, 5));
            try
              Pairage := StrToInt(Temp);
            except
              PostError(mtblOutput, '', '', Temp + ': Invalid Pairage');
            end;
            PairsStart := PairsStart + 5;
          end;
        end
        else
        begin
          PairsStart := 90 + TagNoShift;

          while PairsStart <= Length(FileLine) do
          begin
            Temp := StripStringTrailingSpaces(Copy(FileLine, PairsStart, 5));
            if not(Temp = '     ') and not(Temp = '') then
            try
              Pairage := StrToInt(Temp);
            except
              PostError(mtblOutput, '', '', Temp + ': Invalid Pairage');
            end;
            PairsStart := PairsStart + 10;
          end;
        end;

        Style := QS(StripStringTrailingSpaces(Copy(FileLine, 4, 20)));
///        tblStyles.Open;

        //Only test 'uniquish' Styles
        if not(Style = PrevStyle) then
        begin
          if not tblStyles.FindKey([Style]) then
          begin
            PostError(mtblOutput, Style, '', 'Style does not exist');
            StyleExists := False;
          end
          else
            StyleExists := True;

          PrevStyle := Style;
          Style := StripStringTrailingSpaces(Copy(FileLine, 4, 20));
        end;

        if StyleExists then
        begin
///          tblConParts.Open;
///          tblConstructions.Open;
///          tblParts.Open;
///          tblPtWidKnf.Open;
///          tblWidths.Open;
///          tblWidthRangeWidths.Open;

          Width := QS(StripStringTrailingSpaces(Copy(FileLine, 25, 10)));
          CommonWidth := True;

          tblConParts.RecNo := 1;
          tblConParts.Prior;
          if tblWidths.FindKey([Width]) then
          begin
            for j := 1 to tblConParts.RecordCount do
            begin
              if not tblWidthRangeWidths.FindKey([tblPartsWidthRange.Value, tblWidthsNo.Value]) then
                CommonWidth := False;
              if CommonWidth and not tblPtWidKnf.FindKey([tblConPartsPart.Value, tblWidthsNo.Value]) then
                PostError(mtblOutput, Style, Width, 'No Knives for Part ''' + tblConPartsPart.Value + '''');
              tblConParts.Next;
            end;
          end
          else
            PostError(mtblOutput, '', Width, 'Width does not exist');

          if not CommonWidth then
            PostError(mtblOutput, Style, Width, 'Width not valid on Style');

//        tblSizeRangeSizes.Open;
          if not(SizeBySize) then
          begin
            tblSizeRangeSizes.SetRange([tblConstructionsSizeScale.Value, tblConstructionsSizeRange.Value],
                                       [tblConstructionsSizeScale.Value, tblConstructionsSizeRange.Value]);
            if tblSizeRangeSizes.RecordCount > 0 then
            begin
              if SizeLength mod 5 > 0 then
                NumberOfSizes := trunc(SizeLength / 5) + 1;

              if not(NumberOfSizes = tblSizeRangeSizes.RecordCount) then
                PostError(mtblOutput, Style, Width, 'Wrong number of Sizes');
            end;
          end
          else
          begin
            SizeStart := 85 + TagNoShift;
            while SizeStart < Length(FileLine) do
            begin
              Size := Copy(FileLine, SizeStart, 5);
              if not(Size = '     ') and not(Size = '') then
                Size := QS(StripStringTrailingSpaces(Size))
              else
                Size := 'NO SIZE';

              tblSizeRangeSizes.CancelRange;
              if not(Size = 'NO SIZE') then
              begin
                if not tblSizeRangeSizes.FindKey([tblConstructionsSizeScale.Value, tblConstructionsSizeRange.Value, Size]) then
                  PostError(mtblOutput, Style, Width, 'Size ''' + Size + ''' does not exist');
              end;
              SizeStart := SizeStart + 10;
            end;
          end;
        end;
        inc(i);
      end;

      if mtblOutput.RecordCount = 0 then
      begin
        if FirstLine then
          MyList.Delete(0);

///        tblTicketSequences.Open;
///        tblTicketsInput.Open;

        Style := '';
        PrevStyle := '';
        Width := '';
        PrevWidth := '';
        NextSeq := False;
        qTicketsInput.SQL.Clear;
        qTicketsInput.SQL.Add('DECLARE @WeekNo Integer;');
        qTicketsInput.SQL.Add('DECLARE @Picture Blob;');
        qTicketsInput.SQL.Add('DECLARE @SequenceNo Integer;');

        while (MyList.Count > 0) and not StopNow do
        begin
          try
//            DataConn.BeginTransaction;
            FDDataConn.StartTransaction;

            FileLine := MyList[0];

            FileLine := StripStringTrailingSpaces(FileLine);

            if not(FileLine = '***Next Ticket Sequence***') then
            begin
              WeekNumber := StrToInt(StripStringTrailingSpaces(Copy(FileLine, 1, 2)));
              CombineWidths := StripStringTrailingSpaces(Copy(FileLine, 36, 1));
              PrevStyle := Style;
              PrevWidth := PrevWidth + '***' + Width;     //quick hack to make it work with old file structure quickly for Alpina installation
              Style := QS(StripStringTrailingSpaces(Copy(FileLine, 4, 20)));
              Width := QS(StripStringTrailingSpaces(Copy(FileLine, 25, 10)));
              Customer := QS(StripStringTrailingSpaces(Copy(FileLine, 38, 20)));
              TagNo := QS(StripStringTrailingSpaces(Copy(FileLine, 59, 25 + TagNoShift)));
              tblStyles.FindKey([Style]);
              tblWidths.FindKey([Width]);

              if NextSeq or not(Style = PrevStyle) or ((Style = PrevStyle) and (pos(Width, PrevWidth) > 0)) then
              begin
                PrevWidth := '';

                if (CombineWidths = 'Y') or (CombineWidths = 'y') then
                  Pairage := 1
                else
                  Pairage := 0;

                with qTicketsInput do
                begin
                  SQL.Add('@WeekNo = ' + IntToStr(WeekNumber) + ';');
                  SQL.Add('@Picture = (SELECT TOP 1 Picture ' +
                                       'FROM Styles ' +
                                       'WHERE Style = ''' + Style + ''');');
                  SQL.Add('@SequenceNo = (SELECT MAX(SequenceNo) + 1 ' +
                                          'FROM TicketSequences ' +
                                          'WHERE (WeekNo = @WeekNo) ' +
                                           'OR (WeekNo = 0));');
                  SQL.Add('INSERT INTO TicketSequences (WeekNo, ' +
                                                        'SequenceNo, ' +
                                                        'Style, ' +
                                                        'StyleDescription, ' +
                                                        'Construction, ' +
                                                        'Customer, ' +
                                                        'TagNo, ' +
                                                        'Picture) ' +
                           'VALUES (@WeekNo, ' +
                                    '@SequenceNo, ' +
                                    '''' + Style + ''', ' +
                                    '''' + tblStylesDescription.Value + ''', ' +
                                    '''' + tblStylesCurrentCon.Value + ''', ' +
                                    '''' + Customer + ''', ' +
                                    '''' + TagNo + ''', ' +
                                    '@Picture);');
                end;

{
                qGet.ParamByName('WeekNo').AsInteger := WeekNumber;
                qGet.Open;
                SequenceNo := qGetSequenceNo.Value;
                qGet.Close;

                tblTicketSequences.Append;
                tblTicketSequencesWeekNo.Value := WeekNumber;
                tblTicketSequencesSequenceNo.Value := SequenceNo;
                tblTicketSequencesStyle.Value := Style;
                tblTicketSequencesConstruction.Value := tblStylesCurrentCon.Value;
                tblTicketSequencesCustomer.Value := Customer;
                tblTicketSequencesTagNo.Value := TagNo;
                tblTicketSequencesPicture.Value := tblStylesPicture.Value;
                tblTicketSequences.Post;
}
                qCommonWidths.ParamByName('Construction').Value := tblStylesCurrentCon.Value;
                qCommonWidths.Open;               //this block of code should fill the TicketInput
                while not qCommonWidths.Eof do    //table with defaults for all possible sizes and widths.
                begin
                  with qTicketsInput do
                  begin
                    SQL.Add('INSERT INTO TicketsInput (WeekNo, ' +
                                                       'SequenceNo, ' +
                                                       'Width, ' +
                                                       'Size, ' +
                                                       'Pairs, ' +
                                                       'WidthNo, ' +
                                                       'SizeSeq) ' +
                             'VALUES (@WeekNo, @SequenceNo, ''' + qCommonWidthsWidth.Value + ''', ''AddWidth'', ' + IntToStr(Pairage) + ', ' + IntToStr(qCommonWidthsNo.Value) + ', 0);');
                  end;

{
                  tblTicketsInput.Append;
                  tblTicketsInputWeekNo.Value := WeekNumber;
                  tblTicketsInputSequenceNo.Value := SequenceNo;
                  tblTicketsInputWidth.Value := qCommonWidthsWidth.Value;
                  tblTicketsInputSize.Value := 'AddWidth';
                  tblTicketsInputPairs.Value := 0;        //Default to Addwidth = No
                  tblTicketsInputWidthNo.Value := qCommonWidthsNo.Value;
                  tblTicketsInputSizeSeq.Value := 0;
                  tblTicketsInput.Post;
}
                  tblSizeRangeSizes.IndexName := 'SCALERANGESEQ';

                  tblSizeRangeSizes.SetRange([tblConstructionsSizeScale.Value, tblConstructionsSizeRange.Value],
                                             [tblConstructionsSizeScale.Value, tblConstructionsSizeRange.Value]);


                  for j := 1 to tblSizeRangeSizes.RecordCount do
                  begin
                    with qTicketsInput do
                    begin
                      SQL.Add('INSERT INTO TicketsInput (WeekNo, ' +
                                                         'SequenceNo, ' +
                                                         'Width, ' +
                                                         'Size, ' +
                                                         'Pairs, ' +
                                                         'WidthNo, ' +
                                                         'SizeSeq) ' +
                               'VALUES (@WeekNo, @SequenceNo, ''' + qCommonWidthsWidth.Value + ''', ''' + tblSizeRangeSizesSize.Value + ''', 0, ' + IntToStr(qCommonWidthsNo.Value) + ', ' + FloatToStrSQL(tblSizeRangeSizesSeq.Value) + ');');
                    end;
{
                    tblTicketsInput.Append;
                    tblTicketsInputWeekNo.Value := WeekNumber;
                    tblTicketsInputSequenceNo.Value := SequenceNo;
                    tblTicketsInputWidth.Value := qCommonWidthsWidth.Value;
                    tblTicketsInputSize.Value := tblSizeRangeSizesSize.Value;
                    tblTicketsInputPairs.Value := 0;
                    tblTicketsInputWidthNo.Value := qCommonWidthsNo.Value;
                    tblTicketsInputSizeSeq.Value := tblSizeRangeSizesSeq.Value;
                    tblTicketsInput.Post;
}
                    tblSizeRangeSizes.Next;
                  end;

                  tblSizeRangeSizes.CancelRange;
                  qCommonWidths.Next;
                end;                       //end default block
                qCommonWidths.Close;
              end;

{
              if (CombineWidths = 'Y') or (CombineWidths = 'y') then
              begin
                tblTicketsInput.FindKey([WeekNumber, SequenceNo, Width, 'AddWidth']);
                tblTicketsInput.Edit;
                tblTicketsInputPairs.Value := 1;
                tblTicketsInput.Post;
              end;
}

              if not(SizeBySize) then
              begin
                tblSizeRangeSizes.IndexName := 'SCALERANGESEQ';
                SizeLength := Length(FileLine) - (84 + TagNoShift);
                if SizeLength mod 2 = 1 then
                  SizeLength := SizeLength + 1;
                if SizeLength mod 5 > 0 then
                  NumberOfSizes := trunc(SizeLength / 5) + 1;

                PairsStart := 85 + TagNoShift;
                for j := 1 to NumberOfSizes do
                begin
                  tblSizeRangeSizes.FindKey([tblConstructionsSizeScale.Value, tblConstructionsSizeRange.Value, j]);
                  Temp := StripStringTrailingSpaces(Copy(FileLine, PairsStart, 5));
                  Pairage := StrToInt(Temp);

                  with qTicketsInput do
                  begin
                    SQL.Add('UPDATE TicketsInput ' +
                             'SET Pairs = ' + IntToStr(Pairage) + ' ' +
                             'WHERE WeekNo = @WeekNo AND ' +
                              'SequenceNo = @SequenceNo AND ' +
                              'Width = ''' + Width + ''' AND ' +
                              'Size = ''' + tblSizeRangeSizesSize.Value + ''';');
                  end;

{
                  tblTicketsInput.FindKey([WeekNumber, SequenceNo, Width, tblSizeRangeSizesSize.Value]);
                  tblTicketsInput.Edit;
                  tblTicketsInputPairs.Value := Pairage;
                  tblTicketsInput.Post;
}

                  PairsStart := PairsStart + 5;
                end;
                tblSizeRangeSizes.IndexName := 'PRIMARY';
              end
              else   //is size by size
              begin
                SizeStart := 85 + TagNoShift;
                PairsStart := 90 + TagNoShift;

                tblSizeRangeSizes.IndexName := 'PRIMARY';
                while SizeStart <= Length(FileLine) do
                begin
                  Size := QS(StripStringTrailingSpaces(Copy(FileLine, SizeStart, 5)));
                  if not(Size = '     ') and not(Size = '') then
                    Size := StripStringTrailingSpaces(Size)
                  else
                    Size := 'NO SIZES';
                  SizeStart := SizeStart + 10;

                  Temp := StripStringTrailingSpaces(Copy(FileLine, PairsStart, 5));
                  if not(Temp = '     ') and not(Temp = '') then
                    Pairage := StrToInt(Temp)
                  else
                    Pairage := -1;
                  PairsStart := PairsStart + 10;

                  if not(Size = 'NO SIZE') and not(Pairage = -1) then
                  begin
                    with qTicketsInput do
                    begin
                      SQL.Add('UPDATE TicketsInput ' +
                               'SET Pairs = ' + IntToStr(Pairage) + ' ' +
                               'WHERE WeekNo = @WeekNo AND ' +
                                'SequenceNo = @SequenceNo AND ' +
                                'Width = ''' + Width + ''' AND ' +
                                'Size = ''' + Size + ''';');
                    end;
{
                    tblTicketsInput.FindKey([WeekNumber, SequenceNo, Width, Size]);
                    tblTicketsInput.Edit;
                    tblTicketsInputPairs.Value := Pairage;
                    tblTicketsInput.Post;
}
                  end;
                end;
              end;
              NextSeq := False;
            end    //end not nextticket
            else
              NextSeq := True;

            MyList.Delete(0);

            if (NextSeq) or (MyList.Count = 0) then
            begin
              qTicketsInput.ExecSQL;
              qTicketsInput.SQL.Clear;
            end;
            FDDataConn.Commit;
            StopNow := False;
          except
            StopNow := True;
            FDDataConn.RollBack;
            Raise;
          end;
        end;     //end while

//        tblTicketsInput.Close;
//        tblTicketSequences.Close;
      end;
//      MyList.Free;
//      tblInput.Close;
//  except

//    on E : EFDDBEngineException do
//    begin
      {* ADS-specific error, use ACE error code *}
//      DM1.FDDataConn.Execute( 'INSERT INTO __error VALUES ( ' + IntToStr( E.ACEErrorCode ) + ', ' + QuotedStr( E.Message ) + ' )' );

//      DM1.FDDataConnQ.SQL.Clear;
//      DM1.FDDataConnQ.SQL.Add('INSERT INTO __error VALUES ( ' + IntToStr( E.ErrorCode ) + ', ' + QuotedStr( E.Message ) + ' )');
//      DM1.FDDataConnQ.ExecSQL;
//    end;
//    on E : Exception do
//    begin
      {* other error *}
//      DM1.FDDataConn.Execute( 'INSERT INTO __error VALUES ( 1, ' + QuotedStr( E.Message ) + ' )' );
//      DM1.FDDataConnQ.SQL.Clear;
//      DM1.FDDataConnQ.SQL.Add('INSERT INTO __error VALUES ( 1, ' + QuotedStr( E.Message ) + ' )' );
//      DM1.FDDataConnQ.ExecSQL;
//    end;
//  end;

  Result := mtblOutput;
end;

procedure TExternalInDM1.FDDataConnAfterConnect(Sender: TObject);
begin
  ConnectionModification(Sender);
end;

procedure TExternalInDM1.FDDataConnBeforeConnect(Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

end.
