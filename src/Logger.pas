unit Logger;

interface

Type
  TLogger = class
    class procedure Log(text: string);
  end;

implementation

uses UMain;

class procedure TLogger.Log(text: string);
begin
  Form1.Memo1.Lines.Add(text);
end;

end.
