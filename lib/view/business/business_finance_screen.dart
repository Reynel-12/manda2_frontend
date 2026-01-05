import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BusinessFinanceScreen extends StatefulWidget {
  const BusinessFinanceScreen({super.key});

  @override
  State<BusinessFinanceScreen> createState() => _BusinessFinanceScreenState();
}

class _BusinessFinanceScreenState extends State<BusinessFinanceScreen> {
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 0,
  );

  String _selectedPeriod = 'Esta Semana';
  List<String> _periods = [
    'Esta Semana',
    'Semana Pasada',
    'Este Mes',
    'Mes Pasado',
    'Este Año',
  ];

  // Datos de ejemplo para gráfico de ventas semanales
  List<SalesData> _weeklySalesData = [];

  // Datos de ejemplo para liquidaciones
  List<Settlement> _settlements = [];

  // Resumen financiero
  FinancialSummary _financialSummary = FinancialSummary(
    totalSales: 0,
    commission: 0,
    netAmount: 0,
    pendingSettlements: 0,
  );

  @override
  void initState() {
    super.initState();
    _loadSampleData();
    _calculateSummary();
  }

  void _loadSampleData() {
    // Datos de ejemplo para el gráfico de ventas
    final now = DateTime.now();
    _weeklySalesData = [
      SalesData(
        day: 'Lun',
        date: now.subtract(const Duration(days: 6)),
        amount: 125000,
      ),
      SalesData(
        day: 'Mar',
        date: now.subtract(const Duration(days: 5)),
        amount: 98000,
      ),
      SalesData(
        day: 'Mié',
        date: now.subtract(const Duration(days: 4)),
        amount: 150000,
      ),
      SalesData(
        day: 'Jue',
        date: now.subtract(const Duration(days: 3)),
        amount: 175000,
      ),
      SalesData(
        day: 'Vie',
        date: now.subtract(const Duration(days: 2)),
        amount: 210000,
      ),
      SalesData(
        day: 'Sáb',
        date: now.subtract(const Duration(days: 1)),
        amount: 190000,
      ),
      SalesData(day: 'Dom', date: now, amount: 145000),
    ];

    // Datos de ejemplo para liquidaciones
    _settlements = [
      Settlement(
        id: 'SET001',
        date: now.subtract(const Duration(days: 2)),
        amount: 450000,
        status: SettlementStatus.completed,
      ),
      Settlement(
        id: 'SET002',
        date: now.subtract(const Duration(days: 9)),
        amount: 380000,
        status: SettlementStatus.completed,
      ),
      Settlement(
        id: 'SET003',
        date: now.add(const Duration(days: 2)),
        amount: 520000,
        status: SettlementStatus.pending,
      ),
      Settlement(
        id: 'SET004',
        date: now.add(const Duration(days: 5)),
        amount: 480000,
        status: SettlementStatus.processing,
      ),
    ];
  }

  void _calculateSummary() {
    final totalSales = _weeklySalesData.fold(
      0.0,
      (sum, item) => sum + item.amount,
    );
    final commission = totalSales * 0.10; // 10% de comisión
    final netAmount = totalSales - commission;
    final pendingSettlements = _settlements
        .where((s) => s.status == SettlementStatus.pending)
        .fold(0.0, (sum, item) => sum + item.amount);

    setState(() {
      _financialSummary = FinancialSummary(
        totalSales: totalSales,
        commission: commission,
        netAmount: netAmount,
        pendingSettlements: pendingSettlements,
      );
    });
  }

  void _onPeriodChanged(String? value) {
    if (value != null) {
      setState(() {
        _selectedPeriod = value;
      });
      // En una aplicación real, aquí cargarías los datos del periodo seleccionado
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 768;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finanzas del Negocio'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Acción para exportar reportes
              _showExportOptions(context);
            },
            icon: const Icon(Icons.download_outlined),
            tooltip: 'Exportar reporte',
          ),
          IconButton(
            onPressed: () {
              // Acción para notificaciones
            },
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Notificaciones',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isLargeScreen ? 32 : 16,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selector de periodo
            _buildPeriodSelector(),

            const SizedBox(height: 24),

            // Resumen financiero
            _buildFinancialSummary(context, isLargeScreen),

            const SizedBox(height: 24),

            // Gráfico de ventas semanales
            _buildSalesChart(context, isLargeScreen),

            const SizedBox(height: 24),

            // Sección de comisión
            _buildCommissionSection(),

            const SizedBox(height: 24),

            // Liquidaciones
            _buildSettlementsSection(context, isLargeScreen),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            color: Color(0xFF05386B),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButton<String>(
              value: _selectedPeriod,
              isExpanded: true,
              underline: const SizedBox(),
              items: _periods.map((String period) {
                return DropdownMenuItem<String>(
                  value: period,
                  child: Text(
                    period,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: _onPeriodChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialSummary(BuildContext context, bool isLargeScreen) {
    if (isLargeScreen) {
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
        children: [
          _buildSummaryCard(
            title: 'Ventas Totales',
            amount: _financialSummary.totalSales,
            color: const Color(0xFF05386B),
            icon: Icons.trending_up_outlined,
          ),
          _buildSummaryCard(
            title: 'Comisión (10%)',
            amount: _financialSummary.commission,
            color: const Color(0xFFFF6B00),
            icon: Icons.percent_outlined,
          ),
          _buildSummaryCard(
            title: 'Monto Neto',
            amount: _financialSummary.netAmount,
            color: const Color(0xFF00A86B),
            icon: Icons.account_balance_wallet_outlined,
          ),
          _buildSummaryCard(
            title: 'Pendiente Liquidar',
            amount: _financialSummary.pendingSettlements,
            color: const Color(0xFF6B5BEF),
            icon: Icons.pending_outlined,
          ),
        ],
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        _buildSummaryCard(
          title: 'Ventas Totales',
          amount: _financialSummary.totalSales,
          color: const Color(0xFF05386B),
          icon: Icons.trending_up_outlined,
        ),
        _buildSummaryCard(
          title: 'Comisión (10%)',
          amount: _financialSummary.commission,
          color: const Color(0xFFFF6B00),
          icon: Icons.percent_outlined,
        ),
        _buildSummaryCard(
          title: 'Monto Neto',
          amount: _financialSummary.netAmount,
          color: const Color(0xFF00A86B),
          icon: Icons.account_balance_wallet_outlined,
        ),
        _buildSummaryCard(
          title: 'Pendiente Liquidar',
          amount: _financialSummary.pendingSettlements,
          color: const Color(0xFF6B5BEF),
          icon: Icons.pending_outlined,
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Text(
                  _currencyFormat.format(amount),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesChart(BuildContext context, bool isLargeScreen) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ventas Semanales',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF05386B),
                  ),
                ),
                Chip(
                  label: Text(
                    _currencyFormat.format(_financialSummary.totalSales),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: const Color(0xFFFF6B00),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Desglose de ventas por día de la semana',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: isLargeScreen ? 300 : 200,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelStyle: const TextStyle(fontSize: 12),
                ),
                primaryYAxis: NumericAxis(
                  numberFormat: NumberFormat.compactCurrency(
                    symbol: '\$',
                    decimalDigits: 0,
                  ),
                  labelStyle: const TextStyle(fontSize: 12),
                ),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  format: 'point.x: \${point.y}',
                ),
                series: <CartesianSeries>[
                  ColumnSeries<SalesData, String>(
                    dataSource: _weeklySalesData,
                    xValueMapper: (SalesData sales, _) => sales.day,
                    yValueMapper: (SalesData sales, _) => sales.amount,
                    name: 'Ventas',
                    color: const Color(0xFF05386B),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                    width: 0.6,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _weeklySalesData.map((data) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFF05386B),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${data.day}: ${_currencyFormat.format(data.amount)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommissionSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detalle de Comisión',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF05386B),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manda2 aplica una comisión del 10% sobre las ventas realizadas',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8F2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFF6B00).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B00).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      color: Color(0xFFFF6B00),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Comisión aplicada: ${_currencyFormat.format(_financialSummary.commission)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6B00),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Esta comisión cubre el uso de la plataforma, procesamiento de pagos y soporte al cliente.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettlementsSection(BuildContext context, bool isLargeScreen) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Liquidaciones',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF05386B),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Acción para solicitar liquidación
                    _requestSettlement(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF05386B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.request_quote_outlined, size: 18),
                      SizedBox(width: 8),
                      Text('Solicitar Liquidación'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Historial y estado de tus liquidaciones',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            isLargeScreen ? _buildSettlementsTable() : _buildSettlementsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSettlementsTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 32,
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Fecha')),
          DataColumn(label: Text('Monto')),
          DataColumn(label: Text('Estado')),
          DataColumn(label: Text('Acciones')),
        ],
        rows: _settlements.map((settlement) {
          return DataRow(
            cells: [
              DataCell(Text(settlement.id)),
              DataCell(Text(_dateFormat.format(settlement.date))),
              DataCell(Text(_currencyFormat.format(settlement.amount))),
              DataCell(_buildStatusChip(settlement.status)),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.visibility_outlined, size: 20),
                  onPressed: () {
                    _viewSettlementDetails(settlement);
                  },
                  color: const Color(0xFF05386B),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSettlementsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _settlements.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final settlement = _settlements[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getStatusColor(settlement.status).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getStatusIcon(settlement.status),
              color: _getStatusColor(settlement.status),
              size: 20,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                settlement.id,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              _buildStatusChip(settlement.status),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                _dateFormat.format(settlement.date),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _currencyFormat.format(settlement.amount),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          onTap: () {
            _viewSettlementDetails(settlement);
          },
        );
      },
    );
  }

  Widget _buildStatusChip(SettlementStatus status) {
    final color = _getStatusColor(status);
    final text = _getStatusText(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getStatusColor(SettlementStatus status) {
    switch (status) {
      case SettlementStatus.completed:
        return const Color(0xFF00A86B);
      case SettlementStatus.processing:
        return const Color(0xFFFF6B00);
      case SettlementStatus.pending:
        return const Color(0xFF6B5BEF);
    }
  }

  String _getStatusText(SettlementStatus status) {
    switch (status) {
      case SettlementStatus.completed:
        return 'Completado';
      case SettlementStatus.processing:
        return 'Procesando';
      case SettlementStatus.pending:
        return 'Pendiente';
    }
  }

  IconData _getStatusIcon(SettlementStatus status) {
    switch (status) {
      case SettlementStatus.completed:
        return Icons.check_circle_outline;
      case SettlementStatus.processing:
        return Icons.autorenew;
      case SettlementStatus.pending:
        return Icons.pending_outlined;
    }
  }

  void _showExportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Exportar Reporte',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF05386B),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(
                  Icons.picture_as_pdf,
                  color: Color(0xFF05386B),
                ),
                title: const Text('Exportar a PDF'),
                onTap: () {
                  Navigator.pop(context);
                  // Acción para exportar a PDF
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.table_chart_outlined,
                  color: Color(0xFF05386B),
                ),
                title: const Text('Exportar a Excel'),
                onTap: () {
                  Navigator.pop(context);
                  // Acción para exportar a Excel
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.image_outlined,
                  color: Color(0xFF05386B),
                ),
                title: const Text('Exportar Gráfico'),
                onTap: () {
                  Navigator.pop(context);
                  // Acción para exportar el gráfico
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _requestSettlement(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Solicitar Liquidación'),
          content: const Text(
            '¿Estás seguro de que deseas solicitar una liquidación por el monto disponible?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Acción para solicitar liquidación
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Solicitud de liquidación enviada'),
                    backgroundColor: const Color(0xFF05386B),
                    action: SnackBarAction(label: 'OK', onPressed: () {}),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B00),
                foregroundColor: Colors.white,
              ),
              child: const Text('Solicitar'),
            ),
          ],
        );
      },
    );
  }

  void _viewSettlementDetails(Settlement settlement) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Detalle de Liquidación',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildDetailItem('ID:', settlement.id),
                _buildDetailItem('Fecha:', _dateFormat.format(settlement.date)),
                _buildDetailItem(
                  'Monto:',
                  _currencyFormat.format(settlement.amount),
                ),
                _buildDetailItem('Estado:', _getStatusText(settlement.status)),
                const SizedBox(height: 30),
                if (settlement.status == SettlementStatus.pending)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Acción para acelerar liquidación
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B00),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Acelerar Liquidación'),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

// Modelos de datos
class SalesData {
  final String day;
  final DateTime date;
  final double amount;

  SalesData({required this.day, required this.date, required this.amount});
}

class Settlement {
  final String id;
  final DateTime date;
  final double amount;
  final SettlementStatus status;

  Settlement({
    required this.id,
    required this.date,
    required this.amount,
    required this.status,
  });
}

enum SettlementStatus { completed, processing, pending }

class FinancialSummary {
  final double totalSales;
  final double commission;
  final double netAmount;
  final double pendingSettlements;

  FinancialSummary({
    required this.totalSales,
    required this.commission,
    required this.netAmount,
    required this.pendingSettlements,
  });
}
