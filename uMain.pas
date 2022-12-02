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
const
  emp = Char(nil);
var
  i :integer;
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
  //очистка
  for i := 1 to max_lenght do p[i] := Char(nil);
  //Добавляем первый символ из Верхнего или Нижнего регистра
  p[1] := (str_UPPER+str_LOWER)[Random(Length(str_UPPER+str_LOWER)) + 1];
  //Добавляем символ из Верхнего регистра
  add_random_char(str_UPPER);
  //Добавляем символ из Нижнего регистра
  add_random_char(str_LOWER);
  //Добавляем символ из Набора цифр
  add_random_char(str_NUMBS);
  //Добавляем символ из Набора спецсимволов (не может быть в начале пароля)
  add_random_char(str_CHARS);
  //заполняем массив случайными символами
  for i := 2 to psw_lenght do begin
    if p[i] = emp then
      p[i] := str_COMBS[Random(psw_chrcnt) + 1];
  end;
  //формируем результат
  res := EmptyStr;
  for i := 1 to psw_lenght do res := res + p[i];
  eNewPassword.Text := res;
end;

end.
