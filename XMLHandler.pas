{Unit name: XMLHandler                         }
{Description: Handle XML import/export event   }

unit XMLHandler;

interface

uses
  System.SysUtils, System.Variants, System.Classes,
  Winapi.Windows, Winapi.Messages, System.Generics.Collections, XMLIntf, XMLDoc;

type
  TXMLHandler = class
    private
      strAddress : string;
    public
      constructor Create();
      function ImportXML(): TList<TPoint>;
      procedure ExportXML(listPoints: TList<TPoint>);
      function getCurrentAdd(): string;
      procedure setCurrentAdd(strAdd: string);
  end;
implementation

uses
  User_defined;

{Function name: TXMLHandler.Create                     }
{Description: Constructor                              }
{Input: N/A                                            }
{Return: N/A                                           }
constructor TXMLHandler.Create();
begin
  //TODO: Hard code
  strAddress := GetCurrentDir + CHR_BACKSLASH + STR_XML_FILE_NAME;
end;

{Function name: TXMLHandler.getCurrentAdd              }
{Description: function get current XML address         }
{Input: N/A                                            }
{Return: string: current address                       }
function TXMLHandler.getCurrentAdd(): string;
begin
  getCurrentAdd := strAddress;
end;

{Function name: TXMLHandler.setCurrentAdd              }
{Description: function set current XML address         }
{Input:                                                }
{strAdd(string) : address to be set                    }
{Return: N/A                                           }
procedure TXMLHandler.setCurrentAdd(strAdd: string);
begin
  if strAdd <> STR_NULL then
  begin
    strAddress := strAdd;
  end;
end;

{Function name: TXMLHandler.ImportXML                  }
{Description: function return point list               }
{Input: N/A                                            }
{Return: TList<TPoint>: list of imported points        }
function TXMLHandler.ImportXML(): TList<TPoint>;
var
  Doc: IXMLDocument;
  nodePointList: IXMLNode;
  listPoints: TList<TPoint>;
  Point: TPoint;
  idx: Integer;
begin
  Doc := LoadXMLDocument(strAddress);
  nodePointList := Doc.DocumentElement;

  listPoints := TList<TPoint>.Create;
  for idx := 0 to nodePointList.ChildNodes.Count-1 do
    begin
      Point.X := nodePointList.ChildNodes[idx].Attributes[CHR_XML_NODE_ATT_X];
      Point.Y := nodePointList.ChildNodes[idx].Attributes[CHR_XML_NODE_ATT_Y];
      listPoints.Add(Point);
      listPoints.TrimExcess;
    end;

  ImportXML := listPoints;
end;

{Function name: TXMLHandler.ExportXML                  }
{Description: function export list points to XML       }
{Input:                                                }
{listPoints(TList<TPoint>) : point list to export      }
{Return: N/A                                           }
procedure TXMLHandler.ExportXML(listPoints: TList<TPoint>);
var
  XML : IXMLDOCUMENT;
  RootNode, CurNode : IXMLNODE;
  intIdx : Integer;
  tempPoint: TPoint;
begin

  XML := NewXMLDocument;
  XML.Encoding := STR_TXT_FORMAT_UTF8;
  XML.Options := [doNodeAutoIndent];
  RootNode := XML.AddChild(STR_XML_NODE_POINTLIST);
  for intIdx := 0 to listPoints.Count-1 do
  begin
    tempPoint := listPoints[intIdx];
    CurNode := RootNode.AddChild(STR_XML_NODE_POINT);
    CurNode.Attributes[CHR_XML_NODE_ATT_X] := tempPoint.X;
    CurNode.Attributes[CHR_XML_NODE_ATT_Y] := tempPoint.Y;
  end;

  XMl.SaveToFile(strAddress);
end;
end.
