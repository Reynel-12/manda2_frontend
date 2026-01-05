import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart'; // Agrega: confetti: ^0.7.0 en pubspec.yaml

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;
  final String storeName;
  final double totalAmount;

  const OrderTrackingScreen({
    super.key,
    required this.orderId,
    required this.storeName,
    required this.totalAmount,
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen>
    with TickerProviderStateMixin {
  final OrderStatus _currentStatus = OrderStatus.onTheWay;
  DeliveryPerson? _deliveryPerson;
  List<OrderStatus> _statusHistory = [];

  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  late ConfettiController _confettiController;

  final Map<OrderStatus, String> statusMessages = {
    OrderStatus.pending: 'Tu pedido ha sido recibido',
    OrderStatus.accepted: 'La tienda está preparando tu pedido',
    OrderStatus.onTheWay: 'Tu pedido está en camino',
    OrderStatus.delivered: '¡Pedido entregado con éxito!',
  };

  final Map<OrderStatus, IconData> statusIcons = {
    OrderStatus.pending: Icons.access_time,
    OrderStatus.accepted: Icons.kitchen,
    OrderStatus.onTheWay: Icons.delivery_dining,
    OrderStatus.delivered: Icons.check_circle,
  };

  final Map<OrderStatus, Color> statusColors = {
    OrderStatus.pending: Colors.orange,
    OrderStatus.accepted: Colors.blue,
    OrderStatus.onTheWay: const Color(0xFFFF6B00),
    OrderStatus.delivered: Colors.green,
  };

  @override
  void initState() {
    super.initState();
    _initializeData();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _progressAnimation =
        Tween<double>(
          begin: 0.0,
          end: _getProgressValue(_currentStatus),
        ).animate(
          CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
        );
    _progressController.forward();

    if (_currentStatus == OrderStatus.delivered) _confettiController.play();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _initializeData() {
    _deliveryPerson = DeliveryPerson(
      name: 'Carlos Mendoza',
      phone: '555-7890',
      rating: 4.8,
      vehicle: 'Moto roja',
      plateNumber: 'ABC-123',
    );
    _statusHistory = [
      OrderStatus.pending,
      OrderStatus.accepted,
      OrderStatus.onTheWay,
    ];
    if (_currentStatus == OrderStatus.delivered) {
      _statusHistory.add(OrderStatus.delivered);
    }
  }

  double _getProgressValue(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 0.25;
      case OrderStatus.accepted:
        return 0.5;
      case OrderStatus.onTheWay:
        return 0.75;
      case OrderStatus.delivered:
        return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final isDesktop = MediaQuery.of(context).size.width >= 1200;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Seguimiento del Pedido'),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.help_outline), onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 64 : 24,
                    vertical: 24,
                  ),
                  child: isDesktop || isTablet
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: _buildTimelineAndInfo()),
                            const SizedBox(width: 32),
                            Expanded(flex: 3, child: _buildMapSection()),
                          ],
                        )
                      : Column(
                          children: [
                            _buildCurrentStatusCard(),
                            const SizedBox(height: 24),
                            _buildTimelineAndInfo(),
                            const SizedBox(height: 24),
                            _buildMapSection(),
                            const SizedBox(height: 100),
                          ],
                        ),
                ),
              ),
            ],
          ),
          if (_currentStatus == OrderStatus.delivered)
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                emissionFrequency: 0.05,
                numberOfParticles: 50,
                gravity: 0.2,
              ),
            ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(isTablet || isDesktop),
    );
  }

  Widget _buildCurrentStatusCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (statusColors[_currentStatus] ?? Colors.orange).withOpacity(0.2),
            (statusColors[_currentStatus] ?? Colors.orange).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: (statusColors[_currentStatus] ?? Colors.orange).withOpacity(
            0.3,
          ),
        ),
      ),
      child: Row(
        children: [
          AnimatedScale(
            scale: _currentStatus == OrderStatus.delivered ? 1.2 : 1.0,
            duration: const Duration(milliseconds: 500),
            child: Icon(
              statusIcons[_currentStatus] ?? Icons.help_outline,
              size: 48,
              color: statusColors[_currentStatus] ?? Colors.orange,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getStatusText(_currentStatus),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: statusColors[_currentStatus] ?? Colors.orange,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  statusMessages[_currentStatus] ?? '',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(height: 12),
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (_, __) => LinearProgressIndicator(
                    value: _progressAnimation.value,
                    backgroundColor: Colors.grey[300],
                    color: statusColors[_currentStatus] ?? Colors.orange,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineAndInfo() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pedido #${widget.orderId}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.storeName,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    Text(
                      '\$${widget.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF05386B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Progreso del pedido',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF05386B),
                  ),
                ),
                const SizedBox(height: 20),
                ...OrderStatus.values.map(
                  (status) => _buildTimelineRow(status),
                ),
              ],
            ),
          ),
        ),
        if (_deliveryPerson != null) ...[
          const SizedBox(height: 24),
          _buildDeliveryPersonCard(),
        ],
      ],
    );
  }

  Widget _buildTimelineRow(OrderStatus status) {
    final isCompleted = _statusHistory.contains(status);
    final isCurrent = _currentStatus == status;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                      ? (statusColors[status] ?? Colors.grey)
                      : Colors.grey[300],
                  border: isCurrent
                      ? Border.all(
                          color: statusColors[status] ?? Colors.blue,
                          width: 4,
                        )
                      : null,
                ),
                child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : null,
              ),
              if (status != OrderStatus.delivered)
                Container(
                  width: 2,
                  height: 60,
                  color: isCompleted
                      ? (statusColors[status] ?? Colors.grey)
                      : Colors.grey[300],
                ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getStatusText(status),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isCurrent ? statusColors[status] : Colors.grey[600],
                  ),
                ),
                Text(
                  statusMessages[status] ?? '',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryPersonCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: const Color(0xFF05386B),
              child: const Icon(Icons.person, color: Colors.white, size: 36),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _deliveryPerson?.name ?? 'Repartidor',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Rating: ${_deliveryPerson?.rating ?? 0.0} ⭐',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    '${_deliveryPerson?.vehicle ?? ''} • ${_deliveryPerson?.plateNumber ?? ''}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.phone),
                label: const Text('Llamar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF05386B),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 400,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  'https://via.placeholder.com/800x400/05386B/FFFFFF?text=Mapa+en+Tiempo+Real',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.map, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Seguimiento en vivo',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              // Markers animados
              if (_currentStatus == OrderStatus.onTheWay)
                Center(
                  child: AnimatedScale(
                    scale: 1.2,
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    child: const Icon(
                      Icons.delivery_dining,
                      size: 60,
                      color: Colors.green,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(bool isWide) {
    if (_currentStatus == OrderStatus.delivered) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 20),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.star),
          label: const Text(
            'Calificar el Servicio',
            style: TextStyle(fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B00),
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 20),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.receipt),
              label: const Text('Ver Detalles'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.phone),
              label: const Text('Llamar al Repartidor'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF05386B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pendiente';
      case OrderStatus.accepted:
        return 'Preparando';
      case OrderStatus.onTheWay:
        return 'En Camino';
      case OrderStatus.delivered:
        return 'Entregado';
    }
  }
}

// Enums y modelos de datos
enum OrderStatus { pending, accepted, onTheWay, delivered }

class DeliveryPerson {
  final String name;
  final String phone;
  final double rating;
  final String vehicle;
  final String plateNumber;

  const DeliveryPerson({
    required this.name,
    required this.phone,
    required this.rating,
    required this.vehicle,
    required this.plateNumber,
  });
}
