import 'package:flutter/material.dart';

class EtudiantsList extends StatelessWidget {
  const EtudiantsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 250,
                child: TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.qr_code_scanner),
                    prefixIconColor: Colors.black87,
                    border: OutlineInputBorder(),
                    hintText: 'Scannez Code Appogé ',
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SingleChildScrollView(
                child: DataTable(
                  border: TableBorder.all(
                    width: 1.0,
                    color: Colors.black,
                  ),
                  horizontalMargin: 40,
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Colors.white54),
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Nom',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 19,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Prènom',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 19,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Code Appogé',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 19,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Status',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 19,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                  rows: const <DataRow>[
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Sarah')),
                        DataCell(Text('19')),
                        DataCell(Text('Student')),
                        DataCell(Text('Student')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Janine')),
                        DataCell(Text('43')),
                        DataCell(Text('Professor')),
                        DataCell(Text('Student')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('William')),
                        DataCell(Text('27')),
                        DataCell(Text('Associate Professor')),
                        DataCell(Text('Student')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('William')),
                        DataCell(Text('27')),
                        DataCell(Text('Associate Professor')),
                        DataCell(Text('Student')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('William')),
                        DataCell(Text('27')),
                        DataCell(Text('Associate Professor')),
                        DataCell(Text('Student')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('William')),
                        DataCell(Text('27')),
                        DataCell(Text('Associate Professor')),
                        DataCell(Text('Student')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('William')),
                        DataCell(Text('27')),
                        DataCell(Text('Associate Professor')),
                        DataCell(Text('Student')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('William')),
                        DataCell(Text('27')),
                        DataCell(Text('Associate Professor')),
                        DataCell(Text('Student')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('William')),
                        DataCell(Text('27')),
                        DataCell(Text('Associate Professor')),
                        DataCell(Text('Student')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('William')),
                        DataCell(Text('27')),
                        DataCell(Text('Associate Professor')),
                        DataCell(Text('Student')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('William')),
                        DataCell(Text('27')),
                        DataCell(Text('Associate Professor')),
                        DataCell(Text('Student')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('William')),
                        DataCell(Text('27')),
                        DataCell(Text('Associate Professor')),
                        DataCell(Text('Student')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('William')),
                        DataCell(Text('27')),
                        DataCell(Text('Associate Professor')),
                        DataCell(Text('Student')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('William')),
                        DataCell(Text('27')),
                        DataCell(Text('Associate Professor')),
                        DataCell(Text('Student')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('William')),
                        DataCell(Text('27')),
                        DataCell(Text('Associate Professor')),
                        DataCell(Text('Student')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('William')),
                        DataCell(Text('27')),
                        DataCell(Text('Associate Professor')),
                        DataCell(Text('Student')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('William')),
                        DataCell(Text('27')),
                        DataCell(Text('Associate Professor')),
                        DataCell(Text('Student')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('William')),
                        DataCell(Text('27')),
                        DataCell(Text('Associate Professor')),
                        DataCell(Text('Student')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('William')),
                        DataCell(Text('27')),
                        DataCell(Text('Associate Professor')),
                        DataCell(Text('Student')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('William')),
                        DataCell(Text('27')),
                        DataCell(Text('Associate Professor')),
                        DataCell(Text('Student')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('William')),
                        DataCell(Text('27')),
                        DataCell(Text('Associate Professor')),
                        DataCell(Text('Student')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('William')),
                        DataCell(Text('27')),
                        DataCell(Text('Associate Professor')),
                        DataCell(Text('Student')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('William')),
                        DataCell(Text('27')),
                        DataCell(Text('Associate Professor')),
                        DataCell(Text('Student')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('William')),
                        DataCell(Text('27')),
                        DataCell(Text('Associate Professor')),
                        DataCell(Text('Student')),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
