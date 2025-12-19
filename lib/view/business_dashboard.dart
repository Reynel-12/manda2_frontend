import 'package:flutter/material.dart';
import 'package:manda2_frontend/view/business_finance_screen.dart';
import 'package:manda2_frontend/view/business_product_screen.dart';
import 'package:manda2_frontend/view/business_settings.dart';
import 'package:manda2_frontend/view/create_promotion_screen.dart';

class BusinessDashboardScreen extends StatefulWidget {
  const BusinessDashboardScreen({Key? key}) : super(key: key);

  @override
  State<BusinessDashboardScreen> createState() =>
      _BusinessDashboardScreenState();
}

class _BusinessDashboardScreenState extends State<BusinessDashboardScreen> {
  String _selectedTimeFilter = 'Hoy';
  String _selectedOrderFilter = 'Todos';
  List<BusinessOrder> _orders = [];
  BusinessStore? _storeInfo;
  BusinessStats? _stats;

  final List<String> _timeFilters = ['Hoy', 'Esta semana', 'Este mes', 'Todos'];
  final List<String> _orderFilters = [
    'Todos',
    'Pendientes',
    'En proceso',
    'Completados',
  ];

  @override
  void initState() {
    super.initState();
    _loadStoreData();
    _loadOrders();
    _calculateStats();
  }

  void _loadStoreData() {
    _storeInfo = BusinessStore(
      id: 'STORE-001',
      name: 'Pulpería "El Buen Precio"',
      category: 'Supermercado',
      ownerName: 'Carlos Rodríguez',
      phone: '+504 1234-5678',
      email: 'carlos@elbuenprecio.com',
      address: 'Colonia Los Pinos, Local #5',
      rating: 4.8,
      totalOrders: 1245,
      isOpen: true,
      openingTime: '7:00 AM',
      closingTime: '10:00 PM',
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

  List<BusinessOrder> get _filteredOrders {
    List<BusinessOrder> filtered = _orders;

    // Filtrar por tiempo
    final now = DateTime.now();
    switch (_selectedTimeFilter) {
      case 'Hoy':
        filtered = filtered
            .where(
              (order) =>
                  order.orderTime.day == now.day &&
                  order.orderTime.month == now.month &&
                  order.orderTime.year == now.year,
            )
            .toList();
        break;
      case 'Esta semana':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        filtered = filtered
            .where((order) => order.orderTime.isAfter(startOfWeek))
            .toList();
        break;
      case 'Este mes':
        filtered = filtered
            .where(
              (order) =>
                  order.orderTime.month == now.month &&
                  order.orderTime.year == now.year,
            )
            .toList();
        break;
      // 'Todos' no necesita filtro
    }

    // Filtrar por estado
    if (_selectedOrderFilter != 'Todos') {
      final statusMap = {
        'Pendientes': OrderStatus.pending,
        'En proceso': OrderStatus.preparing,
        'Completados': OrderStatus.delivered,
      };
      final status = statusMap[_selectedOrderFilter];
      if (status != null) {
        filtered = filtered.where((order) => order.status == status).toList();
      }
    }

    return filtered;
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

  void _rejectOrder(String orderId) {
    showDialog(
      context: context,
      builder: (context) => _buildRejectionDialog(orderId),
    );
  }

  void _updateOrderStatus(String orderId, OrderStatus newStatus) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      setState(() {
        _orders[orderIndex] = _orders[orderIndex].copyWith(status: newStatus);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Estado del pedido $orderId actualizado'),
          backgroundColor: const Color(0xFF05386B),
        ),
      );
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
    if (_storeInfo == null || _stats == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard del Negocio'),
          backgroundColor: const Color(0xFF05386B),
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF05386B)),
        ),
      );
    }

    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard del Negocio'),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Notificaciones
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () {
              // Actualizar datos
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Actualizando datos...'),
                  backgroundColor: Color(0xFF05386B),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header con información del negocio
            _buildStoreHeader(),

            // Estadísticas rápidas
            _buildQuickStats(),

            // Filtros
            _buildFiltersSection(),

            // Lista de pedidos
            _buildOrdersSection(isTablet),

            // Espacio final
            const SizedBox(height: 20),
          ],
        ),
      ),

      // Navegación inferior para otras secciones
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Header con información del negocio
  Widget _buildStoreHeader() {
    final store = _storeInfo!;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre y estado del negocio
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    store.category,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              // Botón de estado
              ElevatedButton(
                onPressed: _toggleStoreStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: store.isOpen ? Colors.green : Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  minimumSize: Size.zero, // Prevent infinite width
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      store.isOpen
                          ? Icons.check_circle_outlined
                          : Icons.cancel_outlined,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(store.isOpen ? 'Abierto' : 'Cerrado'),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Información de contacto
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.ownerName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      store.phone,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Horario',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${store.openingTime} - ${store.closingTime}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Rating y pedidos totales
          Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    store.rating.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Row(
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${store.totalOrders} pedidos',
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Estadísticas rápidas
  Widget _buildQuickStats() {
    final stats = _stats!;

    return Container(
      margin: const EdgeInsets.all(16),
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
            'Estadísticas Rápidas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF05386B),
            ),
          ),

          const SizedBox(height: 16),

          // Estadísticas principales
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard(
                Icons.shopping_bag_outlined,
                stats.todayOrders.toString(),
                'Pedidos Hoy',
                const Color(0xFF05386B),
              ),
              _buildStatCard(
                Icons.attach_money_outlined,
                '\$${stats.todayRevenue.toStringAsFixed(0)}',
                'Ventas Hoy',
                const Color(0xFFFF6B00),
              ),
              _buildStatCard(
                Icons.access_time_outlined,
                stats.pendingOrders.toString(),
                'Pendientes',
                Colors.orange,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Estadísticas secundarias
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5,
            children: [
              _buildSecondaryStat(
                'En preparación',
                stats.preparingOrders.toString(),
                Colors.blue,
              ),
              _buildSecondaryStat(
                'Listos para entrega',
                stats.readyOrders.toString(),
                Colors.purple,
              ),
              _buildSecondaryStat(
                'Total de pedidos',
                stats.totalOrders.toString(),
                const Color(0xFF05386B),
              ),
              _buildSecondaryStat(
                'Ticket promedio',
                '\$${stats.averageOrderValue.toStringAsFixed(2)}',
                Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildSecondaryStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Sección de filtros
  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pedidos Recientes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF05386B),
            ),
          ),

          const SizedBox(height: 16),

          // Filtro de tiempo
          Row(
            children: [
              const Text(
                'Período:',
                style: TextStyle(fontSize: 14, color: Color(0xFF05386B)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  children: _timeFilters.map((filter) {
                    final isSelected = filter == _selectedTimeFilter;
                    return FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          _selectedTimeFilter = filter;
                        });
                      },
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
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Filtro de estado
          Row(
            children: [
              const Text(
                'Estado:',
                style: TextStyle(fontSize: 14, color: Color(0xFF05386B)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _orderFilters.map((filter) {
                      final isSelected = filter == _selectedOrderFilter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() {
                              _selectedOrderFilter = filter;
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: const Color(
                            0xFF05386B,
                          ).withOpacity(0.2),
                          checkmarkColor: const Color(0xFF05386B),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? const Color(0xFF05386B)
                                : const Color(0xFF05386B),
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? const Color(0xFF05386B)
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Sección de pedidos
  Widget _buildOrdersSection(bool isTablet) {
    final filteredOrders = _filteredOrders;

    if (filteredOrders.isEmpty) {
      return _buildEmptyOrders();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${filteredOrders.length} ${filteredOrders.length == 1 ? 'pedido' : 'pedidos'}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF05386B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Mostrando: $_selectedOrderFilter • $_selectedTimeFilter',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),

          const SizedBox(height: 16),

          isTablet
              ? _buildOrdersGrid(filteredOrders)
              : _buildOrdersList(filteredOrders),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<BusinessOrder> orders) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(orders[index]);
      },
    );
  }

  Widget _buildOrdersGrid(List<BusinessOrder> orders) {
    final crossAxisCount = MediaQuery.of(context).size.width >= 900 ? 2 : 1;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(orders[index], isGrid: true);
      },
    );
  }

  Widget _buildOrderCard(BusinessOrder order, {bool isGrid = false}) {
    return Container(
      margin: isGrid ? EdgeInsets.zero : const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del pedido
          Padding(
            padding: const EdgeInsets.all(16),
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

                // Información del cliente
                Row(
                  children: [
                    const Icon(
                      Icons.person_outlined,
                      color: Color(0xFF05386B),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        order.customerName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF05386B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.phone_outlined,
                      color: Color(0xFF05386B),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      order.customerPhone,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF05386B),
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
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 13,
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
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                // Información de tiempo y monto
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time_outlined,
                              color: Color(0xFF05386B),
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatTime(order.orderTime),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF05386B),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Entrega: ${order.estimatedDeliveryTime} min',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '\$${order.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF05386B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Acciones según estado
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: _buildOrderActions(order),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderActions(BusinessOrder order) {
    switch (order.status) {
      case OrderStatus.pending:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _rejectOrder(order.id),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Rechazar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _acceptOrder(order.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B00),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Aceptar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );

      case OrderStatus.preparing:
        return Row(
          children: [
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
            Expanded(
              child: ElevatedButton(
                onPressed: () =>
                    _updateOrderStatus(order.id, OrderStatus.ready),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Listo para Entrega',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );

      case OrderStatus.ready:
        return Row(
          children: [
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
            Expanded(
              child: ElevatedButton(
                onPressed: () =>
                    _updateOrderStatus(order.id, OrderStatus.onTheWay),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_shipping_outlined, size: 16),
                    SizedBox(width: 6),
                    Text('En Camino'),
                  ],
                ),
              ),
            ),
          ],
        );

      default:
        return SizedBox(
          width: double.infinity,
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
        );
    }
  }

  Widget _buildEmptyOrders() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 24),
          Text(
            _selectedOrderFilter == 'Todos'
                ? 'No hay pedidos en este período'
                : 'No hay pedidos $_selectedOrderFilter.toLowerCase()',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF05386B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            _selectedTimeFilter == 'Hoy'
                ? 'Los nuevos pedidos aparecerán aquí'
                : 'Intenta con otro período o estado',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              // textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          if (_selectedOrderFilter != 'Todos' || _selectedTimeFilter != 'Hoy')
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedOrderFilter = 'Todos';
                  _selectedTimeFilter = 'Hoy';
                });
              },
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
                'Ver Pedidos de Hoy',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }

  // Diálogo para rechazar pedido
  Widget _buildRejectionDialog(String orderId) {
    String? rejectionReason;
    final List<String> rejectionReasons = [
      'Producto no disponible',
      'Fuera del área de entrega',
      'Horario no disponible',
      'Problema con el pago',
      'Otro motivo',
    ];

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text(
            'Rechazar Pedido',
            style: TextStyle(
              color: Color(0xFF05386B),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('¿Por qué quieres rechazar este pedido?'),
              const SizedBox(height: 16),
              ...rejectionReasons.map((reason) {
                return RadioListTile<String>(
                  title: Text(reason),
                  value: reason,
                  groupValue: rejectionReason,
                  onChanged: (value) {
                    setState(() {
                      rejectionReason = value;
                    });
                  },
                  activeColor: const Color(0xFF05386B),
                );
              }).toList(),
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
              onPressed: rejectionReason != null
                  ? () {
                      final orderIndex = _orders.indexWhere(
                        (order) => order.id == orderId,
                      );
                      if (orderIndex != -1) {
                        setState(() {
                          _orders[orderIndex] = _orders[orderIndex].copyWith(
                            status: OrderStatus.cancelled,
                          );
                        });
                      }
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pedido rechazado'),
                          backgroundColor: Color(0xFF05386B),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Rechazar Pedido'),
            ),
          ],
        );
      },
    );
  }

  // Bottom sheet para detalles del pedido
  Widget _buildOrderDetailsSheet(BusinessOrder order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
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

          // Información del cliente
          _buildDetailRow(Icons.person_outlined, 'Cliente', order.customerName),
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

          // Botones de acción
          if (order.status == OrderStatus.pending)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF05386B)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cerrar',
                      style: TextStyle(color: Color(0xFF05386B)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _acceptOrder(order.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B00),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Aceptar Pedido',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF05386B),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Cerrar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
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

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF6B00),
        unselectedItemColor: Colors.grey[600],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Productos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer_outlined),
            label: 'Promociones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_outlined),
            label: 'Finanzas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Configuración',
          ),
        ],
        onTap: (index) {
          // Navegación
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BusinessProductsScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreatePromotionScreen(),
              ),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BusinessFinanceScreen(),
              ),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BusinessSettingsScreen(),
              ),
            );
          }
        },
      ),
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
