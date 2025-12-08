import 'package:flutter/material.dart';

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

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  OrderStatus _currentStatus = OrderStatus.onTheWay;
  DeliveryPerson? _deliveryPerson;
  List<OrderStatus> _statusHistory = [];
  bool _isChatVisible = false;
  // final List<ChatMessage> _chatMessages = [];
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();

  // Estados de ejemplo para simulación
  final Map<OrderStatus, String> statusMessages = {
    OrderStatus.pending: 'Tu pedido ha sido recibido',
    OrderStatus.accepted: 'La tienda está preparando tu pedido',
    OrderStatus.onTheWay: 'Tu pedido está en camino',
    OrderStatus.delivered: '¡Pedido entregado!',
  };

  final Map<OrderStatus, IconData> statusIcons = {
    OrderStatus.pending: Icons.access_time_outlined,
    OrderStatus.accepted: Icons.restaurant_outlined,
    OrderStatus.onTheWay: Icons.delivery_dining_outlined,
    OrderStatus.delivered: Icons.check_circle_outlined,
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
    _simulateOrderUpdates();
  }

  @override
  void dispose() {
    _chatController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  void _initializeData() {
    // Datos de ejemplo
    _deliveryPerson = DeliveryPerson(
      name: 'Carlos Mendoza',
      phone: '555-7890',
      rating: 4.8,
      vehicle: 'Moto roja',
      plateNumber: 'ABC-123',
    );

    // Historial de estados
    _statusHistory = [
      OrderStatus.pending,
      OrderStatus.accepted,
      OrderStatus.onTheWay,
    ];

    // Mensajes de chat de ejemplo
    // _chatMessages.addAll([
    //   ChatMessage(
    //     sender: 'Repartidor',
    //     message: 'Hola, soy Carlos. Estoy en camino con tu pedido',
    //     time: '14:30',
    //     isFromUser: false,
    //   ),
    //   ChatMessage(
    //     sender: 'Tú',
    //     message: 'Perfecto, gracias. ¿A qué hora llegarás aproximadamente?',
    //     time: '14:32',
    //     isFromUser: true,
    //   ),
    //   ChatMessage(
    //     sender: 'Repartidor',
    //     message: 'En unos 15 minutos máximo. ¿Necesitas que compre algo más?',
    //     time: '14:33',
    //     isFromUser: false,
    //   ),
    // ]);
  }

  void _simulateOrderUpdates() {
    // Simular actualizaciones del estado cada 30 segundos
    Future.delayed(const Duration(seconds: 30), () {
      if (_currentStatus != OrderStatus.delivered) {
        setState(() {
          if (_currentStatus == OrderStatus.onTheWay) {
            _currentStatus = OrderStatus.delivered;
            _statusHistory.add(OrderStatus.delivered);

            // Agregar mensaje automático
            // _chatMessages.add(
            //   ChatMessage(
            //     sender: 'Sistema',
            //     message: '¡Pedido entregado con éxito!',
            //     time: 'Ahora',
            //     isFromUser: false,
            //     isSystem: true,
            //   ),
            // );

            _scrollToBottom();
          }
        });
      }
    });
  }

  void _toggleChat() {
    setState(() {
      _isChatVisible = !_isChatVisible;
      if (_isChatVisible) {
        _scrollToBottom();
      }
    });
  }

  // void _sendMessage() {
  //   if (_chatController.text.trim().isEmpty) return;

  //   final message = ChatMessage(
  //     sender: 'Tú',
  //     message: _chatController.text,
  //     time: 'Ahora',
  //     isFromUser: true,
  //   );

  //   setState(() {
  //     _chatMessages.add(message);
  //     _chatController.clear();
  //   });

  //   _scrollToBottom();

  //   // Simular respuesta automática
  //   Future.delayed(const Duration(seconds: 2), () {
  //     setState(() {
  //       _chatMessages.add(
  //         ChatMessage(
  //           sender: 'Repartidor',
  //           message: 'Recibido. En camino con tu pedido.',
  //           time: 'Ahora',
  //           isFromUser: false,
  //         ),
  //       );
  //     });
  //     _scrollToBottom();
  //   });
  // }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _callDeliveryPerson() {
    // Lógica para llamar al repartidor
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Llamando a ${_deliveryPerson!.name}...'),
        backgroundColor: const Color(0xFF05386B),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seguimiento del Pedido'),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.help_outline_outlined,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              // Ayuda
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Resumen del pedido
            _buildOrderSummary(),

            // Estado actual
            _buildCurrentStatus(),

            // Timeline de estados
            _buildStatusTimeline(),

            // Repartidor
            if (_deliveryPerson != null) _buildDeliveryPersonInfo(),

            // Mapa de ubicación (placeholder)
            _buildLocationMap(),

            // Chat opcional
            if (_isChatVisible) _buildChatSection(),

            // Espacio para el botón flotante
            const SizedBox(height: 80),
          ],
        ),
      ),

      // Botón flotante para chat
      // floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Barra inferior
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Resumen del pedido
  Widget _buildOrderSummary() {
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
                      color: Color(0xFF05386B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.storeName,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColors[_currentStatus]!.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getStatusText(_currentStatus),
                  style: TextStyle(
                    color: statusColors[_currentStatus],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Divider(),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 16, color: Color(0xFF05386B)),
              ),
              Text(
                '\$${widget.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF05386B),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Estimado de entrega',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              Text(
                '20-30 min',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Estado actual destacado
  Widget _buildCurrentStatus() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: statusColors[_currentStatus]!.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColors[_currentStatus]!.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            statusIcons[_currentStatus],
            color: statusColors[_currentStatus],
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getStatusText(_currentStatus),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: statusColors[_currentStatus],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusMessages[_currentStatus]!,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          if (_currentStatus == OrderStatus.delivered)
            const Icon(Icons.verified_outlined, color: Colors.green, size: 32),
        ],
      ),
    );
  }

  // Timeline de estados
  Widget _buildStatusTimeline() {
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
            'Progreso del pedido',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF05386B),
            ),
          ),

          const SizedBox(height: 20),

          // Timeline
          Column(
            children: OrderStatus.values.map((status) {
              final isCompleted = _statusHistory.contains(status);
              final isCurrent = _currentStatus == status;

              return _buildTimelineStep(
                status: status,
                isCompleted: isCompleted,
                isCurrent: isCurrent,
                isLast: status == OrderStatus.values.last,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required OrderStatus status,
    required bool isCompleted,
    required bool isCurrent,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Línea vertical
        Column(
          children: [
            // Punto superior
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted || isCurrent
                    ? statusColors[status]!
                    : Colors.grey[300],
                border: isCurrent
                    ? Border.all(color: statusColors[status]!, width: 3)
                    : null,
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),

            // Línea
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: isCompleted ? statusColors[status]! : Colors.grey[300],
              ),
          ],
        ),

        const SizedBox(width: 16),

        // Contenido
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getStatusText(status),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isCurrent || isCompleted
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isCurrent || isCompleted
                        ? const Color(0xFF05386B)
                        : Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  statusMessages[status]!,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),

                if (isCurrent) ...[
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _getProgressValue(status),
                    backgroundColor: Colors.grey[200],
                    color: statusColors[status],
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],

                if (isCurrent && _currentStatus == OrderStatus.onTheWay) ...[
                  const SizedBox(height: 8),
                  Text(
                    'El repartidor está en camino a tu ubicación',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Hora estimada
        if (isCurrent)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColors[status]!.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getEstimatedTime(status),
              style: TextStyle(
                fontSize: 12,
                color: statusColors[status],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  // Información del repartidor
  Widget _buildDeliveryPersonInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              const Text(
                'Tu repartidor',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF05386B),
                ),
              ),
              // Row(
              //   children: [
              //     const Icon(Icons.star, color: Colors.amber, size: 16),
              //     const SizedBox(width: 4),
              //     Text(
              //       _deliveryPerson!.rating.toString(),
              //       style: const TextStyle(
              //         fontWeight: FontWeight.w600,
              //         color: Color(0xFF05386B),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              // Avatar del repartidor
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF05386B),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: 30,
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
                      _deliveryPerson!.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF05386B),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      _deliveryPerson!.vehicle,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),

                    Text(
                      _deliveryPerson!.plateNumber,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),

              // Botones de acción
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.phone_outlined, size: 24),
                    onPressed: _callDeliveryPerson,
                    color: const Color(0xFF05386B),
                  ),
                  const Text(
                    'Llamar',
                    style: TextStyle(fontSize: 12, color: Color(0xFF05386B)),
                  ),
                ],
              ),
            ],
          ),

          // Tiempo estimado
          if (_currentStatus == OrderStatus.onTheWay) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B00).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer_outlined, color: Color(0xFFFF6B00)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Llegada estimada',
                          style: TextStyle(
                            color: Color(0xFF05386B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '10-15 minutos',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '2.5 km',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Mapa de ubicación (placeholder)
  Widget _buildLocationMap() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage(
            'https://via.placeholder.com/400x200/05386B/FFFFFF?text=Mapa+de+Ubicación',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Marcadores
          Align(
            alignment: const Alignment(0.3, -0.3),
            child: _buildMapMarker(
              Icons.store_outlined,
              'Tienda',
              const Color(0xFF05386B),
            ),
          ),

          Align(
            alignment: const Alignment(-0.3, 0.4),
            child: _buildMapMarker(
              Icons.location_on_outlined,
              'Tú',
              const Color(0xFFFF6B00),
            ),
          ),

          if (_currentStatus == OrderStatus.onTheWay)
            Align(
              alignment: const Alignment(0, 0),
              child: _buildMapMarker(
                Icons.delivery_dining_outlined,
                'En camino',
                Colors.green,
              ),
            ),

          // Leyenda
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Seguimiento en tiempo real',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
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

  // Sección de chat
  Widget _buildChatSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          // Header del chat
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF05386B),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.chat_outlined, color: Colors.white),
                const SizedBox(width: 12),
                const Text(
                  'Chat con el repartidor',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 20),
                  onPressed: _toggleChat,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Mensajes
          // Container(
          //   height: 300,
          //   padding: const EdgeInsets.all(12),
          //   child: ListView.builder(
          //     controller: _chatScrollController,
          //     itemCount: _chatMessages.length,
          //     itemBuilder: (context, index) {
          //       return _buildChatMessage(_chatMessages[index]);
          //     },
          //   ),
          // ),

          // Input de mensaje
          // Container(
          //   padding: const EdgeInsets.all(12),
          //   decoration: BoxDecoration(
          //     border: Border(top: BorderSide(color: Colors.grey[300]!)),
          //   ),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: TextField(
          //           controller: _chatController,
          //           decoration: InputDecoration(
          //             hintText: 'Escribe un mensaje...',
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(20),
          //               borderSide: BorderSide(color: Colors.grey[300]!),
          //             ),
          //             contentPadding: const EdgeInsets.symmetric(
          //               horizontal: 16,
          //               vertical: 12,
          //             ),
          //           ),
          //           onSubmitted: (_) => _sendMessage(),
          //         ),
          //       ),
          //       const SizedBox(width: 8),
          //       CircleAvatar(
          //         backgroundColor: const Color(0xFFFF6B00),
          //         child: IconButton(
          //           icon: const Icon(Icons.send, color: Colors.white),
          //           onPressed: _sendMessage,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  // Widget _buildChatMessage(ChatMessage message) {
  //   final isUser = message.isFromUser;
  //   final isSystem = message.isSystem;

  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 12),
  //     child: Column(
  //       crossAxisAlignment: isUser
  //           ? CrossAxisAlignment.end
  //           : CrossAxisAlignment.start,
  //       children: [
  //         if (!isSystem)
  //           Text(
  //             message.sender,
  //             style: TextStyle(fontSize: 12, color: Colors.grey[600]),
  //           ),
  //         const SizedBox(height: 4),
  //         Container(
  //           constraints: BoxConstraints(
  //             maxWidth: MediaQuery.of(context).size.width * 0.7,
  //           ),
  //           padding: const EdgeInsets.all(12),
  //           decoration: BoxDecoration(
  //             color: isSystem
  //                 ? Colors.grey[100]
  //                 : isUser
  //                 ? const Color(0xFF05386B)
  //                 : const Color(0xFF05386B).withOpacity(0.1),
  //             borderRadius: BorderRadius.circular(16),
  //           ),
  //           child: Text(
  //             message.message,
  //             style: TextStyle(
  //               color: isSystem
  //                   ? Colors.grey[700]
  //                   : isUser
  //                   ? Colors.white
  //                   : const Color(0xFF05386B),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(height: 4),
  //         Text(
  //           message.time,
  //           style: TextStyle(fontSize: 10, color: Colors.grey[500]),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Botón flotante para chat
  // Widget _buildFloatingActionButton() {
  //   if (_isChatVisible) return const SizedBox();

  //   return FloatingActionButton.extended(
  //     onPressed: _toggleChat,
  //     backgroundColor: const Color(0xFFFF6B00),
  //     foregroundColor: Colors.white,
  //     icon: const Icon(Icons.chat_outlined),
  //     label: const Text('Abrir Chat'),
  //   );
  // }

  // Barra de navegación inferior
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
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: _currentStatus == OrderStatus.delivered
              ? SizedBox.shrink()
              // ElevatedButton(
              //     onPressed: () {
              //       // Calificar el servicio
              //       _showRatingDialog();
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: const Color(0xFFFF6B00),
              //       foregroundColor: Colors.white,
              //       minimumSize: const Size(double.infinity, 56),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //     ),
              //     child: const Text(
              //       'Calificar el Servicio',
              //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              //     ),
              //   )
              : Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Ver detalles del pedido
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF05386B)),
                          minimumSize: const Size(0, 56),
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
                        onPressed: _callDeliveryPerson,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF05386B),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(0, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone_outlined, size: 20),
                            SizedBox(width: 8),
                            Text('Llamar'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Califica tu experiencia',
          style: TextStyle(
            color: Color(0xFF05386B),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('¿Cómo calificarías el servicio?'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Icon(
                  Icons.star,
                  color: index < 4 ? Colors.amber : Colors.grey[300],
                  size: 32,
                );
              }),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡Gracias por tu calificación!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B00),
            ),
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  // Métodos de ayuda
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
    }
  }

  String _getEstimatedTime(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return '5 min';
      case OrderStatus.accepted:
        return '15 min';
      case OrderStatus.onTheWay:
        return '10 min';
      case OrderStatus.delivered:
        return 'Ahora';
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

// class ChatMessage {
//   final String sender;
//   final String message;
//   final String time;
//   final bool isFromUser;
//   final bool isSystem;

//   const ChatMessage({
//     required this.sender,
//     required this.message,
//     required this.time,
//     this.isFromUser = false,
//     this.isSystem = false,
//   });
// }

// Ejemplo de navegación
// void navigateToOrderTracking(BuildContext context) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => const OrderTrackingScreen(
//         orderId: 'ORD-2024-001',
//         storeName: 'Pulpería "El Buen Precio"',
//         totalAmount: 18.35,
//       ),
//     ),
//   );
// }
