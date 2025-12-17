import 'package:flutter/material.dart';

class DeliveryOrderDetailScreen extends StatefulWidget {
  final DeliveryOrder order;
  final bool isFromHistory;

  const DeliveryOrderDetailScreen({
    Key? key,
    required this.order,
    this.isFromHistory = false,
  }) : super(key: key);

  @override
  State<DeliveryOrderDetailScreen> createState() =>
      _DeliveryOrderDetailScreenState();
}

class _DeliveryOrderDetailScreenState extends State<DeliveryOrderDetailScreen> {
  DeliveryOrder? _order;
  bool _isLoading = false;
  String _currentAction = '';
  // final PageController _pageController = PageController();
  // int _currentPage = 0;

  // Datos del repartidor (simulados)
  // final DeliveryDriver _driver = DeliveryDriver(
  //   id: 'DRV-001',
  //   name: 'Carlos Mendoza',
  //   phone: '+504 555-7890',
  //   rating: 4.8,
  //   vehicle: 'Moto Honda CB190',
  //   plateNumber: 'ABC-123',
  // );

  // Datos de contacto del cliente (simulados)
  final Map<String, dynamic> _customerContact = {
    'canCall': true,
    'canMessage': true,
    'prefersCall': false,
  };

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  void _updateOrderStatus(OrderStatus newStatus) {
    if (_order == null || _isLoading) return;

    setState(() {
      _isLoading = true;
      _currentAction = _getActionText(newStatus);
    });

    // Simular llamada a API
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _order = _order!.copyWith(status: newStatus);

        // Actualizar tiempos según el estado
        final now = DateTime.now();
        switch (newStatus) {
          case OrderStatus.accepted:
            _order = _order!.copyWith(acceptedTime: now);
            break;
          case OrderStatus.pickedUp:
            _order = _order!.copyWith(pickupTime: now);
            break;
          case OrderStatus.delivered:
            _order = _order!.copyWith(deliveryTime: now);
            break;
          default:
            break;
        }

        _isLoading = false;
      });

      // Mostrar confirmación
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_getSuccessMessage(newStatus)),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      // Si es entregado, mostrar resumen después de un momento
      if (newStatus == OrderStatus.delivered) {
        Future.delayed(const Duration(seconds: 2), () {
          _showDeliverySummary();
        });
      }
    });
  }

  void _callCustomer() {
    // Lógica para llamar al cliente
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Llamando a ${_order!.customerName}...'),
        backgroundColor: const Color(0xFF05386B),
      ),
    );
  }

  void _messageCustomer() {
    // Navegar a chat
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abriendo chat con el cliente...'),
        backgroundColor: const Color(0xFF05386B),
      ),
    );
  }

  void _showDeliverySummary() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildDeliverySummary(),
    );
  }

  void _viewMapRoute() {
    // Navegar a mapa con la ruta
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mostrando ruta en el mapa...'),
        backgroundColor: const Color(0xFF05386B),
      ),
    );
  }

  void _reportProblem() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Reportar Problema',
          style: TextStyle(
            color: Color(0xFF05386B),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('¿Qué problema encontraste con este pedido?'),
            const SizedBox(height: 16),
            ..._getProblemOptions().map((option) {
              return ListTile(
                leading: const Icon(
                  Icons.report_problem_outlined,
                  color: Color(0xFF05386B),
                ),
                title: Text(option),
                onTap: () {
                  Navigator.pop(context);
                  _submitProblemReport(option);
                },
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
        ],
      ),
    );
  }

  void _submitProblemReport(String problem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Problema reportado: $problem'),
        backgroundColor: const Color(0xFF05386B),
      ),
    );
  }

  String _getActionText(OrderStatus status) {
    switch (status) {
      case OrderStatus.accepted:
        return 'Aceptando pedido...';
      case OrderStatus.pickedUp:
        return 'Marcando como recogido...';
      case OrderStatus.delivered:
        return 'Marcando como entregado...';
      default:
        return 'Procesando...';
    }
  }

  String _getSuccessMessage(OrderStatus status) {
    switch (status) {
      case OrderStatus.accepted:
        return '¡Pedido aceptado! Ve a recogerlo en la tienda.';
      case OrderStatus.pickedUp:
        return '¡Pedido recogido! Ahora ve a entregarlo al cliente.';
      case OrderStatus.delivered:
        return '¡Pedido entregado exitosamente!';
      default:
        return 'Estado actualizado';
    }
  }

  List<String> _getProblemOptions() {
    return [
      'Cliente no contesta',
      'Dirección incorrecta',
      'Producto no disponible',
      'Problema con el pago',
      'Accidente o emergencia',
      'Otro problema',
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_order == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detalles del Pedido'),
          backgroundColor: const Color(0xFF05386B),
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF05386B)),
        ),
      );
    }

    final order = _order!;
    final isCompleted =
        order.status == OrderStatus.delivered ||
        order.status == OrderStatus.cancelled;
    final canTakeAction = !widget.isFromHistory && !isCompleted;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido ${order.id}'),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
        actions: [
          if (canTakeAction)
            IconButton(
              icon: const Icon(Icons.report_problem_outlined),
              onPressed: _reportProblem,
              tooltip: 'Reportar problema',
            ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              // Compartir detalles del pedido
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Timeline del estado del pedido
          // _buildOrderTimeline(),

          // Contenido principal
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Información del pedido
                    _buildOrderInfoCard(),

                    const SizedBox(height: 16),

                    // Información del cliente
                    _buildCustomerCard(),

                    const SizedBox(height: 16),

                    // Items del pedido
                    _buildOrderItemsCard(),

                    const SizedBox(height: 16),

                    // Mapa y direcciones
                    _buildAddressesCard(),

                    const SizedBox(height: 16),

                    // Información de pago
                    _buildPaymentInfoCard(),

                    // Espacio para botones flotantes
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Botones de acción flotantes
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: canTakeAction ? _buildActionButtons() : null,

      // Barra inferior con información adicional
      bottomNavigationBar: _buildBottomInfoBar(),
    );
  }

  // Timeline del estado del pedido
  // Widget _buildOrderTimeline() {
  //   final order = _order!;
  //   final steps = [
  //     _TimelineStep('Asignado', order.orderTime, OrderStatus.assigned),
  //     if (order.acceptedTime != null)
  //       _TimelineStep('Aceptado', order.acceptedTime!, OrderStatus.accepted),
  //     if (order.pickupTime != null)
  //       _TimelineStep('Recogido', order.pickupTime!, OrderStatus.pickedUp),
  //     if (order.deliveryTime != null)
  //       _TimelineStep('Entregado', order.deliveryTime!, OrderStatus.delivered),
  //   ];

  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           'Estado del Pedido',
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.w600,
  //             color: Color(0xFF05386B),
  //           ),
  //         ),
  //         const SizedBox(height: 12),
  //         SizedBox(
  //           height: 60,
  //           child: ListView.builder(
  //             scrollDirection: Axis.horizontal,
  //             itemCount: steps.length,
  //             itemBuilder: (context, index) {
  //               final step = steps[index];
  //               final isActive = _isStepActive(step.status);
  //               final isLast = index == steps.length - 1;

  //               return Row(
  //                 children: [
  //                   _buildTimelineStep(step, isActive),
  //                   if (!isLast)
  //                     Container(
  //                       width: 40,
  //                       height: 2,
  //                       color: isActive
  //                           ? const Color(0xFFFF6B00)
  //                           : Colors.grey[300],
  //                     ),
  //                 ],
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTimelineStep(_TimelineStep step, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFFF6B00) : Colors.grey[300],
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Icon(_getStepIcon(step.status), color: Colors.white, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          step.title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isActive ? const Color(0xFF05386B) : Colors.grey[600],
          ),
        ),
        Text(
          _formatTime(step.time),
          style: TextStyle(fontSize: 10, color: Colors.grey[500]),
        ),
      ],
    );
  }

  bool _isStepActive(OrderStatus status) {
    final order = _order!;
    switch (status) {
      case OrderStatus.assigned:
        return true; // Siempre activo
      case OrderStatus.accepted:
        return order.status.index >= OrderStatus.accepted.index;
      case OrderStatus.pickedUp:
        return order.status.index >= OrderStatus.pickedUp.index;
      case OrderStatus.delivered:
        return order.status == OrderStatus.delivered;
      default:
        return false;
    }
  }

  IconData _getStepIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.assigned:
        return Icons.assignment_outlined;
      case OrderStatus.accepted:
        return Icons.check_circle_outlined;
      case OrderStatus.pickedUp:
        return Icons.shopping_bag_outlined;
      case OrderStatus.delivered:
        return Icons.delivery_dining_outlined;
      default:
        return Icons.help_outline_outlined;
    }
  }

  // Información del pedido
  Widget _buildOrderInfoCard() {
    final order = _order!;

    return Container(
      padding: const EdgeInsets.all(16),
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

          Row(
            children: [
              const Icon(
                Icons.store_outlined,
                color: Color(0xFF05386B),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  order.storeName,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF05386B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(
                Icons.access_time_outlined,
                color: Color(0xFF05386B),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Pedido realizado: ${_formatDateTime(order.orderTime)}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),

          if (order.estimatedDeliveryTime > 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      color: Color(0xFF05386B),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Tiempo estimado: ${order.estimatedDeliveryTime} min',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF05386B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),

          if (order.notes.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const Text(
                  'Notas especiales:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF05386B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  order.notes,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // Información del cliente
  Widget _buildCustomerCard() {
    final order = _order!;

    return Container(
      padding: const EdgeInsets.all(16),
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
          const Text(
            'Información del Cliente',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF05386B),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF05386B),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    order.customerName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.customerName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF05386B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.customerPhone,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              // Botones de contacto
              if (!widget.isFromHistory)
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.message_outlined,
                        color: Color(0xFF05386B),
                      ),
                      onPressed: _customerContact['canMessage']
                          ? _messageCustomer
                          : null,
                      tooltip: 'Enviar mensaje',
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.phone_outlined,
                        color: Color(0xFF05386B),
                      ),
                      onPressed: _customerContact['canCall']
                          ? _callCustomer
                          : null,
                      tooltip: 'Llamar al cliente',
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Preferencias de contacto
          if (_customerContact['prefersCall'] != null)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF05386B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    _customerContact['prefersCall']
                        ? Icons.phone_outlined
                        : Icons.message_outlined,
                    color: const Color(0xFF05386B),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _customerContact['prefersCall']
                        ? 'El cliente prefiere llamadas telefónicas'
                        : 'El cliente prefiere mensajes de texto',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF05386B),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Items del pedido
  Widget _buildOrderItemsCard() {
    final order = _order!;

    return Container(
      padding: const EdgeInsets.all(16),
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
          const Text(
            'Items del Pedido',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF05386B),
            ),
          ),

          const SizedBox(height: 12),

          Column(
            children: order.items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF05386B),
                        ),
                      ),
                    ),

                    Text(
                      'x${item.quantity}',
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
          ),

          const Divider(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total del pedido:',
                style: TextStyle(fontSize: 16, color: Color(0xFF05386B)),
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
    );
  }

  // Direcciones y mapa
  Widget _buildAddressesCard() {
    final order = _order!;
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Container(
      padding: const EdgeInsets.all(16),
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
          const Text(
            'Ruta de Entrega',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF05386B),
            ),
          ),

          const SizedBox(height: 12),

          // Mapa (placeholder)
          GestureDetector(
            onTap: _viewMapRoute,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://via.placeholder.com/600x150/05386B/FFFFFF?text=Mapa+de+Ruta',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Marcadores
                  Align(
                    alignment: const Alignment(-0.8, -0.5),
                    child: _buildMapMarker(
                      Icons.store_outlined,
                      'Tienda',
                      const Color(0xFF05386B),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0.8, 0.5),
                    child: _buildMapMarker(
                      Icons.home_outlined,
                      'Cliente',
                      const Color(0xFFFF6B00),
                    ),
                  ),

                  // Botón para ver ruta completa
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B00),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.directions_outlined,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Ver Ruta',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Direcciones detalladas
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildAddressSection(
                  'Recoger en',
                  order.storeAddress,
                  Icons.store_outlined,
                  const Color(0xFF05386B),
                ),
              ),

              if (isTablet) const SizedBox(width: 16),

              if (!isTablet) const SizedBox(height: 16),

              Expanded(
                child: _buildAddressSection(
                  'Entregar en',
                  order.deliveryAddress,
                  Icons.home_outlined,
                  const Color(0xFFFF6B00),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Distancia y tiempo estimado
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF05386B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildRouteInfo(
                  Icons.directions_outlined,
                  '${order.distance} km',
                  'Distancia',
                ),
                _buildRouteInfo(
                  Icons.timer_outlined,
                  '${order.estimatedDeliveryTime} min',
                  'Tiempo estimado',
                ),
                _buildRouteInfo(
                  Icons.attach_money_outlined,
                  '\$${order.deliveryFee.toStringAsFixed(2)}',
                  'Tarifa',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapMarker(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressSection(
    String title,
    String address,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          address,
          style: const TextStyle(fontSize: 14, color: Color(0xFF05386B)),
        ),
      ],
    );
  }

  Widget _buildRouteInfo(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF05386B), size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF05386B),
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  // Información de pago
  Widget _buildPaymentInfoCard() {
    final order = _order!;

    return Container(
      padding: const EdgeInsets.all(16),
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
          const Text(
            'Información de Pago',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF05386B),
            ),
          ),

          const SizedBox(height: 12),

          _buildPaymentDetail('Método de pago', order.paymentMethod),

          const SizedBox(height: 8),

          _buildPaymentDetail(
            'Total del pedido',
            '\$${order.totalAmount.toStringAsFixed(2)}',
          ),

          const SizedBox(height: 8),

          _buildPaymentDetail(
            'Tarifa de entrega',
            '\$${order.deliveryFee.toStringAsFixed(2)}',
          ),

          const Divider(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total a cobrar:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF05386B),
                ),
              ),
              Text(
                '\$${(order.totalAmount + order.deliveryFee).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF05386B),
                ),
              ),
            ],
          ),

          if (order.paymentMethod == 'Efectivo')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B00).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outlined, color: Color(0xFFFF6B00)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Recuerda llevar cambio para el cliente',
                          style: TextStyle(color: Color(0xFF05386B)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetail(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF05386B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Botones de acción
  Widget _buildActionButtons() {
    final order = _order!;

    Widget actionButton;

    switch (order.status) {
      case OrderStatus.assigned:
        actionButton = _buildActionButton(
          'Aceptar Pedido',
          Icons.check_circle_outlined,
          Colors.white,
          const Color(0xFFFF6B00),
          () => _updateOrderStatus(OrderStatus.accepted),
        );
        break;

      case OrderStatus.accepted:
        actionButton = _buildActionButton(
          'Marcar como Recogido',
          Icons.shopping_bag_outlined,
          Colors.white,
          const Color(0xFF05386B),
          () => _updateOrderStatus(OrderStatus.pickedUp),
        );
        break;

      case OrderStatus.pickedUp:
        actionButton = _buildActionButton(
          'Marcar como Entregado',
          Icons.delivery_dining_outlined,
          Colors.white,
          Colors.green,
          () => _updateOrderStatus(OrderStatus.delivered),
        );
        break;

      default:
        actionButton = const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(children: [Expanded(child: actionButton)]),
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    Color textColor,
    Color backgroundColor,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: _isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
      child: _isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 24),
                const SizedBox(width: 12),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }

  // Barra inferior con información
  Widget _buildBottomInfoBar() {
    final order = _order!;
    // final isCompleted = order.status == OrderStatus.delivered;

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomInfoItem(
            Icons.access_time_outlined,
            '${order.estimatedDeliveryTime} min',
            'Tiempo estimado',
          ),
          _buildBottomInfoItem(
            Icons.directions_outlined,
            '${order.distance} km',
            'Distancia',
          ),
          _buildBottomInfoItem(
            Icons.attach_money_outlined,
            '\$${order.deliveryFee.toStringAsFixed(2)}',
            'Tu ganancia',
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInfoItem(IconData icon, String value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xFF05386B), size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF05386B),
          ),
        ),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      ],
    );
  }

  // Resumen de entrega
  Widget _buildDeliverySummary() {
    final order = _order!;
    final earnings = order.deliveryFee + 2.00; // Tarifa + propina simulada

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
              'Pedido ${order.id} entregado exitosamente',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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
                  'Resumen de Ganancias',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF05386B),
                  ),
                ),
                const SizedBox(height: 16),
                _buildEarningRow('Tarifa de entrega', order.deliveryFee),
                _buildEarningRow('Propina recibida', 2.00),
                const Divider(height: 20),
                _buildEarningRow('Total ganado', earnings, isTotal: true),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Estadísticas del día
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B00).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tu progreso hoy',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF05386B),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDailyStat('5', 'Pedidos'),
                    _buildDailyStat('\$45.25', 'Ganancia'),
                    _buildDailyStat('4.8', 'Rating'),
                  ],
                ),
              ],
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
                    'Ver Detalles',
                    style: TextStyle(color: Color(0xFF05386B)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context); // Volver a la lista
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

  Widget _buildEarningRow(String label, double amount, {bool isTotal = false}) {
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
            '\$${amount.toStringAsFixed(2)}',
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

  Widget _buildDailyStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF05386B),
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  // Métodos de ayuda
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} - ${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.assigned:
        return 'Asignado';
      case OrderStatus.accepted:
        return 'Aceptado';
      case OrderStatus.pickedUp:
        return 'Recogido';
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
      case OrderStatus.assigned:
        return Colors.blue;
      case OrderStatus.accepted:
        return Colors.orange;
      case OrderStatus.pickedUp:
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

// Clases de apoyo
class _TimelineStep {
  final String title;
  final DateTime time;
  final OrderStatus status;

  _TimelineStep(this.title, this.time, this.status);
}

// Modelos de datos (de la pantalla anterior)
enum OrderStatus {
  assigned,
  accepted,
  pickedUp,
  onTheWay,
  delivered,
  cancelled,
}

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
  OrderStatus status;
  final String paymentMethod;
  final String notes;
  DateTime? acceptedTime;
  DateTime? pickupTime;
  DateTime? deliveryTime;

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
    OrderStatus? status,
    String? paymentMethod,
    String? notes,
    DateTime? acceptedTime,
    DateTime? pickupTime,
    DateTime? deliveryTime,
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

  const DeliveryDriver({
    required this.id,
    required this.name,
    required this.phone,
    required this.rating,
    required this.vehicle,
    required this.plateNumber,
  });
}
