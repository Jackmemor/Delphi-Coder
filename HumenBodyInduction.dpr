library HumenBodyInduction;

uses
  SysUtils,
  Classes,
  SPComm;

var
  //串口
  cmBodyInduction: TComm;
  bodyInductionData : PChar;
function initBodyInduction(PortName : PChar;
  PortBaudRate : Integer;
  PortByteSize : Integer;
  PortParity : Integer;
  PortPartyCheak : Integer;
  PortStopBits : Integer):Integer;stdcall;
var
  ret: Integer;
begin
  try
    cmBodyInduction := TComm.Create(nil);
    cmBodyInduction.CommName := StrPas(PortName);
    cmBodyInduction.BaudRate := PortBaudRate;
    cmBodyInduction.ByteSize := TByteSize(PortByteSize - 5);
//    cmBodyInduction.ByteSize := TByteSize(3);
    cmBodyInduction.ParityCheck := Boolean(PortPartyCheak);
//    cmBodyInduction.ParityCheck := False;
    cmBodyInduction.Parity := TParity(PortParity);
//    cmBodyInduction.Parity := TParity(0);
    cmBodyInduction.StopBits := TStopBits(PortStopBits);
//    cmBodyInduction.StopBits := TStopBits(0);
    cmBodyInduction.StartComm;
    ret := 1;
  except
    ret := 0;
  end;
  
   Result := ret;

end;

//关闭端口
function bodyInductionClose():Integer;stdcall;
var
  ret: Integer;
begin
  try
    cmBodyInduction.StopComm;
    cmBodyInduction.Free;
    ret := 1;
  except
    ret := 0;
  end;
   Result := ret;
end;

function HexStrToByte(HesStr: String): Byte;stdcall;
var
  iLen: Integer;
begin
  Result := 0;
  iLen := length(HesStr);
  if iLen <> 2 then Exit;
  If not (HesStr[1] in ['0'..'9', 'A'..'F', 'a'..'f']) Then Exit;
  If not (HesStr[2] in ['0'..'9', 'A'..'F', 'a'..'f']) Then Exit;
  Result := StrToInt('$' + HesStr);
end;


//串口数据接收
procedure cmBodyInductionReceiveData(Sender: TObject;
  Buffer: Pointer; BufferLength: Word);
var
  Len:integer;
  cbuf: array[0..511] of char;
  rstr: string;
  i: integer;
begin

  if BufferLength <= 511 then
  begin
    Move(buffer^, cbuf, BufferLength);
    cbuf[BufferLength] := Char(0);
    rstr:=rstr+String(cbuf);
  end
  else
  begin
    Len:=BufferLength div 511;
    for i:=0 to len-1 do
    begin
      Move(Pointer(Integer(Buffer)+i*511)^,cBuf,511);
      cbuf[511]:=Char(0);
      rstr:=rstr+String(cbuf);
    end;
    Move(Pointer((Integer(Buffer)+len*511))^,cbuf,BufferLength-len*511);
    cbuf[BufferLength-len*511]:=Char(0);
    rstr:=rstr+String(cbuf);
  end;
    bodyInductionData := PChar(rstr);
end;

//获取串口数据
function bodyInductionReadData():PChar;stdcall;
begin
  Result := bodyInductionData;
end;

exports
   initBodyInduction,
   bodyInductionClose,
   bodyInductionReadData;

{$R *.res}


begin
end.
