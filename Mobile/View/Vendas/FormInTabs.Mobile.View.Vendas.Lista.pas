unit FormInTabs.Mobile.View.Vendas.Lista;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FormInTabs.Mobile.View.FormModel, FMX.Layouts, FMX.Objects,
  FMX.Controls.Presentation, FMX.TabControl, System.Generics.Collections;

type
  TFormVendaLista = class(TFormModel)
    lytLoading: TLayout;
    AniIndicator1: TAniIndicator;
    Button1: TButton;
    procedure btnHeaderRightClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FThread: TThread;
    FObjLst: TObjectList<TObject>;
    procedure LoadingShow;
    procedure LoadingHide;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormVendaLista: TFormVendaLista;

implementation

uses
  FormInTabs.Mobile.View.Vendas.Crud,
  FormInTabs.Mobile.View.Vendas.ItemList;

{$R *.fmx}

procedure TFormVendaLista.btnHeaderRightClick(Sender: TObject);
begin
  inherited;
  OpenForm(TFormVendaCrud);
end;

procedure TFormVendaLista.Button1Click(Sender: TObject);
begin
  inherited;
  FThread := TThread.CreateAnonymousThread(
    procedure
    var
      LFil: TfilVenda;
      I: Integer;
    begin
      try
        TThread.Synchronize(nil,
          procedure
          begin
            LoadingShow;
            FObjLst.Clear;
            vtsList.BeginUpdate;
          end);
        // Processo lento pgando de um servidor
        TThread.Sleep(10000);

        for I := 0 to 49 do
        begin
          if TThread.CurrentThread.CheckTerminated then
            Break;
          LFil := TfilVenda.Create(vtsList);
          FObjLst.Add(LFil);
          LFil.Name := LFil.ClassName + vtsList.Content.ChildrenCount.ToString;
          LFil.Align := TAlignLayout.Top;
          vtsList.AddObject(LFil);

          LFil.Descricao := 'Teste';
          LFil.Position.Y := LFil.Height * vtsList.Content.ChildrenCount;
        end;
        if TThread.CurrentThread.CheckTerminated then
         Exit;
        // outro processo
      finally
        if not TThread.CurrentThread.CheckTerminated then
        begin
          TThread.Synchronize(nil,
            procedure
            begin
              FThread := nil;
              vtsList.EndUpdate;
              LoadingHide;
            end);
        end;
      end;
    end);
  FThread.Start;
end;

procedure TFormVendaLista.FormCreate(Sender: TObject);
begin
  inherited;
  FObjLst := TObjectList<TObject>.Create;
end;

procedure TFormVendaLista.FormDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FThread) then
    FThread.Terminate;
end;

procedure TFormVendaLista.LoadingHide;
begin
  lytLoading.Visible := False;
  AniIndicator1.Enabled := False;
end;

procedure TFormVendaLista.LoadingShow;
begin
  lytLoading.Visible := True;
  AniIndicator1.Enabled := True;
end;

end.
