unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfMain = class(TForm)
    btnGenerate: TButton;
    eNewPassword: TEdit;
    procedure btnGenerateClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fMain: TfMain;

const
  str_UPPER = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  str_LOWER = 'abcdefghijklmnopqrstuvwxyz';
  str_NUMBS = '0123456789';
  str_CHARS = '@#$&*%_';
  str_COMBS = str_UPPER + str_LOWER + str_NUMBS + str_CHARS;
  psw_chrcnt = Length(str_COMBS);
  psw_lenght = 10;
  min_lenght = 6;
  max_lenght = 50;

var
  p :array [1 .. max_lenght] of Char;

implementation


{$R *.fmx}

procedure TfMain.btnGenerateClick(Sender: TObject);
var
  i :integer;
  str :string;
begin
  //очистка
  for i := 1 to psw_lenght do p[i] := Char(nil);

  //заполняем массив случайными символами
  for i := 1 to psw_lenght do begin
    if p[i] = Char(nil) then
      p[i] := str_COMBS[Random(psw_chrcnt) + 1];
  end;

  //формируем результат
  str := EmptyStr;
  for i := 1 to psw_lenght do str := str + p[i];
  eNewPassword.Text := str;
end;

end.
