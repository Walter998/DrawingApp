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
      function ImportXML(): TList<TList<TPoint>>;
      procedure ExportXML(listZigzag: TList<TList<TPoint>>);
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
function TXMLHandler.ImportXML(): TList<TList<TPoint>>;
var
  Doc: IXMLDocument;
  nodePoint, nodeZigzag, nodeRoot: IXMLNode;
  listZigzag: TList<TList<TPoint>>;
  currentZigzag: TList<TPoint>;
  Point: TPoint;
  ZigZagIdx: Integer;
  PointIdx: Integer;
begin
  listZigzag := TList<TList<TPoint>>.Create;
  currentZigzag := TList<TPoint>.Create;
  
  Doc := LoadXMLDocument(strAddress);
  nodeRoot := Doc.DocumentElement;
  
  for ZigZagIdx := 0 to nodeRoot.ChildNodes.Count-1 do
    begin
      nodeZigzag := nodeRoot.ChildNodes[ZigZagIdx];
      
      for PointIdx := 0 to nodeZigzag.ChildNodes.Count-1 do
      begin
        nodePoint := nodeZigZag.ChildNodes[PointIdx];
        
        Point.X := nodePoint.Attributes[CHR_XML_NODE_ATT_X];
        Point.Y := nodePoint.Attributes[CHR_XML_NODE_ATT_Y];

        currentZigzag.Add(Point);
        currentZigzag.TrimExcess;
      end;

      listZigzag.Add(currentZigzag);
      listZigzag.TrimExcess;
      currentZigzag := TList<TPoint>.Create;
    end;

  ImportXML := listZigzag;
end;

{Function name: TXMLHandler.ExportXML                         }
{Description: function export list points to XML              }
{Input:                                                       }
{listPoints(TList<TList<TPoint>>) : point list to export      }
{Return: N/A                                                  }
procedure TXMLHandler.ExportXML(listZigzag: TList<TList<TPoint>>);
var
  XML : IXMLDOCUMENT;
  RootNode, ZigzagNode, PointNode : IXMLNODE;
  ZigZagIdx : Integer;
  PointIdx : Integer;
  tempPoint: TPoint;
  tempZigzag: TList<TPoint>;
begin

  XML := NewXMLDocument;
  XML.Encoding := STR_TXT_FORMAT_UTF8;
  XML.Options := [doNodeAutoIndent];
  RootNode := XML.AddChild(STR_XML_NODE_ZIGZAG_LIST);

  for ZigZagIdx := 0 to listZigzag.Count-1 do
  begin
    tempZigzag:= listZigzag[ZigZagIdx];
    ZigzagNode := RootNode.AddChild(STR_XML_NODE_ZIGZAG);

    for PointIdx := 0 to tempZigzag.Count-1 do
    begin
      PointNode := ZigzagNode.AddChild(STR_XML_NODE_POINT);
      tempPoint := tempZigzag[PointIdx];
      PointNode.Attributes[CHR_XML_NODE_ATT_X] := tempPoint.X;
      PointNode.Attributes[CHR_XML_NODE_ATT_Y] := tempPoint.Y;
    end;
  end;

  XMl.SaveToFile(strAddress);
end;
end.