import 'package:flutter/material.dart';
import 'package:manda2_frontend/view/configuracion_screen.dart';
import 'package:manda2_frontend/view/detalle_orden.dart' as detalle_orden;

class DeliveryHomeScreen extends StatefulWidget {
  const DeliveryHomeScreen({super.key});

  @override
  State<DeliveryHomeScreen> createState() => _DeliveryHomeScreenState();
}

class _DeliveryHomeScreenState extends State<DeliveryHomeScreen> {
  List<DeliveryOrder> _pendingOrders = [];
  List<DeliveryOrder> _acceptedOrders = [];
  List<DeliveryOrder> _historyOrders = [];
  String _statusFilter = 'Pendientes';
  DeliveryDriver? _driverProfile;
  bool _isAvailable = true;
  double _todayEarnings = 0.0;
  int _completedToday = 0;

  final List<String> _statusFilters = ['Pendientes', 'En Curso', 'Historial'];

  @override
  void initState() {
    super.initState();
    _loadDriverData();
    _loadOrders();
    _loadStatistics();
    _loadHistoryOrders();
  }

  void _loadDriverData() {
    _driverProfile = DeliveryDriver(
      id: 'DRV-001',
      name: 'Carlos Mendoza',
      phone: '+504 555-7890',
      rating: 4.8,
      vehicle: 'Moto Honda CB190',
      plateNumber: 'ABC-123',
      totalDeliveries: 342,
      totalEarnings: 2850.50,
      memberSince: DateTime(2023, 6, 15),
    );
  }

  void _loadOrders() {
    // Pedidos pendientes
    _pendingOrders = [
      DeliveryOrder(
        id: 'ORD-2024-001',
        customerName: 'María González',
        customerPhone: '+504 1234-5678',
        storeName: 'Pulpería "El Buen Precio"',
        storeAddress: 'Colonia Los Pinos, Local #5',
        deliveryAddress: 'Barrio Los Pinos, Casa #45',
        totalAmount: 18.35,
        deliveryFee: 1.50,
        items: [
          OrderItem(name: 'Leche Entera 1L', quantity: 2),
          OrderItem(name: 'Pan Integral', quantity: 1),
          OrderItem(name: 'Huevos x12', quantity: 1),
        ],
        orderTime: DateTime.now().subtract(const Duration(minutes: 15)),
        estimatedDeliveryTime: 20,
        distance: 2.5,
        status: detalle_orden.OrderStatus.assigned,
        paymentMethod: 'Efectivo',
        notes: 'Casa color azul, portón negro',
      ),
      DeliveryOrder(
        id: 'ORD-2024-002',
        customerName: 'José Martínez',
        customerPhone: '+504 8765-4321',
        storeName: 'Restaurante "Sabor Local"',
        storeAddress: 'Colonia San José, Local #12',
        deliveryAddress: 'Residencial Las Flores, Casa #8',
        totalAmount: 24.50,
        deliveryFee: 2.00,
        items: [
          OrderItem(name: 'Pollo a la Parrilla', quantity: 1),
          OrderItem(name: 'Ensalada César', quantity: 1),
          OrderItem(name: 'Refresco 500ml', quantity: 2),
        ],
        orderTime: DateTime.now().subtract(const Duration(minutes: 30)),
        estimatedDeliveryTime: 25,
        distance: 3.8,
        status: detalle_orden.OrderStatus.assigned,
        paymentMethod: 'Tarjeta',
        notes: 'Entregar en la puerta trasera',
      ),
      DeliveryOrder(
        id: 'ORD-2024-003',
        customerName: 'Ana López',
        customerPhone: '+504 555-1234',
        storeName: 'Farmacia "Salud Total"',
        storeAddress: 'Centro Comercial Metro',
        deliveryAddress: 'Colonia San José, Apartamento 302',
        totalAmount: 12.75,
        deliveryFee: 1.00,
        items: [
          OrderItem(name: 'Paracetamol 500mg', quantity: 1),
          OrderItem(name: 'Jarabe para la tos', quantity: 1),
        ],
        orderTime: DateTime.now().subtract(const Duration(minutes: 45)),
        estimatedDeliveryTime: 15,
        distance: 1.8,
        status: detalle_orden.OrderStatus.assigned,
        paymentMethod: 'Efectivo',
        notes: 'Pedir en recepción',
      ),
    ];

    // Pedidos aceptados (en curso)
    _acceptedOrders = [
      DeliveryOrder(
        id: 'ORD-2024-004',
        customerName: 'Roberto García',
        customerPhone: '+504 777-8888',
        storeName: 'Supermercado Central',
        storeAddress: 'Boulevard Centro',
        deliveryAddress: 'Urbanización Bella Vista, Casa #23',
        totalAmount: 32.80,
        deliveryFee: 1.50,
        items: [
          OrderItem(name: 'Arroz 5kg', quantity: 1),
          OrderItem(name: 'Aceite 1L', quantity: 1),
          OrderItem(name: 'Frijoles 1kg', quantity: 2),
          OrderItem(name: 'Azúcar 2kg', quantity: 1),
        ],
        orderTime: DateTime.now().subtract(const Duration(minutes: 60)),
        estimatedDeliveryTime: 18,
        distance: 2.2,
        status: detalle_orden.OrderStatus.pickedUp,
        paymentMethod: 'Tarjeta',
        notes: 'Casa con jardín grande',
      ),
    ];
  }

  void _loadHistoryOrders() {
    // Pedidos pendientes
    _historyOrders = [
      DeliveryOrder(
        id: 'ORD-2024-001',
        customerName: 'María González',
        customerPhone: '+504 1234-5678',
        storeName: 'Pulpería "El Buen Precio"',
        storeAddress: 'Colonia Los Pinos, Local #5',
        deliveryAddress: 'Barrio Los Pinos, Casa #45',
        totalAmount: 18.35,
        deliveryFee: 1.50,
        items: [
          OrderItem(name: 'Leche Entera 1L', quantity: 2),
          OrderItem(name: 'Pan Integral', quantity: 1),
          OrderItem(name: 'Huevos x12', quantity: 1),
        ],
        orderTime: DateTime.now().subtract(const Duration(minutes: 15)),
        estimatedDeliveryTime: 20,
        distance: 2.5,
        status: detalle_orden.OrderStatus.delivered,
        paymentMethod: 'Efectivo',
        notes: 'Casa color azul, portón negro',
      ),
      DeliveryOrder(
        id: 'ORD-2024-002',
        customerName: 'José Martínez',
        customerPhone: '+504 8765-4321',
        storeName: 'Restaurante "Sabor Local"',
        storeAddress: 'Colonia San José, Local #12',
        deliveryAddress: 'Residencial Las Flores, Casa #8',
        totalAmount: 24.50,
        deliveryFee: 2.00,
        items: [
          OrderItem(name: 'Pollo a la Parrilla', quantity: 1),
          OrderItem(name: 'Ensalada César', quantity: 1),
          OrderItem(name: 'Refresco 500ml', quantity: 2),
        ],
        orderTime: DateTime.now().subtract(const Duration(minutes: 30)),
        estimatedDeliveryTime: 25,
        distance: 3.8,
        status: detalle_orden.OrderStatus.delivered,
        paymentMethod: 'Tarjeta',
        notes: 'Entregar en la puerta trasera',
      ),
      DeliveryOrder(
        id: 'ORD-2024-003',
        customerName: 'Ana López',
        customerPhone: '+504 555-1234',
        storeName: 'Farmacia "Salud Total"',
        storeAddress: 'Centro Comercial Metro',
        deliveryAddress: 'Colonia San José, Apartamento 302',
        totalAmount: 12.75,
        deliveryFee: 1.00,
        items: [
          OrderItem(name: 'Paracetamol 500mg', quantity: 1),
          OrderItem(name: 'Jarabe para la tos', quantity: 1),
        ],
        orderTime: DateTime.now().subtract(const Duration(minutes: 45)),
        estimatedDeliveryTime: 15,
        distance: 1.8,
        status: detalle_orden.OrderStatus.delivered,
        paymentMethod: 'Efectivo',
        notes: 'Pedir en recepción',
      ),
    ];
  }

  void _loadStatistics() {
    _todayEarnings = 45.25;
    _completedToday = 3;
  }

  List<DeliveryOrder> get _filteredOrders {
    switch (_statusFilter) {
      case 'Pendientes':
        return _pendingOrders;
      case 'En Curso':
        return _acceptedOrders;
      case 'Historial':
        return _historyOrders; // En una app real vendrían de la base de datos
      default:
        return _pendingOrders;
    }
  }

  void _acceptOrder(String orderId) {
    final orderIndex = _pendingOrders.indexWhere(
      (order) => order.id == orderId,
    );

    if (orderIndex != -1) {
      final acceptedOrder = _pendingOrders[orderIndex].copyWith(
        status: detalle_orden.OrderStatus.accepted,
        acceptedTime: DateTime.now(),
        driverId: _driverProfile!.id,
        driverName: _driverProfile!.name,
      );

      setState(() {
        _pendingOrders.removeAt(orderIndex);
        _acceptedOrders.add(acceptedOrder);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pedido $orderId aceptado'),
          backgroundColor: const Color(0xFF05386B),
          action: SnackBarAction(
            label: 'Ver Detalles',
            textColor: Colors.white,
            onPressed: () {
              _viewOrderDetails(acceptedOrder);
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

  void _toggleAvailability() {
    setState(() {
      _isAvailable = !_isAvailable;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isAvailable
              ? 'Ahora estás disponible para entregas'
              : 'Modo no disponible activado',
        ),
        backgroundColor: const Color(0xFF05386B),
      ),
    );
  }

  void _viewOrderDetails(DeliveryOrder order) {
    final orden = detalle_orden.DeliveryOrder(
      id: order.id,
      customerName: order.customerName,
      customerPhone: order.customerPhone,
      storeName: order.storeName,
      storeAddress: order.storeAddress,
      deliveryAddress: order.deliveryAddress,
      totalAmount: order.totalAmount,
      deliveryFee: order.deliveryFee,
      items: order.items
          .map(
            (item) => detalle_orden.OrderItem(
              name: item.name,
              quantity: item.quantity,
            ),
          )
          .toList(),
      orderTime: order.orderTime,
      estimatedDeliveryTime: order.estimatedDeliveryTime,
      distance: order.distance,
      status: order.status,
      paymentMethod: order.paymentMethod,
      notes: order.notes,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            detalle_orden.DeliveryOrderDetailScreen(order: orden),
      ),
    );
  }

  void _startDelivery(String orderId) {
    final orderIndex = _acceptedOrders.indexWhere(
      (order) => order.id == orderId,
    );

    if (orderIndex != -1) {
      setState(() {
        _acceptedOrders[orderIndex] = _acceptedOrders[orderIndex].copyWith(
          status: detalle_orden.OrderStatus.onTheWay,
          pickupTime: DateTime.now(),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡En camino con el pedido!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _completeDelivery(String orderId) {
    final orderIndex = _acceptedOrders.indexWhere(
      (order) => order.id == orderId,
    );

    if (orderIndex != -1) {
      final completedOrder = _acceptedOrders[orderIndex].copyWith(
        status: detalle_orden.OrderStatus.delivered,
        deliveryTime: DateTime.now(),
      );

      setState(() {
        _acceptedOrders.removeAt(orderIndex);
        // En una app real, se movería a historial
        _completedToday++;
        _todayEarnings += completedOrder.deliveryFee;
        _historyOrders.add(completedOrder);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('¡Pedido entregado exitosamente!'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'Ver Resumen',
            textColor: Colors.white,
            onPressed: () {
              _showDeliverySummary(completedOrder);
            },
          ),
        ),
      );
    }
  }

  void _showDeliverySummary(DeliveryOrder order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildDeliverySummary(order),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repartidor Manda2'),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Botón de disponibilidad
          IconButton(
            icon: Icon(
              _isAvailable
                  ? Icons.location_on_outlined
                  : Icons.location_off_outlined,
              color: _isAvailable ? Colors.green : Colors.orange,
            ),
            onPressed: _toggleAvailability,
            tooltip: _isAvailable ? 'Disponible' : 'No disponible',
          ),
          // Notificaciones
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Ver notificaciones
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header con estadísticas
          _buildDriverHeader(),

          // Filtros de estado
          _buildStatusFilter(),

          // Lista de pedidos
          Expanded(
            child: _filteredOrders.isEmpty
                ? _buildEmptyState()
                : _buildOrderList(),
          ),
        ],
      ),

      // Botón flotante para actualizar
      floatingActionButton: _statusFilter == 'Pendientes'
          ? FloatingActionButton(
              onPressed: () {
                // Actualizar lista de pedidos
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Actualizando pedidos disponibles...'),
                    backgroundColor: Color(0xFF05386B),
                  ),
                );
              },
              backgroundColor: const Color(0xFFFF6B00),
              child: const Icon(Icons.refresh_outlined, color: Colors.white),
            )
          : null,

      // Navegación inferior
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Header del repartidor con estadísticas
  Widget _buildDriverHeader() {
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
          // Información del repartidor
          Row(
            children: [
              // Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFF6B00), width: 2),
                ),
                child: Center(
                  child: Text(
                    _driverProfile?.name.substring(0, 1) ?? 'C',
                    style: const TextStyle(
                      color: Color(0xFF05386B),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Información
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _driverProfile?.name ?? 'Repartidor',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          _driverProfile?.rating.toString() ?? '4.8',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.motorcycle_outlined,
                          color: Colors.white.withOpacity(0.8),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _driverProfile?.vehicle ?? 'Moto',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Estado de disponibilidad
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _isAvailable ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _isAvailable ? 'DISPONIBLE' : 'NO DISP.',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isAvailable ? 'Activo' : 'Inactivo',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Estadísticas del día
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                '\$${_todayEarnings.toStringAsFixed(2)}',
                'Ganancia Hoy',
                Icons.attach_money_outlined,
              ),
              _buildStatItem(
                _completedToday.toString(),
                'Entregas Hoy',
                Icons.check_circle_outlined,
              ),
              _buildStatItem(
                _filteredOrders.length.toString(),
                _statusFilter == 'Pendientes'
                    ? 'Pendientes'
                    : _statusFilter == 'En Curso'
                    ? 'En Curso'
                    : 'Historial',
                Icons.shopping_bag_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
        ),
      ],
    );
  }

  // Filtros de estado de pedidos
  Widget _buildStatusFilter() {
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
            'Pedidos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF05386B),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _statusFilters.map((filter) {
                final isSelected = filter == _statusFilter;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        _statusFilter = filter;
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
            Icon(
              _statusFilter == 'Pendientes'
                  ? Icons.shopping_bag_outlined
                  : _statusFilter == 'En Curso'
                  ? Icons.delivery_dining_outlined
                  : Icons.history_outlined,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 24),
            Text(
              _statusFilter == 'Pendientes'
                  ? 'No hay pedidos pendientes'
                  : _statusFilter == 'En Curso'
                  ? 'No hay pedidos en curso'
                  : 'No hay historial de pedidos',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF05386B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _statusFilter == 'Pendientes'
                  ? 'Los nuevos pedidos aparecerán aquí'
                  : _statusFilter == 'En Curso'
                  ? 'Acepta un pedido para comenzar'
                  : 'Los pedidos completados aparecerán aquí',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                // textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            if (!_isAvailable && _statusFilter == 'Pendientes')
              ElevatedButton(
                onPressed: _toggleAvailability,
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
                  'Activar Disponibilidad',
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
  Widget _buildOrderCard(DeliveryOrder order) {
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
                // ID y estado
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
                _buildInfoRow(
                  Icons.person_outlined,
                  'Cliente',
                  order.customerName,
                ),

                const SizedBox(height: 8),

                _buildInfoRow(
                  Icons.phone_outlined,
                  'Teléfono',
                  order.customerPhone,
                ),

                const SizedBox(height: 16),

                // Tienda y dirección
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.store_outlined,
                      color: const Color(0xFF05386B),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.storeName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF05386B),
                            ),
                          ),
                          Text(
                            order.storeAddress,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Dirección de entrega
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: const Color(0xFFFF6B00),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Entrega a',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF05386B),
                            ),
                          ),
                          Text(
                            order.deliveryAddress,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                if (order.notes.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.note_outlined, 'Notas', order.notes),
                ],

                const SizedBox(height: 16),

                // Detalles del pedido
                Row(
                  children: [
                    _buildDetailItem(
                      Icons.access_time_outlined,
                      '${order.estimatedDeliveryTime} min',
                      'Tiempo estimado',
                    ),
                    const SizedBox(width: 20),
                    _buildDetailItem(
                      Icons.directions_outlined,
                      '${order.distance} km',
                      'Distancia',
                    ),
                    const SizedBox(width: 20),
                    _buildDetailItem(
                      Icons.attach_money_outlined,
                      '\$${order.totalAmount.toStringAsFixed(2)}',
                      'Total',
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  'Tarifa de entrega: \$${order.deliveryFee.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF05386B),
                    fontWeight: FontWeight.w500,
                  ),
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
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: _buildOrderActions(order),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF05386B), size: 18),
        const SizedBox(width: 8),
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
                  fontSize: 14,
                  color: Color(0xFF05386B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF05386B), size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF05386B),
          ),
        ),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }

  // Acciones según estado del pedido
  Widget _buildOrderActions(DeliveryOrder order) {
    switch (order.status) {
      case detalle_orden.OrderStatus.assigned:
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
                  'Aceptar Pedido',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );

      case detalle_orden.OrderStatus.accepted:
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
                onPressed: () => _startDelivery(order.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF05386B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions_bike_outlined, size: 20),
                    SizedBox(width: 8),
                    Text('Iniciar Entrega'),
                  ],
                ),
              ),
            ),
          ],
        );

      case detalle_orden.OrderStatus.pickedUp:
      case detalle_orden.OrderStatus.onTheWay:
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
                  'Ver Ruta',
                  style: TextStyle(color: Color(0xFF05386B)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _completeDelivery(order.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outlined, size: 20),
                    SizedBox(width: 8),
                    Text('Entregado'),
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

  // Diálogo para rechazar pedido
  Widget _buildRejectionDialog(String orderId) {
    String? rejectionReason;
    final List<String> rejectionReasons = [
      'Muy lejos de mi ubicación',
      'No tengo el vehículo adecuado',
      'El pedido es muy grande/pesado',
      'Problemas con la dirección',
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
                      // En una app real, enviar el rechazo al servidor
                      final orderIndex = _pendingOrders.indexWhere(
                        (order) => order.id == orderId,
                      );
                      if (orderIndex != -1) {
                        setState(() {
                          _pendingOrders.removeAt(orderIndex);
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

  // Resumen de entrega
  Widget _buildDeliverySummary(DeliveryOrder order) {
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

          const Center(
            child: Icon(
              Icons.check_circle_outlined,
              color: Colors.green,
              size: 60,
            ),
          ),

          const SizedBox(height: 16),

          const Center(
            child: Text(
              '¡Entrega Completada!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF05386B),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Center(
            child: Text(
              'Pedido ${order.id} entregado a ${order.customerName}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 24),

          // Resumen de ganancias
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF05386B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  'Resumen de Entrega',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF05386B),
                  ),
                ),
                const SizedBox(height: 16),
                _buildSummaryRow(
                  'Tarifa de entrega',
                  '\$${order.deliveryFee.toStringAsFixed(2)}',
                ),
                _buildSummaryRow('Propina recibida', '\$2.00'),
                const Divider(height: 20),
                _buildSummaryRow(
                  'Total ganado',
                  '\$${(order.deliveryFee + 2.00).toStringAsFixed(2)}',
                  isTotal: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Calificación del cliente
          const Text(
            'Calificación del Cliente',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF05386B),
            ),
          ),

          const SizedBox(height: 12),

          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.amber, size: 32),
              Icon(Icons.star, color: Colors.amber, size: 32),
              Icon(Icons.star, color: Colors.amber, size: 32),
              Icon(Icons.star, color: Colors.amber, size: 32),
              Icon(Icons.star_half, color: Colors.amber, size: 32),
            ],
          ),

          const SizedBox(height: 8),

          const Center(
            child: Text(
              '4.5 estrellas - "¡Excelente servicio!"',
              style: TextStyle(
                color: Color(0xFF05386B),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Botones de acción
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
                    // Tomar nuevo pedido
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B00),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Tomar Nuevo Pedido',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
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
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 15,
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
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Perfil',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          }
        },
      ),
    );
  }

  // Métodos de ayuda
  String _getStatusText(detalle_orden.OrderStatus status) {
    switch (status) {
      case detalle_orden.OrderStatus.assigned:
        return 'Asignado';
      case detalle_orden.OrderStatus.accepted:
        return 'Aceptado';
      case detalle_orden.OrderStatus.pickedUp:
        return 'Recogido';
      case detalle_orden.OrderStatus.onTheWay:
        return 'En Camino';
      case detalle_orden.OrderStatus.delivered:
        return 'Entregado';
      case detalle_orden.OrderStatus.cancelled:
        return 'Cancelado';
    }
  }

  Color _getStatusColor(detalle_orden.OrderStatus status) {
    switch (status) {
      case detalle_orden.OrderStatus.assigned:
        return Colors.blue;
      case detalle_orden.OrderStatus.accepted:
        return Colors.orange;
      case detalle_orden.OrderStatus.pickedUp:
        return Colors.purple;
      case detalle_orden.OrderStatus.onTheWay:
        return const Color(0xFFFF6B00);
      case detalle_orden.OrderStatus.delivered:
        return Colors.green;
      case detalle_orden.OrderStatus.cancelled:
        return Colors.red;
    }
  }
}

// Pantalla de detalles del pedido (simplificada)
// class OrderDetailScreen extends StatelessWidget {
//   final DeliveryOrder order;

//   const OrderDetailScreen({required this.order, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Detalles del Pedido'),
//         backgroundColor: const Color(0xFF05386B),
//         foregroundColor: Colors.white,
//       ),
//       body: Center(child: Text('Detalles de ${order.id}')),
//     );
//   }
// }

// Enums y modelos de datos
// enum OrderStatus {
//   assigned,
//   accepted,
//   pickedUp,
//   onTheWay,
//   delivered,
//   cancelled,
// }

class DeliveryOrder {
  final String id;
  final String customerName;
  final String customerPhone;
  final String storeName;
  final String storeAddress;
  final String deliveryAddress;
  final double totalAmount;
  final double deliveryFee;
  final List<OrderItem> items;
  final DateTime orderTime;
  final int estimatedDeliveryTime;
  final double distance;
  detalle_orden.OrderStatus status;
  final String paymentMethod;
  final String notes;
  DateTime? acceptedTime;
  DateTime? pickupTime;
  DateTime? deliveryTime;
  String? driverId;
  String? driverName;

  DeliveryOrder({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.storeName,
    required this.storeAddress,
    required this.deliveryAddress,
    required this.totalAmount,
    required this.deliveryFee,
    required this.items,
    required this.orderTime,
    required this.estimatedDeliveryTime,
    required this.distance,
    required this.status,
    required this.paymentMethod,
    required this.notes,
    this.acceptedTime,
    this.pickupTime,
    this.deliveryTime,
    this.driverId,
    this.driverName,
  });

  DeliveryOrder copyWith({
    String? id,
    String? customerName,
    String? customerPhone,
    String? storeName,
    String? storeAddress,
    String? deliveryAddress,
    double? totalAmount,
    double? deliveryFee,
    List<OrderItem>? items,
    DateTime? orderTime,
    int? estimatedDeliveryTime,
    double? distance,
    detalle_orden.OrderStatus? status,
    String? paymentMethod,
    String? notes,
    DateTime? acceptedTime,
    DateTime? pickupTime,
    DateTime? deliveryTime,
    String? driverId,
    String? driverName,
  }) {
    return DeliveryOrder(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      storeName: storeName ?? this.storeName,
      storeAddress: storeAddress ?? this.storeAddress,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      totalAmount: totalAmount ?? this.totalAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      items: items ?? this.items,
      orderTime: orderTime ?? this.orderTime,
      estimatedDeliveryTime:
          estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      distance: distance ?? this.distance,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
      acceptedTime: acceptedTime ?? this.acceptedTime,
      pickupTime: pickupTime ?? this.pickupTime,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
    );
  }
}

class OrderItem {
  final String name;
  final int quantity;

  const OrderItem({required this.name, required this.quantity});
}

class DeliveryDriver {
  final String id;
  final String name;
  final String phone;
  final double rating;
  final String vehicle;
  final String plateNumber;
  final int totalDeliveries;
  final double totalEarnings;
  final DateTime memberSince;

  const DeliveryDriver({
    required this.id,
    required this.name,
    required this.phone,
    required this.rating,
    required this.vehicle,
    required this.plateNumber,
    required this.totalDeliveries,
    required this.totalEarnings,
    required this.memberSince,
  });
}
