program RoundModeNotThreadSafe;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Classes,
  System.DateUtils,
  System.Math;


procedure Set8087CWThreadSafe(ANewCW: Word);
var
  L8087CW: Word;
asm
  mov L8087CW, ANewCW
  fnclex
  fldcw L8087CW
end;

function SetRoundModeThreadSafe(const RoundMode: TRoundingMode): TRoundingMode;
var
  CtlWord: Word;
begin
  CtlWord := Get8087CW;
  Set8087CWThreadSafe((CtlWord and $F3FF) or (Ord(RoundMode) shl 10));
  Result := TFPURoundingMode((CtlWord shr 10) and 3);
end;


procedure PrintCW(iScope: string);
begin
  WriteLn(Format('%-30s def: %.4x   current: %.4x  RM: %d', [iScope, Default8087CW, Get8087CW, ord(GetRoundMode)]));
end;

procedure ThreadProc;
begin
  PrintCW('Thread ' + FormatDateTime('hh:nn:ss.zzz', OneHour));
end;

begin
  try
    WriteLn('Delphi non-thread-safe SetRoundMode:');
    WriteLn;

    PrintCW('MainThread init');

    // Alter Rounding mode, run a background thread, change it back
    SetRoundMode(rmDown);
    try
      PrintCW('MainThread after rmDown');
      TThread.CreateAnonymousThread(ThreadProc).Start;
      Sleep(500);
    finally
      SetRoundMode(rmNearest);
    end;

    // Run another thread
    PrintCW('MainThread after rmNearest');

    TThread.CreateAnonymousThread(ThreadProc).Start;
    Sleep(500);

    // Now do everything again with a thread-safe version of SetRoundMode
    WriteLn;
    WriteLn('Custom thread-safe SetRoundMode:');
    WriteLn;

    PrintCW('MainThread init');

    // Alter Rounding mode, run a background thread, change it back
    SetRoundModeThreadSafe(rmDown);
    try
      PrintCW('MainThread after rmDown');
      TThread.CreateAnonymousThread(ThreadProc).Start;
      Sleep(500);
    finally
      SetRoundModeThreadSafe(rmNearest);
    end;

    // Run another thread
    PrintCW('MainThread after rmNearest');

    TThread.CreateAnonymousThread(ThreadProc).Start;

    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
