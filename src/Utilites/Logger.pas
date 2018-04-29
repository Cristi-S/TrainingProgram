unit Logger;

interface

uses
  Winapi.Windows, SysUtils;

Type
  TLogger = class
    class procedure Log(sText: string; iHierarchy: integer = 0);
    class procedure Append(sText: string);
    class procedure EnableCouner();
    class procedure DisableCouner();
  end;

var
  Enabled: boolean = True;
  counter: integer = 0;

implementation

uses UMain;

class procedure TLogger.Log(sText: string; iHierarchy: integer = 0);
var
  sHierarchy: string;
  sCounter: string;
begin
  if Enabled then
  begin
    if counter > 0 then
    begin
      sCounter := IntToStr(counter) + '. ';
      Inc(counter);
    end
    else
      sCounter := '';

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
    FormMain.Memo1.Lines.Add(sCounter + sHierarchy + sText);
  end;
end;

class procedure TLogger.Append(sText: string);
var
  str: string;
begin
  if Enabled then
  begin
    str := FormMain.Memo1.Lines.Text;
    str := Trim(str);
    FormMain.Memo1.Lines.Text := str + ' ' + sText;
  end;
end;

class procedure TLogger.EnableCouner();
begin
  counter := 1;
end;

class procedure TLogger.DisableCouner();
begin
  counter := 0;
end;

end.
