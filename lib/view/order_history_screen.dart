import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  String _selectedFilter = 'Todos'; // Filtro actual
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

  @override
  void initState() {
    super.initState();
    _loadOrders();
    _calculateStatistics();
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
          .where((order) => order.status == OrderStatus.delivered)
          .length;
      _totalSpent = _orders
          .where((order) => order.status == OrderStatus.delivered)
          .fold(0.0, (sum, order) => sum + order.total);
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

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  // void _reorderOrder(Order order) {
  //   // Lógica para reordenar
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Reordenando ${order.storeName}...'),
  //       backgroundColor: const Color(0xFF05386B),
  //       action: SnackBarAction(
  //         label: 'Ver Carrito',
  //         textColor: Colors.white,
  //         onPressed: () {
  //           // Navegar al carrito
  //         },
  //       ),
  //     ),
  //   );
  // }

  void _viewOrderDetails(Order order) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderDetailScreen(order: order)),
    );
  }

  void _rateOrder(Order order) {
    showDialog(
      context: context,
      builder: (context) => _buildRatingDialog(order),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Pedidos'),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () {
              // Buscar en historial
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Estadísticas
          _buildStatisticsCard(),

          // Filtros
          _buildFilterSection(),

          // Lista de pedidos
          Expanded(
            child: _filteredOrders.isEmpty
                ? _buildEmptyState()
                : _buildOrderList(),
          ),
        ],
      ),
    );
  }

  // Tarjeta de estadísticas
  Widget _buildStatisticsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF05386B),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Estadísticas principales
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                _totalOrders.toString(),
                'Pedidos',
                Icons.shopping_bag_outlined,
              ),
              _buildStatItem(
                '\$${_totalSpent.toStringAsFixed(0)}',
                'Total gastado',
                Icons.attach_money_outlined,
              ),
              _buildStatItem(
                _completedOrders.toString(),
                'Completados',
                Icons.check_circle_outlined,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Resumen del filtro
          Text(
            'Mostrando ${_filteredOrders.length} pedidos$_getFilterText',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  String get _getFilterText {
    if (_selectedFilter == 'Todos') return '';
    return ' ($_selectedFilter)';
  }

  // Sección de filtros
  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filtrar por',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF05386B),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((filter) {
                final isSelected = filter == _selectedFilter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (_) => _onFilterChanged(filter),
                    backgroundColor: Colors.white,
                    selectedColor: const Color(0xFFFF6B00).withOpacity(0.2),
                    checkmarkColor: const Color(0xFFFF6B00),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? const Color(0xFFFF6B00)
                          : const Color(0xFF05386B),
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFFFF6B00)
                          : Colors.grey[300]!,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Estado vacío
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF05386B).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.history_outlined,
                size: 60,
                color: Color(0xFF05386B),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No hay pedidos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF05386B),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _selectedFilter == 'Todos'
                  ? 'Realiza tu primer pedido para comenzar'
                  : 'No hay pedidos en este período',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                // textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            if (_selectedFilter != 'Todos')
              ElevatedButton(
                onPressed: () => _onFilterChanged('Todos'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B00),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Ver todos los pedidos',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Lista de pedidos
  Widget _buildOrderList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredOrders.length,
      itemBuilder: (context, index) {
        final order = _filteredOrders[index];
        return _buildOrderCard(order);
      },
    );
  }

  // Tarjeta de pedido
  Widget _buildOrderCard(Order order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        children: [
          // Header del pedido
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Primera fila: ID y fecha
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
                    Text(
                      _formatDate(order.date),
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Segunda fila: Tienda y estado
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        order.storeName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF05386B),
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getStatusText(order.status),
                        style: TextStyle(
                          color: _getStatusColor(order.status),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Items del pedido
                Column(
                  children: order.items.take(2).map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 4,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF05386B),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${item.name} x${item.quantity}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF05386B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                if (order.items.length > 2) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '+${order.items.length - 2} más',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                // Total y rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '\$${order.total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF05386B),
                          ),
                        ),
                      ],
                    ),

                    // if (order.status == OrderStatus.delivered &&
                    //     order.rating != null)
                    //   Row(
                    //     children: [
                    //       const Icon(Icons.star, color: Colors.amber, size: 16),
                    //       const SizedBox(width: 4),
                    //       Text(
                    //         order.rating!.toString(),
                    //         style: const TextStyle(
                    //           fontWeight: FontWeight.w600,
                    //           color: Color(0xFF05386B),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                  ],
                ),
              ],
            ),
          ),

          // Acciones del pedido
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                // Botón de detalles
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _viewOrderDetails(order),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF05386B)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Ver Detalles',
                      style: TextStyle(color: Color(0xFF05386B)),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Botón de reordenar (solo para entregados)
                // if (order.status == OrderStatus.delivered)
                //   Expanded(
                //     child: ElevatedButton(
                //       onPressed: () => _reorderOrder(order),
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: const Color(0xFFFF6B00),
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(8),
                //         ),
                //       ),
                //       child: const Text(
                //         'Reordenar',
                //         style: TextStyle(color: Colors.white),
                //       ),
                //     ),
                //   ),

                // Botón de calificar (solo para entregados sin rating)
                if (order.status == OrderStatus.delivered &&
                    order.rating == null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _rateOrder(order),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF05386B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Calificar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Diálogo de calificación
  Widget _buildRatingDialog(Order order) {
    int rating = 0;

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text(
            'Calificar Pedido',
            style: TextStyle(
              color: Color(0xFF05386B),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '¿Cómo calificarías tu experiencia con ${order.storeName}?',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border_outlined,
                      color: Colors.amber,
                      size: 36,
                    ),
                    onPressed: () {
                      setState(() {
                        rating = index + 1;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 10),
              Text(
                rating == 0 ? '' : '$rating estrellas',
                style: const TextStyle(
                  color: Color(0xFF05386B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Color(0xFF05386B)),
              ),
            ),
            ElevatedButton(
              onPressed: rating > 0
                  ? () {
                      // Actualizar rating
                      final updatedOrder = order.copyWith(rating: rating);
                      final index = _orders.indexOf(order);
                      setState(() {
                        _orders[index] = updatedOrder;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('¡Gracias por tu calificación!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B00),
              ),
              child: const Text('Enviar Calificación'),
            ),
          ],
        );
      },
    );
  }

  // Métodos de ayuda
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoy';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
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

  // Widget _buildBottomActions(BuildContext context) {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.2),
  //           blurRadius: 10,
  //           spreadRadius: 2,
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       children: [
  //         // Reordenar
  //         // Expanded(
  //         //   child: ElevatedButton(
  //         //     onPressed: () {
  //         //       // Reordenar
  //         //       Navigator.pop(context);
  //         //       ScaffoldMessenger.of(context).showSnackBar(
  //         //         SnackBar(
  //         //           content: Text('Reordenando ${order.storeName}...'),
  //         //           backgroundColor: const Color(0xFF05386B),
  //         //         ),
  //         //       );
  //         //     },
  //         //     style: ElevatedButton.styleFrom(
  //         //       backgroundColor: const Color(0xFFFF6B00),
  //         //       foregroundColor: Colors.white,
  //         //       padding: const EdgeInsets.symmetric(vertical: 16),
  //         //       shape: RoundedRectangleBorder(
  //         //         borderRadius: BorderRadius.circular(12),
  //         //       ),
  //         //     ),
  //         //     child: const Text(
  //         //       'Reordenar',
  //         //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  //         //     ),
  //         //   ),
  //         // ),

  //         // const SizedBox(width: 12),

  //         // Ayuda
  //         Container(
  //           width: 56,
  //           height: 56,
  //           decoration: BoxDecoration(
  //             border: Border.all(color: const Color(0xFF05386B)),
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: IconButton(
  //             icon: const Icon(
  //               Icons.help_outline_outlined,
  //               color: Color(0xFF05386B),
  //             ),
  //             onPressed: () {
  //               // Ayuda
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
