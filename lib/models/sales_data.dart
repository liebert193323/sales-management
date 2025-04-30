class SalesData {
  String invoiceNumber;
  DateTime saleDate;
  String customerName;
  int itemQuantity;
  double totalSale;

  SalesData({
    required this.invoiceNumber,
    required this.saleDate,
    required this.customerName,
    required this.itemQuantity,
    required this.totalSale,
  });

  // Convert SalesData object to a Map
  Map<String, dynamic> toMap() {
    return {
      'invoiceNumber': invoiceNumber,
      'saleDate': saleDate.toIso8601String(),
      'customerName': customerName,
      'itemQuantity': itemQuantity,
      'totalSale': totalSale,
    };
  }

  // Create a SalesData object from a Map
  factory SalesData.fromMap(Map<String, dynamic> map) {
    return SalesData(
      invoiceNumber: map['invoiceNumber'],
      saleDate: DateTime.parse(map['saleDate']),
      customerName: map['customerName'],
      itemQuantity: map['itemQuantity'],
      totalSale: map['totalSale'],
    );
  }
}

// Create a singleton class to manage sales data across the app
class SalesDataProvider {
  // Singleton instance
  static final SalesDataProvider _instance = SalesDataProvider._internal();

  factory SalesDataProvider() {
    return _instance;
  }

  SalesDataProvider._internal();

  // Sample data
  final List<SalesData> salesList = [
    SalesData(
      invoiceNumber: 'INV-001',
      saleDate: DateTime(2025, 4, 15),
      customerName: 'PT Maju Jaya',
      itemQuantity: 50,
      totalSale: 7500000,
    ),
    SalesData(
      invoiceNumber: 'INV-002',
      saleDate: DateTime(2025, 4, 20),
      customerName: 'CV Sentosa',
      itemQuantity: 25,
      totalSale: 3750000,
    ),
    SalesData(
      invoiceNumber: 'INV-003',
      saleDate: DateTime(2025, 4, 28),
      customerName: 'Toko Makmur',
      itemQuantity: 35,
      totalSale: 5250000,
    ),
  ];

  // Add a new sales data
  void addSalesData(SalesData data) {
    salesList.add(data);
  }

  // Update existing sales data
  void updateSalesData(String invoiceNumber, SalesData updatedData) {
    final index = salesList.indexWhere(
      (data) => data.invoiceNumber == invoiceNumber,
    );
    if (index != -1) {
      salesList[index] = updatedData;
    }
  }

  // Get sales data by invoice number
  SalesData? getSalesDataByInvoice(String invoiceNumber) {
    try {
      return salesList.firstWhere(
        (data) => data.invoiceNumber == invoiceNumber,
      );
    } catch (e) {
      return null;
    }
  }
}
