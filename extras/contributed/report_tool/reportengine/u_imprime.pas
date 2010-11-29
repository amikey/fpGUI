{
    << Impressions >>  U_Imprime.pas

    Copyright (C) 2010 - JM.Levecque - <jmarc.levecque@jmlesite.fr>

   This library is a free software coming as a add-on to fpGUI toolkit
   See the copyright included in the fpGUI distribution for details about redistribution

   This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    Description:
      This unit interfaces with the user program
}

unit U_Imprime;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StrUtils,
  fpg_base, fpg_main,
  fpg_panel,
  U_Commande, U_Pdf;

type
  TTypePapier= (A4,Letter,Legal,Executive,Comm10,Monarch,DL,C5,B5);
  TOrient= (oPortrait,oLandscape);
  TMesure = (msMM,msInch);
  TPreparation= (ppPrepare,ppVisualise,ppFichierPDF);

  T_Imprime = class(TObject)
    private
      FVersion: Char;
      FPapier: TPapier;
      FTypePapier: TTypePapier;
      FOrientation: TOrient;
      FMargeCourante: TDimensions;
      FMesure: TMesure;
      FPreparation: TPreparation;
      FVisualisation: Boolean;
      FCanevas: TfpgCanvas;
      FFonteCourante: Integer;
      FInterLCourante: Integer;
      FColorCourante: Integer;
      FNmSection: Integer;
      FNmPage: Integer;
      FNmPageSect: Integer;
      FPosRef: TPoint;              // absolute writting position
      FEnTeteHeight: Integer;       // end of text vertical position in the header
      FPageHeight: Integer;         // end of text vertical position in the page
      FPiedHeight: Integer;         // beginning of text vertical position in the footer
      FGroupe: Boolean;
      FDefaultFile: string;
      function Dim2Pixels(Value: Single): Integer;
      function AddLineBreaks(const Txt: TfpgString; AMaxLineWidth: integer; AFnt: TfpgFont): string;
      function TxtHeight(AWid: Integer; const ATxt: TfpgString; AFnt: TfpgFont; ALSpace: Integer= 2): Integer;
      function ConvertitEnAlpha(Valeur: Integer): string;
      function GetHauteurPapier: Integer;
      function GetLargeurPapier: Integer;
      procedure Bv_VisuPaint(Sender: TObject);
      procedure PrepareVisu;
      procedure ImprimePage(PageNumero: Integer);
      procedure DecaleLignesPied(Decalage: Integer);
      procedure DecaleLigne(Decalage: Integer);
      procedure DecaleGroupe(Decalage: Integer);
      procedure EcritLigne(PosX,PosY,Colonne,Texte,FonteNum,FondNum,BordNum,InterL: Integer;
                TxtFlags: TFTextFlags; Zone: TZone);
      procedure EcritNum(PosX,PosY,Colonne,TexteNum,TexteTot,FonteNum,FondNum,BordNum,InterL: Integer;
                TxtFlags: TFTextFlags; Total,Alpha: Boolean; Zone: TZone; SPNum: TSectPageNum);
      procedure InsereEspace(PosY,Colonne,EspHeight,FondNum: Integer; Zone: TZone);
      procedure FinLigne(Zone: TZone);
      procedure TraceCadre(StTrait: Integer; Zone: TZone);
      procedure TraceTrait(XDebut,YDebut,XFin,YFin,StTrait: Integer);
    public
      constructor Create;
      destructor Destroy; override;
      procedure Debut(IniOriente: TOrient= oPortrait; IniTypePapier: TTypePapier= A4;
                IniMesure: TMesure= msMM; IniVersion: Char= 'F'; IniVisu: Boolean= True);
                // starts preview and printing process with initializations
                // IniOriente = paper orientation >> oPortrait or oLandscape
                // IniTypePapier = (A4, Letter,Legal,Executive,Comm10,Monarch,DL,C5,B5)
                // IniMesure = millimeters (msMM) or inches (msInches)
                // IniVersion = version française 'F' or version English 'E', or other, to come
                // IniVisu = True (visualisation) or False (direct printing or PDF generation)
      procedure Fin;
      procedure ImprimeDocument;
      procedure Visualisation;
      procedure Section(MgGauche,MgDroite,MgHaute,MgBasse: Single; Retrait: Single= 0);
                // new section with initialization of margins
      procedure Page;
                // new page in the current section
      function Fond(FdColor: TfpgColor): Integer;
               // returns the number allocated to the color
               // FdColor = background color
      function Fonte(FtNom: string; FtColor: TfpgColor): Integer;
               // returns the number allocated to the font
               // FtNom = FontDesc of the font
               // FtColor = font color
      function StyleTrait(StEpais: Integer; StColor: Tfpgcolor; StStyle: TfpgLineStyle): Integer;
               // returns the number allocated to the line style
               // StEpais = thickness of the line in pixels
               // StColor = line color
               // StStyle = line style
      function Bordure(BdFlags: TFBordFlags; BdStyle: Integer): Integer;
               // returns the number allocated to the border
               // BdFlags = position of the border (bdTop,bdBottom,bdLeft,bdRight)
               // BdStyle = border line style: thickness, color, style
      function Colonne(ClnPos,ClnWidth: Single; ClnMargin: Single= 0; ClnColor: TfpgColor= clWhite): Integer;
               // returns the number allocated to the column
               // ClnPos = left position in numeric value in the measurement unit (msMM or msInch)
               // ClnWidth = width in numeric value in the measurement unit (msMM or msInch)
               // ClnMargin = left and right margins in numeric value in the measurement unit (msMM or msInch)
               // ClnColor = column background color
      procedure EcritEnTete(Horiz,Verti: Single; Texte: string; ColNum: Integer= 0; FonteNum: Integer= 0;
                InterNum: Integer= 0; CoulFdNum: Integer= -1; BordNum: Integer= -1);
                // Horiz = horizontal position in column (cnLeft,cnCenter,cnRight)
                //         or numeric value in the measurement unit (msMM or msInch)
                // Verti = line position in column (lnCourante,lnFin)
                //         or numeric value in the measurement unit (msMM or msInch)
                // Texte = texte to be written
                // ColNum = column reference, default between left and right margins
                // FonteNum = font reference
                // InterNum = space between lines reference
                // CoulFdNum = background color reference, if > -1, replaces the column background color if any
                // BordNum = border reference, if> -1
      procedure EcritPage(Horiz,Verti: Single; Texte: string; ColNum: Integer= 0; FonteNum: Integer= 0;
                InterNum: Integer= 0; CoulFdNum: Integer= -1; BordNum: Integer= -1);
                // Horiz = horizontal position in column (cnLeft,cnCenter,cnRight)
                //         or numeric value in the measurement unit (msMM or msInch)
                // Verti = line position in column (lnCourante,lnFin)
                //         or numeric value in the measurement unit (msMM or msInch)
                // Texte = texte to be written
                // ColNum = column reference, default between left and right margins
                // FonteNum = font reference
                // InterNum = space between lines reference
                // CoulFdNum = background color reference, if > -1, replaces the column background color if any
                // BordNum = border reference, if> -1
      procedure EcritPied(Horiz,Verti: Single; Texte: string; ColNum: Integer= 0; FonteNum: Integer= 0;
                InterNum: Integer= 0; CoulFdNum: Integer= -1; BordNum: Integer= -1);
                // Horiz = horizontal position in column (cnLeft,cnCenter,cnRight)
                //         or numeric value in the measurement unit (msMM or msInch)
                // Verti = line position in column (lnCourante,lnFin)
                //         or numeric value in the measurement unit (msMM or msInch)
                // Texte = texte to be written
                // ColNum = column reference, default between left and right margins
                // FonteNum = font reference
                // InterNum = space between lines reference
                // CoulFdNum = background color reference, if > -1, replaces the column background color if any
                // BordNum = border reference, if> -1
      procedure NumSectionEnTete(Horiz,Verti: Single; TexteSect: string= ''; TexteTot: string= '';
                Total: Boolean= False; Alpha: Boolean= False; ColNum: Integer= 0; FonteNum: Integer= 0;
                InterNum: Integer= 0; CoulFdNum: Integer= -1; BordNum: Integer= -1);
                // Horiz = horizontal position in column (cnLeft,cnCenter,cnRight)
                //         or numeric value in the measurement unit (msMM or msInch)
                // Verti = line position in column (lnCourante,lnFin)
                //         or numeric value in the measurement unit (msMM or msInch)
                // TexteSection = text to be written before the section number
                // TexteTotal = text to be written before the number of sections
                // Total= True => displays the number of sections
                // Alpha= True => displays the number of sections using letters in alphabetic order
                // ColNum = column reference, default between left and right margins
                // FonteNum = font reference
                // InterNum = space between lines reference
                // CoulFdNum = background color reference, if > -1, replaces the column background color if any
                // BordNum = border reference, if> -1
      procedure NumSectionPied(Horiz,Verti: Single; TexteSect: string= ''; TexteTot: string= '';
                Total: Boolean= False; Alpha: Boolean= False; ColNum: Integer= 0; FonteNum: Integer= 0;
                InterNum: Integer= 0; CoulFdNum: Integer= -1; BordNum: Integer= -1);
                // Horiz = horizontal position in column (cnLeft,cnCenter,cnRight)
                //         or numeric value in the measurement unit (msMM or msInch)
                // Verti = line position in column (lnCourante,lnFin)
                //         or numeric value in the measurement unit (msMM or msInch)
                // TexteSection = text to be written before the section number
                // TexteTotal = text to be written before the number of sections
                // Total= True => displays the number of sections
                // Alpha= True => displays the number of sections using letters in alphabetic order
                // ColNum = column reference, default between left and right margins
                // FonteNum = font reference
                // InterNum = space between lines reference
                // CoulFdNum = background color reference, if > -1, replaces the column background color if any
                // BordNum = border reference, if> -1
      procedure NumPageEnTete(Horiz,Verti: Single; TextePage: string= ''; TexteTotal: string= '';
                Total: Boolean= False; ColNum: Integer= 0; FonteNum: Integer= 0; InterNum: Integer= 0;
                CoulFdNum: Integer= -1; BordNum: Integer= -1);
                // Horiz = horizontal position in column (cnLeft,cnCenter,cnRight)
                //         or numeric value in the measurement unit (msMM or msInch)
                // Verti = line position in column (lnCourante,lnFin)
                //         or numeric value in the measurement unit (msMM or msInch)
                // TextePage = text to be written before the page number in the document
                // TexteTotal = text to be written before the number of pages of the document
                // Total= True > displays the number of pages of the document
                // ColNum = column reference, default between left and right margins
                // FonteNum = font reference
                // InterNum = space between lines reference
                // CoulFdNum = background color reference, if > -1, replaces the column background color if any
                // BordNum = border reference, if> -1
      procedure NumPagePied(Horiz,Verti: Single; TextePage: string= ''; TexteTotal: string= '';
                Total: Boolean= False; ColNum: Integer= 0; FonteNum: Integer= 0; InterNum: Integer= 0;
                CoulFdNum: Integer= -1; BordNum: Integer= -1);
                // Horiz = horizontal position in column (cnLeft,cnCenter,cnRight)
                //         or numeric value in the measurement unit (msMM or msInch)
                // Verti = line position in column (lnCourante,lnFin)
                //         or numeric value in the measurement unit (msMM or msInch)
                // TextePage = text to be written before the page number in the document
                // TexteTotal = text to be written before the number of pages of the document
                // Total= True > displays the number of pages of the document
                // ColNum = column reference, default between left and right margins
                // FonteNum = font reference
                // InterNum = space between lines reference
                // CoulFdNum = background color reference, if > -1, replaces the column background color if any
                // BordNum = border reference, if> -1
      procedure NumPageSectionEnTete(Horiz,Verti: Single; TexteSect: string= ''; TexteTot: string= '';
                Total: Boolean= False; Alpha: Boolean= False; ColNum: Integer= 0; FonteNum: Integer= 0;
                InterNum: Integer= 0; CoulFdNum: Integer= -1; BordNum: Integer= -1);
                // Horiz = horizontal position in column (cnLeft,cnCenter,cnRight)
                //         or numeric value in the measurement unit (msMM or msInch)
                // Verti = line position in column (lnCourante,lnFin)
                //         or numeric value in the measurement unit (msMM or msInch)
                // TextePage = text to ba written before the page number in the section
                // TexteTotal = text to be written before the number of pages of the section
                // Total= True > displays the number of pages of the section
                // ColNum = column reference, default between left and right margins
                // FonteNum = font reference
                // InterNum = space between lines reference
                // CoulFdNum = background color reference, if > -1, replaces the column background color if any
                // BordNum = border reference, if> -1
      procedure NumPageSectionPied(Horiz,Verti: Single; TexteSect: string= ''; TexteTot: string= '';
                Total: Boolean= False; Alpha: Boolean= False; ColNum: Integer= 0; FonteNum: Integer= 0;
                InterNum: Integer= 0; CoulFdNum: Integer= -1; BordNum: Integer= -1);
                // Horiz = horizontal position in column (cnLeft,cnCenter,cnRight)
                //         or numeric value in the measurement unit (msMM or msInch)
                // Verti = line position in column (lnCourante,lnFin)
                //         or numeric value in the measurement unit (msMM or msInch)
                // TextePage = text to ba written before the page number in the section
                // TexteTotal = text to be written before the number of pages of the section
                // Total= True > displays the number of pages of the section
                // ColNum = column reference, default between left and right margins
                // FonteNum = font reference
                // InterNum = space between lines reference
                // CoulFdNum = background color reference, if > -1, replaces the column background color if any
                // BordNum = border reference, if> -1
      //procedure TraitEnTete(Horiz,Verti: Single; ColNum: Integer= 0; StyleNum: Integer= 0; FinH: Integer= -1;
                //FinV: Integer= -1);
      //procedure TraitPage(Horiz,Verti: Single; ColNum: Integer= 0; StyleNum: Integer= 0; FinH: Integer= -1;
                //FinV: Integer= -1);
      //procedure TraitPied(Horiz,Verti: Single; ColNum: Integer= 0; StyleNum: Integer= 0; FinH: Integer= -1;
                //FinV: Integer= -1);
      procedure EspaceEnTete(Verti: Single; ColNum: Integer=0; CoulFdNum: Integer= -1);
                // Verti = height of the empty space : numeric value in the measurement unit (msMM or msInch)
                // ColNum = column reference, default between left and right margins
                // CoulFdNum = background color reference, if > -1, replaces the column background color if any
      procedure EspacePage(Verti: Single; ColNum: Integer=0; CoulFdNum: Integer= -1);
                // Verti = height of the empty space : numeric value in the measurement unit (msMM or msInch)
                // ColNum = column reference, default between left and right margins
                // CoulFdNum = background color reference, if > -1, replaces the column background color if any
      procedure EspacePied(Verti: Single; ColNum: Integer=0; CoulFdNum: Integer= -1);
                // Verti = height of the empty space : numeric value in the measurement unit (msMM or msInch)
                // ColNum = column reference, default between left and right margins
                // CoulFdNum = background color reference, if > -1, replaces the column background color if any
      function Interligne(ItlSup,ItlInt,ItlInf: Single): Integer;
               // IntSup = space between lines, top : numeric value in the measurement unit (msMM or msInch)
               // IntInt = space between lines, internal if wrapping : numeric value in the measurement unit (msMM or msInch)
               // IntInf = space between lines, botom : numeric value in the measurement unit (msMM or msInch)
      procedure Groupe(SautPage: Boolean= False);
                // SautPage = True >> forces new page before the group
                //          = False >> does not create a new page if the whole group can stand on the same page as the preceding text
      procedure FinGroupe(SautPage: Boolean= False);
                // SautPage = True >> forces new page after the group
                //          = False >> lets continue on the same page after the group
      procedure ColorColChange(ColNum: Integer; ColColor: TfpgColor);
                // Changes the background color of a column
                // ColNum = column reference
                // ColColor = new background color for the column
      procedure CadreMarges(AStyle: Integer);
                // draw a frame at the page margins
                // AStyle = line style of the frame
      procedure CadreEnTete(AStyle: Integer);
                // draw a frame at the limits of the header
                // AStyle = line style of the frame
      procedure CadrePage(AStyle: Integer);
                // draw a frame at the page limits : left and right margins, header bottom and footer top
                // AStyle = line style of the frame
      procedure CadrePied(AStyle: Integer);
                // draw a frame at the limits of the footer
                // AStyle = line style of the frame
      procedure TraitPage(XDebut,YDebut,XFin,YFin: Single; AStyle: Integer);
                // draw a line at absolute position
                // XDebut = horizontal position of starting point in numeric value in the measurement unit (msMM or msInch)
                // YDebut = vertical position of starting point in numeric value in the measurement unit (msMM or msInch)
                // XFin = horizontal position of ending point in numeric value in the measurement unit (msMM or msInch)
                // YFin = vertical position of ending point in numeric value in the measurement unit (msMM or msInch)
                // AStyle = line style of the frame
      property Langue: Char read FVersion write FVersion;
      property Visualiser: Boolean read FVisualisation write FVisualisation;
      property NumeroSection: Integer read FNmSection write FNmSection;
      property NumeroPage: Integer read FNmPage write FNmPage;
      property NumeroPageSection: Integer read FNmPageSect write FNmPageSect;
      property HauteurPapier: Integer read GetHauteurPapier;
      property LargeurPapier: Integer read GetLargeurPapier;
      property DefaultFile: string read FDefaultFile write FDefaultFile;
      property CouleurCourante: Integer read FColorCourante write FColorCourante;
    end;

  // classes for interface with PDF generation

  TPdfElement = class
    end;

  TPdfTexte= class(TPdfElement)
    private
      FPage: Integer;
      FFont: Integer;
      FSize: string;
      FPosX: Integer;
      FPosY: Integer;
      FLarg: Integer;
      FText: string;
      FColor: TfpgColor;
    public
      property PageId: Integer read FPage write FPage;
      property FontName: Integer read FFont write FFont;
      property FontSize: string read FSize write FSize;
      property TextPosX: Integer read FPosX write FPosX;
      property TextPosY: Integer read FPosY write FPosY;
      property TextLarg: Integer read FLarg write FLarg;
      property Ecriture: string read FText write FText;
      property Couleur: TfpgColor read FColor write FColor;
    end;

  TPdfRect = class(TPdfElement)
    private
      FPage: Integer;
      FEpais: Integer;
      FGauche: Integer;
      FBas: Integer;
      FHaut: Integer;
      FLarg: Integer;
      FColor: Integer;
      FFill: Boolean;
      FStroke: Boolean;
      FLineStyle: TfpgLineStyle;
    protected
    public
      property PageId: Integer read FPage write FPage;
      property RectEpais: Integer read FEpais write FEpais;
      property RectGauche: Integer read FGauche write FGauche;
      property RectBas: Integer read FBas write FBas;
      property RectHaut: Integer read FHaut write FBas;
      property RectLarg: Integer read FLarg write FLarg;
      property RectCouleur: Integer read FColor write FColor;
      property RectEmplit: Boolean read FFill write FFill;
      property RectTrace: Boolean read FStroke write FStroke;
      property RectLineStyle: TfpgLineStyle read FLineStyle write FLineStyle;
    end;

  TPdfLine = class(TPdfElement)
    private
      FPage: Integer;
      FEpais: Integer;
      FStartX: Integer;
      FStartY: Integer;
      FEndX: Integer;
      FEndY: Integer;
      FColor: Integer;
      FStyle: TfpgLineStyle;
    protected
    public
      property PageId: Integer read FPage write FPage;
      property LineEpais: Integer read FEpais write FEpais;
      property LineStartX: Integer read FSTartX write FStartX;
      property LineStartY: Integer read FStartY write FStartY;
      property LineEndX: Integer read FEndX write FEndX;
      property LineEndY: Integer read FEndY write FEndY;
      property LineColor: Integer read FColor write FColor;
      property LineStyle: TfpgLineStyle read FStyle write FStyle;
    end;

var
  Imprime: T_Imprime;

  Infos: record
    Titre: string;
    Auteur: string;
    end;

  PdfPage: TList;
  PdfTexte: TPdfTexte;
  PdfRect: TPdfRect;
  PdfLine: TPdfLine;

const
  FontDefaut= 0;
  ColDefaut= 0;
  lnCourante= -1;
  lnFin= -2;
//  cnSuite= -1;
  cnLeft= -2;
  cnCenter= -3;
  cnRight= -4;

implementation

uses
  U_Visu;

const
  InchToMM= 25.4;
  PPI= 72;
  Cent= 100;

function T_Imprime.Dim2Pixels(Value: Single): Integer;
begin
if FMesure= msMM
then
  Result:= Round(Value*PPI/InchToMM)
else
  Result:= Trunc(Value*PPI);
end;

function T_Imprime.AddLineBreaks(const Txt: TfpgString; AMaxLineWidth: integer; AFnt: TfpgFont): string;
var
  i,n,ls: integer;
  sub: string;
  lw,tw: integer;
begin
Result:= '';
ls:= Length(Txt);
lw:= 0;
i:= 1;
while i<= ls do
  begin
  if (Txt[i] in txtWordDelims)
  then       // read the delimeter only
    begin
    sub:= Txt[i];
    Inc(i);
    end
  else                                // read the whole word
    begin
    n:= PosSetEx(txtWordDelims,Txt,i);
    if n> 0
    then
      begin
      sub:= Copy(Txt,i,n-i);
      i:= n;
      end
    else
      begin
      sub:= Copy(Txt,i,MaxInt);
      i:= ls+1;
      end;
    end;
  tw:= AFnt.TextWidth(sub);            // wrap if needed
  if (lw+tw> aMaxLineWidth) and (lw> 0)
  then
    begin
    lw:= tw;
    Result:= TrimRight(Result)+sLineBreak;
    end
  else
    Inc(lw,tw);
  Result:= Result+sub;
  end;
end;

function T_Imprime.TxtHeight(AWid: Integer; const ATxt: TfpgString; AFnt: TfpgFont; ALSpace: Integer= 2): Integer;
var
  Cpt: Integer;
  Wraplst: TStringList;
begin
Wraplst:= TStringList.Create;
Wraplst.Text := ATxt;
for Cpt:= 0 to Pred(Wraplst.Count) do
  Wraplst[Cpt] := AddLineBreaks(Wraplst[Cpt],AWid,AFnt);
Wraplst.Text := Wraplst.Text;
Result:= (AFnt.Height*Wraplst.Count)+(ALSpace*Pred(Wraplst.Count));
WrapLst.Free;
end;

function T_Imprime.ConvertitEnAlpha(Valeur: Integer): string;
var
  Cpt: Byte;
begin
Result:= '';
Cpt:= 0;
repeat
  if Valeur> 26
  then
    begin
    Valeur:= Valeur-26;
    Inc(Cpt);
    Result:= Chr(Cpt+64);
    end
  else
    begin
    Result:= Chr(Valeur+64);
    Valeur:= 0;
    end;
until Valeur< 1;
end;

function T_Imprime.GetHauteurPapier: Integer;
begin
Result:= FPapier.H;
end;

function T_Imprime.GetLargeurPapier: Integer;
begin
Result:= FPapier.W;
end;

procedure T_Imprime.Bv_VisuPaint(Sender: TObject);
begin
ImprimePage(NumeroPage);
end;

procedure T_Imprime.PrepareVisu;
var
  TempH,TempW,TempT,TempL,TempR,TempB: Integer;
begin
with FPapier do
  begin
  case FTypePapier of
    A4:
      begin
      H:= 842;
      W:= 595;
      with Imprimable do
        begin
        T:= 10;
        L:= 11;
        R:= 586;
        B:= 822;
        end;
      end;
    Letter:
      begin
      H:= 792;
      W:= 612;
      with Imprimable do
        begin
        T:= 13;
        L:= 13;
        R:= 599;
        B:= 780;
        end;
      end;
    Legal:
      begin
      H:= 1008;
      W:= 612;
      with Imprimable do
        begin
        T:= 13;
        L:= 13;
        R:= 599;
        B:= 996;
        end;
      end;
    Executive:
      begin
      H:= 756;
      W:= 522;
      with Imprimable do
        begin
        T:= 14;
        L:= 13;
        R:= 508;
        B:= 744;
        end;
      end;
    Comm10:
      begin
      H:= 684;
      W:= 297;
      with Imprimable do
        begin
        T:= 13;
        L:= 13;
        R:= 284;
        B:= 672;
        end;
      end;
    Monarch:
      begin
      H:= 540;
      W:= 279;
      with Imprimable do
        begin
        T:= 13;
        L:= 13;
        R:= 266;
        B:= 528;
        end;
      end;
    DL:
      begin
      H:= 624;
      W:= 312;
      with Imprimable do
        begin
        T:= 14;
        L:= 13;
        R:= 297;
        B:= 611;
        end;
      end;
    C5:
      begin
      H:= 649;
      W:= 459;
      with Imprimable do
        begin
        T:= 13;
        L:= 13;
        R:= 446;
        B:= 637;
        end;
      end;
    B5:
      begin
      H:= 708;
      W:= 499;
      with Imprimable do
        begin
        T:= 14;
        L:= 13;
        R:= 485;
        B:= 696;
        end;
      end;
    end;
  if FOrientation= oLandscape
  then
    begin
    TempH:= H;
    TempW:= W;
    H:= TempW;
    W:= TempH;
    with Imprimable do
      begin
      TempT:= T;
      TempL:= L;
      TempR:= R;
      TempB:= B;
      T:= TempL;
      L:= TempT;
      R:= TempB;
      B:= TempR;
      end;
    end;
  end;
F_Visu:= TF_Visu.Create(nil);
with F_Visu do
  begin
  Bv_Visu:= CreateBevel(F_Visu,(F_Visu.Width-FPapier.W) div 2,50+(F_Visu.Height-50-FPapier.H) div 2,
            FPapier.W,FPapier.H,bsBox,bsRaised);
  Bv_Visu.BackgroundColor:= clWhite;
  Bv_Visu.OnPaint:= @Bv_VisuPaint;
  end;
end;

procedure LibereCommandesPages(ACommandes: PPage);
var
  Cpt: Integer;
begin
with T_Page(ACommandes) do
  if Commandes.Count> 0
  then
    begin
    for Cpt:= 0 to Pred(Commandes.Count) do
      T_Commande(Commandes[Cpt]).Free;
    Commandes.Free;
    end;
end;

procedure LiberePages(APageSect: PSection);
var
  Cpt: Integer;
begin
with T_Section(APageSect) do
  if Pages.Count> 0
  then
    begin
    for Cpt:= 0 to Pred(Pages.Count) do
      LibereCommandesPages(Pages[Cpt]);
    Pages.Free;
    end;
end;

procedure T_Imprime.ImprimePage(PageNumero: Integer);
var
  CptSect,CptPage,CptCmd: Integer;
  LaPage: T_Page;
  Cmd: T_Commande;
begin
CptSect:= 0;
repeat
  Inc(CptSect);
  CptPage:= 0;
  with T_Section(Sections[Pred(CptSect)]) do
    repeat
      Inc(CptPage);
      LaPage:= T_Page(Pages.Items[Pred(CptPage)]);
    until (LaPage.PagesTot= PageNumero) or (CptPage= Pages.Count);
until (LaPage.PagesTot= PageNumero) or (CptSect= Sections.Count);
NumeroPage:= PageNumero;
NumeroSection:= CptSect;
NumeroPageSection:= LaPage.PagesSect;
with T_Section(Sections[Pred(NumeroSection)]) do
  begin
  if GetCmdEnTete.Count> 0
  then
    for CptCmd:= 0 to Pred(GetCmdEnTete.Count) do
      begin
      Cmd:= T_Commande(GetCmdEnTete.Items[CptCmd]);
      if Cmd is T_EcritTexte
      then
        with Cmd as T_EcritTexte do
          EcritLigne(GetPosX,GetPosY,GetColonne,GetTexte,GetFonte,GetFond,GetBord,GetInterL,GetFlags,ZEnTete);
      if Cmd is T_Numero
      then
        with Cmd as T_Numero do
          EcritNum(GetPosX,GetPosY,GetColonne,GetTexteNum,GetTexteTot,GetFonte,GetFond,GetBord,GetInterL,
                   GetFlags,GetTotal,GetAlpha,zEnTete,GetTypeNum);
      if Cmd is T_Espace
      then
        with Cmd as T_Espace do
          InsereEspace(GetPosY,GetColonne,GetHeight,GetFond,zEnTete);
      end;
  if GetCmdPage(NumeroPageSection).Count> 0
  then
    for CptCmd:= 0 to Pred(GetCmdPage(NumeroPageSection).Count) do
      begin
      Cmd:= T_Commande(GetCmdPage(NumeroPageSection).Items[CptCmd]);
      if Cmd is T_EcritTexte
      then
        with Cmd as T_EcritTexte do
          EcritLigne(GetPosX,GetPosY,GetColonne,GetTexte,GetFonte,GetFond,GetBord,GetInterL,GetFlags,ZPage);
      if Cmd is T_Espace
      then
        with Cmd as T_Espace do
          InsereEspace(GetPosY,GetColonne,GetHeight,GetFond,zPage);
      if Cmd is T_Trait
      then
        with Cmd as T_Trait do
          TraceTrait(GetPosX,GetPosY,GetEndX,GetEndY,GetStyle);
      end;
  if GetCmdPied.Count> 0
  then
    for CptCmd:= 0 to Pred(GetCmdPied.Count) do
      begin
      Cmd:= T_Commande(GetCmdPied.Items[CptCmd]);
      if Cmd is T_EcritTexte
      then
        with Cmd as T_EcritTexte do
          EcritLigne(GetPosX,GetPosY,GetColonne,GetTexte,GetFonte,GetFond,GetBord,GetInterL,GetFlags,ZPied);
      if Cmd is T_Numero
      then
        with Cmd as T_Numero do
          EcritNum(GetPosX,GetPosY,GetColonne,GetTexteNum,GetTexteTot,GetFonte,GetFond,GetBord,GetInterL,
                   GetFlags,GetTotal,GetAlpha,zPied,GetTypeNum);
      if Cmd is T_Espace
      then
        with Cmd as T_Espace do
          InsereEspace(GetPosY,GetColonne,GetHeight,GetFond,zPied);
      end;
  if GetCmdCadres.Count> 0
  then
    for CptCmd:= 0 to Pred(GetCmdCadres.Count) do
      begin
      Cmd:= T_Commande(GetCmdCadres.Items[CptCmd]);
      if Cmd is T_Cadre
      then
        with Cmd as T_Cadre do
          TraceCadre(GetStyle,GetZone);
      end;
  end;
end;

procedure T_Imprime.DecaleLignesPied(Decalage: Integer);
var
  Cpt: Integer;
  Cmd: T_Commande;
begin
with T_Section(Sections[Pred(NumeroSection)]) do
  if GetCmdPied.Count> 0
  then
    for Cpt:= 0 to Pred(GetCmdPied.Count) do
      begin
      Cmd:= T_Commande(GetCmdPied.Items[Cpt]);
      if Cmd is T_EcritTexte
      then
        with Cmd as T_EcritTexte do
          SetPosY(GetPosY-Decalage);
      if Cmd is T_Numero
      then
        with Cmd as T_Numero do
          SetPosY(GetPosY-Decalage);
      if Cmd is T_Espace
      then
        with Cmd as T_Espace do
          SetPosY(GetPosY-Decalage);
      end;
end;

procedure T_Imprime.DecaleLigne(Decalage: Integer);
var
  Cpt: Integer;
  Cmd: T_Commande;
begin
with ALigne do
  for Cpt:= 0 to Pred(Commandes.Count) do
    begin
    Cmd:= T_Commande(Commandes.Items[Cpt]);
    if Cmd is T_EcritTexte
    then
      with Cmd as T_EcritTexte do
        SetPosY(GetPosY-Decalage);
    end;
end;

procedure T_Imprime.DecaleGroupe(Decalage: Integer);
var
  Cpt: Integer;
  Cmd: T_Commande;
begin
with AGroupe do
  for Cpt:= 0 to Pred(Commandes.Count) do
    begin
    Cmd:= T_Commande(Commandes.Items[Cpt]);
    if Cmd is T_EcritTexte
    then
      with Cmd as T_EcritTexte do
        SetPosY(GetPosY-Decalage);
    end;
end;

procedure T_Imprime.EcritLigne(PosX,PosY,Colonne,Texte,FonteNum,FondNum,BordNum,InterL: Integer;
          TxtFlags: TFTextFlags; Zone: TZone);
var
  PosH,PosV,HTxt,HautTxt,IntlInt,IntLSup,IntLInf,Half,CoulTrait,EpaisTrait: Integer;
  FinDeLigne,UseCurFont: Boolean;
  Fnt: TfpgFont;
  StylTrait: TfpgLineStyle;
begin
FinDeLigne:= False;
if FPreparation= ppPrepare
then
  if FFonteCourante<> FonteNum
  then
    begin
    FFonteCourante:= FonteNum;
    UseCurFont:= False;
    end
  else
    UseCurFont:= True;
Fnt:= T_Fonte(Fontes[FonteNum]).GetFonte;
if Interlignes.Count= 0
then
  Interligne(0,0,0);
if FInterLCourante<> InterL
then
  FInterLCourante:= InterL;
IntLSup:= T_Interligne(Interlignes[FInterLCourante]).GetSup;
IntlInt:= T_Interligne(Interlignes[FInterLCourante]).GetInt;
IntLInf:= T_Interligne(Interlignes[FInterLCourante]).GetInf;
if Colonne> -1
then
  HautTxt:= TxtHeight(T_Colonne(Colonnes[Colonne]).GetTextWidth,Textes[Texte],Fnt,IntlInt)+IntLSup+IntLInf
else
  HautTxt:= TxtHeight(FPapier.W,Textes[Texte],Fnt,IntlInt)+IntLSup+IntLInf;
if (Colonne> -1) and (BordNum> -1)
then
  Half:= T_TraitStyle(TraitStyles[T_Bord(Bords[BordNum]).GetStyle]).GetEpais div 2
else
  Half:= 0;
case FPreparation of
  ppPrepare:
    begin
    if T_Section(Sections[Pred(NumeroSection)]).GetNbPages= 0
    then
      Page;
    if Colonne> -1
    then
      begin
      HTxt:= ALigne.GetHeight;
      if HTxt< HautTxt
      then
        HTxt:= HautTxt;
      end
    else
      if HTxt< Fnt.Height
      then
        HTxt:= Fnt.Height;
    case Zone of
      zEntete:
        FPosRef.Y:= FMargeCourante.T+FEnTeteHeight;
      zPage:
        FPosRef.Y:= FMargeCourante.T+FEnTeteHeight+FPageHeight;
      zPied:
        begin
        FPosRef.Y:= FMargeCourante.B-HTxt;
        FPiedHeight:= FPiedHeight+HTxt;
        DecaleLignesPied(HTxt);
        end;
      end;
    if PosY= lnCourante
    then
      PosV:= FPosRef.Y+IntLSup
    else
      begin
      FinDeLigne:= True;
      if PosY= lnFin
      then
        begin
        PosV:= FPosRef.Y+IntLSup;
        case Zone of
          zEnTete:
            FPosRef.Y:= FPosRef.Y+HTxt;
          zPage:
            begin
            if FPosRef.Y+HTxt> FMargeCourante.B-FPiedHeight
            then
              if FGroupe
              then
                begin
                if AGroupe.GetGroupeHeight+HTxt< FMargeCourante.B-FMargeCourante.T-FEnTeteHeight-FPiedHeight
                then
                  begin
                  Page;
                  if AGroupe.Commandes.Count> 0
                  then
                    begin
                    FPosRef.Y:= FMargeCourante.T+FEnTeteHeight;
                    DecaleGroupe(T_EcritTexte(AGroupe.Commandes[0]).GetPosY-FPosRef.Y);
                    FPosRef.Y:= FPosRef.Y+AGroupe.GetGroupeHeight+Succ(Half);
                    if ALigne.Commandes.Count> 0
                    then
                      DecaleLigne(T_EcritTexte(ALigne.Commandes[0]).GetPosY-FPosRef.Y);
                    PosV:= FPosRef.Y+IntLSup;
                    FPosRef.Y:= FPosRef.Y+HTxt+Succ(Half);
                    end
                  else
                    begin
                    if ALigne.Commandes.Count> 0
                    then
                      DecaleLigne(T_EcritTexte(ALigne.Commandes[0]).GetPosY-FPosRef.Y);
                    PosV:= FPosRef.Y+IntLSup;
                    FPosRef.Y:= FPosRef.Y+HTxt+Succ(Half);
                    end;
                  end
                else
                  begin
                  T_Section(Sections[Pred(Sections.Count)]).LoadCmdGroupeToPage;
                  AGroupe.Commandes.Clear;
                  Page;
                  FPosRef.Y:= FMargeCourante.T+FEnTeteHeight;
                  if ALigne.Commandes.Count> 0
                  then
                    DecaleLigne(T_EcritTexte(ALigne.Commandes[0]).GetPosY-FPosRef.Y);
                  PosV:= FPosRef.Y+IntLSup;
                  FPosRef.Y:= FPosRef.Y+HTxt+Succ(Half);
                  end;
                end
              else
                begin
                Page;
                FPosRef.Y:= FMargeCourante.T+FEnTeteHeight;
                if ALigne.Commandes.Count> 0
                then
                  DecaleLigne(T_EcritTexte(ALigne.Commandes[0]).GetPosY-FPosRef.Y);
                PosV:= FPosRef.Y+IntLSup;
                FPosRef.Y:= FPosRef.Y+HTxt+Succ(Half);
                end
            else
              FPosRef.Y:= FPosRef.Y+HTxt;
            end;
          end;
        if BordNum> -1
        then
          with T_Bord(Bords[BordNum]) do
            if bcBas in GetFlags
            then
              FPosRef.Y:= FPosRef.Y+1;
        end
      else
        begin
        PosV:= PosY;
        FPosRef.Y:= PosV+IntLInf;
        end;
      case Zone of
        zEnTete:
          FEnTeteHeight:= FPosRef.Y-FMargeCourante.T;
        zPage:
          FPageHeight:= FPosRef.Y-FEnTeteHeight-FMargeCourante.T;
        end;
      end;
    //if PosX= cnSuite
    //then
      //PosH:= FPosRef.X
    //else
    if Colonne= -1
    then
      if PosX> 0
      then
        PosH:= PosX
      else
        begin
        PosH:= T_Colonne(Colonnes[0]).GetTextPos;
        if (txtRight in TxtFlags)
        then
          PosH:= PosH+T_Colonne(Colonnes[0]).GetColWidth-Fnt.TextWidth(Textes[Texte])-T_Colonne(Colonnes[0]).GetColMargin;
        if (txtHCenter in TxtFlags)
        then
          PosH:= PosH+(T_Colonne(Colonnes[0]).GetColWidth-Fnt.TextWidth(Textes[Texte])) div 2;
        end
    else
      if PosX> 0
      then
        begin
        if (PosX< T_Colonne(Colonnes[Colonne]).GetTextPos)
           or (PosX> (T_Colonne(Colonnes[Colonne]).GetTextPos+T_Colonne(Colonnes[Colonne]).GetTextWidth))
        then
          PosH:= T_Colonne(Colonnes[Colonne]).GetTextPos
        else
          PosH:= PosX;
        end
      else
        begin
        PosH:= T_Colonne(Colonnes[Colonne]).GetTextPos;
        if (txtRight in TxtFlags)
        then
          PosH:= PosH+T_Colonne(Colonnes[0]).GetColWidth-Fnt.TextWidth(Textes[Texte])-T_Colonne(Colonnes[0]).GetColMargin;
        if (txtHCenter in TxtFlags)
        then
          PosH:= PosH+(T_Colonne(Colonnes[0]).GetColWidth-Fnt.TextWidth(Textes[Texte])) div 2;
        end;
    FPosRef.X:= PosH+Fnt.TextWidth(Textes[Texte]+' ');
    ALigne.LoadTexte(PosH,PosV,Colonne,Texte,FonteNum,HTxt,FondNum,BordNum,InterL,UseCurFont,TxtFlags);
    if FinDeLigne
    then
      begin
      HTxt:= 0;
      FinLigne(Zone);
      end;
    end;
  ppVisualise:
    with FCanevas do
      begin
      Font:= T_Fonte(Fontes[FonteNum]).GetFonte;
      SetTextColor(T_Fonte(Fontes[FonteNum]).GetColor);
      if Colonne> -1
      then
        with T_Colonne(Colonnes[Colonne]) do
          begin
          if FondNum> -1
          then
            SetColor(T_Fond(Fonds[FondNum]).GetColor)
          else
            SetColor(GetColor);
          FillRectangle(GetColPos,PosY-IntLSup,GetColWidth,HautTxt);
          if BordNum> -1
          then
            with T_Bord(Bords[BordNum]) do
              begin
              SetLineStyle(T_TraitStyle(TraitStyles[GetStyle]).GetEpais,T_TraitStyle(TraitStyles[GetStyle]).GetStyle);
              SetColor(T_TraitStyle(TraitStyles[GetStyle]).GetColor);
              if bcGauche in GetFlags
              then
                DrawLine(GetColPos+Half,PosY-IntLSup,GetColPos+Half,PosY-IntLSup+HautTxt);
              if bcDroite in GetFlags
              then
                DrawLine(GetColPos+GetColWidth-Succ(Half),PosY-IntLSup,GetColPos+GetColWidth-Succ(Half),PosY-IntLSup+HautTxt);
              if bcHaut in GetFlags
              then
                DrawLine(GetColPos,PosY-IntLSup+Half,GetColPos+GetColWidth,PosY-IntLSup+Half);
              if bcBas in GetFlags
              then
                DrawLine(GetColPos,PosY-IntLSup+HautTxt-Half,GetColPos+GetColWidth,PosY-IntLSup+HautTxt-Half);
              end;
          DrawText(GetTextPos,PosY,GetTextWidth,0,Textes[Texte],TxtFlags,IntlInt);
          end
      else
        DrawText(PosX,PosY-Fnt.Ascent,Textes[Texte],TxtFlags);
      end;
  ppFichierPDF:
    if Colonne> -1
    then
      with T_Colonne(Colonnes[Colonne]) do
        begin
        if (GetColor<> clWhite) or (FondNum> -1)
        then
          begin
          PdfRect:= TPdfRect.Create;
          with PdfRect do
            begin
            PageId:= NumeroPage;
            FGauche:= GetColPos;
            FBas:= FPapier.H-PosY+IntLSup-HautTxt;
            FHaut:= HautTxt;
            FLarg:= GetColWidth;
            if FondNum> -1
            then
              FColor:= T_Fond(Fonds[FondNum]).GetColor
            else
              FColor:= GetColor;
            FFill:= True;
            FStroke:= False;
            end;
          PdfPage.Add(PdfRect);
          end;
        if BordNum> -1
        then
          with T_Bord(Bords[BordNum]) do
            begin
            StylTrait:= T_TraitStyle(TraitStyles[T_Bord(Bords[BordNum]).GetStyle]).GetStyle;
            CoulTrait:= T_TraitStyle(TraitStyles[T_Bord(Bords[BordNum]).GetStyle]).GetColor;
            EpaisTrait:= T_TraitStyle(TraitStyles[T_Bord(Bords[BordNum]).GetStyle]).GetEpais;
            if bcGauche in GetFlags
            then
              begin
              PdfLine:= TPdfLine.Create;
              with PdfLine do
                begin
                PageId:= NumeroPage;
                FStartX:= GetColPos;
                FStartY:= FPapier.H-PosY+IntLSup;
                FEndX:= GetColPos;
                FEndY:= FPapier.H-PosY+IntLSup-HautTxt;
                FStyle:= StylTrait;
                FColor:= CoulTrait;
                FEpais:= EpaisTrait;
                end;
              PdfPage.Add(PdfLine);
              end;
            if bcDroite in GetFlags
            then
              begin
              PdfLine:= TPdfLine.Create;
              with PdfLine do
                begin
                PageId:= NumeroPage;
                FStartX:= GetColPos+GetColWidth;
                FStartY:= FPapier.H-PosY+IntLSup;
                FEndX:= GetColPos+GetColWidth;
                FEndY:= FPapier.H-PosY+IntLSup-HautTxt;
                FStyle:= StylTrait;
                FColor:= CoulTrait;
                FEpais:= EpaisTrait;
                end;
              PdfPage.Add(PdfLine);
              end;
            if bcHaut in GetFlags
            then
              begin
              PdfLine:= TPdfLine.Create;
              with PdfLine do
                begin
                PageId:= NumeroPage;
                FStartX:= GetColPos;
                FStartY:= FPapier.H-PosY+IntLSup;
                FEndX:= GetColPos+GetColWidth;
                FEndY:= FPapier.H-PosY+IntLSup;
                FStyle:= StylTrait;
                FColor:= CoulTrait;
                FEpais:= EpaisTrait;
                end;
              PdfPage.Add(PdfLine);
              end;
            if bcBas in GetFlags
            then
              begin
              PdfLine:= TPdfLine.Create;
              with PdfLine do
                begin
                PageId:= NumeroPage;
                FStartX:= GetColPos;
                FStartY:= FPapier.H-PosY+IntLSup-HautTxt;
                FEndX:= GetColPos+GetColWidth;
                FEndY:= FPapier.H-PosY+IntLSup-HautTxt;
                FStyle:= StylTrait;
                FColor:= CoulTrait;
                FEpais:= EpaisTrait;
                end;
              PdfPage.Add(PdfLine);
              end;
            end;
        PdfTexte:= TPdfTexte.Create;
        with PdfTexte do
          begin
          PageId:= NumeroPage;
          FFont:= FonteNum;
          FSize:= T_Fonte(Fontes[FonteNum]).GetSize;
          FColor:= T_Fonte(Fontes[FonteNum]).GetColor;
          TextPosX:= GetTextPos;
          if (txtRight in TxtFlags)
          then
            TextPosX:= GetColPos+GetColWidth-GetColMargin-Fnt.TextWidth(Textes[Texte]);
          if (txtHCenter in TxtFlags)
          then
            TextPosX:= GetTextPos+(GetColWidth-Fnt.TextWidth(Textes[Texte])) div 2;
          TextPosY:= FPapier.H-PosY-Fnt.Ascent;
          TextLarg:= GetColWidth;
          Ecriture:= Textes[Texte];
          end;
        PdfPage.Add(PdfTexte);
        end
    else
      begin
      PdfTexte:= TPdfTexte.Create;
      with PdfTexte do
        begin
        PageId:= NumeroPage;
        FFont:= FonteNum;
        FSize:= T_Fonte(Fontes[FonteNum]).GetSize;
        FColor:= T_Fonte(Fontes[FonteNum]).GetColor;
        FPosX:= PosX;
        FPosY:= FPapier.H-PosY;
        FLarg:= FPapier.W;
        FText:= Textes[Texte];
        end;
      PdfPage.Add(PdfTexte);
      end;
  end;
end;

procedure T_Imprime.EcritNum(PosX,PosY,Colonne,TexteNum,TexteTot,FonteNum,FondNum,BordNum,InterL: Integer;
          TxtFlags: TFTextFlags; Total,Alpha: Boolean; Zone: TZone; SPNum: TSectPageNum);

  function BuildChaine: string;
  var
    NumAlpha: string;
  begin
  case SPNum of
    PageNum:
      if Total
      then
        Result:= Textes[TexteNum]+' '+IntToStr(NumeroPage)+' '+Textes[TexteTot]+' '
                 +IntToStr(T_Section(Sections[Pred(Sections.Count)]).TotPages)
      else
        Result:= Textes[TexteNum]+' '+IntToStr(NumeroPage);
    SectNum:
      begin
      if Alpha
      then
        NumAlpha:= ConvertitEnAlpha(NumeroSection)
      else
        NumAlpha:= IntToStr(NumeroSection);
      if Total
      then
        Result:= Textes[TexteNum]+' '+NumAlpha+' '+Textes[TexteTot]+' '+IntToStr(Sections.Count)
      else
        Result:= Textes[TexteNum]+' '+NumAlpha;
      end;
    PSectNum:
      begin
      if Alpha
      then
        NumAlpha:= ConvertitEnAlpha(NumeroPageSection)
      else
        NumAlpha:= IntToStr(NumeroPageSection);
      if Total
      then
        Result:= Textes[TexteNum]+' '+NumAlpha+' '+Textes[TexteTot]+' '
                 +IntToStr(T_Section(Sections[Pred(NumeroSection)]).GetNbPages)
      else
        Result:= Textes[TexteNum]+' '+NumAlpha;
      end;
    end;
  end;

var
  PosH,PosV,HTxt,HautTxt,IntlInt,IntLSup,IntLInf,Half,CoulTrait,EpaisTrait: Integer;
  FinDeLigne,UseCurFont: Boolean;
  Fnt: TfpgFont;
  StylTrait: TfpgLineStyle;
  Chaine: string;
begin
FinDeLigne:= False;
if FPreparation= ppPrepare
then
  if FFonteCourante<> FonteNum
  then
    begin
    FFonteCourante:= FonteNum;
    UseCurFont:= False;
    end
  else
    UseCurFont:= True;
Fnt:= T_Fonte(Fontes[FonteNum]).GetFonte;
if Interlignes.Count= 0
then
  Interligne(0,0,0);
if FInterLCourante<> InterL
then
  FInterLCourante:= InterL;
IntLSup:= T_Interligne(Interlignes[FInterLCourante]).GetSup;
IntlInt:= T_Interligne(Interlignes[FInterLCourante]).GetInt;
IntLInf:= T_Interligne(Interlignes[FInterLCourante]).GetInf;
HautTxt:= TxtHeight(T_Colonne(Colonnes[Colonne]).GetTextWidth,Textes[TexteNum]+' 0 '+Textes[TexteTot]+' 0',Fnt,IntlInt)+IntLSup+IntLInf;
if (Colonne> -1) and (BordNum> -1)
then
  Half:= T_TraitStyle(TraitStyles[T_Bord(Bords[BordNum]).GetStyle]).GetEpais div 2;
case FPreparation of
  ppPrepare:
    begin
    if T_Section(Sections[Pred(NumeroSection)]).GetNbPages= 0
    then
      Page;
    if Colonne> -1
    then
      begin
      HTxt:= ALigne.GetHeight;
      if HTxt< HautTxt
      then
        HTxt:= HautTxt;
      end
    else
      if HTxt< Fnt.Height
      then
        HTxt:= Fnt.Height;
    case Zone of
      zEntete:
        FPosRef.Y:= FMargeCourante.T+FEnTeteHeight;
      zPied:
        begin
        FPosRef.Y:= FMargeCourante.B-HTxt;
        FPiedHeight:= FPiedHeight+HTxt;
        DecaleLignesPied(HTxt);
        end;
      end;
    if PosY= lnCourante
    then
      PosV:= FPosRef.Y+IntLSup
    else
      begin
      FinDeLigne:= True;
      if PosY= lnFin
      then
        begin
        PosV:= FPosRef.Y+IntLSup;
        case Zone of
          zEnTete:
            FPosRef.Y:= FPosRef.Y+HTxt;
          end;
        if BordNum> -1
        then
          with T_Bord(Bords[BordNum]) do
            if bcBas in GetFlags
            then
              FPosRef.Y:= FPosRef.Y+1;
        end
      else
        begin
        PosV:= PosY;
        FPosRef.Y:= PosV+IntLInf;
        end;
      case Zone of
        zEnTete:
          FEnTeteHeight:= FPosRef.Y-FMargeCourante.T;
        //zPied:                                          ////////////
        //  PosV:= FPosRef.Y;                             ////////////
        end;
      end;
    if Colonne= -1
    then
      if PosX> 0
      then
        PosH:= PosX
      else
        begin
        PosH:= T_Colonne(Colonnes[0]).GetTextPos-T_Colonne(Colonnes[0]).GetColMargin;
        if (txtRight in TxtFlags)
        then
          if Total
          then
            PosH:= PosH+T_Colonne(Colonnes[0]).GetColWidth-Fnt.TextWidth(Textes[TexteNum]+' 0 '+Textes[TexteTot]+' 0 ')-T_Colonne(Colonnes[0]).GetColMargin
          else
            PosH:= PosH+T_Colonne(Colonnes[0]).GetColWidth-Fnt.TextWidth(Textes[TexteNum]+' 0 ')-T_Colonne(Colonnes[0]).GetColMargin;
        if (txtHCenter in TxtFlags)
        then
          if Total
          then
            PosH:= PosH+(T_Colonne(Colonnes[0]).GetColWidth-Fnt.TextWidth(Textes[TexteNum]+' 0 '+Textes[TexteTot]+' 0 ')) div 2
          else
            PosH:= PosH+(T_Colonne(Colonnes[0]).GetColWidth-Fnt.TextWidth(Textes[TexteNum]+' 0 ')) div 2;
        end
    else
      if PosX> 0
      then
        if (PosX< T_Colonne(Colonnes[Colonne]).GetTextPos)
           or (PosX> (T_Colonne(Colonnes[Colonne]).GetTextPos+T_Colonne(Colonnes[Colonne]).GetTextWidth))
        then
          PosH:= T_Colonne(Colonnes[Colonne]).GetTextPos
        else
          PosH:= PosX
      else
        begin
        PosH:= T_Colonne(Colonnes[Colonne]).GetTextPos-T_Colonne(Colonnes[0]).GetColMargin;
        if (txtRight in TxtFlags)
        then
          if Total
          then
            PosH:= PosH+T_Colonne(Colonnes[0]).GetColWidth-Fnt.TextWidth(Textes[TexteNum]+' 0 '+Textes[TexteTot]+' 0 ')-T_Colonne(Colonnes[0]).GetColMargin
          else
            PosH:= PosH+T_Colonne(Colonnes[0]).GetColWidth-Fnt.TextWidth(Textes[TexteNum]+' 0 ')-T_Colonne(Colonnes[0]).GetColMargin;
        if (txtHCenter in TxtFlags)
        then
          if Total
          then
            PosH:= PosH+(T_Colonne(Colonnes[0]).GetColWidth-Fnt.TextWidth(Textes[TexteNum]+' 0 '+Textes[TexteTot]+' 0 ')) div 2
          else
            PosH:= PosH+(T_Colonne(Colonnes[0]).GetColWidth-Fnt.TextWidth(Textes[TexteNum]+' 0 ')) div 2;
        end;
    FPosRef.X:= PosH+Fnt.TextWidth(Textes[TexteNum]+' 0 '+Textes[TexteTot]+' 0 ');
    ALigne.LoadNumero(PosH,PosV,Colonne,TexteNum,TexteTot,FonteNum,HTxt,FondNum,BordNum,InterL,UseCurFont,TxtFlags,Total,Alpha,SPNum);
    if FinDeLigne
    then
      begin
      HTxt:= 0;
      FinLigne(Zone);
      end;
    end;
  ppVisualise:
    with FCanevas do
      begin
      Chaine:= BuildChaine;
      Font:= T_Fonte(Fontes[FonteNum]).GetFonte;
      SetTextColor(T_Fonte(Fontes[FonteNum]).GetColor);
      if Colonne> -1
      then
        with T_Colonne(Colonnes[Colonne]) do
          begin
          if FondNum> -1
          then
            SetColor(T_Fond(Fonds[FondNum]).GetColor)
          else
            SetColor(GetColor);
          FillRectangle(GetColPos,PosY-IntLSup,GetColWidth,HautTxt);
          if BordNum> -1
          then
            with T_Bord(Bords[BordNum]) do
              begin
              SetLineStyle(T_TraitStyle(TraitStyles[GetStyle]).GetEpais,T_TraitStyle(TraitStyles[GetStyle]).GetStyle);
              SetColor(T_TraitStyle(TraitStyles[GetStyle]).GetColor);
              if bcGauche in GetFlags
              then
                DrawLine(GetColPos+Half,PosY-IntLSup,GetColPos+Half,PosY-IntLSup+HautTxt);
              if bcDroite in GetFlags
              then
                DrawLine(GetColPos+GetColWidth-Half,PosY-IntLSup,GetColPos+GetColWidth-Half,PosY-IntLSup+HautTxt);
              if bcHaut in GetFlags
              then
                DrawLine(GetColPos,PosY-IntLSup+Half,GetColPos+GetColWidth,PosY-IntLSup+Half);
              if bcBas in GetFlags
              then
                DrawLine(GetColPos,PosY-IntLSup+HautTxt-Succ(Half),GetColPos+GetColWidth,PosY-IntLSup+HautTxt-Succ(Half));
              end;
          DrawText(GetTextPos,PosY,GetTextWidth,0,Chaine,TxtFlags,IntlInt);
          end
      else
        DrawText(PosX,PosY,Chaine,TxtFlags);
      end;
  ppFichierPDF:
    begin
    Chaine:= BuildChaine;
    if Colonne> -1
    then
      with T_Colonne(Colonnes[Colonne]) do
        begin
        if (GetColor<> clWhite) or (FondNum> -1)
        then
          begin
          PdfRect:= TPdfRect.Create;
          with PdfRect do
            begin
            PageId:= NumeroPage;
            FGauche:= GetColPos;
            FBas:= FPapier.H-PosY+IntLSup-HautTxt;
            FHaut:= HautTxt;
            FLarg:= GetColWidth;
            if FondNum> -1
            then
              FColor:= T_Fond(Fonds[FondNum]).GetColor
            else
              FColor:= GetColor;
            FFill:= True;
            FStroke:= False;
            end;
          PdfPage.Add(PdfRect);
          end;
        if BordNum> -1
        then
          with T_Bord(Bords[BordNum]) do
            begin
            StylTrait:= T_TraitStyle(TraitStyles[T_Bord(Bords[BordNum]).GetStyle]).GetStyle;
            CoulTrait:= T_TraitStyle(TraitStyles[T_Bord(Bords[BordNum]).GetStyle]).GetColor;
            EpaisTrait:= T_TraitStyle(TraitStyles[T_Bord(Bords[BordNum]).GetStyle]).GetEpais;
            if bcGauche in GetFlags
            then
              begin
              PdfLine:= TPdfLine.Create;
              with PdfLine do
                begin
                PageId:= NumeroPage;
                FStartX:= GetColPos;
                FStartY:= FPapier.H-PosY+IntLSup;
                FEndX:= GetColPos;
                FEndY:= FPapier.H-PosY+IntLSup-HautTxt;
                FStyle:= StylTrait;
                FColor:= CoulTrait;
                FEpais:= EpaisTrait;
                end;
              PdfPage.Add(PdfLine);
              end;
            if bcDroite in GetFlags
            then
              begin
              PdfLine:= TPdfLine.Create;
              with PdfLine do
                begin
                PageId:= NumeroPage;
                FStartX:= GetColPos+GetColWidth;
                FStartY:= FPapier.H-PosY+IntLSup;
                FEndX:= GetColPos+GetColWidth;
                FEndY:= FPapier.H-PosY+IntLSup-HautTxt;
                FStyle:= StylTrait;
                FColor:= CoulTrait;
                FEpais:= EpaisTrait;
                end;
              PdfPage.Add(PdfLine);
              end;
            if bcHaut in GetFlags
            then
              begin
              PdfLine:= TPdfLine.Create;
              with PdfLine do
                begin
                PageId:= NumeroPage;
                FStartX:= GetColPos;
                FStartY:= FPapier.H-PosY+IntLSup;
                FEndX:= GetColPos+GetColWidth;
                FEndY:= FPapier.H-PosY+IntLSup;
                FStyle:= StylTrait;
                FColor:= CoulTrait;
                FEpais:= EpaisTrait;
                end;
              PdfPage.Add(PdfLine);
              end;
            if bcBas in GetFlags
            then
              begin
              PdfLine:= TPdfLine.Create;
              with PdfLine do
                begin
                PageId:= NumeroPage;
                FStartX:= GetColPos;
                FStartY:= FPapier.H-PosY+IntLSup-HautTxt;
                FEndX:= GetColPos+GetColWidth;
                FEndY:= FPapier.H-PosY+IntLSup-HautTxt;
                FStyle:= StylTrait;
                FColor:= CoulTrait;
                FEpais:= EpaisTrait;
                end;
              PdfPage.Add(PdfLine);
              end;
            end;
        PdfTexte:= TPdfTexte.Create;
        with PdfTexte do
          begin
          PageId:= NumeroPage;
          FFont:= FonteNum;
          FSize:= T_Fonte(Fontes[FonteNum]).GetSize;
          FColor:= T_Fonte(Fontes[FonteNum]).GetColor;
          TextPosX:= GetTextPos;
          if (txtRight in TxtFlags)
          then
            TextPosX:= GetColPos+GetColWidth-GetColMargin-Fnt.TextWidth(Chaine);
          if (txtHCenter in TxtFlags)
          then
            TextPosX:= GetTextPos+(GetColWidth-Fnt.TextWidth(Chaine)) div 2;
          TextPosY:= FPapier.H-PosY-Fnt.Ascent;
          TextLarg:= GetColWidth;
          Ecriture:= Chaine;
          end;
        PdfPage.Add(PdfTexte);
        end
    else
      begin
      PdfTexte:= TPdfTexte.Create;
      with PdfTexte do
        begin
        PageId:= NumeroPage;
        FFont:= FonteNum;
        FSize:= T_Fonte(Fontes[FonteNum]).GetSize;
        FColor:= T_Fonte(Fontes[FonteNum]).GetColor;
        FPosX:= PosX;
        FPosY:= PosY-Fnt.Ascent;
        FLarg:= FPapier.W;
        FText:= Chaine;
        end;
      PdfPage.Add(PdfTexte);
      end;
    end;
  end;
end;

procedure T_Imprime.InsereEspace(PosY,Colonne,EspHeight,FondNum: Integer; Zone: TZone);
var
  PosV: Integer;
begin
if PosY> -1
then
  PosV:= PosY
else
  PosV:= FPosRef.Y;
case FPreparation of
  ppPrepare:
    begin
    case Zone of
      zEnTete:
        begin
        FPosRef.Y:= FMargeCourante.T+FEnTeteHeight;
        FPosRef.Y:= FPosRef.Y+EspHeight;
        FEnTeteHeight:= FPosRef.Y-FMargeCourante.T;
        T_Section(Sections[Pred(NumeroSection)]).LoadEspaceEnTete(PosV,Colonne,EspHeight,FondNum);
        end;
      zPage:
        begin
        FPosRef.Y:= FMargeCourante.T+FEnTeteHeight+FPageHeight;
        if FPosRef.Y+EspHeight> FMargeCourante.B-FPiedHeight
        then
          begin
          FPosRef.Y:= FMargeCourante.T+FEnTeteHeight;
          Page;
          end
        else
          FPosRef.Y:= FPosRef.Y+EspHeight;
        FPageHeight:= FPosRef.Y-FEnTeteHeight-FMargeCourante.T;
        T_Section(Sections[Pred(NumeroSection)]).LoadEspacePage(PosV,Colonne,EspHeight,FondNum);
        end;
      zPied:
        begin
        FPosRef.Y:= FMargeCourante.B-EspHeight;
        FPiedHeight:= FPiedHeight+EspHeight;
        PosV:= FPosRef.Y;
        DecaleLignesPied(EspHeight);
        T_Section(Sections[Pred(NumeroSection)]).LoadEspacePied(PosV,Colonne,EspHeight,FondNum);
        end;
      end;
    FinLigne(Zone);
    end;
  ppVisualise:
    with FCanevas,T_Colonne(Colonnes[Colonne]) do
      begin
      if FondNum> -1
      then
        SetColor(T_Fond(Fonds[FondNum]).GetColor)
      else
        SetColor(GetColor);
      FillRectangle(GetColPos,PosV,GetColWidth,EspHeight);
      end;
  ppFichierPDF:
    begin
    if Colonne> -1
    then
      with T_Colonne(Colonnes[Colonne]) do
        begin
        if (GetColor<> clWhite) or (FondNum> -1)
        then
          begin
          PdfRect:= TPdfRect.Create;
          with PdfRect do
            begin
            PageId:= NumeroPage;
            FGauche:= GetColPos;
            FBas:= FPapier.H-PosY-EspHeight;
            FHaut:= EspHeight;
            FLarg:= GetColWidth;
            if FondNum> -1
            then
              FColor:= T_Fond(Fonds[FondNum]).GetColor
            else
              FColor:= GetColor;
            FFill:= True;
            FStroke:= False;
            end;
          PdfPage.Add(PdfRect);
          end;
        end;
    end;
  end;
end;

procedure T_Imprime.FinLigne(Zone: TZone);
begin
case Zone of
  zEnTete:
    T_Section(Sections[Pred(NumeroSection)]).LoadCmdEnTete;
  zPage:
    if FGroupe
    then
      T_Section(Sections[Pred(NumeroSection)]).LoadCmdGroupe
    else
      T_Section(Sections[Pred(NumeroSection)]).LoadCmdPage;
  zPied:
    T_Section(Sections[Pred(NumeroSection)]).LoadCmdPied;
  end;
end;

procedure T_Imprime.TraceCadre(StTrait: Integer; Zone: TZone);
var
  Half: Integer;
begin
case FPreparation of
  ppPrepare:
    T_Section(Sections[Pred(NumeroSection)]).LoadCadre(StTrait,Zone);
  ppVisualise:
    with FCanevas do
      begin
      with T_TraitStyle(TraitStyles[StTrait]) do
        begin
        SetLineStyle(GetEpais,GetStyle);
        Half:= GetEpais div 2;
        SetColor(GetColor);
        end;
      with FMargeCourante do
        case Zone of
          zEnTete:
            begin
            DrawLine(L+Half,T,L+Half,T+FEnTeteHeight);                // gauche
            DrawLine(R-Half,T,R-Half,T+FEnTeteHeight);                // droite
            DrawLine(L,T+Half,R,T+Half);                              // haute
            DrawLine(L,T+FEnTeteHeight-Half,R,T+FEnTeteHeight-Half);  // basse
            end;
          zPage:
            begin
            DrawLine(L+Half,T+FEnTeteHeight,L+Half,B-FPiedHeight);    // gauche
            DrawLine(R-Half,T+FEnTeteHeight,R-Half,B-FPiedHeight);    // droite
            DrawLine(L,T+FEnTeteHeight+Half,R,T+FEnTeteHeight+Half);  // haute
            DrawLine(L,B-FPiedHeight-Half,R,B-FPiedHeight-Half);      // basse
            end;
          zPied:
            begin
            DrawLine(L+Half,B-FPiedHeight,L+Half,B);                  // gauche
            DrawLine(R-Half,B-FPiedHeight,R-Half,B);                  // droite
            DrawLine(L,B-FPiedHeight+Half,R,B-FPiedHeight+Half);      // haute
            DrawLine(L,B-Half,R,B-Half);                              // basse
            end;
          zMarges:
            begin
            DrawLine(L+Half,T,L+Half,B-Succ(Half));                   // gauche
            DrawLine(R-Half,T,R-Half,B-Succ(Half));                   // droite
            DrawLine(L,T+Half,R,T+Half);                              // haute
            DrawLine(L,B-Half,R,B-Half);                              // basse
            end;
          end;
      end;
  ppFichierPDF:
    begin
    PdfRect:= TPdfRect.Create;
    with PdfRect do
      begin
      PageId:= NumeroPage;
      with T_TraitStyle(TraitStyles[StTrait]) do
        begin
        FEpais:= GetEpais;
        FColor:= GetColor;
        FLineStyle:= GetStyle;
        end;
      with FMargeCourante do
        case Zone of
          zEnTete:
            begin
            FGauche:= L;
            FBas:= FPapier.H-T-FEnTeteHeight;
            FHaut:= FEnTeteHeight;
            FLarg:= R-L;
            end;
          zPage:
            begin
            FGauche:= L;
            FBas:= FPapier.H-B-FPiedHeight;
            FHaut:= FPapier.H-T-FEnTeteHeight-B-FPiedHeight;
            FLarg:= R-L;
            end;
          zPied:
            begin
            FGauche:= L;
            FBas:= FPapier.H-B;
            FHaut:= FPiedHeight;
            FLarg:= R-L;
            end;
          zMarges:
            begin
            FGauche:= L;
            FBas:= FPapier.H-B;
            FHaut:= B-T;
            FLarg:= R-L;
            end;
          end;
      FFill:= False;
      FStroke:= True;
      PdfPage.Add(PdfRect);
      end;
    end;
  end;
end;

procedure T_Imprime.TraceTrait(XDebut,YDebut,XFin,YFin,StTrait: Integer);
begin
case FPreparation of
  ppPrepare:
    T_Section(Sections[Pred(NumeroSection)]).LoadTrait(XDebut,YDebut,ColDefaut,XFin,YFin,StTrait);
  ppVisualise:
    begin
    with FCanevas do
      begin
      with T_TraitStyle(TraitStyles[StTrait]) do
        begin
        SetLineStyle(GetEpais,GetStyle);
        SetColor(GetColor);
        end;
      DrawLine(XDebut,YDebut,XFin,YFin);
      end;
    end;
  ppFichierPdf:
    begin
    PdfLine:= TPdfLine.Create;
    with PdfLine do
      begin
      PageId:= NumeroPage;
      FStartX:= XDebut;
      FStartY:= FPapier.H-YDebut;
      FEndX:= XFin;
      FEndY:= FPapier.H-YFin;
      FStyle:= T_TraitStyle(TraitStyles[StTrait]).GetStyle;;
      FColor:= T_TraitStyle(TraitStyles[StTrait]).GetColor;
      FEpais:= T_TraitStyle(TraitStyles[StTrait]).GetEpais;
      end;
    PdfPage.Add(PdfLine);
    end;
  end;
end;

{ Commandes publiques }

constructor T_Imprime.Create;
begin
inherited Create;
Sections:= TList.Create;
Colonnes:= TList.Create;
Fontes:= TList.Create;
Interlignes:= TList.Create;
Fonds:= TList.Create;
TraitStyles:= TList.Create;
Bords:= TList.Create;
Textes:= TStringList.Create;
ALigne:= T_Ligne.Create;
PdfPage:= TList.Create;
OldDecSeparator:= DecimalSeparator;
DecimalSeparator:= '.';
end;

destructor T_Imprime.Destroy;
var
  Cpt: Integer;
begin
DecimalSeparator:= OldDecSeparator;
if Sections.Count> 0
then
  for Cpt:= 0 to Pred(Sections.Count) do
    LiberePages(Sections[Cpt]);
Sections.Free;
if Colonnes.Count> 0
then
  for Cpt:= 0 to Pred(Colonnes.Count) do
    T_Colonne(Colonnes[Cpt]).Free;
Colonnes.Free;
if Fontes.Count> 0
then
  for Cpt:= 0 to Pred(Fontes.Count) do
    T_Fonte(Fontes[Cpt]).Free;
Fontes.Free;
if Interlignes.Count> 0
then
  for Cpt:= 0 to Pred(Interlignes.Count) do
    T_Interligne(Interlignes[Cpt]).Free;
Interlignes.Free;
if Fonds.Count> 0
then
  for Cpt:= 0 to Pred(Fonds.Count) do
    T_Fond(Fonds[Cpt]).Free;
Fonds.Free;
if TraitStyles.Count> 0
then
  for Cpt:= 0 to Pred(TraitStyles.Count) do
    T_TraitStyle(TraitStyles[Cpt]).Free;
TraitStyles.Free;
if Bords.Count> 0
then
  for Cpt:= 0 to Pred(Bords.Count) do
    T_Bord(Bords[Cpt]).Free;
Bords.Free;
Textes.Free;
ALigne.Free;
inherited;
end;

procedure T_Imprime.Debut(IniOriente: TOrient= oPortrait; IniTypePapier: TTypePapier= A4;
          IniMesure: TMesure= msMM; IniVersion: Char= 'F'; IniVisu: Boolean= True);
begin
FVersion:= IniVersion;
FOrientation:= IniOriente;
FTypepapier:= IniTypePapier;
FMesure:= IniMesure;
FPreparation:= ppPrepare;
FVisualisation:= IniVisu;
PrepareVisu;
FFonteCourante:= -1;
FInterLCourante:= -1;
FGroupe:= False;
end;

procedure T_Imprime.Fin;
var
  Cpt: Integer;
begin
FPreparation:= ppFichierPDF;
if Sections.Count> 0
then
  for Cpt:= 1 to Sections.Count do
    begin
    NumeroSection:= Cpt;
    if T_Section(Sections[Pred(NumeroSection)]).TotPages> 0
    then
      begin
      NumeroPageSection:= 1;
      NumeroPage:= 1;
      end;
    end
else
  Exit;
for Cpt:= 1 to T_Section(Sections[Pred(NumeroSection)]).TotPages do
  ImprimePage(Cpt);
if FVisualisation
then
  begin
  FPreparation:= ppVisualise;
  try
    ImprimeDocument;
    if FVisualisation
    then
      F_Visu.ShowModal;
  finally
    F_Visu.Free;
    end;
  end;
//Libere;
end;

procedure T_Imprime.ImprimeDocument;
begin
if FVisualisation
then
  FCanevas:= Bv_Visu.Canvas;
end;

procedure T_Imprime.Visualisation;
begin
FVisualisation:= not FVisualisation;
if FVisualisation
then
  FCanevas:= Bv_Visu.Canvas;
end;

procedure T_Imprime.Section(MgGauche,MgDroite,MgHaute,MgBasse: Single; Retrait: Single);
var
  CMargin: Integer;
begin
if FPreparation= ppPrepare
then
  begin
  with FMargeCourante,FPapier do
    begin
    if Dim2Pixels(MgGauche)> Imprimable.L
    then
      L:= Dim2Pixels(MgGauche)
    else
      L:= Imprimable.L;
    if (W-Dim2Pixels(MgDroite))< Imprimable.R
    then
      R:= W-Dim2Pixels(MgDroite)
    else
      R:= Imprimable.R;
    if Dim2Pixels(MgHaute)> Imprimable.T
    then
      T:= Dim2Pixels(MgHaute)
    else
      T:= Imprimable.T;
    if (H-Dim2Pixels(MgBasse))< Imprimable.B
    then
      B:= H-Dim2Pixels(MgBasse)
    else
      B:= Imprimable.B;
    end;
  FPosRef.X:= FMargeCourante.L;
  FEnTeteHeight:= 0;
  FPageHeight:= 0;
  FPiedHeight:= 0;
  NumeroSection:= NumeroSection+1;
  ASection:= T_Section.Create(FMargeCourante,NumeroSection);
  Sections.Add(ASection);
  if Sections.Count= 1
  then
    begin
    CMargin:= Dim2Pixels(Retrait);
    AColonne:= T_Colonne.Create(FMargeCourante.L,FMargeCourante.R-FMargeCourante.L,CMargin,clWhite);
    Colonnes.Add(AColonne);
    end;
  end;
end;

procedure T_Imprime.Page;
begin
if FPreparation= ppPrepare
then
  begin
  NumeroPage:= NumeroPage+1;
  T_Section(Sections[Pred(Sections.Count)]).LoadPage(NumeroPage);
  FPosRef.Y:= FMargeCourante.T+FEnTeteHeight;
  FPageHeight:= 0;
  end;
end;

function T_Imprime.Fond(FdColor: TfpgColor): Integer;
begin
AFond:= T_Fond.Create(FdColor);
Result:= Fonds.Add(AFond);
end;

function T_Imprime.Fonte(FtNom: string; FtColor: TfpgColor): Integer;
begin
AFonte:= T_Fonte.Create(FtNom,FtColor);
Result:= Fontes.Add(AFonte);
end;

function T_Imprime.StyleTrait(StEpais: Integer; StColor: Tfpgcolor; StStyle: TfpgLineStyle): Integer;
begin
ATraitStyle:= T_TraitStyle.Create(StEpais,StColor,StStyle);
Result:= TraitStyles.Add(ATraitStyle);
end;

function T_Imprime.Bordure(BdFlags: TFBordFlags; BdStyle: Integer): Integer;
begin
ABord:= T_Bord.Create(BdFlags,BdStyle);
Result:= Bords.Add(ABord);
end;

function T_Imprime.Colonne(ClnPos,ClnWidth: Single; ClnMargin: Single= 0; ClnColor: TfpgColor= clWhite): Integer;
var
  CPos,CWidth,CMargin: Integer;
begin
CPos:= Dim2Pixels(ClnPos);
with T_Section(Sections[Pred(NumeroSection)]) do
  begin
  if CPos< GetMarges.L
  then
    CPos:= GetMarges.L;
  CWidth:= Dim2Pixels(ClnWidth);
  if CWidth> (GetMarges.R-GetMarges.L)
  then
    CWidth:= GetMarges.R-GetMarges.L;
  end;
CMargin:= Dim2Pixels(ClnMargin);
AColonne:= T_Colonne.Create(CPos,CWidth,CMargin,ClnColor);
Result:= Colonnes.Add(AColonne);
end;

procedure T_Imprime.EcritEnTete(Horiz,Verti: Single; Texte: string; ColNum: Integer= 0; FonteNum: Integer= 0;
          InterNum: Integer= 0; CoulFdNum: Integer= -1; BordNum: Integer= -1);
var
  X,Y,RefTexte: Integer;
  Flags: TFTextFlags;
begin
Flags:= [];
if Horiz< 0
then
  begin
  X:= Round(Horiz);
  case X of
    cnLeft:
      Include(Flags,txtLeft);
    cnCenter:
      Include(Flags,txtHCenter);
    cnRight:
      Include(Flags,txtRight);
    end;
  end
else
  X:= Dim2Pixels(Horiz);
if Verti< 0
then
  Y:= Round(Verti)
else
  Y:= Dim2Pixels(Verti);
RefTexte:= Textes.IndexOf(Texte);
if RefTexte= -1
then
  RefTexte:= Textes.Add(Texte);
EcritLigne(X,Y,ColNum,RefTexte,FonteNum,CoulFdNum,BordNum,InterNum,Flags,ZEnTete);
end;

procedure T_Imprime.EcritPage(Horiz,Verti: Single; Texte: string; ColNum: Integer= 0; FonteNum: Integer= 0;
          InterNum: Integer= 0; CoulFdNum: Integer= -1; BordNum: Integer= -1);
var
  X,Y,RefTexte: Integer;
  Flags: TFTextFlags;
begin
Flags:= [];
if Horiz< 0
then
  begin
  X:= Round(Horiz);
  Include(Flags,txtWrap);
  case X of
    cnLeft:
      Include(Flags,txtLeft);
    cnCenter:
      Include(Flags,txtHCenter);
    cnRight:
      Include(Flags,txtRight);
    end;
  end
else
  X:= Dim2Pixels(Horiz);
if Verti< 0
then
  Y:= Round(Verti)
else
  Y:= Dim2Pixels(Verti);
RefTexte:= Textes.IndexOf(Texte);
if RefTexte= -1
then
  RefTexte:= Textes.Add(Texte);
EcritLigne(X,Y,ColNum,RefTexte,FonteNum,CoulFdNum,BordNum,InterNum,Flags,ZPage);
end;

procedure T_Imprime.EcritPied(Horiz,Verti: Single; Texte: string; ColNum: Integer= 0; FonteNum: Integer= 0;
          InterNum: Integer= 0; CoulFdNum: Integer= -1; BordNum: Integer= -1);
var
  X,Y,RefTexte: Integer;
  Flags: TFTextFlags;
begin
Flags:= [];
if Horiz< 0
then
  begin
  X:= Round(Horiz);
  case X of
    cnLeft:
      Include(Flags,txtLeft);
    cnCenter:
      Include(Flags,txtHCenter);
    cnRight:
      Include(Flags,txtRight);
    end;
  end
else
  X:= Dim2Pixels(Horiz);
if Verti< 0
then
  Y:= Round(Verti)
else
  Y:= Dim2Pixels(Verti);
RefTexte:= Textes.IndexOf(Texte);
if RefTexte= -1
then
  RefTexte:= Textes.Add(Texte);
EcritLigne(X,Y,ColNum,RefTexte,FonteNum,CoulFdNum,BordNum,InterNum,Flags,ZPied);
end;

procedure T_Imprime.NumSectionEnTete(Horiz,Verti: Single; TexteSect: string= ''; TexteTot: string= '';
          Total: Boolean= False; Alpha: Boolean= False; ColNum: Integer= 0; FonteNum: Integer= 0;
          InterNum: Integer= 0; CoulFdNum: Integer= -1; BordNum: Integer= -1);
var
  X,Y,RefTextePage,RefTexteTot: Integer;
  Flags: TFTextFlags;
begin
Flags:= [];
if Horiz< 0
then
  begin
  X:= Round(Horiz);
  case X of
    cnLeft:
      Include(Flags,txtLeft);
    cnCenter:
      Include(Flags,txtHCenter);
    cnRight:
      Include(Flags,txtRight);
    end;
  end
else
  X:= Dim2Pixels(Horiz);
if Verti< 0
then
  Y:= Round(Verti)
else
  Y:= Dim2Pixels(Verti);
RefTextePage:= Textes.IndexOf(TexteSect);
if RefTextePage= -1
then
  RefTextePage:= Textes.Add(TexteSect);
RefTexteTot:= Textes.IndexOf(TexteTot);
if RefTexteTot= -1
then
  RefTexteTot:= Textes.Add(TexteTot);
EcritNum(X,Y,ColNum,RefTextePage,RefTexteTot,FonteNum,CoulFdNum,BordNum,InterNum,Flags,Total,Alpha,ZEnTete,SectNum);
end;

procedure T_Imprime.NumSectionPied(Horiz,Verti: Single; TexteSect: string= ''; TexteTot: string= '';
          Total: Boolean= False; Alpha: Boolean= False; ColNum: Integer= 0; FonteNum: Integer= 0;
          InterNum: Integer= 0;CoulFdNum: Integer= -1; BordNum: Integer= -1);
var
  X,Y,RefTextePage,RefTexteTot: Integer;
  Flags: TFTextFlags;
begin
Flags:= [];
if Horiz< 0
then
  begin
  X:= Round(Horiz);
  case X of
    cnLeft:
      Include(Flags,txtLeft);
    cnCenter:
      Include(Flags,txtHCenter);
    cnRight:
      Include(Flags,txtRight);
    end;
  end
else
  X:= Dim2Pixels(Horiz);
if Verti< 0
then
  Y:= Round(Verti)
else
  Y:= Dim2Pixels(Verti);
RefTextePage:= Textes.IndexOf(TexteSect);
if RefTextePage= -1
then
  RefTextePage:= Textes.Add(TexteSect);
RefTexteTot:= Textes.IndexOf(TexteTot);
if RefTexteTot= -1
then
  RefTexteTot:= Textes.Add(TexteTot);
EcritNum(X,Y,ColNum,RefTextePage,RefTexteTot,FonteNum,CoulFdNum,BordNum,InterNum,Flags,Total,Alpha,ZPied,SectNum);
end;

procedure T_Imprime.NumPageEnTete(Horiz,Verti: Single; TextePage: string= ''; TexteTotal: string= '';
          Total: Boolean= False; ColNum: Integer= 0; FonteNum: Integer= 0; InterNum: Integer= 0;
          CoulFdNum: Integer= -1; BordNum: Integer= -1);
var
  X,Y,RefTextePage,RefTexteTot: Integer;
  Flags: TFTextFlags;
begin
Flags:= [];
if Horiz< 0
then
  begin
  X:= Round(Horiz);
  case X of
    cnLeft:
      Include(Flags,txtLeft);
    cnCenter:
      Include(Flags,txtHCenter);
    cnRight:
      Include(Flags,txtRight);
    end;
  end
else
  X:= Dim2Pixels(Horiz);
if Verti< 0
then
  Y:= Round(Verti)
else
  Y:= Dim2Pixels(Verti);
RefTextePage:= Textes.IndexOf(TextePage);
if RefTextePage= -1
then
  RefTextePage:= Textes.Add(TextePage);
RefTexteTot:= Textes.IndexOf(TexteTotal);
if RefTexteTot= -1
then
  RefTexteTot:= Textes.Add(TexteTotal);
EcritNum(X,Y,ColNum,RefTextePage,RefTexteTot,FonteNum,CoulFdNum,BordNum,InterNum,Flags,Total,False,ZEnTete,PageNum);
end;

procedure T_Imprime.NumPagePied(Horiz,Verti: Single; TextePage: string= ''; TexteTotal: string= '';
          Total: Boolean= False; ColNum: Integer= 0; FonteNum: Integer= 0; InterNum: Integer= 0;
          CoulFdNum: Integer= -1; BordNum: Integer= -1);
var
  X,Y,RefTextePage,RefTexteTot: Integer;
  Flags: TFTextFlags;
begin
Flags:= [];
if Horiz< 0
then
  begin
  X:= Round(Horiz);
  case X of
    cnLeft:
      Include(Flags,txtLeft);
    cnCenter:
      Include(Flags,txtHCenter);
    cnRight:
      Include(Flags,txtRight);
    end;
  end
else
  X:= Dim2Pixels(Horiz);
if Verti< 0
then
  Y:= Round(Verti)
else
  Y:= Dim2Pixels(Verti);
RefTextePage:= Textes.IndexOf(TextePage);
if RefTextePage= -1
then
  RefTextePage:= Textes.Add(TextePage);
RefTexteTot:= Textes.IndexOf(TexteTotal);
if RefTexteTot= -1
then
  RefTexteTot:= Textes.Add(TexteTotal);
EcritNum(X,Y,ColNum,RefTextePage,RefTexteTot,FonteNum,CoulFdNum,BordNum,InterNum,Flags,Total,False,ZPied,PageNum);
end;

procedure T_Imprime.NumPageSectionEnTete(Horiz,Verti: Single; TexteSect: string= ''; TexteTot: string= '';
          Total: Boolean= False; Alpha: Boolean= False; ColNum: Integer= 0; FonteNum: Integer= 0;
          InterNum: Integer= 0; CoulFdNum: Integer= -1; BordNum: Integer= -1);
var
  X,Y,RefTextePage,RefTexteTot: Integer;
  Flags: TFTextFlags;
begin
Flags:= [];
if Horiz< 0
then
  begin
  X:= Round(Horiz);
  case X of
    cnLeft:
      Include(Flags,txtLeft);
    cnCenter:
      Include(Flags,txtHCenter);
    cnRight:
      Include(Flags,txtRight);
    end;
  end
else
  X:= Dim2Pixels(Horiz);
if Verti< 0
then
  Y:= Round(Verti)
else
  Y:= Dim2Pixels(Verti);
RefTextePage:= Textes.IndexOf(TexteSect);
if RefTextePage= -1
then
  RefTextePage:= Textes.Add(TexteSect);
RefTexteTot:= Textes.IndexOf(TexteTot);
if RefTexteTot= -1
then
  RefTexteTot:= Textes.Add(TexteTot);
EcritNum(X,Y,ColNum,RefTextePage,RefTexteTot,FonteNum,CoulFdNum,BordNum,InterNum,Flags,Total,Alpha,ZEnTete,PSectNum);
end;

procedure T_Imprime.NumPageSectionPied(Horiz,Verti: Single; TexteSect: string= ''; TexteTot: string= '';
          Total: Boolean= False; Alpha: Boolean= False; ColNum: Integer= 0; FonteNum: Integer= 0;
          InterNum: Integer= 0; CoulFdNum: Integer= -1; BordNum: Integer= -1);
var
  X,Y,RefTextePage,RefTexteTot: Integer;
  Flags: TFTextFlags;
begin
Flags:= [];
if Horiz< 0
then
  begin
  X:= Round(Horiz);
  case X of
    cnLeft:
      Include(Flags,txtLeft);
    cnCenter:
      Include(Flags,txtHCenter);
    cnRight:
      Include(Flags,txtRight);
    end;
  end
else
  X:= Dim2Pixels(Horiz);
if Verti< 0
then
  Y:= Round(Verti)
else
  Y:= Dim2Pixels(Verti);
RefTextePage:= Textes.IndexOf(TexteSect);
if RefTextePage= -1
then
  RefTextePage:= Textes.Add(TexteSect);
RefTexteTot:= Textes.IndexOf(TexteTot);
if RefTexteTot= -1
then
  RefTexteTot:= Textes.Add(TexteTot);
EcritNum(X,Y,ColNum,RefTextePage,RefTexteTot,FonteNum,CoulFdNum,BordNum,InterNum,Flags,Total,Alpha,ZPied,PSectNum);
end;

procedure T_Imprime.EspaceEnTete(Verti: Single; ColNum: Integer=0; CoulFdNum: Integer= -1);
var
  H: Integer;
begin
H:= Dim2Pixels(Verti);
InsereEspace(-1,ColNum,H,CoulFdNum,zEntete);
end;

procedure T_Imprime.EspacePage(Verti: Single; ColNum: Integer=0; CoulFdNum: Integer= -1);
var
  H: Integer;
begin
H:= Dim2Pixels(Verti);
InsereEspace(-1,ColNum,H,CoulFdNum,zPage);
end;

procedure T_Imprime.EspacePied(Verti: Single; ColNum: Integer=0; CoulFdNum: Integer= -1);
var
  H: Integer;
begin
H:= Dim2Pixels(Verti);
InsereEspace(-1,ColNum,H,CoulFdNum,zPied);
end;

function T_Imprime.Interligne(ItlSup,ItlInt,ItlInf: Single): Integer;
var
  Sup,Int,Inf: Integer;
begin
if ItlSup> 0
then
  Sup:= Dim2Pixels(ItlSup)
else
  Sup:= 0;
if ItlInt> 0
then
  Int:= Dim2Pixels(ItlInt)
else
  Int:= 0;
if ItlInf> 0
then
  Inf:= Dim2Pixels(ItlInf)
else
  Inf:= 0;
AInterligne:= T_Interligne.Create(Sup,Int,Inf);
Result:= Interlignes.Add(AInterligne);
end;

procedure T_Imprime.Groupe(SautPage: Boolean= False);
begin
AGroupe:= T_Groupe.Create;
FGroupe:= True;
if SautPage
then
  Page;
end;

procedure T_Imprime.FinGroupe(SautPage: Boolean= False);
var
  Cpt: Integer;
begin
T_Section(Sections[Pred(Sections.Count)]).LoadCmdGroupeToPage;
FGroupe:= False;
AGroupe.Free;
if SautPage
then
  Page;
end;

procedure T_Imprime.ColorColChange(ColNum: Integer; ColColor: TfpgColor);
begin
T_Colonne(Colonnes[ColNum]).SetColColor(ColColor);
end;

procedure T_Imprime.CadreMarges(AStyle: Integer);
begin
TraceCadre(AStyle,zMarges);
end;

procedure T_Imprime.CadreEnTete(AStyle: Integer);
begin
TraceCadre(AStyle,zEntete);
end;

procedure T_Imprime.CadrePage(AStyle: Integer);
begin
TraceCadre(AStyle,zPage);
end;

procedure T_Imprime.CadrePied(AStyle: Integer);
begin
TraceCadre(AStyle,zPied);
end;

procedure T_Imprime.TraitPage(XDebut,YDebut,XFin,YFin: Single; AStyle: Integer);
var
  XDeb,YDeb,XEnd,YEnd: Integer;
begin
XDeb:= Dim2Pixels(XDebut);
YDeb:= Dim2Pixels(YDebut);
XEnd:= Dim2Pixels(XFin);
YEnd:= Dim2Pixels(YFin);
TraceTrait(XDeb,YDeb,XEnd,YEnd,AStyle);
end;

end.

