import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  final double _deliveryFee = 1.50;
  String _selectedAddress = 'Barrio Los Pinos, Casa #45';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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

  final List<String> _addresses = [
    'Barrio Los Pinos, Casa #45',
    'Colonia San José, Apartamento 302',
    'Residencial Las Flores, Casa #12',
    'Urbanización Bella Vista, Local #5',
  ];

  double get _subtotal => _cartItems.fold(
    0.0,
    (sum, item) => sum + (item.product.price * item.quantity),
  );
  double get _total => _subtotal + _deliveryFee;

  @override
  void initState() {
    super.initState();
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

  void _updateQuantity(int index, int delta) {
    setState(() {
      final newQty = _cartItems[index].quantity + delta;
      if (newQty > 0) {
        _cartItems[index] = _cartItems[index].copyWith(quantity: newQty);
      } else {
        _removeItem(index);
      }
    });
  }

  void _removeItem(int index) {
    final removed = _cartItems[index];
    setState(() => _cartItems.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${removed.product.name} eliminado'),
        backgroundColor: const Color(0xFF05386B),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () => setState(() => _cartItems.insert(index, removed)),
        ),
      ),
    );
  }

  void _proceedToCheckout() {
    if (_cartItems.isEmpty) return;
    // Navegar al checkout (puedes descomentar)
    // Navigator.push(context, MaterialPageRoute(builder: (_) => CheckoutScreen(...)));
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final isDesktop = MediaQuery.of(context).size.width >= 1200;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Carrito'),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => setState(() => _cartItems.clear()),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: _cartItems.isEmpty
          ? _buildEmptyState()
          : FadeTransition(
              opacity: _fadeAnimation,
              child: isDesktop || isTablet
                  ? Row(
                      children: [
                        Expanded(flex: 3, child: _buildCartItemsList()),
                        Expanded(flex: 2, child: _buildStickySummary()),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(child: _buildCartItemsList()),
                        _buildMobileSummary(),
                      ],
                    ),
            ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
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
                Icons.shopping_cart_outlined,
                size: 80,
                color: Color(0xFF05386B),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Tu carrito está vacío',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: const Color(0xFF05386B),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Explora tiendas y agrega productos deliciosos',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.store),
              label: const Text('Ir a Comprar', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B00),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItemsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _cartItems.length,
      itemBuilder: (context, index) {
        final item = _cartItems[index];
        return Dismissible(
          key: Key('cart_${item.product.id}'),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 32),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) => _removeItem(index),
          child: AnimatedScale(
            scale: 1.0,
            duration: Duration(milliseconds: 600 + index * 100),
            curve: Curves.easeOutBack,
            child: _buildCartItemCard(item, index),
          ),
        );
      },
    );
  }

  Widget _buildCartItemCard(CartItem item, int index) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.image_outlined,
                size: 40,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF05386B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.product.storeName,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${item.product.price.toStringAsFixed(2)} c/u • ${item.product.unit}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    IconButton.filledTonal(
                      onPressed: () => _updateQuantity(index, -1),
                      icon: const Icon(Icons.remove),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: () => _updateQuantity(index, 1),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                Text(
                  '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
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
      ),
    );
  }

  Widget _buildStickySummary() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 20),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen del pedido',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF05386B),
            ),
          ),
          const SizedBox(height: 24),
          _buildAddressSection(),
          const SizedBox(height: 24),
          _buildPriceLine('Subtotal', _subtotal),
          _buildPriceLine('Envío', _deliveryFee),
          const Divider(height: 32),
          _buildPriceLine('Total', _total, isTotal: true),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _proceedToCheckout,
            icon: const Icon(Icons.shopping_cart_checkout),
            label: const Text(
              'Confirmar Pedido',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B00),
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileSummary() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 20),
        ],
      ),
      child: Column(
        children: [
          _buildAddressSection(),
          const SizedBox(height: 20),
          _buildPriceLine('Subtotal', _subtotal),
          _buildPriceLine('Envío', _deliveryFee),
          const Divider(),
          _buildPriceLine('Total', _total, isTotal: true),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _proceedToCheckout,
            icon: const Icon(Icons.shopping_cart_checkout),
            label: const Text(
              'Confirmar Pedido',
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
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on_outlined, color: Color(0xFF05386B)),
            const SizedBox(width: 8),
            const Text(
              'Entregar en',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            TextButton(
              onPressed: _showAddressSelector,
              child: const Text(
                'Cambiar',
                style: TextStyle(color: Color(0xFFFF6B00)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          _selectedAddress,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildPriceLine(String label, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 24 : 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF05386B),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddressSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Seleccionar dirección',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF05386B),
              ),
            ),
            const SizedBox(height: 16),
            ..._addresses.map(
              (addr) => RadioListTile<String>(
                value: addr,
                groupValue: _selectedAddress,
                title: Text(addr),
                onChanged: (val) => setState(() => _selectedAddress = val!),
                activeColor: const Color(0xFFFF6B00),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Agregar nueva dirección'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Modelos (sin cambios)
class CartItem {
  final Product product;
  final int quantity;
  const CartItem({required this.product, required this.quantity});
  CartItem copyWith({int? quantity}) =>
      CartItem(product: product, quantity: quantity ?? this.quantity);
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
