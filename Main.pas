unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,StdCtrls,ComObj,TlHelp32,FileCtrl, ExtCtrls, Buttons;

type
  TCheckTest = class(TForm)
    dlgOpen1: TOpenDialog;
    pnl1: TPanel;
    lblMessage: TLabel;
    btnOutput: TButton;
    mmoMessage: TMemo;
    btninput: TButton;
    btnClose: TButton;
    procedure btninputClick(Sender: TObject);
    procedure btnOutputClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    function KillWordTask : integer;
    procedure Comparison (TitleTemp :TStringList);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CheckTest: TCheckTest;

implementation

{$R *.dfm}

procedure TCheckTest.btn1Click(Sender: TObject);

begin
  lblMessage.Font.Name := 'Noto Sans TC Regular';
  btninput.Font.Name := 'Noto Sans TC Regular';
  btnOutput.Font.Name := 'Noto Sans TC Regular';
  btnClose.Font.Name := 'Noto Sans TC Regular';
end;

procedure TCheckTest.btnCloseClick(Sender: TObject);
begin
Close;
end;

procedure TCheckTest.btninputClick(Sender: TObject);
var
WordApp,WordDoc, myRange : Variant ;
i,x,y : Integer;
TitleTemp  : TStringList;
check : Boolean;
begin
  check := False;
  KillWordTask;
  TitleTemp := TStringList.Create ;
  WordApp := CreateOleObject('Word.Application');
  if dlgOpen1.Execute then  WordDoc := WordApp.Documents.Open(dlgOpen1.FileName)
  else
    begin
      ShowMessage('�п���ɮ�');
      Exit;
    end;
  myRange := WordDoc.Content;
try
  mmoMessage.Clear;
  try
    if WordDoc.Tables.Item(1).Columns.Count  <> 26 then mmoMessage.Lines.Add('Word��Ƥ����T');
  except
    mmoMessage.Lines.Add('Word��Ƥ����T');
    Exit;
  end;

  mmoMessage.Lines.Add('�СССССФ���Ƥ�...�ССССС�');

  for i  := 2 to WordDoc.Tables.Item(1).Columns.Count   do
    begin
      mmoMessage.Lines.Add('�СССССХثe�i��'+IntToStr(i)+'/'+IntToStr(WordDoc.Tables.Item(1).Columns.Count)+'�ССССС�');
      if (i = 12)  then
        begin
          for x  := 2 to WordDoc.Tables.Item(1).Rows.Count  do
            begin
              for y:=1 to length(Trim(WordDoc.Tables.Item(1).Cell(x,i).Range.Text)) do
                if not (Trim(WordDoc.Tables.Item(1).Cell(x,i).Range.Text)[y] in ['0'..'9','.','-']) and (check = False)  then
                  begin
                    mmoMessage.Lines.Add('�]�w���~�G[ ��'+IntToStr(i)+'�C�B��'+IntToStr(x)+'�� ] �����Ʀr');
                    check := True;
                  end;
                  check := False;
            end;
        end

      else if (i = 2 ) or (i = 8 ) or (i =9) or (i =10) or (i =11) or (i =13) or (i =14) or (i =15) or (i =17) or (i =19) then
        begin
          for x  := 2 to WordDoc.Tables.Item(1).Rows.Count  do
            begin
              if  Trim(WordDoc.Tables.Item(1).Cell(x,i).Range.Text) = '' then
                mmoMessage.Lines.Add('�]�w���~�G[ ��'+IntToStr(i)+'�C�B��'+IntToStr(x)+'�� ] ���ର��')
            end;
        end ;
      TitleTemp.Add(Trim(WordDoc .Tables.Item(1).Cell(1,i).Range.Text));
    end;
  Comparison(TitleTemp);
finally
  mmoMessage.Lines.Add('�СССССФ�ﵲ���ССССС�');
  WordApp.Quit;
  WordApp:=Unassigned;
end;
end;

procedure TCheckTest.btnOutputClick(Sender: TObject);
Var
RCS : TResourceStream;
dirpath : string;
begin
mmoMessage.Clear;
if SelectDirectory('��ܶץX��m','',dirpath) then
  begin
    RCS := TResourceStream.Create(HInstance, 'WordExample','Word');
    RCS.SaveToFile(dirpath+'\QuExp.docx'); //�t�s�ɮ�
    RCS.Free;
  end;
  mmoMessage.Text := '---�ץX���\---';
end;
function TCheckTest.KillWordTask : integer;
const
  PROCESS_TERMINATE=$0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  result := 0;

  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = 'WINWORD.EXE') or
       (UpperCase(FProcessEntry32.szExeFile) = 'WINWORD.EXE')) then
      Result := Integer(TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0),FProcessEntry32.th32ProcessID), 0));
    ContinueLoop := Process32Next(FSnapshotHandle,FProcessEntry32);
  end;

  CloseHandle(FSnapshotHandle);
end;

procedure TCheckTest.Comparison (TitleTemp :TStringList);
var
TitleArray  : TStringList;
i : Integer;
begin
  TitleArray := TStringList.Create;
  TitleArray.Add('�D��');
  TitleArray.Add('1�ﶵ');
  TitleArray.Add('2�ﶵ');
  TitleArray.Add('3�ﶵ');
  TitleArray.Add('4�ﶵ');
  TitleArray.Add('5�ﶵ');
  TitleArray.Add('�зǵ���');
  TitleArray.Add('�D��');
  TitleArray.Add('���O');
  TitleArray.Add('�Ҭ�');
  TitleArray.Add('�~��');
  TitleArray.Add('�D��');
  TitleArray.Add('�{��');
  TitleArray.Add('���');
  TitleArray.Add('�����I');
  TitleArray.Add('������');
  TitleArray.Add('�Ը�');
  TitleArray.Add('�R�D��');
  TitleArray.Add('�f�D��');
  TitleArray.Add('�D���D');
  TitleArray.Add('��ĳ�D');
  TitleArray.Add('QID');
  TitleArray.Add('���D��');
  TitleArray.Add('�����v');
  TitleArray.Add('�����D');
  mmoMessage.Lines.Add('�СССССФ����D�ССССС�');
  for i := 0 to TitleArray.Count -1 do
    if TitleArray[i] <> Trim(TitleTemp[i])  then  mmoMessage.Lines.Add('�]�w���~�G[ ��'+IntToStr(i)+'�C ] ���D���~');
end;

procedure TCheckTest.FormDestroy(Sender: TObject);
begin
  RemoveFontResource(PChar('NotoSansTC.otf'));
  SendMessage(HWND_BROADCAST,WM_FONTCHANGE,0,0);
end;

procedure TCheckTest.FormShow(Sender: TObject);
Var
RCS : TResourceStream;
begin
  RCS := TResourceStream.Create(hInstance, 'NotoSansTC', Pchar('otf'));
  RCS.SavetoFile('NotoSansTC.otf');
  RCS.Free;
  AddFontResource(PChar('NotoSansTC.otf'));
  SendMessage(HWND_BROADCAST,WM_FONTCHANGE,0,0);

  lblMessage.Font.Name := 'Noto Sans TC Regular';
  btninput.Font.Name := 'Noto Sans TC Regular';
  btnOutput.Font.Name := 'Noto Sans TC Regular';
  btnClose.Font.Name := 'Noto Sans TC Regular';
end;


end.
