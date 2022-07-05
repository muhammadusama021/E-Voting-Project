import 'package:ars_progress_dialog/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:e_voting_project_final/Pages/savePdf.dart';
import 'package:e_voting_project_final/services/contract_linking.dart';
import 'package:e_voting_project_final/widgets/small_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:e_voting_project_final/Pages/resources.dart';
import 'package:intl/intl.dart';
import 'package:rounded_letter/rounded_letter.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ResultPage extends StatefulWidget {
  final String status;

  const ResultPage({Key key, this.status}) : super(key: key);

  @override
  _ExpansionTileCardDemoState createState() => _ExpansionTileCardDemoState();
}

class _ExpansionTileCardDemoState extends State<ResultPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  int _selectedIndex = 0;

  List<Widget> list = [
    Tab(
        child: Text('See Election Result Here!',
            style: TextStyle(color: Colors.white, fontSize: 16))),
  ];

  @override
  void initState() {

    // TODO: implement initState
    _refreshData();

    super.initState();

    // Create TabController for getting the index of current tab
    _controller = TabController(length: list.length, vsync: this);

    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
    });
  }

  bool _expanded = false;

  Color colorGreen = Color(0xff03c8a8);
  Color colorGrey = Colors.grey;
  double textSize = 16;

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  );
  final roundShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10)),
  );

  @override


  @override
  Widget build(BuildContext context) {
    var contractLink = Provider.of<ContractLinking>(context);



    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Result',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: kmainColor,
        bottom: TabBar(
          indicatorWeight: 8,
          indicatorColor: Colors.white,
          controller: _controller,
          tabs: list,
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {

                  contractLink.initialSetup();

                },
                child: Icon(
                  Icons.refresh,
                ),
              )),
        ],
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          RefreshIndicator(
            child: Center(
              child: contractLink.isLoading
                  ? CircularProgressIndicator()
                  : Container(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 2, vertical: 5),
                  children: [
                    if (contractLink.candidateResultData.entries != null) ...{
                      for (var p in contractLink.candidateResultData.entries) ...{
                        Card(
                          elevation: 5,
                          child: ExpansionTileCard(
                              title: Text(
                                "Voting for " + p.key.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Small_Text(text:
                                            "Election Status:  ",color: colorGreen,size: 12,latterSpacing: 0.5,

                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Small_Text(text:
                                            contractLink.state,
                                              color: colorGrey,size: 12,latterSpacing: 0.5
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if(contractLink.state=="CONCLUDED")...{
                                    if(widget.status=="ORGANIZER")...[
                                      Row(
                                        children: [
                                          ElevatedButton(
                                              onPressed: (){
                                                //Create a new PDF document with conformance A1B.
                                                PdfDocument document =
                                                PdfDocument();
//Add page to the PDF.
                                                final PdfPage page = document.pages.add();
//Get page client size.
                                                final Size pageSize = page.getClientSize();
                                                //Draw rectangle.
                                                page.graphics.drawRectangle(
                                                    bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
                                                    pen: PdfPen(PdfColor(142, 170, 219, 255)));
//Read font file.
                                                // List<int> fontData = await _readData('Roboto-Regular.ttf');
                                                //Create a PDF true type font.
                                                PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
                                                PdfFont headerFont = PdfStandardFont(PdfFontFamily.helvetica, 30);
                                                PdfFont footerFont = PdfStandardFont(PdfFontFamily.helvetica, 18);
                                                PdfFont winFont = PdfStandardFont(PdfFontFamily.helvetica, 15);
                                                PdfLayoutResult _drawHeader(PdfPage page, Size pageSize, PdfGrid grid,
                                                    PdfFont contentFont, PdfFont headerFont, PdfFont footerFont) {
                                                  //Draw rectangle.
                                                  page.graphics.drawRectangle(
                                                      brush: PdfSolidBrush(PdfColor(3, 200, 168, 255)),
                                                      bounds: Rect.fromLTWH(0, 0, pageSize.width, 90));
                                                  //Draw string.
                                                  page.graphics.drawString('Election Result', headerFont,
                                                      brush: PdfBrushes.white,
                                                      bounds: Rect.fromLTWH(25, 0, pageSize.width, 90),
                                                      format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

                                                  final format = DateFormat("dd-MM-yyyy HH:mm");

                                                  final String invoiceNumber = 'Election ID: 2058557939\r\n\r\nDate: ' +
                                                      format.format(DateTime.now());
                                                  final Size contentSize = contentFont.measureString(invoiceNumber);
                                                  String elcName=contractLink.electionName;
                                                  String totalcand=contractLink.candidateCount;
                                                  String totalvoter=contractLink.VoterCount;
                                                  String winName=contractLink.winnerName;
                                                  //String totalvoter=contractLink.VoterCount;
                                                  String address =
                                                      'Election Name: Voting for $elcName\r\n\r\nTotal Candidates: $totalcand, \r\n\r\nTotal Voters: $totalvoter,';
                                                  PdfTextElement(text: invoiceNumber, font: contentFont).draw(
                                                      page: page,
                                                      bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
                                                          contentSize.width + 30, pageSize.height - 120));

                                                  PdfTextElement(text:"Winner: $winName", font: winFont).draw(
                                                      page: page,
                                                      bounds: Rect.fromLTWH(90, 180,
                                                          pageSize.width - (contentSize.width + 30), pageSize.height - 120));

                                                  return PdfTextElement(text: address, font: contentFont).draw(
                                                      page: page,
                                                      bounds: Rect.fromLTWH(30, 120,
                                                          pageSize.width - (contentSize.width + 30), pageSize.height - 120));
                                                }

                                                //Create PDF grid and return.
                                                PdfGrid _getGrid(PdfFont contentFont) {
                                                  //Create a PDF grid.
                                                  final PdfGrid grid = PdfGrid();
                                                  //Specify the column count to the grid.
                                                  grid.columns.add(count: 5);
                                                  //Create the header row of the grid.
                                                  final PdfGridRow headerRow = grid.headers.add(1)[0];
                                                  //Set style.
                                                  headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(3, 200, 168));
                                                  headerRow.style.textBrush = PdfBrushes.white;
                                                  headerRow.cells[0].value = 'Voter Id';
                                                  headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
                                                  headerRow.cells[1].value = 'Voter Name';
                                                  headerRow.cells[1].stringFormat.alignment = PdfTextAlignment.center;
                                                  headerRow.cells[2].value = 'Reg No';
                                                  headerRow.cells[2].stringFormat.alignment = PdfTextAlignment.center;
                                                  headerRow.cells[3].value = 'Department Name';
                                                  headerRow.cells[3].stringFormat.alignment = PdfTextAlignment.center;
                                                  headerRow.cells[4].value = 'Vote to';
                                                  headerRow.cells[4].stringFormat.alignment = PdfTextAlignment.center;
                                                  for(var i in contractLink.VoterRec.entries)
                                                  {
                                                    for(var j in i.value)
                                                      {
                                                        _addProducts('V-00'+j.toString().split("/")[0], j.toString().split("/")[1], j.toString().split("/")[2], "CS", j.toString().split("/")[3], grid);
                                                      }

                                                  }

                                                  final PdfPen whitePen = PdfPen(PdfColor.empty, width: 0.5);
                                                  PdfBorders borders = PdfBorders();
                                                  borders.all = PdfPen(PdfColor(142, 179, 219), width: 0.5);
                                                  ;
                                                  grid.rows.applyStyle(PdfGridCellStyle(borders: borders));
                                                  grid.columns[1].width = 130;
                                                  for (int i = 0; i < headerRow.cells.count; i++) {
                                                    headerRow.cells[i].style.cellPadding =
                                                        PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
                                                    headerRow.cells[i].style.borders.all = whitePen;
                                                  }
                                                  for (int i = 0; i < grid.rows.count; i++) {
                                                    final PdfGridRow row = grid.rows[i];
                                                    if (i % 2 == 0) {
                                                      row.style.backgroundBrush = PdfSolidBrush(PdfColor(217, 226, 243));
                                                    }
                                                    for (int j = 0; j < row.cells.count; j++) {
                                                      final PdfGridCell cell = row.cells[j];
                                                      cell.stringFormat.alignment = PdfTextAlignment.center;

                                                      cell.style.cellPadding =
                                                          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
                                                    }
                                                  }
                                                  //Set font
                                                  grid.style.font = contentFont;
                                                  return grid;
                                                }
                                                PdfGrid _getGrid2(PdfFont contentFont) {
                                                  //Create a PDF grid.
                                                  final PdfGrid grid = PdfGrid();
                                                  //Specify the column count to the grid.
                                                  grid.columns.add(count: 5);
                                                  //Create the header row of the grid.
                                                  final PdfGridRow headerRow = grid.headers.add(1)[0];
                                                  //Set style.
                                                  headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(3, 200, 168));
                                                  headerRow.style.textBrush = PdfBrushes.white;
                                                  headerRow.cells[0].value = 'Candidate Id';
                                                  headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
                                                  headerRow.cells[1].value = 'Candidate Name';
                                                  headerRow.cells[1].stringFormat.alignment = PdfTextAlignment.center;
                                                  headerRow.cells[2].value = 'Reg No';
                                                  headerRow.cells[2].stringFormat.alignment = PdfTextAlignment.center;
                                                  headerRow.cells[3].value = 'Department Name';
                                                  headerRow.cells[3].stringFormat.alignment = PdfTextAlignment.center;
                                                  headerRow.cells[4].value = 'Total Votes Gain';
                                                  headerRow.cells[4].stringFormat.alignment = PdfTextAlignment.center;
                                                  for(var i in contractLink.candidateResultData.entries)
                                                  {
                                                    for(var j in i.value)
                                                      {
                                                        _addProducts('C-00'+j.toString().split("/")[0], j.toString().split("/")[1], j.toString().split("/")[2], "CS", j.toString().split("/")[3], grid);
                                                      }
                                                  }

                                                  final PdfPen whitePen = PdfPen(PdfColor.empty, width: 0.5);
                                                  PdfBorders borders = PdfBorders();
                                                  borders.all = PdfPen(PdfColor(142, 179, 219), width: 0.5);
                                                  ;
                                                  grid.rows.applyStyle(PdfGridCellStyle(borders: borders));
                                                  grid.columns[1].width = 130;
                                                  for (int i = 0; i < headerRow.cells.count; i++) {
                                                    headerRow.cells[i].style.cellPadding =
                                                        PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
                                                    headerRow.cells[i].style.borders.all = whitePen;
                                                  }
                                                  for (int i = 0; i < grid.rows.count; i++) {
                                                    final PdfGridRow row = grid.rows[i];
                                                    if (i % 2 == 0) {
                                                      row.style.backgroundBrush = PdfSolidBrush(PdfColor(217, 226, 243));
                                                    }
                                                    for (int j = 0; j < row.cells.count; j++) {
                                                      final PdfGridCell cell = row.cells[j];
                                                      cell.stringFormat.alignment = PdfTextAlignment.center;

                                                      cell.style.cellPadding =
                                                          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
                                                    }
                                                  }
                                                  //Set font
                                                  grid.style.font = contentFont;
                                                  return grid;
                                                }
                                                //Create and row for the grid.

                                                final PdfGrid grid = _getGrid(contentFont);
                                                final PdfGrid grid2 = _getGrid2(contentFont);
                                                //Draw the header section by creating text element.
                                                final PdfLayoutResult result =
                                                _drawHeader(page, pageSize, grid, contentFont, headerFont, footerFont);
                                                  //Draw grid.
                                                _drawGrid(page, grid, grid2,result, contentFont);
                                                //Add invoice footer.
                                                _drawFooter(page, pageSize, contentFont);
                                                //Save and dispose the document.
                                                final List<int> bytes = document.save();
                                                document.dispose();


                                                saveAndLaunchFile(bytes, 'Result.pdf');

                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                MaterialStateProperty
                                                    .all(kmainColor),
                                              ),
                                              child: Center(
                                                  child: Small_Text(
                                                    text: "Generate Election Report",
                                                    color: Colors.white,
                                                  ))),

                                        ],
                                      )
                                    ]
                                    else...[
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Small_Text(text:
                                              "Winner :  ",color: colorGreen,size: 12,latterSpacing: 0.5

                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Small_Text(text:
                                              contractLink.winnerName,
                                                  color: colorGrey,size: 12,latterSpacing: 0.5
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]


                                  }


                                ],
                              ),
                              leading: CircleAvatar(
                                  child: RoundedLetter.withRedCircle(
                                      p.key[0].toString(), 40, 20)),
                              children: [
                                for (var item in p.value) ...{
                                  Container(
                                      width: MediaQuery.of(context)
                                          .size
                                          .width -
                                          50,
                                      margin: EdgeInsets.only(left: 30),
                                      child: InkWell(
                                        onTap: () {
                                          //_openPopup(context, list, "", "");
                                        },
                                        child: Card(

                                          elevation: 10,
                                          child: ListTile(
                                            //trailing: Container(),
                                            title: Text(
                                              item.toString().split("/")[1],
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                            subtitle: Padding(padding: EdgeInsets.all(10),child: Text("Total Vote Gains "+item.toString().split("/")[3])),
                                            leading: CircleAvatar(
                                                child: RoundedLetter
                                                    .withRedCircle(
                                                    item.toString().split("/")[1][0],
                                                    40,
                                                    20)),
                                          ),
                                        ),
                                      )),
                                }
                              ]),
                        ),
                        Divider(
                          thickness: 2,
                          color: Colors.black87,
                        )
                      }
                    } else ...{
                      Center(
                        child: Text("Curently! No Election Opened!"),
                      )
                    }
                  ],
                ),
              ),
            ),
            onRefresh: _refreshData,
          ),
        ],
      ),
    );
  }

  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 5));
  }
  void _drawGrid(
      PdfPage page, PdfGrid grid, PdfGrid grid2,PdfLayoutResult result, PdfFont contentFont) {
    Rect totalPriceCellBounds;
    Rect quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    result = grid2.draw(
        page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0));

    page.graphics.drawString('Voters Details:', contentFont,
        bounds: Rect.fromLTWH(
            14,
            result.bounds.bottom + 20,
            500,
            100));

    //Draw the PDF grid and get the result.
    result = grid.draw(
        page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 35, 0, 0));
    //Draw grand total.
    /*page.graphics.drawString('Grand Total', contentFont,
        bounds: Rect.fromLTWH(
            quantityCellBounds.left,
            result.bounds.bottom + 10,
            quantityCellBounds.width,
            quantityCellBounds.height));
    page.graphics.drawString("Hy", contentFont,
        bounds: Rect.fromLTWH(
            totalPriceCellBounds.left,
            result.bounds.bottom + 10,
            totalPriceCellBounds.width,
            totalPriceCellBounds.height));*/
  }

  void _drawFooter(PdfPage page, Size pageSize, PdfFont contentFont) {
    final PdfPen linePen =
    PdfPen(PdfColor(142, 170, 219, 255), dashStyle: PdfDashStyle.custom);
    linePen.dashPattern = <double>[3, 3];
    //Draw line.
    page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
        Offset(pageSize.width, pageSize.height - 100));
    const String footerContent =
        'Comsats University Islamabad .\r\n\r\nMain Kamra road, Attock,\r\n\r\nAny Questions? e_voting@cuiatk.edu.pk';
    //Added 30 as a margin for the layout.
    page.graphics.drawString(footerContent, contentFont,
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
        bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
  }
  void _addProducts(String voterId, String voterName, String regNo,
      String departName, String voteTo, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = voterId;
    row.cells[1].value = voterName;
    row.cells[2].value = regNo;
    row.cells[3].value = departName;
    row.cells[4].value = voteTo;
  }

}
