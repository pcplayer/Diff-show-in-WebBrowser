unit UFmMain;
{------------------------------------------------------------------------------
  ���� Angus Johnson д�� Diff.pas ��Ԫ�Ĺ��ܣ��Ƚ������ı�������ͬ�ĵط���ǳ������ֱ���ʾ�� 2 �� WebBrowser ���档

  WebBrowser ������ʾ���ı���Ϊ���Ű棬���� BootStrap CSS��ܡ�

  �Ƚϳ����Ĳ���ĵط�����Ҫ���ϱ���ɫ���������Ҫ�Լ����屳����ɫ�� CSS��

  ���� HTML �ļ������
  1. ���� BootStrap ��ܣ��Ű��Ƚ��Զ���
  2. ��Ҫ��Ǳ���ɫ�ĵط�������ɫ�����Լ������ CSS���� <Span class=""> ��Χ�����Ϳ����б���ɫ�ˡ�
  3. �ո��� HTML ���£�����ո����ᱻ���������Ϊһ���ո����Ҫ��ʾ����ո��������취��
  3.1. �� &nbsp ��� HTML ���������ո�
  3.2. ���������Ƚ��鷳��ֱ�Ӱ������ı���ǰ���� <pre> ��ǰ�Χ�����������ı�����Ļس����кͿո񣬶��������������ʾ��
  3.3. ���� HTML ����Ŀո�����˵�ú������https://zh.wikihow.com/%E5%9C%A8HTML%E4%B8%AD%E6%8F%92%E5%85%A5%E7%A9%BA%E6%A0%BC

  ��ˣ����� diff.pas �Աȣ�������ͬ�ĵط���������ɫ��ǣ�����Ͽո��Լ���ɫ��ǡ�
  �������ı����������������������ǵ��ı��������������ʾ��

  pcplayer 2018-10-13
------------------------------------------------------------------------------}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, SHDocVw, Vcl.StdCtrls,
  Vcl.ExtCtrls, Diff, mshtml, ActiveX, System.IoUtils;

type
  TFmMain = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter1: TSplitter;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Memo1: TMemo;
    Memo2: TMemo;
    WebBrowser1: TWebBrowser;
    WebBrowser2: TWebBrowser;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    FDiff: TDiff;

    FSrcStringA: TStringList; //Ҫ�Ƚϴ�Դ�ı� A ��������ļ��������� LoadFromFile �����ı��ļ���
    FSrcStringB: TStringList;  //Ҫ�Ƚϴ�Դ�ı� B
    FDestStringA: TStringList;  //�ȽϽ���ı� A
    FDestStringB: TStringList;  //�ȽϽ���ı� B

    function GetMyPath: string;
    procedure CompareOneLine(const S1, S2: string; var Sd1, Sd2: string);
    procedure ShowTextInWebBrowser(const AFileName: string; WebBrowser: TWebBrowser; SL: TStringList);

    procedure PrapareBuffers;
    procedure StartCompare;
  public
    { Public declarations }
  end;

var
  FmMain: TFmMain;

implementation

uses System.StrUtils;

const My_TEMP_PAGE = 'StartPage.html';

{$R *.dfm}

{ TFmMain }

procedure TFmMain.Button1Click(Sender: TObject);
begin
  Self.StartCompare;
end;

procedure TFmMain.CompareOneLine(const S1, S2: string; var Sd1, Sd2: string);
var
  LastKind: TChangeKind;
  i: Integer;
  AChar: Char;

  procedure AddCharToStr(var s: string; c: Char; Kind, Lastkind: TChangeKind);
  begin
    if (Kind = lastKind) then
      s := s + c //no need to change colors
    else
    case kind of
      ckNone: s := s + '</span>' + c;  //����
      ckAdd: s := s + '<span class="bg-red">' + c;   //���ӵ�Ҫ��ʾΪ��ɫ����Ϊ���������������Σ�յġ�
      ckDelete: s := s + '<span class="bg-blue">' + c;
      ckModify: s := s + '<span class="bg-green">' + c;
    end;
  end;
begin
{--------------------------------------------------------------------------
  �Ƚ�һ�С����������1. ��ͬ��2. �в��죻3. S1�У�S2�ޣ�4. S2��S1�ޡ�
--------------------------------------------------------------------------}
  FDiff.Execute(PChar(S1), PChar(S2), Length(S1), Length(S2));

  //��ʼ����Щ��׼��Ϊ�� HTML ��ǵ��֣�����в���Ļ���
  LastKind := ckNone;
  Sd1 := '';
  Sd2 := '';

  for i := 0 to FDiff.count-1 do
  begin
    with FDiff.Compares[i] do
    begin

      //show changes to first string (with spaces for adds to align with second string)
      if Kind = ckAdd then
      begin
        if (Chr2 = Char(#13)) or (Chr2 = Char(#10)) then AChar := Chr2
        else AChar := Char(' ');

        AddCharToStr(Sd1, AChar, Kind, LastKind)
      end
      else AddCharToStr(Sd1, Chr1, Kind, LastKind);

      //show changes to second string (with spaces for deletes to align with first string)
      if Kind = ckDelete then
      begin
        if (Chr1 = Char(#13)) or (Chr1 = Char(#10)) then AChar := Chr1
        else AChar := Char(' ');

        AddCharToStr(Sd2, AChar, Kind, lastKind)
      end
      else AddCharToStr(Sd2, Chr2, Kind, LastKind);

      lastKind := Kind;
    end;
  end;

end;

procedure TFmMain.FormCreate(Sender: TObject);
begin
  FDiff := TDiff.Create(Self);
end;

procedure TFmMain.FormResize(Sender: TObject);
begin
  Panel4.Width := Trunc(Self.Width / 2);
  Panel6.Width := Panel4.Width;
end;

function TFmMain.GetMyPath: string;
begin
  Result := ExtractFilePath(Application.ExeName);
end;

procedure TFmMain.PrapareBuffers;
begin
  if not Assigned(FSrcStringA) then FSrcStringA := TStringList.Create;
  if not Assigned(FSrcStringB) then FSrcStringB := TStringList.Create;
  if not Assigned(FDestStringA) then FDestStringA := TStringList.Create;
  if not Assigned(FDestStringB) then FDestStringB := TStringList.Create;

  FSrcStringA.Clear;
  FSrcStringB.Clear;
  FDestStringA.Clear;
  FDestStringB.Clear;
end;

procedure TFmMain.ShowTextInWebBrowser(const AFileName: string; WebBrowser: TWebBrowser;
  SL: TStringList);
var
  Fn1, Fn2: string;
  STemp: string;
  SLtemp: TStringList;
begin
  //�ı���ʾ��������������ǽ��ı�д��һ�� HTML �ļ�Ȼ����������򿪡�
  //д����ļ��Ѿ����� BootStrap ��ܡ�

  Fn1 := TPath.Combine(Self.GetMyPath, My_TEMP_PAGE);
  if not FileExists(Fn1) then raise Exception.Create('ģ���ļ�û�ҵ���');

  Fn2 := TPath.Combine(Self.GetMyPath, AFileName);

  SLTemp := TStringList.Create;
  try
    SLTemp.LoadFromFile(Fn1);
    STemp := SLTemp.Text;

    STemp := ReplaceStr(STemp, '<##>', sL.Text); // �滻����

    SLTemp.Text := STemp;
    SLTemp.SaveToFile(Fn2);
  finally
    SLTemp.Free;
  end;

  WebBrowser.Navigate('file://' + Fn2);
end;

procedure TFmMain.StartCompare;
var
  S1, S2, Sd1, Sd2: string;
  i, ACount: Integer;
  StreamA, StreamB: TMemoryStream;
begin
  //��ʼ�Ƚϡ��Ƚ����� Memo ������ı��ַ�����
  //���бȽϡ� �Ƿ����ȫ�ıȽ� -- �����бȽϣ����˼����س������ѡ�
  //�������ԣ�����Ҫ���бȽϣ�ȫ�ıȽϾͿ����ˡ�

  Self.PrapareBuffers;

//  FSrcStringA.AddStrings(Memo1.Lines);
//  FSrcStringB.AddStrings(Memo2.Lines);

//  ACount := FSrcStringA.Count;
//  if ACount < FSrcStringB.Count then ACount := FSrcStringB.Count;

//  S1 := FSrcStringA.Text;
//  S2 := FSrcStringB.Text;
  S1 := Memo1.Lines.Text;
  S2 := Memo2.Lines.Text; //todo: ���﷢�� Memo �Զ�������ʾ���ַ����������г�������ϻس����з���

  Self.CompareOneLine(S1, S2, Sd1, Sd2);
  FDestStringA.Add(Sd1);
  FDestStringB.Add(Sd2);



  Self.ShowTextInWebBrowser('CompareFile1.html', WebBrowser1, FDestStringA);
  Self.ShowTextInWebBrowser('CompareFile2.html', WebBrowser2, FDestStringB);

end;



end.
