unit FormInTabs.Mobile.View.Vendas.ItemList;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts;

type
  TfilVenda = class(TFrame)
    lblDescricao: TLabel;
    lytBackground: TLayout;
    procedure lytBackgroundPainting(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
  private
    FDescricao: string;
    procedure SetDescricao(const Value: string);
    { Private declarations }
  public
  property Descricao: string read FDescricao write SetDescricao;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TfilVenda }

procedure TfilVenda.lytBackgroundPainting(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  if lytBackground.Tag <> 0 then
    Exit;
  lytBackground.Tag := 1;

  lblDescricao.Text := Descricao;
end;

procedure TfilVenda.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

end.
