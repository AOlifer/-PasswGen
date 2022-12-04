unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.EditBox, FMX.SpinBox, FMX.Layouts,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo;

type
  TfMain = class(TForm)
    pBottom: TPanel;
    lbAlhabetCnt: TLabel;
    lLeft: TLayout;
    lMain: TLayout;
    pAlphabet: TGroupBox;
    lAlphabet: TGridPanelLayout;
    lStandart: TGridPanelLayout;
    rbStandart: TRadioButton;
    lCheckButtons: TGridPanelLayout;
    chStrUpper: TCheckBox;
    chStrLower: TCheckBox;
    chStrNumbs: TCheckBox;
    chStrChars: TCheckBox;
    eStrUpper: TMemo;
    eStrLower: TMemo;
    eStrNumbs: TMemo;
    eStrChars: TMemo;
    lManual: TGridPanelLayout;
    rbManual: TRadioButton;
    eManual: TMemo;
    pPswEdit: TGridPanelLayout;
    eOldPassword: TEdit;
    eNewPassword: TMemo;
    btnGenerate: TButton;
    Splitter1: TSplitter;
    pParams: TGroupBox;
    lParams: TGridPanelLayout;
    lbPswLength: TLabel;
    ePswLength: TSpinBox;
    chFirst: TCheckBox;
    procedure btnGenerateClick(Sender: TObject);
    procedure rbStandartDblClick(Sender: TObject);
    procedure rbClick(Sender: TObject);
    procedure chClick(Sender: TObject);
    function LoadAlphabet: boolean;
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fMain: TfMain;

const
  minAlhabetCnt = 36;
  str_UPPER = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  str_LOWER = 'abcdefghijklmnopqrstuvwxyz';
  str_NUMBS = '0123456789';
  str_CHARS = '@#$&*%_';
  str_COMBS = str_UPPER + str_LOWER + str_NUMBS + str_CHARS;
  min_lenght = 6;
  max_lenght = 50;


var
  p :array [1 .. max_lenght] of Char;
  v_UPPER,v_LOWER,v_NUMBS,v_CHARS,v_COMBS :string;
  AlhabetCnt,psw_lenght :integer;

implementation


{$R *.fmx}

procedure TfMain.btnGenerateClick(Sender: TObject);
const
  emp = Char(nil);
var
  i,inc :integer;
  res :string;
  procedure add_random_char(str :string);
  var n :integer;
  begin
    Repeat
      n := Random(psw_lenght - 1) + 2;
    Until (p[n] = emp);
    p[n] := str[Random(Length(str)) + 1];
  end;
begin
  if LoadAlphabet then begin
    inc := 0;
    //очистка
    for i := 1 to max_lenght do p[i] := emp;
    if chFirst.IsChecked then begin
      //Добавляем первый символ из Верхнего или Нижнего регистра
      p[1] := (str_UPPER+str_LOWER)[Random(Length(str_UPPER + str_LOWER)) + 1];
      inc := inc + 1;
    end;
    if rbStandart.IsChecked then begin
      //Добавляем символ из Верхнего регистра
      if (chStrUpper.IsChecked and (eStrUpper.Text <> EmptyStr)) then add_random_char(v_UPPER);
      //Добавляем символ из Нижнего регистра
      if (chStrLower.IsChecked and (eStrLower.Text <> EmptyStr)) then add_random_char(v_LOWER);
      //Добавляем символ из Набора цифр
      if (chStrNumbs.IsChecked and (eStrNumbs.Text <> EmptyStr)) then add_random_char(v_NUMBS);
      //Добавляем символ из Набора спецсимволов (не может быть в начале пароля)
      if (chStrChars.IsChecked and (eStrChars.Text <> EmptyStr)) then add_random_char(str_CHARS);
    end;
    //заполняем массив случайными символами
    for i := (1 + inc) to psw_lenght do begin
      if p[i] = emp then
        p[i] := v_COMBS[Random(AlhabetCnt) + 1];
    end;
    //формируем результат
    res := EmptyStr;
    for i := 1 to psw_lenght do res := res + p[i];
    eNewPassword.Text := res;
  end;
end;

function TfMain.LoadAlphabet: boolean;
  procedure ResetStr;
  begin
    v_UPPER := EmptyStr;
    v_LOWER := EmptyStr;
    v_NUMBS := EmptyStr;
    v_CHARS := EmptyStr;
    v_COMBS := EmptyStr;
  end;
  function DistinctChar(str :string): string;
  begin
    Result := str;
  end;
begin
  Result := False;
  if rbManual.IsChecked then begin
    if eManual.Text = EmptyStr then Exit;
    ResetStr;
    v_COMBS := DistinctChar(eManual.Text);
  end else begin
    if (chStrUpper.IsChecked and (eStrUpper.Text <> EmptyStr)) or
       (chStrLower.IsChecked and (eStrLower.Text <> EmptyStr)) or
       (chStrNumbs.IsChecked and (eStrNumbs.Text <> EmptyStr)) or
       (chStrChars.IsChecked and (eStrChars.Text <> EmptyStr)) then begin
      ResetStr;
      if chStrUpper.IsChecked then
        v_UPPER := DistinctChar(eStrUpper.Text);
      if chStrLower.IsChecked then
        v_LOWER := DistinctChar(eStrLower.Text);
      if chStrNumbs.IsChecked then
        v_NUMBS := DistinctChar(eStrNumbs.Text);
      if chStrChars.IsChecked then
        v_CHARS := DistinctChar(eStrChars.Text);
      v_COMBS := DistinctChar(v_UPPER + v_LOWER + v_NUMBS + v_CHARS);
    end else Exit;
  end;
  psw_lenght := StrToInt(ePswLength.Text);
  AlhabetCnt := Length(V_COMBS);
  eManual.Text := V_COMBS;
  if not lbAlhabetCnt.Visible then lbAlhabetCnt.Visible := True;
  lbAlhabetCnt.Text := 'Мощность алфавита: ' + IntToStr(AlhabetCnt) + ' симв.';
  Result := True;
end;

procedure TfMain.rbStandartDblClick(Sender: TObject);
begin
  eStrUpper.Text := str_upper;
  eStrLower.Text := str_lower;
  eStrNumbs.Text := str_numbs;
  eStrChars.Text := str_chars;
end;

procedure TfMain.rbClick(Sender: TObject);
begin
  lCheckButtons.Enabled := rbStandart.IsChecked;
  eManual.Enabled := rbManual.IsChecked;
end;

procedure TfMain.chClick(Sender: TObject);
begin
  eStrUpper.Enabled := chStrUpper.IsChecked;
  eStrLower.Enabled := chStrLower.IsChecked;
  eStrNumbs.Enabled := chStrNumbs.IsChecked;
  eStrChars.Enabled := chStrChars.IsChecked;
end;

procedure TfMain.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
var S :TStringList;
begin
  if key = 112 then begin
    S := TStringList.Create;
    try
      S.Add('Все вопросы по работе программы:');
      S.Add('AOlifer@yahoo.com    +7 (921) 4290915');
      S.Add('© AOlifer 2022');
      showmessage(S.Text);
    finally
     S.Free;
    end;
  end;
end;

end.
