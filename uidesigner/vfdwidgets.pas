{
    fpGUI  -  Free Pascal GUI Toolkit

    Copyright (C) 2006 - 2009 See the file AUTHORS.txt, included in this
    distribution, for details of the copyright.

    See the file COPYING.modifiedLGPL, included in this distribution,
    for details about redistributing fpGUI.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    Description:
      Setting up of widgets, properties and images.
}

unit vfdwidgets;

{$mode objfpc}{$H+}

interface

uses
  SysUtils,
  Classes,
  contnrs,
  vfdwidgetclass,
  vfdprops,
  typinfo;

procedure RegisterWidgets;
procedure RegisterVFDWidget(awc: TVFDWidgetClass);
function  VFDWidgetCount: integer;
function  VFDWidget(ind: integer): TVFDWidgetClass;
function  VFDFormWidget: TVFDWidgetClass;

var
  VFDOtherWidget: TVFDWidgetClass;

implementation

uses
  fpg_main,
  vfddesigner,
  fpg_widget,
  fpg_form,
  fpg_label,
  fpg_edit,
  fpg_button,
  fpg_listbox,
  fpg_memo,
  fpg_combobox,
  fpg_grid,
  fpg_checkbox,
  fpg_panel,
  fpg_tree,
  fpg_radiobutton,
  fpg_listview,
  fpg_trackbar,
  fpg_menu,
  fpg_progressbar,
  fpg_tab,
  fpg_popupcalendar,
  fpg_gauge,
  vfdpropeditgrid,
  vfdmain;

type
  TVFDPageControlWidgetClass = class(TVFDWidgetClass)
  private
    FWidget: TfpgPageControl;
    procedure AddTabSClicked(Sender: TObject);
    procedure DeleteTabClicked(Sender: TObject);
  public
    function CreatePopupMenu(AWidget: TfpgWidget): TfpgPopupMenu; override;
  end;

{ TVFDPageControlWidgetClass }

procedure TVFDPageControlWidgetClass.AddTabSClicked(Sender: TObject);
begin
  Exit;
  FWidget.AppendTabSheet('TabSheet' + IntToStr(FWidget.PageCount));
end;

procedure TVFDPageControlWidgetClass.DeleteTabClicked(Sender: TObject);
begin
  Exit;
  FWidget.RemoveTabSheet(FWidget.ActivePage);
end;

function TVFDPageControlWidgetClass.CreatePopupMenu(AWidget: TfpgWidget): TfpgPopupMenu;
begin
  FWidget := TfpgPageControl(AWidget);
  Result := TfpgPopupMenu.Create(nil);
  { TODO : These are disabled for now, because a TabSheet component is used
           instead of a menu item - for adding tabs. }
  Result.AddMenuItem('Add Tab', '', @AddTabSClicked).Enabled := False;
  Result.AddMenuItem('Delete Tab', '', @DeleteTabClicked).Enabled := False;
end;

var
  FVFDFormWidget: TVFDWidgetClass;
  FVFDWidgets: TObjectList;

function VFDFormWidget: TVFDWidgetClass;
begin
  Result := FVFDFormWidget;
end;

function VFDWidgetCount: integer;
begin
  Result := FVFDWidgets.Count;
end;

function VFDWidget(ind: integer): TVFDWidgetClass;
begin
  Result := TVFDWidgetClass(FVFDWidgets[ind]);
end;

procedure RegisterVFDWidget(awc: TVFDWidgetClass);
begin
  FVFDWidgets.Add(awc);
end;

{$I icons.inc}

procedure LoadIcons;
begin
  fpgImages.AddMaskedBMP(
    'vfd.arrow', @stdimg_vfd_arrow,
    sizeof(stdimg_vfd_arrow),
    0, 0);

  fpgImages.AddMaskedBMP(
    'vfd.label', @stdimg_vfd_label,
    sizeof(stdimg_vfd_label),
    0, 0);

  fpgImages.AddMaskedBMP(
    'vfd.edit', @stdimg_vfd_edit,
    sizeof(stdimg_vfd_edit),
    0, 0);

  fpgImages.AddMaskedBMP(
    'vfd.memo', @stdimg_vfd_memo,
    sizeof(stdimg_vfd_memo),
    0, 0);

  fpgImages.AddMaskedBMP(
    'vfd.button', @stdimg_vfd_button,
    sizeof(stdimg_vfd_button),
    0, 0);

  fpgImages.AddMaskedBMP(
    'vfd.checkbox', @stdimg_vfd_checkbox,
    sizeof(stdimg_vfd_checkbox),
    0, 0);

  fpgImages.AddMaskedBMP(
    'vfd.listbox', @stdimg_vfd_listbox,
    sizeof(stdimg_vfd_listbox),
    0, 0);

  fpgImages.AddMaskedBMP(
    'vfd.combobox', @stdimg_vfd_combobox,
    sizeof(stdimg_vfd_combobox),
    0, 0);

  fpgImages.AddMaskedBMP(
    'vfd.panel', @stdimg_vfd_panel,
    sizeof(stdimg_vfd_panel),
    0, 0);

  fpgImages.AddMaskedBMP(
    'vfd.other', @stdimg_vfd_other,
    sizeof(stdimg_vfd_other),
    0, 0);

  fpgImages.AddMaskedBMP(
    'vfd.dbgrid', @stdimg_vfd_dbgrid,
    sizeof(stdimg_vfd_dbgrid),
    15,0 );

  fpgImages.AddMaskedBMP(
    'vfd.progressbar', @stdimg_vfd_progressbar,
    sizeof(stdimg_vfd_progressbar),
    0, 0);

  fpgImages.AddMaskedBMP(
    'vfd.trackbar', @stdimg_vfd_trackbar,
    sizeof(stdimg_vfd_trackbar),
    0, 0);
    
  fpgImages.AddMaskedBMP(
    'vfd.gauge', @stdimg_vfd_gauge,
    sizeof(stdimg_vfd_gauge),
    0, 0);
    
  fpgImages.AddMaskedBMP(
    'vfd.menubar', @stdimg_vfd_menubar,
    sizeof(stdimg_vfd_menubar),
    0, 0);
    
  fpgImages.AddMaskedBMP(
    'vfd.listview', @stdimg_vfd_listview,
    sizeof(stdimg_vfd_listview),
    0, 0);
    
  fpgImages.AddMaskedBMP(
    'vfd.stringgrid', @stdimg_vfd_stringgrid,
    sizeof(stdimg_vfd_stringgrid),
    0, 0);
    
  fpgImages.AddMaskedBMP(
    'vfd.radiobutton', @stdimg_vfd_radiobutton,
    sizeof(stdimg_vfd_radiobutton),
    0, 0);
    
  fpgImages.AddMaskedBMP(
    'vfd.pagecontrol', @stdimg_vfd_pagecontrol,
    sizeof(stdimg_vfd_pagecontrol),
    0, 0);

  fpgImages.AddMaskedBMP(
    'vfd.treeview', @stdimg_vfd_treeview,
    sizeof(stdimg_vfd_treeview),
    0, 0);

  fpgImages.AddMaskedBMP(
    'vfd.newform', @stdimg_vfd_newform,
    sizeof(stdimg_vfd_newform),
    0, 0);
    
  fpgImages.AddMaskedBMP(
    'vfd.combodateedit', @stdimg_vfd_dateedit,
    sizeof(stdimg_vfd_dateedit),
    0, 0);
    
  fpgImages.AddMaskedBMP(
    'vfd.bevel', @stdimg_vfd_bevel,
    sizeof(stdimg_vfd_bevel),
    0, 0);

  fpgImages.AddMaskedBMP(
    'vfd.tabsheet', @stdimg_vfd_tabsheet,
    sizeof(stdimg_vfd_tabsheet),
    0, 0);

  fpgImages.AddMaskedBMP(
    'vfd.editinteger', @stdimg_vfd_editinteger,
    sizeof(stdimg_vfd_editinteger),
    0, 0);

  fpgImages.AddMaskedBMP(
    'vfd.editfloat', @stdimg_vfd_editfloat,
    sizeof(stdimg_vfd_editfloat),
    0, 0);

  fpgImages.AddMaskedBMP(
    'vfd.editcurrency', @stdimg_vfd_editcurrency,
    sizeof(stdimg_vfd_editcurrency),
    0, 0);

  fpgImages.AddMaskedBMP(
    'vfd.groupbox', @stdimg_vfd_groupbox,
    sizeof(stdimg_vfd_groupbox),
    0, 0);

  fpgImages.AddMaskedBMP(
    'vfd.combodatecheckedit', @stdimg_vfd_combodatecheckedit,
    sizeof(stdimg_vfd_combodatecheckedit),
    0, 0);

end;

procedure AddWidgetPosProps(wgc: TVFDWidgetClass);
begin
  wgc.AddProperty('Left', TPropertyInteger, '');
  wgc.AddProperty('Top', TPropertyInteger, '');
  wgc.AddProperty('Width', TPropertyInteger, '');
  wgc.AddProperty('Height', TPropertyInteger, '');
end;

procedure RegisterWidgets;
var
  wc: TVFDWidgetClass;
begin
  LoadIcons;

  wc          := TVFDWidgetClass.Create(TfpgForm);
  wc.NameBase := 'frm';
  wc.AddProperty('WindowTitle', TPropertyString, '');
//  wc.AddProperty('WindowPosition', TPropertyEnum, '');
  wc.AddProperty('ShowHint', TPropertyBoolean, '');
  FVFDFormWidget := wc;

  // Label
  wc          := TVFDWidgetClass.Create(TfpgLabel);
  wc.NameBase := 'Label';
  wc.AddProperty('Alignment', TPropertyEnum, 'Horizontal text alignment');
  wc.AddProperty('FontDesc', TPropertyFontDesc, 'The font used for displaying the label text');
  wc.AddProperty('Hint', TPropertyString, '');
  wc.AddProperty('Layout', TPropertyEnum, 'Vertical text layout');
  wc.AddProperty('ParentShowHint', TPropertyBoolean, '');
  wc.AddProperty('ShowHint', TPropertyBoolean, '');
  wc.AddProperty('Text', TPropertyString, 'Label text');
  wc.AddProperty('WrapText', TPropertyBoolean, 'If True text will wrap when it doesn''t fit the width');
  wc.WidgetIconName := 'vfd.label';
  RegisterVFDWidget(wc);

  // Edit
  wc          := TVFDWidgetClass.Create(TfpgEdit);
  wc.NameBase := 'Edit';
//  wc.AddProperty('Color', TPropertyColor, 'Text color');
  wc.AddProperty('TabOrder', TPropertyInteger, 'The tab order');
  wc.AddProperty('Text', TPropertyString, 'Initial text');
  wc.AddProperty('FontDesc', TPropertyFontDesc, 'The font used for displaying the text');
  wc.AddProperty('ParentShowHint', TPropertyBoolean, '');
  wc.AddProperty('ShowHint', TPropertyBoolean, '');
  wc.WidgetIconName := 'vfd.edit';
  RegisterVFDWidget(wc);

  // Memo
  wc          := TVFDWidgetClass.Create(TfpgMemo);
  wc.NameBase := 'Memo';
  wc.AddProperty('Lines', TPropertyStringList, '');
  wc.AddProperty('FontDesc', TPropertyFontDesc, 'The font used for displaying the text');
  wc.AddProperty('ParentShowHint', TPropertyBoolean, '');
  wc.AddProperty('ShowHint', TPropertyBoolean, '');
  wc.AddProperty('TabOrder', TPropertyInteger, 'The tab order');
  wc.WidgetIconName := 'vfd.memo';
  RegisterVFDWidget(wc);

  // Button
  wc          := TVFDWidgetClass.Create(TfpgButton);
  wc.NameBase := 'Button';
  wc.AddProperty('Text', TPropertyString, 'Initial text');
  wc.AddProperty('AllowAllUp', TPropertyBoolean, '');
  wc.AddProperty('Embedded', TPropertyBoolean, 'No focus rectangle will be drawn. eg: Toolbar buttons');
  wc.AddProperty('Flat', TPropertyBoolean, 'Only draw button borders when mouse hovers over button');
  wc.AddProperty('FontDesc', TPropertyFontDesc, 'The font used for displaying the text');
  wc.AddProperty('GroupIndex', TPropertyInteger, '');
  wc.AddProperty('Hint', TPropertyString, '');
  wc.AddProperty('ImageLayout', TPropertyEnum, 'Which side of the button contains the image');
  wc.AddProperty('ImageMargin', TPropertyInteger, 'Space between image and border, -1 centers image/text');
  wc.AddProperty('ImageName', TPropertyString, '');
  wc.AddProperty('ImageSpacing', TPropertyInteger, 'Space between image and text, -1 centers text');
  wc.AddProperty('ModalResult', TPropertyInteger, '');
  wc.AddProperty('ParentShowHint', TPropertyBoolean, '');
  wc.AddProperty('ShowHint', TPropertyBoolean, '');
  wc.AddProperty('ShowImage', TPropertyBoolean, 'Boolean value');
  wc.AddProperty('TabOrder', TPropertyInteger, 'The tab order');
  wc.WidgetIconName := 'vfd.button';
  RegisterVFDWidget(wc);

  // CheckBox
  wc          := TVFDWidgetClass.Create(TfpgCheckBox);
  wc.NameBase := 'CheckBox';
  wc.AddProperty('Checked', TPropertyBoolean, 'Boolean value');
  wc.AddProperty('FontDesc', TPropertyFontDesc, 'The font used for displaying the text');
  wc.AddProperty('ParentShowHint', TPropertyBoolean, '');
  wc.AddProperty('ShowHint', TPropertyBoolean, '');
  wc.AddProperty('TabOrder', TPropertyInteger, 'The tab order');
  wc.AddProperty('Text', TPropertyString, 'Initial text');
  wc.WidgetIconName := 'vfd.checkbox';
  RegisterVFDWidget(wc);

  // RadioButton
  wc          := TVFDWidgetClass.Create(TfpgRadioButton);
  wc.NameBase := 'RadioButton';
  wc.AddProperty('Checked', TPropertyBoolean, 'Boolean value');
  wc.AddProperty('FontDesc', TPropertyFontDesc, 'The font used for displaying the text');
  wc.AddProperty('GroupIndex', TPropertyInteger, '');
  wc.AddProperty('ParentShowHint', TPropertyBoolean, '');
  wc.AddProperty('ShowHint', TPropertyBoolean, '');
  wc.AddProperty('TabOrder', TPropertyInteger, 'The tab order');
  wc.AddProperty('Text', TPropertyString, 'Initial text');
  wc.WidgetIconName := 'vfd.radiobutton';
  RegisterVFDWidget(wc);

  // ComboBox
  wc          := TVFDWidgetClass.Create(TfpgComboBox);
  wc.NameBase := 'ComboBox';
  wc.AddProperty('FontDesc', TPropertyFontDesc, 'The font used for displaying the text');
  wc.AddProperty('Items', TPropertyStringList, '');
  wc.AddProperty('ParentShowHint', TPropertyBoolean, '');
  wc.AddProperty('ShowHint', TPropertyBoolean, '');
  wc.AddProperty('TabOrder', TPropertyInteger, 'The tab order');
  wc.WidgetIconName := 'vfd.combobox';
  RegisterVFDWidget(wc);

  // Calendar ComboBox
  wc          := TVFDWidgetClass.Create(TfpgCalendarCombo);
  wc.NameBase := 'CalendarCombo';
  wc.AddProperty('DateFormat', TPropertyString, 'Standard RTL date formatting applies');
  wc.AddProperty('FontDesc', TPropertyFontDesc, 'The font used for displaying the text');
  wc.AddProperty('ParentShowHint', TPropertyBoolean, '');
  wc.AddProperty('ShowHint', TPropertyBoolean, '');
  wc.AddProperty('WeekStartDay', TPropertyInteger, '0 = Sun, 1 = Mon, etc.');
  wc.AddProperty('TabOrder', TPropertyInteger, 'The tab order');
  wc.WidgetIconName := 'vfd.combodateedit';
  RegisterVFDWidget(wc);

  // Calendar ComboBox Checkbox
  wc          := TVFDWidgetClass.Create(TfpgCalendarCheckCombo);
  wc.NameBase := 'CalendarCombo';
  wc.AddProperty('Checked', TPropertyBoolean, 'Boolean value');
  wc.AddProperty('DateFormat', TPropertyString, 'Standard RTL date formatting applies');
  wc.AddProperty('FontDesc', TPropertyFontDesc, 'The font used for displaying the text');
  wc.AddProperty('ParentShowHint', TPropertyBoolean, '');
  wc.AddProperty('ShowHint', TPropertyBoolean, '');
  wc.AddProperty('WeekStartDay', TPropertyInteger, '0 = Sun, 1 = Mon, etc.');
  wc.AddProperty('TabOrder', TPropertyInteger, 'The tab order');
  wc.WidgetIconName := 'vfd.combodatecheckedit';
  RegisterVFDWidget(wc);

  // ListBox
  wc          := TVFDWidgetClass.Create(TfpgListBox);
  wc.NameBase := 'ListBox';
  wc.AddProperty('FontDesc', TPropertyFontDesc, 'The font used for displaying the text');
  wc.AddProperty('HotTrack', TPropertyBoolean, '');
  wc.AddProperty('Items', TPropertyStringList, '');
  wc.AddProperty('ParentShowHint', TPropertyBoolean, '');
  wc.AddProperty('PopupFrame', TPropertyBoolean, '');
  wc.AddProperty('ShowHint', TPropertyBoolean, '');
  wc.AddProperty('TabOrder', TPropertyInteger, 'The tab order');
  wc.WidgetIconName := 'vfd.listbox';
  RegisterVFDWidget(wc);

  // StringGrid
  wc := TVFDWidgetClass.Create(TfpgStringGrid);
  wc.NameBase := 'Grid';
  wc.AddProperty('Columns', TPropertyDBColumns, '');
  wc.AddProperty('FontDesc', TPropertyFontDesc, 'The font used for displaying the text');
  wc.AddProperty('HeaderFontDesc', TPropertyFontDesc, '');
  wc.AddProperty('ParentShowHint', TPropertyBoolean, '');
  wc.AddProperty('RowCount', TPropertyInteger, '');
  wc.AddProperty('RowSelect', TPropertyBoolean, '');
  wc.AddProperty('ShowHeader', TPropertyBoolean, '');
  wc.AddProperty('ShowHint', TPropertyBoolean, '');
  wc.AddProperty('ShowGrid', TPropertyBoolean, '');
  wc.AddProperty('TabOrder', TPropertyInteger, 'The tab order');
  wc.WidgetIconName := 'vfd.stringgrid';
  RegisterVFDWidget(wc);

  // Bevel
  wc           := TVFDWidgetClass.Create(TfpgBevel);
  wc.NameBase  := 'Bevel';
  wc.AddProperty('BorderStyle', TPropertyEnum, 'Single or Double');
  wc.AddProperty('ParentShowHint', TPropertyBoolean, '');
  wc.AddProperty('Style', TPropertyEnum, 'Raised or Lower look');
  wc.AddProperty('Shape', TPropertyEnum, 'Box, Frame, TopLine, Spacer etc..');
  wc.AddProperty('ShowHint', TPropertyBoolean, '');
  wc.WidgetIconName := 'vfd.bevel';
  wc.Container := True;
  RegisterVFDWidget(wc);

  // Panel
  wc           := TVFDWidgetClass.Create(TfpgPanel);
  wc.NameBase  := 'Panel';
  wc.AddProperty('Alignment', TPropertyEnum, 'Text alignment');
  wc.AddProperty('FontDesc', TPropertyFontDesc, 'The font used for displaying the text');
  wc.AddProperty('Layout', TPropertyEnum, 'Layout of the caption');
  wc.AddProperty('LineSpace', TPropertyInteger, 'Line spacing between wrapped caption');
  wc.AddProperty('Margin', TPropertyInteger, 'Margin of text');
  wc.AddProperty('ParentShowHint', TPropertyBoolean, '');
  wc.AddProperty('ShowHint', TPropertyBoolean, '');
  wc.AddProperty('Style', TPropertyEnum, 'Raised or Lower look');
  wc.AddProperty('Text', TPropertyString, 'The panel caption');
  wc.AddProperty('WrapText', TPropertyBoolean, 'Should the panel text be wrapped');
  wc.WidgetIconName := 'vfd.panel';
  wc.Container := True;
  RegisterVFDWidget(wc);

  // GroupBox
  wc           := TVFDWidgetClass.Create(TfpgGroupBox);
  wc.NameBase  := 'GroupBox';
  wc.AddProperty('Alignment', TPropertyEnum, 'Text alignment');
  wc.AddProperty('BorderStyle', TPropertyEnum, 'Single or Double');
  wc.AddProperty('FontDesc', TPropertyFontDesc, 'The font used for displaying the text');
  wc.AddProperty('Margin', TPropertyInteger, 'Margin of text');
  wc.AddProperty('ShowHint', TPropertyBoolean, '');
  wc.AddProperty('Style', TPropertyEnum, 'Raised or Lower look');
  wc.AddProperty('ParentShowHint', TPropertyBoolean, '');
  wc.AddProperty('Text', TPropertyString, 'The panel caption');
  wc.WidgetIconName := 'vfd.groupbox';
  wc.Container := True;
  RegisterVFDWidget(wc);

  // ProgressBar
  wc          := TVFDWidgetClass.Create(TfpgProgressBar);
  wc.NameBase := 'ProgressBar';
  wc.AddProperty('Min', TPropertyInteger, '');
  wc.AddProperty('Max', TPropertyInteger, '');
  wc.AddProperty('ParentShowHint', TPropertyBoolean, '');
  wc.AddProperty('Position', TPropertyInteger, '');
  wc.AddProperty('ShowCaption', TPropertyBoolean, '');
  wc.AddProperty('ShowHint', TPropertyBoolean, '');
  wc.WidgetIconName := 'vfd.progressbar';
  RegisterVFDWidget(wc);

  // TrackBar
  wc          := TVFDWidgetClass.Create(TfpgTrackBar);
  wc.NameBase := 'TrackBar';
  wc.AddProperty('Max', TPropertyInteger, '');
  wc.AddProperty('Min', TPropertyInteger, '');
  wc.AddProperty('Orientation', TPropertyEnum, '');
  wc.AddProperty('ParentShowHint', TPropertyBoolean, '');
  wc.AddProperty('ShowHint', TPropertyBoolean, '');
  wc.AddProperty('Position', TPropertyInteger, '');
  wc.AddProperty('ShowPosition', TPropertyBoolean, '');
  wc.AddProperty('TabOrder', TPropertyInteger, 'The tab order');
  wc.WidgetIconName := 'vfd.trackbar';
  RegisterVFDWidget(wc);

  // ListView
  wc := TVFDWidgetClass.Create(TfpgListView);
  wc.NameBase := 'ListView';
  wc.AddProperty('MultiSelect', TPropertyBoolean, '');
  wc.AddProperty('ParentShowHint', TPropertyBoolean, '');
  wc.AddProperty('ShowHeaders', TPropertyBoolean, '');
  wc.AddProperty('ShowHint', TPropertyBoolean, '');
  wc.AddProperty('TabOrder', TPropertyInteger, 'The tab order');
  wc.WidgetIconName := 'vfd.listview';
  RegisterVFDWidget(wc);

  // Treeview
  wc := TVFDWidgetClass.Create(TfpgTreeView);
  wc.NameBase := 'TreeView';
  wc.AddProperty('DefaultColumnWidth',TPropertyInteger, '');
  wc.AddProperty('FontDesc',TPropertyFontDesc, '');
  wc.AddProperty('ParentShowHint', TPropertyBoolean, '');
  wc.AddProperty('ScrollWheelDelta', TPropertyInteger, 'Scroll amount with mouse wheel');
  wc.AddProperty('ShowColumns',TPropertyBoolean, 'Boolean value');
  wc.AddProperty('ShowHint', TPropertyBoolean, '');
  wc.AddProperty('ShowImages',TPropertyBoolean, 'Boolean value');
  wc.AddProperty('TabOrder', TPropertyInteger, 'The tab order');
  wc.AddProperty('TreeLineStyle', TPropertyEnum, '');
  wc.WidgetIconName := 'vfd.treeview';
  RegisterVFDWidget(wc);
  
  // PageControl
  wc          := TVFDPageControlWidgetClass.Create(TfpgPageControl);
  wc.NameBase := 'PageControl';
  wc.AddProperty('ActivePageIndex', TPropertyInteger, '');
  wc.AddProperty('FixedTabWidth', TPropertyInteger, '');
  wc.AddProperty('ParentShowHint', TPropertyBoolean, '');
  wc.AddProperty('ShowHint', TPropertyBoolean, '');
  wc.AddProperty('SortPages', TPropertyBoolean, 'Boolean value');
  wc.AddProperty('Style', TPropertyEnum, '');
  wc.AddProperty('TabOrder', TPropertyInteger, 'The tab order');
  wc.AddProperty('TabPosition', TPropertyEnum, '');
  wc.WidgetIconName := 'vfd.pagecontrol';
  wc.Container := True;
  wc.BlockMouseMsg := False;
  RegisterVFDWidget(wc);

  // TabSheet
  wc          := TVFDWidgetClass.Create(TfpgTabSheet);
  wc.NameBase := 'TabSheet';
  wc.AddProperty('Text', TPropertyString, 'The tab title');
  wc.WidgetIconName := 'vfd.tabsheet';
  wc.Container := True;
  RegisterVFDWidget(wc);

  // Gauge
  wc          := TVFDWidgetClass.Create(TfpgGauge);
  wc.NameBase := 'Gauge';
  wc.AddProperty('Kind', TPropertyEnum, '');
  wc.AddProperty('MinValue', TPropertyInteger, '');
  wc.AddProperty('MaxValue', TPropertyInteger, '');
  wc.AddProperty('ParentShowHint', TPropertyBoolean, '');
  wc.AddProperty('Progress', TPropertyInteger, '');
  wc.AddProperty('ShowHint', TPropertyBoolean, '');
  wc.AddProperty('ShowText', TPropertyBoolean, 'Boolean value');
  wc.WidgetIconName := 'vfd.gauge';
  RegisterVFDWidget(wc);


  // Integer Edit
  wc          := TVFDWidgetClass.Create(TfpgEditInteger);
  wc.NameBase := 'EditInteger';
  wc.AddProperty('TabOrder', TPropertyInteger, 'The tab order');
  wc.AddProperty('FontDesc', TPropertyFontDesc, 'The font used for displaying the text');
  wc.AddProperty('ParentShowHint', TPropertyBoolean, '');
  wc.AddProperty('ShowHint', TPropertyBoolean, '');
  wc.AddProperty('ShowThousand', TPropertyBoolean, 'Show thousand separator');
//  wc.AddProperty('CustomThousandSeparator', TPropertyString, 'Thousand separator character');
  wc.AddProperty('Value', TPropertyInteger, 'Initial value');
  wc.WidgetIconName := 'vfd.editinteger';
  RegisterVFDWidget(wc);

  // Float Edit
  wc          := TVFDWidgetClass.Create(TfpgEditFloat);
  wc.NameBase := 'EditFloat';
  wc.AddProperty('TabOrder', TPropertyInteger, 'The tab order');
  wc.AddProperty('FontDesc', TPropertyFontDesc, 'The font used for displaying the text');
  wc.AddProperty('ParentShowHint', TPropertyBoolean, '');
  wc.AddProperty('ShowHint', TPropertyBoolean, '');
  wc.AddProperty('Value', TPropertyFloat, 'Initial value');
  wc.AddProperty('ShowThousand', TPropertyBoolean, 'Show thousand separator');
  wc.AddProperty('FixedDecimals', TPropertyBoolean, '');
  wc.Addproperty('Decimals', TPropertyInteger, '');
//  wc.AddProperty('CustomDecimalSeparator', TPropertyString, 'Decimal separator character');
//  wc.AddProperty('CustomThousandSeparator', TPropertyString, 'Thousand separator character');
  wc.WidgetIconName := 'vfd.editfloat';
  RegisterVFDWidget(wc);

  // Currency Edit
  wc          := TVFDWidgetClass.Create(TfpgEditCurrency);
  wc.NameBase := 'EditCurrency';
  wc.AddProperty('TabOrder', TPropertyInteger, 'The tab order');
  wc.AddProperty('FontDesc', TPropertyFontDesc, 'The font used for displaying the text');
  wc.AddProperty('ParentShowHint', TPropertyBoolean, '');
  wc.AddProperty('ShowHint', TPropertyBoolean, '');
  wc.AddProperty('Value', TPropertyFloat, 'Initial value');
  wc.AddProperty('ShowThousand', TPropertyBoolean, 'Show thousand separator');
  wc.Addproperty('Decimals', TPropertyInteger, '');
//  wc.AddProperty('CustomDecimalSeparator', TPropertyString, 'Decimal separator character');
//  wc.AddProperty('CustomThousandSeparator', TPropertyString, 'Thousand separator character');
  wc.WidgetIconName := 'vfd.editcurrency';
  RegisterVFDWidget(wc);

  { TODO : UI Designer still has problems with components that have child components. }
  // Spin Edit
  //wc          := TVFDWidgetClass.Create(TfpgSpinEdit);
  //wc.NameBase := 'SpinEdit';
  //wc.AddProperty('ButtonWidth', TPropertyInteger, 'Spin button width');
  //wc.AddProperty('FontDesc', TPropertyFontDesc, 'The font used for displaying the text');
  //wc.Addproperty('Hint', TPropertyString, '');
  //wc.AddProperty('Increment', TPropertyInteger, 'Increment value on short press');
  //wc.AddProperty('LargeIncrement', TPropertyInteger, 'Large increment value on long press');
  //wc.AddProperty('MaxValue', TPropertyInteger, 'Maximum value');
  //wc.AddProperty('MinValue', TPropertyInteger, 'Minimum value');
  //wc.AddProperty('ParentShowHint', TPropertyBoolean, '');
  //wc.AddProperty('ShowHint', TPropertyBoolean, '');
  //wc.AddProperty('TabOrder', TPropertyInteger, 'The tab order');
  //wc.AddProperty('Value', TPropertyInteger, 'Initial value');
  //wc.WidgetIconName := 'vfd.editinteger';
  //RegisterVFDWidget(wc);

  // Spin Edit Float
  //wc          := TVFDWidgetClass.Create(TfpgSpinEditFloat);
  //wc.NameBase := 'SpinEditFloat';
  //wc.AddProperty('ButtonWidth', TPropertyInteger, 'Spin button width');
  //wc.Addproperty('Decimals', TPropertyInteger, '');
  //wc.Addproperty('FixedDecimals', TPropertyBoolean, '');
  //wc.AddProperty('FontDesc', TPropertyFontDesc, 'The font used for displaying the text');
  //wc.Addproperty('Hint', TPropertyString, '');
  //wc.AddProperty('Increment', TPropertyFloat, 'Increment value on short press');
  //wc.AddProperty('LargeIncrement', TPropertyFloat, 'Large increment value on long press');
  //wc.AddProperty('TabOrder', TPropertyInteger, 'The tab order');
  //wc.AddProperty('MaxValue', TPropertyFloat, 'Maximum value');
  //wc.AddProperty('MinValue', TPropertyFloat, 'Minimum value');
  //wc.AddProperty('ParentShowHint', TPropertyBoolean, '');
  //wc.AddProperty('ShowHint', TPropertyBoolean, '');
  //wc.AddProperty('Value', TPropertyFloat, 'Initial value');
  //wc.WidgetIconName := 'vfd.editfloat';
  //RegisterVFDWidget(wc);

  // Other - do not delete!!! this should be the last...
  wc          := TVFDWidgetClass.Create(TOtherWidget);
  wc.NameBase := 'Custom';
  wc.WidgetIconName := 'vfd.other';
  wc.Container := True;
  RegisterVFDWidget(wc);
  VFDOtherWidget := wc;
end;


initialization
    FVFDWidgets := TObjectList.Create;

finalization
    FVFDWidgets.Free;
    FVFDFormWidget.Free;
    
end.
