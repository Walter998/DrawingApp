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
    listPoints: TList<TPoint>;
  public
    function getListPoints(): TList<TPoint>;
    procedure setListPoints(ilistPoints: TList<TPoint>);
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
  
{Function name: TformMainForm.getListPoints()          }
{Description: return listPoints property               }
{Input: N/A                                            }
{Return:                                               }
{       TList<TPoint> : list of TPoint value           }
function TformMainForm.getListPoints(): TList<TPoint>;
begin
  getListPoints := listPoints;
end;

{Function name: TformMainForm.setListPoints()                    }
{Description: set listPoints property with new value             }
{Input:                                                          }
{ilistPoints(TList<TPoint>) : value to set for listPoints        }
{Return: N/A                                                     }
procedure TformMainForm.setListPoints(ilistPoints: TList<TPoint>);
begin
  self.listPoints := ilistPoints;
end;

{Function name: TformMainForm.btnExportClick           }
{Description: function handle event click btnExport    }
{Input: N/A                                            }
{Return: N/A                                           }
procedure TformMainForm.btnExportClick(Sender: TObject);
begin
  if (listPoints.Count < 1)
  and (MessageDlg(STR_MSG_CONFIRM_EXPORT,
    mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo) then
    Exit();

  pXMLHandler.ExportXML(listPoints);
  ShowMessage(STR_MSG_EXPORT_XML_FILE);
end;

{Function name: TformMainForm.btnImportClick           }
{Description: function handle event click btnImport    }
{Input: N/A                                            }
{Return: N/A                                           }
procedure TformMainForm.btnImportClick(Sender: TObject);
begin

  listPoints := pXMLHandler.ImportXML;
  labelNumOfPoint.Caption := IntToStr(listPoints.Count);

  self.Render();
end;

{Function name: TformMainForm.FormCreate               }
{Description: function handle event create main form   }
{Input: N/A                                            }
{Return: N/A                                           }
procedure TformMainForm.FormCreate(Sender: TObject);
begin
  pXMLHandler := TXMLHandler.Create;
  listPoints := TList<TPoint>.Create;
end;

{Function name: TformMainForm.OnDblClick               }
{Description: function handle event create main form   }
{Input: N/A                                            }
{Return: N/A                                           }
procedure TformMainForm.OnDblClick(Sender: TObject);
begin
  //TODO: Prevent OnClick to happen
  CalculateDistance;
end;

{Function name: TformMainForm.OnDestroy                }
{Description: function handle event destroy main form  }
{Input: N/A                                            }
{Return: N/A                                           }
procedure TformMainForm.OnDestroy(Sender: TObject);
begin
  listPoints.Free;
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

  labelNumOfPoint.Caption := IntToStr(listPoints.Count);
end;

{Function name: TformMainForm.Render                   }
{Description: function render point to form            }
{Input:                                                }
{iPoint(TPoint) : input point to render                }
{Return: N/A                                           }
procedure TformMainForm.Render(iPoint: TPoint);
begin
  // Add point and render
  listPoints.Add(iPoint);
  listPoints.TrimExcess;

  iPoint.X := iPoint.X + panelButtons.Width;
  iPoint.Y := iPoint.Y + panelDisplay.Height;

  //If there are more than 2 points in the Graph
  if listPoints.Count > 1 then
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

{Function name: TformMainForm.Render                   }
{Description: function render whole point list to form }
{Input: N/A                                            }
{Return: N/A                                           }
procedure TformMainForm.Render();
var
  idx : integer;
  drawPoint: TPoint;
begin
  //Render list points
  drawPoint := listPoints[0];
  drawPoint.X := drawPoint.X + panelButtons.Width;
  drawPoint.Y := drawPoint.Y + panelDisplay.Height;

  Canvas.MoveTo(drawPoint.X,drawPoint.Y);

  for idx := 1 to listPoints.Count-1 do
  begin
    drawPoint := listPoints[idx];
    drawPoint.X := drawPoint.X + panelButtons.Width;
    drawPoint.Y := drawPoint.Y + panelDisplay.Height;
    Canvas.LineTo(drawPoint.X,drawPoint.Y);
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
  for idx := 1 to listPoints.Count-1 do
  begin
    XPointSq := sqr(listPoints[idx].X-listPoints[idx-1].X);
    YPointSq := sqr(listPoints[idx].Y-listPoints[idx-1].Y);
    Distance := sqrt(XPointSq + YPointSq);
    TotalDistance := TotalDistance + Distance;
  end;

  labelDistance.Caption := FloatToStr(TotalDistance);

end;

end.
