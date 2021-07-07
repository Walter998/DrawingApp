{Unit name: ScreenHandler                    }
{Description: Handle all main screen event   }

unit ScreenHandler;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  System.Generics.Collections, System.UITypes, Vcl.ExtCtrls;

type
  TformMainForm = class(TForm)
    panelButtons: TPanel;
    btnExport: TButton;
    btnImport: TButton;
    panelDisplay: TPanel;
    labelX: TLabel;
    labelXCoordinate: TLabel;
    labelY: TLabel;
    labelYCoordinate: TLabel;
    labelNums: TLabel;
    labelNumOfPoint: TLabel;
    labelTotalDistance: TLabel;
    labelDistance: TLabel;
    procedure OnDblClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OnClick(Sender: TObject);
    procedure OnDestroy(Sender: TObject);
  private
    listZigzag: TList<TList<TPoint>>;
    currentZigzag: TList<TPoint>;
  public
    function getListZigzag(): TList<TList<TPoint>>;
    procedure setListZigzag(iListZigzag: TList<TList<TPoint>>);
    procedure Render(); overload;
    procedure Render(iPoint: TPoint); overload;
    procedure CalculateDistance();
  end;
var
  formMainForm: TformMainForm;

implementation

uses
  User_defined,XMLHandler;
{$R *.dfm}
var
  pXMLHandler: TXMLHandler;
  
{Function name: TformMainForm.getListZigzag            }
{Description: return listPoints property               }
{Input: N/A                                            }
{Return:                                               }
{       TList<TPoint> : list of TPoint value           }
function TformMainForm.getListZigzag(): TList<TList<TPoint>>;
begin
  getListZigzag := listZigzag;
end;

{Function name: TformMainForm.setListZigzag                      }
{Description: set listPoints property with new value             }
{Input:                                                          }
{ilistPoints(TList<TPoint>) : value to set for listPoints        }
{Return: N/A                                                     }
procedure TformMainForm.setListZigzag(iListZigzag: TList<TList<TPoint>>);
begin
  self.listZigzag := iListZigzag;
end;

{Function name: TformMainForm.btnExportClick           }
{Description: function handle event click btnExport    }
{Input: N/A                                            }
{Return: N/A                                           }
procedure TformMainForm.btnExportClick(Sender: TObject);
begin
  if (listZigzag.Count < 1)
  and (MessageDlg(STR_MSG_CONFIRM_EXPORT,
    mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo) then
    Exit();

  pXMLHandler.ExportXML(listZigzag);
  ShowMessage(STR_MSG_EXPORT_XML_FILE);
end;

{Function name: TformMainForm.btnImportClick           }
{Description: function handle event click btnImport    }
{Input: N/A                                            }
{Return: N/A                                           }
procedure TformMainForm.btnImportClick(Sender: TObject);
begin
  try
    listZigzag := pXMLHandler.ImportXML;
    self.Render();
  except
    on E: exception do
    begin
      MessageDlg(STR_MSG_NOT_FOUND,mtError,mbOKCancel,0);
    end;

  end;

end;

{Function name: TformMainForm.FormCreate               }
{Description: function handle event create main form   }
{Input: N/A                                            }
{Return: N/A                                           }
procedure TformMainForm.FormCreate(Sender: TObject);
begin
  pXMLHandler := TXMLHandler.Create;
  listZigzag := TList<TList<TPoint>>.Create;
  currentZigzag := TList<TPoint>.Create;
end;

{Function name: TformMainForm.OnDblClick               }
{Description: function handle event create main form   }
{Input: N/A                                            }
{Return: N/A                                           }
procedure TformMainForm.OnDblClick(Sender: TObject);
begin
  //TODO: Prevent OnClick to happen
  CalculateDistance;
  listZigzag.Add(currentZigzag);
  currentZigzag := TList<TPoint>.Create;
end;

{Function name: TformMainForm.OnDestroy                }
{Description: function handle event destroy main form  }
{Input: N/A                                            }
{Return: N/A                                           }
procedure TformMainForm.OnDestroy(Sender: TObject);
begin
//  for idxZigZag := 0 to listZigzag.Count-1 do
//  begin
//    listZigzag[idxZigZag].Free;
//  end;

  listZigzag.Free;
  pXMLHandler.Free;
end;

{Function name: TformMainForm.OnClick                  }
{Description: function handle event click main form    }
{Input: N/A                                            }
{Return: N/A                                           }
procedure TformMainForm.OnClick(Sender: TObject);
var
  Point: TPoint;
begin
  //Update cursor position to Labels
  GetCursorPos(Point);

  Point.X := Point.X - panelButtons.Width;
  Point.Y := Point.Y - panelDisplay.Height;

  labelXCoordinate.Caption := IntToStr(Point.X);
  labelYCoordinate.Caption := IntToStr(Point.Y);

  self.Render(Point);

  labelNumOfPoint.Caption := IntToStr(currentZigzag.Count);
end;

{Function name: TformMainForm.Render                   }
{Description: function render point to form            }
{Input:                                                }
{iPoint(TPoint) : input point to render                }
{Return: N/A                                           }
procedure TformMainForm.Render(iPoint: TPoint);
begin
  // Add point and render
  currentZigzag.Add(iPoint);
  currentZigzag.TrimExcess;

  iPoint.X := iPoint.X + panelButtons.Width;
  iPoint.Y := iPoint.Y + panelDisplay.Height;

  //If there are more than 2 points in the Graph
  if currentZigzag.Count > 1 then
  begin
    //Draw a line
    Canvas.LineTo( iPoint.X, iPoint.Y );
  end
  else
  begin
    //Move into position
    Canvas.MoveTo( iPoint.X, iPoint.Y );
  end;

end;

{Function name: TformMainForm.Render                    }
{Description: function render whole zigzag list to form }
{Input: N/A                                             }
{Return: N/A                                            }
procedure TformMainForm.Render();
var
  PointIdx : integer;
  ZigzagIdx : integer;
  drawPoint: TPoint;
  drawZigzag: TList<TPoint>;
begin
  //Render list zigzag
  for ZigzagIdx := 0 to listZigzag.Count-1 do
  begin
    drawZigzag := listZigzag[ZigzagIdx];

    drawPoint := drawZigzag[0];
    drawPoint.X := drawPoint.X + panelButtons.Width;
    drawPoint.Y := drawPoint.Y + panelDisplay.Height;

    Canvas.MoveTo(drawPoint.X, drawPoint.Y);

    for PointIdx := 1 to drawZigzag.Count-1 do
    begin
      drawPoint := drawZigzag[PointIdx];
      drawPoint.X := drawPoint.X + panelButtons.Width;
      drawPoint.Y := drawPoint.Y + panelDisplay.Height;

      Canvas.LineTo(drawPoint.X, drawPoint.Y);
    end;
  end;
end;

{Function name: TformMainForm.CalculateDistance        }
{Description: function calculate distance of the Graph }
{Input: N/A                                            }
{Return: N/A                                           }
procedure TformMainForm.CalculateDistance;
var
  idx: integer;
  TotalDistance: Extended;
  Distance: Extended;
  XPointSq,YPointSq: integer;
begin
  TotalDistance := 0;
  for idx := 1 to currentZigzag.Count-1 do
  begin
    XPointSq := sqr(currentZigzag[idx].X-currentZigzag[idx-1].X);
    YPointSq := sqr(currentZigzag[idx].Y-currentZigzag[idx-1].Y);
    Distance := sqrt(XPointSq + YPointSq);
    TotalDistance := TotalDistance + Distance;
  end;

  labelDistance.Caption := FloatToStr(TotalDistance);

end;

end.