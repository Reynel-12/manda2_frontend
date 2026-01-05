import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with TickerProviderStateMixin {
  String _selectedFilter = 'Todos';
  final List<Order> _orders = [];
  final List<String> _filters = [
    'Todos',
    'Este mes',
    'Últimos 3 meses',
    '2024',
  ];

  // Estadísticas
  int _totalOrders = 0;
  double _totalSpent = 0.0;
  int _completedOrders = 0;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadOrders();
    _calculateStatistics();

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

  void _loadOrders() {
    // Datos de ejemplo para historial de pedidos
    _orders.addAll([
      Order(
        id: 'ORD-2024-001',
        date: DateTime.now().subtract(const Duration(days: 1)),
        storeName: 'Pulpería "El Buen Precio"',
        status: OrderStatus.delivered,
        items: [
          OrderItem(name: 'Leche Entera 1L', quantity: 2, price: 2.50),
          OrderItem(name: 'Pan Integral', quantity: 1, price: 1.75),
          OrderItem(name: 'Huevos x12', quantity: 1, price: 3.20),
        ],
        subtotal: 9.95,
        deliveryFee: 1.50,
        total: 11.45,
        deliveryAddress: 'Barrio Los Pinos, Casa #45',
        deliveryPerson: 'Carlos Mendoza',
        rating: 4,
      ),
      Order(
        id: 'ORD-2024-002',
        date: DateTime.now().subtract(const Duration(days: 3)),
        storeName: 'Restaurante "Sabor Local"',
        status: OrderStatus.delivered,
        items: [
          OrderItem(name: 'Pollo a la Parrilla', quantity: 1, price: 8.99),
          OrderItem(name: 'Ensalada César', quantity: 1, price: 4.50),
          OrderItem(name: 'Refresco 500ml', quantity: 2, price: 1.25),
        ],
        subtotal: 15.99,
        deliveryFee: 1.50,
        total: 17.49,
        deliveryAddress: 'Colonia San José, Apt 302',
        deliveryPerson: 'Ana López',
        rating: 5,
      ),
      Order(
        id: 'ORD-2024-003',
        date: DateTime.now().subtract(const Duration(days: 7)),
        storeName: 'Farmacia "Salud Total"',
        status: OrderStatus.delivered,
        items: [
          OrderItem(name: 'Paracetamol 500mg', quantity: 1, price: 3.50),
          OrderItem(name: 'Jarabe para la tos', quantity: 1, price: 6.75),
        ],
        subtotal: 10.25,
        deliveryFee: 0.00, // Envío gratis
        total: 10.25,
        deliveryAddress: 'Barrio Los Pinos, Casa #45',
        deliveryPerson: 'Roberto García',
        rating: 4,
        notes: 'Entregar en la puerta trasera',
      ),
      Order(
        id: 'ORD-2024-004',
        date: DateTime.now().subtract(const Duration(days: 15)),
        storeName: 'Supermercado Central',
        status: OrderStatus.cancelled,
        items: [
          OrderItem(name: 'Arroz 5kg', quantity: 1, price: 8.90),
          OrderItem(name: 'Aceite 1L', quantity: 1, price: 4.30),
          OrderItem(name: 'Frijoles 1kg', quantity: 1, price: 2.75),
        ],
        subtotal: 15.95,
        deliveryFee: 1.50,
        total: 17.45,
        deliveryAddress: 'Barrio Los Pinos, Casa #45',
        cancellationReason: 'Producto no disponible',
      ),
      Order(
        id: 'ORD-2024-005',
        date: DateTime.now().subtract(const Duration(days: 30)),
        storeName: 'Licorería "La Bodega"',
        status: OrderStatus.delivered,
        items: [
          OrderItem(name: 'Vino Tinto 750ml', quantity: 1, price: 12.99),
          OrderItem(name: 'Cerveza Nacional 6-pack', quantity: 1, price: 7.50),
        ],
        subtotal: 20.49,
        deliveryFee: 1.50,
        total: 21.99,
        deliveryAddress: 'Residencial Las Flores',
        deliveryPerson: 'Miguel Ángel',
        rating: 3,
      ),
      Order(
        id: 'ORD-2024-006',
        date: DateTime.now().subtract(const Duration(days: 45)),
        storeName: 'Pulpería "El Buen Precio"',
        status: OrderStatus.delivered,
        items: [
          OrderItem(name: 'Leche Entera 1L', quantity: 1, price: 2.50),
          OrderItem(name: 'Huevos x12', quantity: 1, price: 3.20),
          OrderItem(name: 'Queso 250g', quantity: 1, price: 4.75),
          OrderItem(name: 'Mantequilla 250g', quantity: 1, price: 2.90),
        ],
        subtotal: 13.35,
        deliveryFee: 1.50,
        total: 14.85,
        deliveryAddress: 'Barrio Los Pinos, Casa #45',
        deliveryPerson: 'Carlos Mendoza',
        rating: 4,
      ),
    ]);
  }

  void _calculateStatistics() {
    setState(() {
      _totalOrders = _orders.length;
      _completedOrders = _orders
          .where((o) => o.status == OrderStatus.delivered)
          .length;
      _totalSpent = _orders
          .where((o) => o.status == OrderStatus.delivered)
          .fold(0.0, (sum, o) => sum + o.total);
    });
  }

  List<Order> get _filteredOrders {
    if (_selectedFilter == 'Todos') {
      return _orders;
    } else if (_selectedFilter == 'Este mes') {
      final firstDayOfMonth = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        1,
      );
      return _orders
          .where((order) => order.date.isAfter(firstDayOfMonth))
          .toList();
    } else if (_selectedFilter == 'Últimos 3 meses') {
      final threeMonthsAgo = DateTime.now().subtract(const Duration(days: 90));
      return _orders
          .where((order) => order.date.isAfter(threeMonthsAgo))
          .toList();
    } else {
      return _orders.where((order) => order.date.year == 2024).toList();
    }
  }

  // void _onFilterChanged(String filter) {
  //   setState(() {
  //     _selectedFilter = filter;
  //   });
  // }

  // void _viewOrderDetails(Order order) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => OrderDetailScreen(order: order)),
  //   );
  // }

  // void _rateOrder(Order order) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => _buildRatingDialog(order),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final isDesktop = MediaQuery.of(context).size.width >= 1200;
    final crossAxisCount = isDesktop
        ? 3
        : isTablet
        ? 2
        : 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Pedidos'),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Estadísticas
            _buildStatsSection(isTablet || isDesktop),

            // Filtros
            _buildFilterChips(),

            // Lista/Grid de pedidos
            Expanded(
              child: _filteredOrders.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 48 : 16,
                        vertical: 24,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                        childAspectRatio: isDesktop ? 1.2 : 1.0,
                      ),
                      itemCount: _filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = _filteredOrders[index];
                        return ScaleTransition(
                          scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                            CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(
                                index * 0.05,
                                1.0,
                                curve: Curves.easeOutBack,
                              ),
                            ),
                          ),
                          child: _buildOrderCard(order),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Tarjeta de estadísticas
  Widget _buildStatsSection(bool isWide) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF05386B), Color(0xFF0A5A9B)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: isWide
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _buildStatCards(),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _buildStatCards(),
            ),
    );
  }

  List<Widget> _buildStatCards() {
    return [
      _buildStatCard(
        _totalOrders.toString(),
        'Pedidos Totales',
        Icons.shopping_bag_outlined,
      ),
      _buildStatCard(
        '\$${_totalSpent.toStringAsFixed(0)}',
        'Gastado Total',
        Icons.attach_money,
      ),
      _buildStatCard(
        _completedOrders.toString(),
        'Entregados',
        Icons.check_circle_outline,
      ),
    ];
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 32, color: Colors.white),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: _filters.map((f) {
          final selected = f == _selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(f),
              selected: selected,
              onSelected: (_) => setState(() => _selectedFilter = f),
              selectedColor: const Color(0xFFFF6B00),
              backgroundColor: Colors.grey[100],
              labelStyle: TextStyle(
                color: selected ? Colors.white : const Color(0xFF05386B),
                fontWeight: FontWeight.w600,
              ),
              avatar: selected
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF05386B).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.history,
                size: 80,
                color: Color(0xFF05386B),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Sin pedidos aún',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: const Color(0xFF05386B),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tus pedidos aparecerán aquí una vez que los realices',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.store),
              label: const Text('Explorar Tiendas'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B00),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => OrderDetailScreen(order: order)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.id,
                    style: const TextStyle(
                      fontSize: 16,
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                order.storeName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _formatDate(order.date),
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              ...order.items
                  .take(3)
                  .map(
                    (i) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Text('• ${i.name} ×${i.quantity}'),
                          const Spacer(),
                          Text(
                            '\$${(i.price * i.quantity).toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              if (order.items.length > 3)
                Text(
                  '+${order.items.length - 3} más',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total', style: TextStyle(color: Colors.grey)),
                      Text(
                        '\$${order.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF05386B),
                        ),
                      ),
                    ],
                  ),
                  if (order.status == OrderStatus.delivered &&
                      order.rating == null)
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Calificar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF05386B),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // String get _getFilterText {
  //   if (_selectedFilter == 'Todos') return '';
  //   return ' ($_selectedFilter)';
  // }

  // Diálogo de calificación
  // Widget _buildRatingDialog(Order order) {
  //   int rating = 0;

  //   return StatefulBuilder(
  //     builder: (context, setState) {
  //       return AlertDialog(
  //         title: const Text(
  //           'Calificar Pedido',
  //           style: TextStyle(
  //             color: Color(0xFF05386B),
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text(
  //               '¿Cómo calificarías tu experiencia con ${order.storeName}?',
  //               textAlign: TextAlign.center,
  //             ),
  //             const SizedBox(height: 20),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: List.generate(5, (index) {
  //                 return IconButton(
  //                   icon: Icon(
  //                     index < rating ? Icons.star : Icons.star_border_outlined,
  //                     color: Colors.amber,
  //                     size: 36,
  //                   ),
  //                   onPressed: () {
  //                     setState(() {
  //                       rating = index + 1;
  //                     });
  //                   },
  //                 );
  //               }),
  //             ),
  //             const SizedBox(height: 10),
  //             Text(
  //               rating == 0 ? '' : '$rating estrellas',
  //               style: const TextStyle(
  //                 color: Color(0xFF05386B),
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text(
  //               'Cancelar',
  //               style: TextStyle(color: Color(0xFF05386B)),
  //             ),
  //           ),
  //           ElevatedButton(
  //             onPressed: rating > 0
  //                 ? () {
  //                     // Actualizar rating
  //                     final updatedOrder = order.copyWith(rating: rating);
  //                     final index = _orders.indexOf(order);
  //                     setState(() {
  //                       _orders[index] = updatedOrder;
  //                     });
  //                     Navigator.pop(context);
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       const SnackBar(
  //                         content: Text('¡Gracias por tu calificación!'),
  //                         backgroundColor: Colors.green,
  //                       ),
  //                     );
  //                   }
  //                 : null,
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: const Color(0xFFFF6B00),
  //             ),
  //             child: const Text('Enviar Calificación'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Métodos de ayuda
  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'Hoy';
    if (diff.inDays == 1) return 'Ayer';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pendiente';
      case OrderStatus.accepted:
        return 'Aceptado';
      case OrderStatus.onTheWay:
        return 'En Camino';
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
      case OrderStatus.accepted:
        return Colors.blue;
      case OrderStatus.onTheWay:
        return const Color(0xFFFF6B00);
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }
}

// Pantalla de Detalles del Pedido
class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Pedido'),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen del pedido
            _buildOrderSummary(),

            const SizedBox(height: 20),

            // Items del pedido
            _buildOrderItems(),

            const SizedBox(height: 20),

            // Desglose de precios
            _buildPriceBreakdown(),

            const SizedBox(height: 20),

            // Información de entrega
            _buildDeliveryInfo(),

            const SizedBox(height: 20),

            // Notas (si existen)
            if (order.notes != null) _buildNotesSection(),

            const SizedBox(height: 40),
          ],
        ),
      ),
      // bottomNavigationBar: _buildBottomActions(context),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.id,
                style: const TextStyle(
                  fontSize: 18,
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

          const SizedBox(height: 12),

          Text(
            order.storeName,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF05386B),
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            _formatDetailedDate(order.date),
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Items del Pedido',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF05386B),
            ),
          ),

          const SizedBox(height: 16),

          Column(
            children: order.items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    // Imagen del producto
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Información
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF05386B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${item.price.toStringAsFixed(2)} c/u',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Cantidad y subtotal
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'x${item.quantity}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF05386B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF05386B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdown() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Desglose de Pagos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF05386B),
            ),
          ),

          const SizedBox(height: 16),

          _buildPriceRow('Subtotal', order.subtotal),
          _buildPriceRow('Tarifa de envío', order.deliveryFee),

          if (order.deliveryFee == 0)
            _buildPriceRow('Descuento en envío', -1.50, isDiscount: true),

          const Divider(height: 24),

          _buildPriceRow('Total', order.total, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    double amount, {
    bool isTotal = false,
    bool isDiscount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 15,
              color: isTotal ? const Color(0xFF05386B) : Colors.grey[700],
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            isDiscount
                ? '-\$${amount.abs().toStringAsFixed(2)}'
                : '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 18 : 15,
              color: isDiscount
                  ? Colors.green[700]
                  : isTotal
                  ? const Color(0xFF05386B)
                  : const Color(0xFF05386B),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información de Entrega',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF05386B),
            ),
          ),

          const SizedBox(height: 16),

          _buildInfoRow(
            Icons.location_on_outlined,
            'Dirección',
            order.deliveryAddress,
          ),

          if (order.deliveryPerson != null)
            _buildInfoRow(
              Icons.person_outlined,
              'Repartidor',
              order.deliveryPerson!,
            ),

          // if (order.rating != null)
          //   _buildInfoRow(
          //     Icons.star_outlined,
          //     'Tu calificación',
          //     '${order.rating!}/5',
          //   ),
          if (order.cancellationReason != null)
            _buildInfoRow(
              Icons.cancel_outlined,
              'Motivo de cancelación',
              order.cancellationReason!,
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
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

  Widget _buildNotesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notas del Pedido',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF05386B),
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF05386B).withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              order.notes!,
              style: const TextStyle(fontSize: 16, color: Color(0xFF05386B)),
            ),
          ),
        ],
      ),
    );
  }

  // Métodos de ayuda
  String _formatDetailedDate(DateTime date) {
    final days = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
    final months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];

    final weekday = days[date.weekday % 7];
    final month = months[date.month - 1];

    return '$weekday, ${date.day} de $month de ${date.year} a las ${_formatTime(date)}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pendiente';
      case OrderStatus.accepted:
        return 'Aceptado';
      case OrderStatus.onTheWay:
        return 'En Camino';
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
      case OrderStatus.accepted:
        return Colors.blue;
      case OrderStatus.onTheWay:
        return const Color(0xFFFF6B00);
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }
}

// Enums y modelos de datos
enum OrderStatus { pending, accepted, onTheWay, delivered, cancelled }

class Order {
  final String id;
  final DateTime date;
  final String storeName;
  final OrderStatus status;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String deliveryAddress;
  final String? deliveryPerson;
  final int? rating;
  final String? notes;
  final String? cancellationReason;

  const Order({
    required this.id,
    required this.date,
    required this.storeName,
    required this.status,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.deliveryAddress,
    this.deliveryPerson,
    this.rating,
    this.notes,
    this.cancellationReason,
  });

  Order copyWith({
    String? id,
    DateTime? date,
    String? storeName,
    OrderStatus? status,
    List<OrderItem>? items,
    double? subtotal,
    double? deliveryFee,
    double? total,
    String? deliveryAddress,
    String? deliveryPerson,
    int? rating,
    String? notes,
    String? cancellationReason,
  }) {
    return Order(
      id: id ?? this.id,
      date: date ?? this.date,
      storeName: storeName ?? this.storeName,
      status: status ?? this.status,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryPerson: deliveryPerson ?? this.deliveryPerson,
      rating: rating ?? this.rating,
      notes: notes ?? this.notes,
      cancellationReason: cancellationReason ?? this.cancellationReason,
    );
  }
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
