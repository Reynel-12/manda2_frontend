import 'package:flutter/material.dart';
import 'package:manda2_frontend/view/business/business_finance_screen.dart';
import 'package:manda2_frontend/view/business/business_product_screen.dart';
import 'package:manda2_frontend/view/business/business_settings.dart';
import 'package:manda2_frontend/view/business/create_promotion_screen.dart';

class BusinessDashboardScreen extends StatefulWidget {
  const BusinessDashboardScreen({Key? key}) : super(key: key);

  @override
  State<BusinessDashboardScreen> createState() =>
      _BusinessDashboardScreenState();
}

class _BusinessDashboardScreenState extends State<BusinessDashboardScreen>
    with TickerProviderStateMixin {
  List<BusinessOrder> _orders = [];
  BusinessStore? _storeInfo;
  BusinessStats? _stats;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadStoreData();
    _loadOrders();
    _calculateStats();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadStoreData() {
    _storeInfo = BusinessStore(
      id: 'STORE-001',
      name: 'Pulpería "El Buen Precio"',
      category: 'Supermercado',
      ownerName: 'Carlos Rodríguez',
      phone: '+504 1234-5678',
      rating: 4.8,
      totalOrders: 1245,
      isOpen: true,
      openingTime: '7:00 AM',
      closingTime: '10:00 PM',
      email: '',
      address: '',
    );
  }

  void _loadOrders() {
    _orders = [
      BusinessOrder(
        id: 'ORD-2024-001',
        customerName: 'María González',
        customerPhone: '+504 9876-5432',
        items: [
          OrderItem(name: 'Leche Entera 1L', quantity: 2, price: 2.50),
          OrderItem(name: 'Pan Integral', quantity: 1, price: 1.75),
          OrderItem(name: 'Huevos x12', quantity: 1, price: 3.20),
        ],
        totalAmount: 9.95,
        deliveryFee: 1.50,
        orderTime: DateTime.now().subtract(const Duration(minutes: 15)),
        estimatedDeliveryTime: 20,
        status: OrderStatus.pending,
        paymentMethod: 'Efectivo',
        deliveryAddress: 'Barrio Los Pinos, Casa #45',
        notes: 'Casa color azul, portón negro',
      ),
      BusinessOrder(
        id: 'ORD-2024-002',
        customerName: 'José Martínez',
        customerPhone: '+504 8765-4321',
        items: [
          OrderItem(name: 'Arroz 5kg', quantity: 1, price: 8.90),
          OrderItem(name: 'Aceite 1L', quantity: 1, price: 4.30),
          OrderItem(name: 'Frijoles 1kg', quantity: 2, price: 2.75),
        ],
        totalAmount: 18.70,
        deliveryFee: 1.50,
        orderTime: DateTime.now().subtract(const Duration(minutes: 30)),
        estimatedDeliveryTime: 25,
        status: OrderStatus.preparing,
        paymentMethod: 'Tarjeta',
        deliveryAddress: 'Residencial Las Flores, Casa #8',
        notes: 'Entregar en la puerta trasera',
      ),
      BusinessOrder(
        id: 'ORD-2024-003',
        customerName: 'Ana López',
        customerPhone: '+504 555-1234',
        items: [
          OrderItem(name: 'Jugo de Naranja 1L', quantity: 1, price: 3.50),
          OrderItem(name: 'Galletas de Chocolate', quantity: 2, price: 2.20),
          OrderItem(name: 'Queso 250g', quantity: 1, price: 4.75),
        ],
        totalAmount: 12.65,
        deliveryFee: 1.50,
        orderTime: DateTime.now().subtract(const Duration(minutes: 45)),
        estimatedDeliveryTime: 15,
        status: OrderStatus.ready,
        paymentMethod: 'Efectivo',
        deliveryAddress: 'Colonia San José, Apartamento 302',
        notes: 'Pedir en recepción',
      ),
      BusinessOrder(
        id: 'ORD-2024-004',
        customerName: 'Roberto García',
        customerPhone: '+504 777-8888',
        items: [
          OrderItem(name: 'Pollo a la Parrilla', quantity: 1, price: 8.99),
          OrderItem(name: 'Ensalada César', quantity: 1, price: 4.50),
          OrderItem(name: 'Refresco 500ml', quantity: 2, price: 1.25),
        ],
        totalAmount: 15.99,
        deliveryFee: 2.00,
        orderTime: DateTime.now().subtract(const Duration(hours: 1)),
        estimatedDeliveryTime: 18,
        status: OrderStatus.onTheWay,
        paymentMethod: 'Tarjeta',
        deliveryAddress: 'Urbanización Bella Vista, Casa #23',
        notes: 'Casa con jardín grande',
      ),
      BusinessOrder(
        id: 'ORD-2024-005',
        customerName: 'Laura Fernández',
        customerPhone: '+504 666-9999',
        items: [
          OrderItem(name: 'Detergente 2L', quantity: 1, price: 6.80),
          OrderItem(name: 'Suavizante 1L', quantity: 1, price: 5.25),
          OrderItem(name: 'Jabón de barra', quantity: 3, price: 1.50),
        ],
        totalAmount: 16.55,
        deliveryFee: 1.50,
        orderTime: DateTime.now().subtract(const Duration(hours: 2)),
        estimatedDeliveryTime: 22,
        status: OrderStatus.delivered,
        paymentMethod: 'Efectivo',
        deliveryAddress: 'Colonia Miraflores, Casa #12',
        notes: '',
      ),
      BusinessOrder(
        id: 'ORD-2024-006',
        customerName: 'Miguel Ángel',
        customerPhone: '+504 333-4444',
        items: [
          OrderItem(name: 'Vino Tinto 750ml', quantity: 1, price: 12.99),
          OrderItem(name: 'Cerveza Nacional 6-pack', quantity: 1, price: 7.50),
        ],
        totalAmount: 20.49,
        deliveryFee: 1.50,
        orderTime: DateTime.now().subtract(const Duration(hours: 3)),
        estimatedDeliveryTime: 25,
        status: OrderStatus.cancelled,
        paymentMethod: 'Tarjeta',
        deliveryAddress: 'Residencial Las Flores',
        notes: 'Cliente canceló el pedido',
      ),
    ];
  }

  void _calculateStats() {
    final today = DateTime.now();
    final todayOrders = _orders
        .where(
          (order) =>
              order.orderTime.day == today.day &&
              order.orderTime.month == today.month &&
              order.orderTime.year == today.year,
        )
        .toList();

    _stats = BusinessStats(
      todayOrders: todayOrders.length,
      todayRevenue: todayOrders.fold(
        0.0,
        (sum, order) => sum + order.totalAmount,
      ),
      pendingOrders: _orders
          .where((order) => order.status == OrderStatus.pending)
          .length,
      preparingOrders: _orders
          .where((order) => order.status == OrderStatus.preparing)
          .length,
      readyOrders: _orders
          .where((order) => order.status == OrderStatus.ready)
          .length,
      totalOrders: _orders.length,
      totalRevenue: _orders.fold(0.0, (sum, order) => sum + order.totalAmount),
      averageOrderValue: _orders.isEmpty
          ? 0.0
          : _orders.fold(0.0, (sum, order) => sum + order.totalAmount) /
                _orders.length,
    );
  }

  void _acceptOrder(String orderId) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1 && _orders[orderIndex].status == OrderStatus.pending) {
      setState(() {
        _orders[orderIndex] = _orders[orderIndex].copyWith(
          status: OrderStatus.preparing,
          acceptedTime: DateTime.now(),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pedido $orderId aceptado'),
          backgroundColor: const Color(0xFF05386B),
          action: SnackBarAction(
            label: 'Ver',
            textColor: Colors.white,
            onPressed: () {
              _viewOrderDetails(_orders[orderIndex]);
            },
          ),
        ),
      );
    }
  }

  void _markOrderReady(String orderId) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1 && _orders[orderIndex].status == OrderStatus.preparing) {
      setState(() {
        _orders[orderIndex] = _orders[orderIndex].copyWith(
          status: OrderStatus.ready,
          readyTime: DateTime.now(),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pedido $orderId marcado como listo'),
          backgroundColor: const Color(0xFF05386B),
        ),
      );
    }
  }

  void _finalizeOrder(String orderId) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1 && _orders[orderIndex].status == OrderStatus.ready) {
      setState(() {
        _orders[orderIndex] = _orders[orderIndex].copyWith(
          status: OrderStatus.delivered,
          deliveredTime: DateTime.now(),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pedido $orderId finalizado (entregado)'),
          backgroundColor: const Color(0xFF05386B),
        ),
      );
    }
  }

  void _cancelOrder(String orderId, {required String reason}) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1 &&
        _orders[orderIndex].status != OrderStatus.delivered &&
        _orders[orderIndex].status != OrderStatus.cancelled) {
      setState(() {
        _orders[orderIndex] = _orders[orderIndex].copyWith(
          status: OrderStatus.cancelled,
          cancelledTime: DateTime.now(),
          cancelReason: reason.trim(),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pedido $orderId cancelado'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _confirmAcceptOrder(BusinessOrder order) async {
    final shouldAccept = await showDialog<bool>(
      context: context,
      builder: (context) {
        final isWide = MediaQuery.of(context).size.width >= 520;
        return AlertDialog(
          title: const Text('Aceptar pedido'),
          content: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isWide ? 520 : 360),
            child: Text(
              '¿Deseas aceptar el pedido ${order.id} de ${order.customerName}?\n\n'
              'Al aceptarlo pasarás a preparación.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B00),
              ),
              child: const Text('Sí, aceptar'),
            ),
          ],
        );
      },
    );

    if (shouldAccept == true) {
      _acceptOrder(order.id);
    }
  }

  Future<void> _promptCancelOrder(
    BusinessOrder order, {
    String title = 'Cancelar pedido',
    String confirmLabel = 'Sí, cancelar',
  }) async {
    final reasonController = TextEditingController();
    String? errorText;
    try {
      final result = await showDialog<String?>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          final isWide = MediaQuery.of(context).size.width >= 520;
          return StatefulBuilder(
            builder: (context, setLocalState) {
              return AlertDialog(
                title: Text(title),
                content: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isWide ? 520 : 360),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pedido: ${order.id}'),
                      const SizedBox(height: 12),
                      TextField(
                        controller: reasonController,
                        autofocus: true,
                        maxLines: 3,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: 'Motivo',
                          hintText:
                              'Ej. Cliente no responde / Sin stock / Dirección inválida',
                          errorText: errorText,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Esta acción no se puede deshacer.',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, null),
                    child: const Text('Volver'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final reason = reasonController.text.trim();
                      if (reason.isEmpty) {
                        setLocalState(() => errorText = 'Ingresa un motivo');
                        return;
                      }
                      Navigator.pop(context, reason);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text(confirmLabel),
                  ),
                ],
              );
            },
          );
        },
      );

      if (result != null) {
        _cancelOrder(order.id, reason: result);
      }
    } finally {
      reasonController.dispose();
    }
  }

  Future<void> _confirmFinalizeOrder(BusinessOrder order) async {
    final shouldFinalize = await showDialog<bool>(
      context: context,
      builder: (context) {
        final isWide = MediaQuery.of(context).size.width >= 520;
        return AlertDialog(
          title: const Text('Finalizar pedido'),
          content: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isWide ? 520 : 360),
            child: Text(
              '¿Confirmas que el pedido ${order.id} está listo y se finaliza como entregado?',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF05386B),
              ),
              child: const Text('Sí, finalizar'),
            ),
          ],
        );
      },
    );

    if (shouldFinalize == true) {
      _finalizeOrder(order.id);
    }
  }

  void _viewOrderDetails(BusinessOrder order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildOrderDetailsSheet(order),
    );
  }

  void _toggleStoreStatus() {
    if (_storeInfo != null) {
      setState(() {
        _storeInfo = _storeInfo!.copyWith(isOpen: !_storeInfo!.isOpen);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _storeInfo!.isOpen ? 'Negocio abierto' : 'Negocio cerrado',
          ),
          backgroundColor: const Color(0xFF05386B),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final isDesktop = MediaQuery.of(context).size.width >= 1200;
    final crossAxisCount = isDesktop
        ? 3
        : isTablet
        ? 2
        : 1;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Dashboard del Negocio'),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: () {}),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 64 : 24,
            vertical: 24,
          ),
          child: Column(
            children: [
              _buildStoreHeader(isDesktop || isTablet),
              const SizedBox(height: 32),
              _buildStatsGrid(isDesktop, isTablet),
              const SizedBox(height: 32),
              _buildOrdersSection(crossAxisCount),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildStoreHeader(bool isWide) {
    final store = _storeInfo!;
    final theme = Theme.of(context);
    final content = [
      Expanded(
        flex: isWide ? 1 : 0,
        child: Column(
          crossAxisAlignment: isWide
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Text(
              store.name,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF05386B),
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: isWide ? TextAlign.start : TextAlign.center,
            ),
            Text(
              store.category,
              style: TextStyle(color: Colors.grey[600]),
              textAlign: isWide ? TextAlign.start : TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: isWide
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber),
                Flexible(
                  child: Text(
                    ' ${store.rating} • ${store.totalOrders} pedidos',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      if (!isWide) const SizedBox(height: 24),
      if (isWide) const SizedBox(width: 16),
      Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: store.isOpen ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  store.isOpen ? Icons.check_circle : Icons.cancel,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  store.isOpen ? 'ABIERTO' : 'CERRADO',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${store.openingTime} - ${store.closingTime}',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Switch(
            value: store.isOpen,
            onChanged: (_) => _toggleStoreStatus(),
            activeColor: const Color(0xFFFF6B00),
          ),
        ],
      ),
    ];

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: isWide ? Row(children: content) : Column(children: content),
      ),
    );
  }

  Widget _buildStatsGrid(bool isDesktop, bool isTablet) {
    final stats = _stats!;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isDesktop
          ? 3
          : isTablet
          ? 2
          : 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: isDesktop ? 1.5 : 0.9,
      children: [
        _buildStatCard(
          Icons.shopping_bag,
          '${stats.todayOrders}',
          'Pedidos Hoy',
          const Color(0xFF05386B),
        ),
        _buildStatCard(
          Icons.attach_money,
          '\$${stats.todayRevenue.toStringAsFixed(0)}',
          'Ventas Hoy',
          const Color(0xFFFF6B00),
        ),
        _buildStatCard(
          Icons.access_time,
          '${stats.pendingOrders}',
          'Pendientes',
          Colors.orange,
        ),
        _buildStatCard(
          Icons.timer,
          '${stats.preparingOrders}',
          'Preparando',
          Colors.blue,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 16),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(label, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersSection(int crossAxisCount) {
    final orders = _orders; // aplicar filtros aquí
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Pedidos Recientes',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text('${orders.length} pedidos'),
          ],
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 20.0;
            final itemWidth =
                (constraints.maxWidth - (spacing * (crossAxisCount - 1))) /
                crossAxisCount;
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: orders
                  .map(
                    (order) => SizedBox(
                      width: itemWidth,
                      child: _buildOrderCard(order),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildOrderCard(BusinessOrder order) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    order.id,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(_getStatusText(order.status)),
                  backgroundColor: _getStatusColor(
                    order.status,
                  ).withOpacity(0.1),
                  labelStyle: TextStyle(color: _getStatusColor(order.status)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              order.customerName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              order.deliveryAddress,
              style: TextStyle(color: Colors.grey[600]),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 16),
            ...order.items
                .take(2)
                .map((i) => Text('• ${i.name} ×${i.quantity}')),
            if (order.items.length > 2)
              Text(
                '+${order.items.length - 2} más',
                style: TextStyle(color: Colors.grey[600]),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '\$${order.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF05386B),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(child: _buildActionButtons(order)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BusinessOrder order) {
    if (order.status == OrderStatus.pending) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _viewOrderDetails(order),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B00),
          ),
          child: const Text('Ver Detalles'),
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _viewOrderDetails(order),
        child: const Text('Ver Detalles'),
      ),
    );
  }

  // Bottom sheet para detalles del pedido
  Widget _buildOrderDetailsSheet(BusinessOrder order) {
    final actions = _buildOrderDetailActions(order);

    return Container(
      padding: const EdgeInsets.all(20),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.id,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF05386B),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusText(order.status),
                    style: TextStyle(
                      color: _getStatusColor(order.status),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildOrderProgress(order),
            const SizedBox(height: 16),
            // Información del cliente
            _buildDetailRow(
              Icons.person_outlined,
              'Cliente',
              order.customerName,
            ),
            _buildDetailRow(
              Icons.phone_outlined,
              'Teléfono',
              order.customerPhone,
            ),
            _buildDetailRow(
              Icons.location_on_outlined,
              'Dirección',
              order.deliveryAddress,
            ),
            _buildDetailRow(
              Icons.access_time_outlined,
              'Hora del pedido',
              _formatDateTime(order.orderTime),
            ),
            _buildDetailRow(
              Icons.timer_outlined,
              'Tiempo estimado',
              '${order.estimatedDeliveryTime} minutos',
            ),
            _buildDetailRow(
              Icons.payment_outlined,
              'Método de pago',
              order.paymentMethod,
            ),
            if (order.status == OrderStatus.cancelled &&
                (order.cancelReason?.trim().isNotEmpty ?? false))
              _buildDetailRow(
                Icons.cancel_outlined,
                'Motivo de cancelación',
                order.cancelReason!.trim(),
              ),
            if (order.notes.isNotEmpty)
              _buildDetailRow(Icons.note_outlined, 'Notas', order.notes),
            const SizedBox(height: 20),
            // Items del pedido
            const Text(
              'Items del Pedido',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF05386B),
              ),
            ),
            const SizedBox(height: 12),
            ...order.items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${item.name} x${item.quantity}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF05386B),
                        ),
                      ),
                    ),
                    Text(
                      '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF05386B),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            const Divider(height: 20),
            // Totales
            _buildTotalRow('Subtotal', order.totalAmount - order.deliveryFee),
            _buildTotalRow('Tarifa de entrega', order.deliveryFee),
            _buildTotalRow('Total', order.totalAmount, isTotal: true),
            const SizedBox(height: 24),
            // Botones de acción (según estado)
            actions,
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderProgress(BusinessOrder order) {
    final steps = <_OrderStep>[
      _OrderStep(
        label: 'Pendiente',
        icon: Icons.schedule,
        isActive: true,
        isDone: true,
        time: _formatTime(order.orderTime),
      ),
      _OrderStep(
        label: 'Aceptado',
        icon: Icons.thumb_up_alt_outlined,
        isActive: order.status != OrderStatus.pending,
        isDone: order.acceptedTime != null,
        time: order.acceptedTime != null ? _formatTime(order.acceptedTime!) : null,
      ),
      _OrderStep(
        label: 'Listo',
        icon: Icons.inventory_2_outlined,
        isActive: order.status == OrderStatus.ready ||
            order.status == OrderStatus.onTheWay ||
            order.status == OrderStatus.delivered,
        isDone: order.readyTime != null,
        time: order.readyTime != null ? _formatTime(order.readyTime!) : null,
      ),
      _OrderStep(
        label: 'Entregado',
        icon: Icons.check_circle_outline,
        isActive: order.status == OrderStatus.delivered,
        isDone: order.deliveredTime != null || order.status == OrderStatus.delivered,
        time:
            order.deliveredTime != null ? _formatTime(order.deliveredTime!) : null,
      ),
    ];

    final isCancelled = order.status == OrderStatus.cancelled;

    return Card(
      elevation: 0,
      color: const Color(0xFF05386B).withOpacity(0.04),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.route_outlined, color: Color(0xFF05386B)),
                const SizedBox(width: 8),
                Text(
                  isCancelled ? 'Pedido cancelado' : 'Progreso del pedido',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF05386B),
                  ),
                ),
                const Spacer(),
                if (isCancelled && order.cancelledTime != null)
                  Text(
                    _formatTime(order.cancelledTime!),
                    style: TextStyle(color: Colors.grey[700]),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 520;
                return isWide
                    ? Row(
                        children: steps
                            .map((s) => Expanded(child: _buildStepChip(s)))
                            .toList(),
                      )
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: steps.map(_buildStepChip).toList(),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepChip(_OrderStep step) {
    final baseColor = step.isDone ? const Color(0xFF05386B) : Colors.grey[600]!;
    final bg = step.isDone
        ? const Color(0xFF05386B).withOpacity(0.10)
        : Colors.grey.withOpacity(0.08);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: step.isActive ? baseColor.withOpacity(0.35) : Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(step.icon, size: 18, color: baseColor),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.label,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: baseColor,
                    fontSize: 12.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (step.time != null)
                  Text(
                    step.time!,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 11.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetailActions(BusinessOrder order) {
    final closeButton = OutlinedButton(
      onPressed: () => Navigator.pop(context),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFF05386B)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'Cerrar',
        style: TextStyle(color: Color(0xFF05386B)),
      ),
    );

    if (order.status == OrderStatus.pending) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: closeButton),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _confirmAcceptOrder(order);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B00),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Aceptar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _promptCancelOrder(
                  order,
                  title: 'Rechazar pedido',
                  confirmLabel: 'Sí, rechazar',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Rechazar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      );
    }

    if (order.status == OrderStatus.preparing) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: closeButton),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _markOrderReady(order.id);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF05386B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Marcar listo',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _promptCancelOrder(order);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Cancelar pedido',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      );
    }

    if (order.status == OrderStatus.ready) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: closeButton),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _confirmFinalizeOrder(order);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF05386B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Finalizar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _promptCancelOrder(order);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Cancelar pedido',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      );
    }

    if (order.status == OrderStatus.onTheWay) {
      return Column(
        children: [
          SizedBox(width: double.infinity, child: closeButton),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _promptCancelOrder(order);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Cancelar pedido',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      );
    }

    // delivered / cancelled
    return SizedBox(width: double.infinity, child: closeButton);
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF05386B), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF05386B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? const Color(0xFF05386B) : Colors.grey[700],
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              color: const Color(0xFF05386B),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFFFF6B00),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory),
          label: 'Productos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_offer),
          label: 'Promociones',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet),
          label: 'Finanzas',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
      ],
      onTap: (i) {
        if (i == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BusinessProductsScreen()),
          );
        }
        if (i == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreatePromotionScreen()),
          );
        }
        if (i == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BusinessFinanceScreen()),
          );
        }
        if (i == 4) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BusinessSettingsScreen()),
          );
        }
        // ... otros
      },
    );
  }

  // Métodos de ayuda
  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${_formatTime(dateTime)} - ${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pendiente';
      case OrderStatus.preparing:
        return 'En preparación';
      case OrderStatus.ready:
        return 'Listo para entrega';
      case OrderStatus.onTheWay:
        return 'En camino';
      case OrderStatus.delivered:
        return 'Entregado';
      case OrderStatus.cancelled:
        return 'Cancelado';
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.preparing:
        return Colors.blue;
      case OrderStatus.ready:
        return Colors.purple;
      case OrderStatus.onTheWay:
        return const Color(0xFFFF6B00);
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }
}

// Modelos de datos
enum OrderStatus { pending, preparing, ready, onTheWay, delivered, cancelled }

class BusinessOrder {
  final String id;
  final String customerName;
  final String customerPhone;
  final List<OrderItem> items;
  final double totalAmount;
  final double deliveryFee;
  final DateTime orderTime;
  final int estimatedDeliveryTime;
  OrderStatus status;
  final String paymentMethod;
  final String deliveryAddress;
  final String notes;
  DateTime? acceptedTime;
  DateTime? readyTime;
  DateTime? deliveredTime;
  DateTime? cancelledTime;
  String? cancelReason;

  BusinessOrder({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.items,
    required this.totalAmount,
    required this.deliveryFee,
    required this.orderTime,
    required this.estimatedDeliveryTime,
    required this.status,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.notes,
    this.acceptedTime,
    this.readyTime,
    this.deliveredTime,
    this.cancelledTime,
    this.cancelReason,
  });

  BusinessOrder copyWith({
    String? id,
    String? customerName,
    String? customerPhone,
    List<OrderItem>? items,
    double? totalAmount,
    double? deliveryFee,
    DateTime? orderTime,
    int? estimatedDeliveryTime,
    OrderStatus? status,
    String? paymentMethod,
    String? deliveryAddress,
    String? notes,
    DateTime? acceptedTime,
    DateTime? readyTime,
    DateTime? deliveredTime,
    DateTime? cancelledTime,
    String? cancelReason,
  }) {
    return BusinessOrder(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      orderTime: orderTime ?? this.orderTime,
      estimatedDeliveryTime:
          estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      notes: notes ?? this.notes,
      acceptedTime: acceptedTime ?? this.acceptedTime,
      readyTime: readyTime ?? this.readyTime,
      deliveredTime: deliveredTime ?? this.deliveredTime,
      cancelledTime: cancelledTime ?? this.cancelledTime,
      cancelReason: cancelReason ?? this.cancelReason,
    );
  }
}

class _OrderStep {
  final String label;
  final IconData icon;
  final bool isActive;
  final bool isDone;
  final String? time;

  const _OrderStep({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.isDone,
    this.time,
  });
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  const OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}

class BusinessStore {
  final String id;
  final String name;
  final String category;
  final String ownerName;
  final String phone;
  final String email;
  final String address;
  final double rating;
  final int totalOrders;
  bool isOpen;
  final String openingTime;
  final String closingTime;

  BusinessStore({
    required this.id,
    required this.name,
    required this.category,
    required this.ownerName,
    required this.phone,
    required this.email,
    required this.address,
    required this.rating,
    required this.totalOrders,
    required this.isOpen,
    required this.openingTime,
    required this.closingTime,
  });

  BusinessStore copyWith({
    String? id,
    String? name,
    String? category,
    String? ownerName,
    String? phone,
    String? email,
    String? address,
    double? rating,
    int? totalOrders,
    bool? isOpen,
    String? openingTime,
    String? closingTime,
  }) {
    return BusinessStore(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      ownerName: ownerName ?? this.ownerName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      rating: rating ?? this.rating,
      totalOrders: totalOrders ?? this.totalOrders,
      isOpen: isOpen ?? this.isOpen,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
    );
  }
}

class BusinessStats {
  final int todayOrders;
  final double todayRevenue;
  final int pendingOrders;
  final int preparingOrders;
  final int readyOrders;
  final int totalOrders;
  final double totalRevenue;
  final double averageOrderValue;

  const BusinessStats({
    required this.todayOrders,
    required this.todayRevenue,
    required this.pendingOrders,
    required this.preparingOrders,
    required this.readyOrders,
    required this.totalOrders,
    required this.totalRevenue,
    required this.averageOrderValue,
  });
}
