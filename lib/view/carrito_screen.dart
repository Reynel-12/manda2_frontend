import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final double _deliveryFee = 1.50; // Tarifa fija de envío
  String _selectedAddress = 'Barrio Los Pinos, Casa #45';
  final List<CartItem> _cartItems = [
    CartItem(
      product: Product(
        id: 1,
        name: 'Leche Entera 1L',
        price: 2.50,
        storeName: 'Pulpería "El Buen Precio"',
        category: 'Lácteos',
        unit: 'litro',
      ),
      quantity: 2,
    ),
    CartItem(
      product: Product(
        id: 2,
        name: 'Pan Integral',
        price: 1.75,
        storeName: 'Pulpería "El Buen Precio"',
        category: 'Panadería',
        unit: 'bolsa',
      ),
      quantity: 1,
    ),
    CartItem(
      product: Product(
        id: 3,
        name: 'Huevos Blancos x12',
        price: 3.20,
        storeName: 'Supermercado Central',
        category: 'Lácteos',
        unit: 'docena',
      ),
      quantity: 1,
    ),
    CartItem(
      product: Product(
        id: 4,
        name: 'Arroz 5kg',
        price: 8.90,
        storeName: 'Pulpería "El Buen Precio"',
        category: 'Granos',
        unit: 'bolsa',
      ),
      quantity: 1,
    ),
  ];

  // Direcciones disponibles
  final List<String> _addresses = [
    'Barrio Los Pinos, Casa #45',
    'Colonia San José, Apartamento 302',
    'Residencial Las Flores, Casa #12',
    'Urbanización Bella Vista, Local #5',
  ];

  double get _subtotal {
    return _cartItems.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  double get _total {
    return _subtotal + _deliveryFee;
  }

  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      if (newQuantity > 0) {
        _cartItems[index] = _cartItems[index].copyWith(quantity: newQuantity);
      } else {
        _removeItem(index);
      }
    });
  }

  void _removeItem(int index) {
    final removedItem = _cartItems[index];

    setState(() {
      _cartItems.removeAt(index);
    });

    // Mostrar opción para deshacer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${removedItem.product.name} removido del carrito'),
        backgroundColor: const Color(0xFF05386B),
        action: SnackBarAction(
          label: 'Deshacer',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _cartItems.insert(index, removedItem);
            });
          },
        ),
      ),
    );
  }

  void _clearCart() {
    if (_cartItems.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Vaciar carrito',
          style: TextStyle(
            color: Color(0xFF05386B),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          '¿Estás seguro de que quieres vaciar todo el carrito?',
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
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _cartItems.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Carrito vaciado'),
                  backgroundColor: Color(0xFF05386B),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B00),
            ),
            child: const Text('Vaciar'),
          ),
        ],
      ),
    );
  }

  void _proceedToCheckout() {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El carrito está vacío'),
          backgroundColor: Color(0xFF05386B),
        ),
      );
      return;
    }

    // Navegar al checkout
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(
          cartItems: _cartItems,
          subtotal: _subtotal,
          deliveryFee: _deliveryFee,
          total: _total,
          deliveryAddress: _selectedAddress,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de Compras'),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline_outlined),
              onPressed: _clearCart,
              tooltip: 'Vaciar carrito',
            ),
        ],
      ),
      body: _cartItems.isEmpty ? _buildEmptyCart() : _buildCartContent(),
    );
  }

  // Carrito vacío
  Widget _buildEmptyCart() {
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
                Icons.shopping_cart_outlined,
                size: 60,
                color: Color(0xFF05386B),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Tu carrito está vacío',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF05386B),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Agrega productos para comenzar a comprar',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                // textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Regresar al home
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
                'Comenzar a Comprar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Contenido del carrito
  Widget _buildCartContent() {
    return Column(
      children: [
        // Lista de productos
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _cartItems.length,
            itemBuilder: (context, index) {
              return _buildCartItem(_cartItems[index], index);
            },
          ),
        ),

        // Resumen y checkout
        _buildOrderSummary(),
      ],
    );
  }

  // Item del carrito
  Widget _buildCartItem(CartItem item, int index) {
    final product = item.product;

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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen del producto
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(width: 16),

                // Información del producto
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre y tienda
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF05386B),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      Text(
                        product.storeName,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Precio y cantidad
                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${(product.price * item.quantity).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF05386B),
                            ),
                          ),

                          // Selector de cantidad
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                // Botón disminuir
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 18),
                                  onPressed: () =>
                                      _updateQuantity(index, item.quantity - 1),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                    minWidth: 36,
                                    minHeight: 36,
                                  ),
                                ),

                                // Cantidad
                                SizedBox(
                                  width: 30,
                                  child: Center(
                                    child: Text(
                                      item.quantity.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF05386B),
                                      ),
                                    ),
                                  ),
                                ),

                                // Botón aumentar
                                IconButton(
                                  icon: const Icon(Icons.add, size: 18),
                                  onPressed: () =>
                                      _updateQuantity(index, item.quantity + 1),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                    minWidth: 36,
                                    minHeight: 36,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Precio unitario
                      Text(
                        '\$${product.price.toStringAsFixed(2)} c/u • ${product.unit}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Acciones del item
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border_outlined, size: 20),
                  onPressed: () {
                    // Agregar a favoritos
                  },
                  color: const Color(0xFF05386B),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: () => _removeItem(index),
                  color: const Color(0xFFFF6B00),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Resumen del pedido
  Widget _buildOrderSummary() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            const Text(
              'Resumen del Pedido',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF05386B),
              ),
            ),

            const SizedBox(height: 16),

            // Dirección de entrega
            _buildDeliveryAddress(),

            const SizedBox(height: 20),

            // Desglose de precios
            _buildPriceBreakdown(),

            const SizedBox(height: 20),

            // Total
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!, width: 1),
                  bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF05386B),
                    ),
                  ),
                  Text(
                    '\$${_total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF05386B),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Botón de confirmar
            ElevatedButton(
              onPressed: _proceedToCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B00),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_checkout_outlined, size: 22),
                  SizedBox(width: 10),
                  Text(
                    'Confirmar Pedido',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Texto informativo
            Text(
              'Al confirmar, aceptas nuestros Términos y Condiciones',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                // textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dirección de entrega
  Widget _buildDeliveryAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              color: Color(0xFF05386B),
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Dirección de entrega',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF05386B),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                _showAddressSelector();
              },
              child: const Text(
                'Cambiar',
                style: TextStyle(
                  color: Color(0xFFFF6B00),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.home_outlined,
                color: Color(0xFF05386B),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _selectedAddress,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF05386B),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Entrega estimada: 20-30 minutos',
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
      ],
    );
  }

  // Desglose de precios
  Widget _buildPriceBreakdown() {
    return Column(
      children: [
        // Subtotal
        _buildPriceRow(
          'Subtotal (${_cartItems.length} ${_cartItems.length == 1 ? 'artículo' : 'artículos'})',
          '\$${_subtotal.toStringAsFixed(2)}',
        ),

        const SizedBox(height: 8),

        // Tarifa de envío
        _buildPriceRow(
          'Tarifa de envío',
          '\$${_deliveryFee.toStringAsFixed(2)}',
        ),

        const SizedBox(height: 8),

        // Descuento (si aplica)
        if (_subtotal > 20)
          _buildPriceRow(
            'Descuento (compra > \$20)',
            '-\$2.00',
            isDiscount: true,
          ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 15, color: Colors.grey[700])),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            color: isDiscount ? Colors.green[700] : const Color(0xFF05386B),
            fontWeight: isDiscount ? FontWeight.normal : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // Selector de dirección
  void _showAddressSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildAddressSelector(),
    );
  }

  Widget _buildAddressSelector() {
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

          const Text(
            'Seleccionar dirección',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF05386B),
            ),
          ),

          const SizedBox(height: 16),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _addresses.length,
            itemBuilder: (context, index) {
              final address = _addresses[index];
              final isSelected = address == _selectedAddress;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF05386B).withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF05386B)
                        : Colors.grey[300]!,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedAddress = address;
                      });
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: isSelected
                                ? const Color(0xFF05386B)
                                : Colors.grey[400],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dirección ${index + 1}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  address,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF05386B),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (index == 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6B00).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Predeterminada',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFFF6B00),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Botón para agregar nueva dirección
          OutlinedButton(
            onPressed: () {
              // Navegar a agregar nueva dirección
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF05386B), width: 1.5),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Color(0xFF05386B)),
                SizedBox(width: 8),
                Text(
                  'Agregar nueva dirección',
                  style: TextStyle(
                    color: Color(0xFF05386B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}

// Pantalla de Checkout (simplificada)
class CheckoutScreen extends StatelessWidget {
  final List<CartItem> cartItems;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String deliveryAddress;

  const CheckoutScreen({
    Key? key,
    required this.cartItems,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.deliveryAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar Pedido'),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen
            Container(
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
                    'Resumen del pedido',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF05386B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCheckoutRow('Subtotal', subtotal),
                  _buildCheckoutRow('Envío', deliveryFee),
                  const Divider(height: 30),
                  _buildCheckoutRow('Total', total, isTotal: true),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Dirección
            Container(
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
                  const Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Color(0xFF05386B),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Dirección de entrega',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF05386B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    deliveryAddress,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF05386B),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Botón de confirmación final
            ElevatedButton(
              onPressed: () {
                // Procesar pedido
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('¡Pedido confirmado con éxito!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 3),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B00),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Confirmar y Pagar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutRow(String label, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              color: isTotal ? const Color(0xFF05386B) : Colors.grey[700],
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 24 : 16,
              color: const Color(0xFF05386B),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// Modelos de datos actualizados
class CartItem {
  final Product product;
  final int quantity;

  const CartItem({required this.product, required this.quantity});

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

class Product {
  final int id;
  final String name;
  final double price;
  final String storeName;
  final String category;
  final String unit;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.storeName,
    required this.category,
    required this.unit,
  });
}
