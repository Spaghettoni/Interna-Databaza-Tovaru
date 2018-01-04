unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Vyhladat: TButton;
    Pridat: TButton;
    Vymazat: TButton;
    sortByCode: TButton;
    sortByName: TButton;
    Reload: TButton;
    Zmenit: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    procedure VyhladatClick(Sender: TObject);
    procedure PridatClick(Sender: TObject);
    procedure VymazatClick(Sender: TObject);
    procedure sortByCodeClick(Sender: TObject);
    procedure sortByNameClick(Sender: TObject);
    procedure ReloadClick(Sender: TObject);
    procedure ZmenitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure recognize();
    procedure vypis();
    procedure prepis();
    procedure zapis();
  private
    { private declarations }
  public
    { public declarations }
  end;
  type
    zoznam=record
      kod:string;
      nazov:string;
    end;

var
  Form1: TForm1;
  tovar:array [1..10] of zoznam;
  upperkase:array [1..10] of string;
  search:array [1..10] of zoznam;
  doc:TextFile;
  lines,a,i,b,x,k:integer;
  znak:char;
  cislo:boolean;
  input:string;
implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var i,k:integer;
var kod:string;
begin

  for i:=1 to 10 do begin
    tovar[i].nazov:='';
    tovar[i].kod:='';
  end;
  x:=0;
  k:=1;
  kod:='';
  AssignFile(doc,'tovar.txt');
  Reset(doc);
  readln(doc,lines);
  while not eof(doc) do begin
    inc(x);
    for i:=1 to 6 do begin
      read(doc,znak);
      tovar[k].kod:=tovar[k].kod+znak;
    end;
    read(doc,znak);
    readln(doc,tovar[k].nazov);
    inc(k);
    kod:='';
  end;
  CloseFile(doc);
  vypis();
  for i:=1 to x do
   upperkase[i]:=UpperCase(tovar[i].nazov);
end;

procedure TForm1.VyhladatClick(Sender: TObject);
var q,n:integer;
begin
  recognize;
if (input='') then begin
     ShowMessage('Prázdne pole!');
end else begin
   q:=0;
   b:=0;
   n:=1;
 {  Memo1.Append(IntToStr(x));
   Memo1.Append(IntToStr(q));
   Memo1.Append(IntToStr(a));  }
   if (b=0) then begin  //ak je to cislo
     for i:=1 to x do begin
       q:=0;
       for k:=1 to a do begin
         if (tovar[i].kod[k]=input[k]) then begin
           inc(q);
          { Memo1.Append('i'+IntToStr(i));
           Memo1.Append('k'+IntToStr(k));
           Memo1.Append('q'+IntToStr(q));}
         end;
       end;
       if (q=a) then begin
         search[n].kod:=tovar[i].kod;
         search[n].nazov:=tovar[i].nazov;
         inc(n);
       end;
     end;
     Memo1.Clear;
     for i:=1 to n-1 do
     Memo1.Append(search[i].kod+';'+search[i].nazov);
   end else begin
    for i:=1 to x do begin
       if (upperkase[i]=input) then begin
         Memo1.Clear;
         Memo1.Append(tovar[i].kod+';'+tovar[i].nazov);
       end;
     end;
   end;


end;

end;

procedure TForm1.PridatClick(Sender: TObject);
begin
  input:=(Edit4.Text);
  a:=0;
  b:=0;
  for i:=1 to 6 do begin
      case input[i] of
        '0'..'9' : inc(a);
        'A'..'Z' : inc(b);
      end;
    end;

  if (a=6) then begin
    tovar[x+1].kod:=Edit4.Text;
    tovar[x+1].nazov:=Edit5.Text;
    prepis();
  end else
      ShowMessage('Zadajte spravny format kodu!');


  x:=0;
  for i:=1 to 10 do begin
     if (tovar[i].nazov<>'') then
       inc(x);
  end;
  zapis();
  vypis();
end;

procedure TForm1.VymazatClick(Sender: TObject);
begin
  recognize;
if (input='') then begin
    ShowMessage('Prázdne pole!');
end else begin

  if (a=6) then begin  //ak je to cislo
     for i:=1 to x do begin
       if (tovar[i].kod=input) then begin
         for k:=i to (x-1) do begin
         tovar[k].nazov:=tovar[k+1].nazov;
         tovar[k].kod:=tovar[k+1].kod;
         end;
         tovar[x].kod:='';
         tovar[x].nazov:='';
         prepis();
         zapis();
       end;
     end;
   end else begin
    for i:=1 to x do begin
       if (upperkase[i]=input) then begin
         for k:=i to (x-1) do begin
         tovar[k].nazov:=tovar[k+1].nazov;
         tovar[k].kod:=tovar[k+1].kod;
         end;
         tovar[x].kod:='';
         tovar[x].nazov:='';
         prepis();
         zapis();
       end;
     end;
   end;


   x:=0;
  for i:=1 to 10 do begin
     if (tovar[i].nazov<>'') then
       inc(x);
  end;
  zapis();
  vypis();
end;

end;

procedure TForm1.sortByCodeClick(Sender: TObject);
begin
  Memo1.Clear;
  Memo1.Append(IntToStr(x));
  for i:=x downto 1 do begin
    if (tovar[i].kod<>'') then
      Memo1.Append(tovar[i].kod+';'+tovar[i].nazov);
  end;
end;

procedure TForm1.sortByNameClick(Sender: TObject);
begin
  vypis();
end;

procedure TForm1.ReloadClick(Sender: TObject);
begin
  vypis();
end;

procedure TForm1.ZmenitClick(Sender: TObject);
begin
  input:=UpperCase(Edit2.Text);
    for i:=1 to 6 do begin
      case input[i] of
        '0'..'9' : inc(a);

      end;
    end;
  if (a>=1) AND (a<6) then
    ShowMessage('Zadajte spravny format tovaru!');


  vypis();
end;

procedure TForm1.recognize();
begin
  a:=0;
  b:=0;
  input:=UpperCase(Edit1.Text);

  for i:=1 to 6 do begin
       case input[i] of
         '0'..'9' : inc(a);
         'A'..'Z' : inc(b);
       end;
  end;

  x:=0;
  for i:=1 to 10 do begin
     if (tovar[i].nazov<>'') then
       inc(x);
  end;
end;

procedure TForm1.vypis();
begin
   Memo1.Clear;
   Memo1.Append(IntToStr(x));
  for i:=1 to x do
      if (tovar[i].kod<>'') then
        Memo1.Append(tovar[i].kod+';'+tovar[i].nazov);

end;
procedure TForm1.prepis();
begin
  for i:=1 to x do
     upperkase[i]:=tovar[i].nazov;
  end;
procedure TForm1.zapis();
begin
  AssignFile(doc,'tovar.txt');
  Rewrite(doc);
  writeLn(doc,x);
  for i:=1 to x do begin
      writeLn(doc,tovar[i].kod+';'+tovar[i].nazov);
  end;
  closeFile(doc);

end;

end.

