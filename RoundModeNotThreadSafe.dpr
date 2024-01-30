program RoundModeNotThreadSafe;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Classes,
  System.DateUtils,
  System.Math;

procedure PrintCW(iScope: string);
begin
  WriteLn(Format('%-30s def: %.4x   current: %.4x  RM: %d', [iScope, Default8087CW, Get8087CW, ord(GetRoundMode)]));
end;

procedure ThreadProc;
begin
  PrintCW('Thread ' + FormatDateTime('hh:nn:ss.zzz', OneHour));
end;

begin
  PrintCW('MainThread init');

  try
    // Alter Rounding mode, run a background thread, change it back
    SetRoundMode(rmDown);
    try
      PrintCW('MainThread after rmDown');
      TThread.CreateAnonymousThread(ThreadProc).Start;
      Sleep(1000);
    finally
      SetRoundMode(rmNearest);
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
