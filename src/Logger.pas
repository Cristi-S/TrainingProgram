unit Logger;

interface

uses
  Winapi.Windows;

Type
  TLogger = class
  public
    class procedure Log(sText: string; iHierarchy: integer = 0);
  end;

var
  Enabled: boolean = True;

implementation

uses UMain;

class procedure TLogger.Log(sText: string; iHierarchy: integer = 0);
var
  sHierarchy: string;
begin
  if Enabled then
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
end;

end.
