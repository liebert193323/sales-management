import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/sales_data.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedInvoice = '';
  final _customerNameController = TextEditingController();
  final _itemQuantityController = TextEditingController();
  final _totalSaleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final _salesDataProvider = SalesDataProvider();

  @override
  void initState() {
    super.initState();
    if (_salesDataProvider.salesList.isNotEmpty) {
      _selectedInvoice = _salesDataProvider.salesList.first.invoiceNumber;
      _loadSalesData();
    }
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _itemQuantityController.dispose();
    _totalSaleController.dispose();
    super.dispose();
  }

  void _loadSalesData() {
    final salesData = _salesDataProvider.getSalesDataByInvoice(
      _selectedInvoice,
    );
    if (salesData != null) {
      setState(() {
        _selectedDate = salesData.saleDate;
        _customerNameController.text = salesData.customerName;
        _itemQuantityController.text = salesData.itemQuantity.toString();
        _totalSaleController.text = NumberFormat.currency(
          locale: 'id_ID',
          symbol: 'Rp ',
          decimalDigits: 0,
        ).format(salesData.totalSale);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _updateSalesData() {
    if (_formKey.currentState!.validate()) {
      // Create updated sales data
      final updatedSalesData = SalesData(
        invoiceNumber: _selectedInvoice,
        saleDate: _selectedDate,
        customerName: _customerNameController.text,
        itemQuantity: int.parse(_itemQuantityController.text),
        totalSale: double.parse(
          _totalSaleController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        ),
      );

      // Update in provider
      _salesDataProvider.updateSalesData(_selectedInvoice, updatedSalesData);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data penjualan berhasil diupdate')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final invoiceList =
        _salesDataProvider.salesList.map((data) => data.invoiceNumber).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Data Penjualan'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: invoiceList.isNotEmpty ? _selectedInvoice : null,
                  decoration: const InputDecoration(
                    labelText: 'Pilih No Faktur',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      invoiceList.map((invoice) {
                        return DropdownMenuItem<String>(
                          value: invoice,
                          child: Text(invoice),
                        );
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedInvoice = value;
                      });
                      _loadSalesData();
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Pilih No Faktur terlebih dahulu';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Penjualan',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _customerNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Customer',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama Customer tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _itemQuantityController,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah Barang',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jumlah Barang tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _totalSaleController,
                  decoration: const InputDecoration(
                    labelText: 'Total Penjualan (Rp)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Total Penjualan tidak boleh kosong';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    // Format as currency
                    if (value.isNotEmpty) {
                      final numericValue = double.parse(
                        value.replaceAll(RegExp(r'[^0-9]'), ''),
                      );
                      final formatted = NumberFormat.currency(
                        locale: 'id_ID',
                        symbol: 'Rp ',
                        decimalDigits: 0,
                      ).format(numericValue);

                      // Update text field without triggering onChanged again
                      _totalSaleController.value = _totalSaleController.value
                          .copyWith(
                            text: formatted,
                            selection: TextSelection.collapsed(
                              offset: formatted.length,
                            ),
                          );
                    }
                  },
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _updateSalesData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Update Data'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
