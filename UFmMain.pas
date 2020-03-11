unit UFmMain;
{------------------------------------------------------------------------------
  采用 Angus Johnson 写的 Diff.pas 单元的功能，比较两个文本，将不同的地方标记出来，分别显示到 2 个 WebBrowser 里面。

  WebBrowser 里面显示纯文本，为了排版，加上 BootStrap CSS框架。

  比较出来的差异的地方，需要加上背景色。这里就需要自己定义背景颜色的 CSS。

  关于 HTML 的几个概念：
  1. 采用 BootStrap 框架，排版会比较自动。
  2. 需要标记背景色的地方，背景色采用自己定义的 CSS，用 <Span class=""> 包围起来就可以有背景色了。
  3. 空格：在 HTML 底下，多个空格最后会被浏览器解释为一个空格。如果要显示多个空格，有两个办法：
  3.1. 用 &nbsp 这个 HTML 标记来代表空格。
  3.2. 上述方法比较麻烦。直接把整段文本，前后用 <pre> 标记包围起来。这样文本里面的回车换行和空格，都被浏览器完整显示。
  3.3. 关于 HTML 里面的空格，这里说得很清楚：https://zh.wikihow.com/%E5%9C%A8HTML%E4%B8%AD%E6%8F%92%E5%85%A5%E7%A9%BA%E6%A0%BC

  因此，先用 diff.pas 对比，并将不同的地方，加上颜色标记，或加上空格以及颜色标记。
  对整个文本，逐行这样做。最后加完标记的文本，用浏览器来显示。

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

    FSrcStringA: TStringList; //要比较大源文本 A ，如果是文件，用它来 LoadFromFile 加载文本文件。
    FSrcStringB: TStringList;  //要比较大源文本 B
    FDestStringA: TStringList;  //比较结果文本 A
    FDestStringB: TStringList;  //比较结果文本 B

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
      ckNone: s := s + '</span>' + c;  //结束
      ckAdd: s := s + '<span class="bg-red">' + c;   //增加的要显示为红色，因为不多出来的内容是危险的。
      ckDelete: s := s + '<span class="bg-blue">' + c;
      ckModify: s := s + '<span class="bg-green">' + c;
    end;
  end;
begin
{--------------------------------------------------------------------------
  比较一行。可能情况：1. 相同；2. 有差异；3. S1有，S2无；4. S2有S1无。
--------------------------------------------------------------------------}
  FDiff.Execute(PChar(S1), PChar(S2), Length(S1), Length(S2));

  //开始把这些字准备为带 HTML 标记的字，如果有差异的话。
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
  //文本显示进浏览器。这里是将文本写入一个 HTML 文件然后用浏览器打开。
  //写入的文件已经包含 BootStrap 框架。

  Fn1 := TPath.Combine(Self.GetMyPath, My_TEMP_PAGE);
  if not FileExists(Fn1) then raise Exception.Create('模板文件没找到！');

  Fn2 := TPath.Combine(Self.GetMyPath, AFileName);

  SLTemp := TStringList.Create;
  try
    SLTemp.LoadFromFile(Fn1);
    STemp := SLTemp.Text;

    STemp := ReplaceStr(STemp, '<##>', sL.Text); // 替换填充符

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
  //开始比较。比较两个 Memo 里面的文本字符串。
  //逐行比较。 是否可以全文比较 -- 比逐行比较，多了几个回车符而已。
  //经过测试，不需要逐行比较，全文比较就可以了。

  Self.PrapareBuffers;

//  FSrcStringA.AddStrings(Memo1.Lines);
//  FSrcStringB.AddStrings(Memo2.Lines);

//  ACount := FSrcStringA.Count;
//  if ACount < FSrcStringB.Count then ACount := FSrcStringB.Count;

//  S1 := FSrcStringA.Text;
//  S2 := FSrcStringB.Text;
  S1 := Memo1.Lines.Text;
  S2 := Memo2.Lines.Text; //todo: 这里发现 Memo 自动折行显示的字符串，在折行出它会加上回车换行符！

  Self.CompareOneLine(S1, S2, Sd1, Sd2);
  FDestStringA.Add(Sd1);
  FDestStringB.Add(Sd2);



  Self.ShowTextInWebBrowser('CompareFile1.html', WebBrowser1, FDestStringA);
  Self.ShowTextInWebBrowser('CompareFile2.html', WebBrowser2, FDestStringB);

end;



end.
