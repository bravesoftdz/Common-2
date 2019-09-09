unit uForm;

interface

uses
  Windows, Messages, Classes, SysUtils, Forms, Menus, ExtCtrls,
  StdCtrls, ComCtrls, ActnList, StdActns, Buttons, Dialogs, PngBitBtn,
  ICSLanguages;

type
  TfrmForm = class(TForm)
    ICSLanguages1: TICSLanguages;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FAlignToSystemTray: Boolean;
    procedure OnAppSetLanguageMsg(var Msg: TMessage); message ICS_SETLANGUAGE_MSG;
    procedure SetCaptions(LanguageId: Integer);
    procedure OnWMSettingChange(var Msg: TWMSettingChange); message WM_SETTINGCHANGE;
    procedure OnWMDisplayChange(var Msg: TWMDisplayChange); message WM_DISPLAYCHANGE;
    procedure SetAlignToSystemTray(const Value: Boolean);
  public
    procedure CheckPosition;
    property AlignToSystemTray: Boolean read FAlignToSystemTray write SetAlignToSystemTray default False;
  end;

var
  frmForm: TfrmForm;
  ICSCurrentLanguageString: String = 'ENU';

implementation

uses uVCLTools;

{$R *.dfm}

{ TfrmForm }

procedure TfrmForm.CheckPosition;
 var
   L, T: Integer;
   CurrentMonitor: TMonitor;
   P: TPoint;
begin
  L := Left; T := Top;
  if Top < Screen.DesktopTop then T := Screen.DesktopTop;
  if L  < Screen.DesktopLeft then L := Screen.DesktopLeft;
  if L + Width > Screen.DesktopWidth then L := Screen.DesktopWidth - Width;
  if T + Height > Screen.DesktopHeight then T := Screen.DesktopWidth - Height;

  P.X := L + Width div 2; P.Y := T + Height div 2;
  CurrentMonitor := Screen.MonitorFromPoint(P);

  if Top < CurrentMonitor.Top then T := CurrentMonitor.Top;
  if L  < CurrentMonitor.Left then L := CurrentMonitor.Left;
  if L + Width > CurrentMonitor.Left + CurrentMonitor.Width then L := CurrentMonitor.Left + CurrentMonitor.Width - Width;
  if T + Height > CurrentMonitor.Top + CurrentMonitor.Height then T := CurrentMonitor.Top + CurrentMonitor.Height - Height;

  SetBounds(L, T, Width, Height);
end;

procedure TfrmForm.FormShow(Sender: TObject);
begin
  CheckPosition;
end;

procedure TfrmForm.OnAppSetLanguageMsg(var Msg: TMessage);
begin
  SetCaptions(Msg.WParam);
end;

procedure TfrmForm.SetAlignToSystemTray(const Value: Boolean);
begin
  FAlignToSystemTray := Value;
  if FAlignToSystemTray then SetPositionToSystemTray(Self);
end;

procedure TfrmForm.SetCaptions(LanguageId: Integer);
 var I, J: Integer;
begin
  if ICSLanguages1.Languages.Count = 0 then Exit;
  if LanguageId >= 0 then ICSLanguages1.CurrentLanguageID := LanguageId else ICSLanguages1.CurrentLanguageString := ICSCurrentLanguageString;
  if (Tag >= 0) and (ICSLanguages1.CurrentStrings[Tag] <> '') then Caption := ICSLanguages1.CurrentStrings[Tag];
  for I := 0 to ComponentCount - 1 do if (Components[I].Tag > 0) and (Components[I].Tag < ICSLanguages1.CurrentStrings.Count) then begin
    if Components[I] is TAction then begin
      (Components[I] as TAction).Caption := ICSLanguages1.CurrentStrings[Components[I].Tag];
      (Components[I] as TAction).Hint := ICSLanguages1.CurrentStrings[Components[I].Tag];
    end else
    if Components[I] is TMenuItem then (Components[I] as TMenuItem).Caption := ICSLanguages1.CurrentStrings[Components[I].Tag] else
    if Components[I] is TLabel then (Components[I] as TLabel).Caption := ICSLanguages1.CurrentStrings[Components[I].Tag] else
    if Components[I] is TButton then (Components[I] as TButton).Caption := ICSLanguages1.CurrentStrings[Components[I].Tag] else
    if Components[I] is TBitBtn then (Components[I] as TBitBtn).Caption := ICSLanguages1.CurrentStrings[Components[I].Tag] else
    if Components[I] is TSpeedButton then begin
      if (Components[I] as TSpeedButton).ShowHint then (Components[I] as TSpeedButton).Hint := ICSLanguages1.CurrentStrings[Components[I].Tag] else (Components[I] as TSpeedButton).Caption := ICSLanguages1.CurrentStrings[Components[I].Tag];
    end;
    if Components[I] is TCheckBox then (Components[I] as TCheckBox).Caption := ICSLanguages1.CurrentStrings[Components[I].Tag] else
    if Components[I] is TRadioButton then (Components[I] as TRadioButton).Caption := ICSLanguages1.CurrentStrings[Components[I].Tag] else
    if Components[I] is TGroupBox then (Components[I] as TGroupBox).Caption := ICSLanguages1.CurrentStrings[Components[I].Tag] else
    if Components[I] is TTabSheet then (Components[I] as TTabSheet).Caption := ICSLanguages1.CurrentStrings[Components[I].Tag] else
    if Components[I] is TImage then (Components[I] as TImage).Hint := ICSLanguages1.CurrentStrings[Components[I].Tag] else
    if Components[I] is TTrackBar then (Components[I] as TTrackBar).Hint := ICSLanguages1.CurrentStrings[Components[I].Tag] else
    if Components[I] is TSaveDialog then (Components[I] as TSaveDialog).Filter := ICSLanguages1.CurrentStrings[Components[I].Tag] else
    if Components[I] is TLabeledEdit then (Components[I] as TLabeledEdit).EditLabel.Caption := ICSLanguages1.CurrentStrings[(Components[I] as TLabeledEdit).Tag] else
    if Components[I] is TPngBitBtn then (Components[I] as TPngBitBtn).Caption := ICSLanguages1.CurrentStrings[(Components[I] as TPngBitBtn).Tag] else
    if Components[I] is TListView then for J := 0 to (Components[I] as TListView).Columns.Count - 1 do (Components[I] as TListView).Columns[J].Caption := ICSLanguages1.CurrentStrings[(Components[I] as TListView).Columns[J].Tag];
  end;
end;

procedure TfrmForm.OnWMDisplayChange(var Msg: TWMDisplayChange);
begin
  inherited;
  CheckPosition;
end;

procedure TfrmForm.OnWMSettingChange(var Msg: TWMSettingChange);
begin
  inherited;
  CheckPosition;
end;

procedure TfrmForm.FormCreate(Sender: TObject);
begin
  FAlignToSystemTray := False;
  SendMessage(Handle, ICS_SETLANGUAGE_MSG, -1, 0);
end;

initialization

  ICSCurrentLanguageString := GetCurrentLanguage;
//  if ICSCurrentLanguageString = 'UKR' then

end.
