unit Logger;

interface

uses
  Winapi.Windows;

Type
  TLogger = class
    class procedure Log(sText: string; iHierarchy: integer = 0);
  end;

implementation

uses UMain;

class procedure TLogger.Log(sText: string; iHierarchy: integer = 0);
var
  sHierarchy: string;
begin
  case iHierarchy of
    0:
      begin
        sHierarchy := '';
      end;
    1:
      begin
        sHierarchy := chr(VK_TAB);
      end;
    2:
      begin
        sHierarchy := chr(VK_TAB) + chr(VK_TAB);
      end;
  end;
  Form1.Memo1.Lines.Add(sHierarchy + sText);
end;

end.
