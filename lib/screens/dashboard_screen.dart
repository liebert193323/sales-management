import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/sales_data.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Helper method to build table cells
  Widget _buildTableCell(String text, bool isHeader) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
        textAlign: isHeader ? TextAlign.center : TextAlign.left,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final salesDataProvider = SalesDataProvider();
    final salesList = salesDataProvider.salesList;

    // Currency formatter
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Penjualan'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Data Penjualan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Table(
                        border: TableBorder.all(color: Colors.grey.shade300),
                        columnWidths: const {
                          0: const FractionColumnWidth(0.2),
                          1: const FractionColumnWidth(0.2),
                          2: const FractionColumnWidth(0.25),
                          3: const FractionColumnWidth(0.15),
                          4: const FractionColumnWidth(0.2),
                        },
                        children: [
                          // Header row
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                            ),
                            children: [
                              _buildTableCell('No Faktur', true),
                              _buildTableCell('Tanggal', true),
                              _buildTableCell('Customer', true),
                              _buildTableCell('Jumlah Barang', true),
                              _buildTableCell('Total Penjualan', true),
                            ],
                          ),
                          // Data rows
                          ...salesList.map((data) {
                            return TableRow(
                              children: [
                                _buildTableCell(data.invoiceNumber, false),
                                _buildTableCell(
                                    DateFormat('dd/MM/yyyy')
                                        .format(data.saleDate),
                                    false),
                                _buildTableCell(data.customerName, false),
                                _buildTableCell(
                                    data.itemQuantity.toString(), false),
                                _buildTableCell(
                                    currencyFormat.format(data.totalSale),
                                    false),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Kembali ke Home'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
