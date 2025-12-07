import 'package:flutter/material.dart';

class StoreScreen extends StatefulWidget {
  final bool isOfficialStore;
  final String storeName;
  final String storeCategory;

  const StoreScreen({
    super.key,
    this.isOfficialStore = false,
    required this.storeName,
    required this.storeCategory,
  });

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  int _cartItemCount = 0;
  String _selectedCategory = 'Todos';
  final List<Product> _cartItems = [];
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  // Categorías de productos
  final List<String> categories = [
    'Todos',
    'Lácteos',
    'Panadería',
    'Bebidas',
    'Enlatados',
    'Snacks',
    'Limpieza',
    'Carnes',
  ];

  // Productos de ejemplo
  final List<Product> products = [
    Product(
      id: 1,
      name: 'Leche Entera 1L',
      description: 'Leche fresca pasteurizada',
      price: 2.50,
      originalPrice: 2.80,
      category: 'Lácteos',
      imageUrl: '',
      isFavorite: false,
      rating: 4.5,
      stock: 20,
      unit: 'unidad',
    ),
    Product(
      id: 2,
      name: 'Pan Integral Bolsa',
      description: 'Pan integral fresco 500g',
      price: 1.75,
      originalPrice: 2.00,
      category: 'Panadería',
      imageUrl: '',
      isFavorite: true,
      rating: 4.2,
      stock: 15,
      unit: 'bolsa',
    ),
    Product(
      id: 3,
      name: 'Huevos Blancos x12',
      description: 'Huevos frescos grado A',
      price: 3.20,
      originalPrice: 3.50,
      category: 'Lácteos',
      imageUrl: '',
      isFavorite: false,
      rating: 4.7,
      stock: 8,
      unit: 'docena',
    ),
    Product(
      id: 4,
      name: 'Arroz 5kg',
      description: 'Arroz grano largo premium',
      price: 8.90,
      originalPrice: 9.50,
      category: 'Enlatados',
      imageUrl: '',
      isFavorite: false,
      rating: 4.8,
      stock: 12,
      unit: 'bolsa',
    ),
    Product(
      id: 5,
      name: 'Aceite Vegetal 1L',
      description: 'Aceite de girasol',
      price: 4.30,
      originalPrice: 4.80,
      category: 'Enlatados',
      imageUrl: '',
      isFavorite: false,
      rating: 4.3,
      stock: 25,
      unit: 'botella',
    ),
    Product(
      id: 6,
      name: 'Jugo de Naranja 1L',
      description: 'Jugo 100% natural',
      price: 3.50,
      originalPrice: 3.90,
      category: 'Bebidas',
      imageUrl: '',
      isFavorite: true,
      rating: 4.4,
      stock: 18,
      unit: 'caja',
    ),
    Product(
      id: 7,
      name: 'Galletas de Chocolate',
      description: 'Galletas con chispas de chocolate',
      price: 2.20,
      originalPrice: 2.50,
      category: 'Snacks',
      imageUrl: '',
      isFavorite: false,
      rating: 4.6,
      stock: 30,
      unit: 'paquete',
    ),
    Product(
      id: 8,
      name: 'Detergente Líquido 2L',
      description: 'Detergente para ropa',
      price: 6.80,
      originalPrice: 7.50,
      category: 'Limpieza',
      imageUrl: '',
      isFavorite: false,
      rating: 4.5,
      stock: 10,
      unit: 'botella',
    ),
    Product(
      id: 9,
      name: 'Pechuga de Pollo 1kg',
      description: 'Pechuga de pollo fresca',
      price: 7.90,
      originalPrice: 8.50,
      category: 'Carnes',
      imageUrl: '',
      isFavorite: false,
      rating: 4.7,
      stock: 6,
      unit: 'kg',
    ),
    Product(
      id: 10,
      name: 'Yogurt Natural 1kg',
      description: 'Yogurt natural sin azúcar',
      price: 3.80,
      originalPrice: 4.20,
      category: 'Lácteos',
      imageUrl: '',
      isFavorite: false,
      rating: 4.4,
      stock: 22,
      unit: 'pote',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  void _addToCart(Product product) {
    setState(() {
      _cartItems.add(product);
      _cartItemCount = _cartItems.length;

      // Mostrar snackbar de confirmación
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.name} agregado al carrito'),
          backgroundColor: const Color(0xFF05386B),
          action: SnackBarAction(
            label: 'Deshacer',
            textColor: Colors.white,
            onPressed: () {
              setState(() {
                _cartItems.removeLast();
                _cartItemCount = _cartItems.length;
              });
            },
          ),
        ),
      );
    });
  }

  void _toggleFavorite(int productId) {
    setState(() {
      final product = products.firstWhere((p) => p.id == productId);
      product.isFavorite = !product.isFavorite;
    });
  }

  List<Product> get filteredProducts {
    if (_selectedCategory == 'Todos') {
      return products;
    }
    return products
        .where((product) => product.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final appBarHeight = AppBar().preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final totalAppBarHeight = appBarHeight + statusBarHeight;

    final bannerHeight = 200.0;
    final bannerVisibleHeight =
        bannerHeight - _scrollOffset.clamp(0, bannerHeight - totalAppBarHeight);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // AppBar personalizado
          SliverAppBar(
            expandedHeight: bannerHeight,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: _scrollOffset > bannerHeight - totalAppBarHeight
                  ? Text(
                      widget.storeName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
              background: _buildStoreBanner(),
            ),
            actions: [
              // Icono de favoritos
              IconButton(
                icon: const Icon(Icons.favorite_border_outlined),
                onPressed: () {
                  // Agregar a favoritos
                },
              ),
              // Icono del carrito con badge
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () {
                      // Navegar al carrito
                    },
                  ),
                  if (_cartItemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B00),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          _cartItemCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),

          // Información de la tienda (solo visible en scroll)
          SliverToBoxAdapter(child: _buildStoreInfo()),

          // Badge de tienda oficial (si aplica)
          if (widget.isOfficialStore)
            SliverToBoxAdapter(child: _buildOfficialStoreBadge()),

          // Filtros por categoría
          SliverPersistentHeader(
            pinned: true,
            delegate: _CategoryFilterDelegate(
              categories: categories,
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
          ),

          // Lista de productos
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: _buildProductGrid(),
          ),
        ],
      ),

      // Botón flotante para ver carrito
      floatingActionButton: _cartItemCount > 0
          ? FloatingActionButton.extended(
              onPressed: () {
                // Ver carrito
              },
              backgroundColor: const Color(0xFFFF6B00),
              icon: const Icon(Icons.shopping_cart_checkout_outlined),
              label: Text(
                'Ver Carrito (\$${_cartItems.fold(0.0, (sum, item) => sum + item.price).toStringAsFixed(2)})',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          : null,

      // Navegación inferior
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Banner de la tienda
  Widget _buildStoreBanner() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.isOfficialStore
              ? [const Color(0xFF05386B), const Color(0xFF1A5A9C)]
              : [Colors.grey[800]!, Colors.grey[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Contenido del banner
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(
                    widget.isOfficialStore
                        ? Icons.storefront_outlined
                        : Icons.store_outlined,
                    size: 40,
                    color: const Color(0xFF05386B),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.storeName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.storeCategory,
                  style: TextStyle(color: Colors.grey[200], fontSize: 16),
                ),
                if (widget.isOfficialStore) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B00),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'TIENDA OFICIAL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Información de envío en esquina inferior
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.delivery_dining_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Envío: \$${widget.isOfficialStore ? '0.00' : '1.50'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Rating en esquina inferior derecha
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  const Text(
                    '4.7',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Información de la tienda
  Widget _buildStoreInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Horario y tiempo de entrega
          Row(
            children: [
              _buildInfoItem(
                Icons.access_time_outlined,
                'Horario',
                '7:00 AM - 10:00 PM',
              ),
              const SizedBox(width: 24),
              _buildInfoItem(Icons.timer_outlined, 'Entrega', '15-25 min'),
              const SizedBox(width: 24),
              _buildInfoItem(Icons.phone_outlined, 'Teléfono', '555-1234'),
            ],
          ),
          const SizedBox(height: 16),

          // Descripción
          const Text(
            'Descripción',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF05386B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.isOfficialStore
                ? 'Tienda oficial de Manda2 con productos seleccionados, precios especiales y envío gratuito para todos nuestros clientes.'
                : 'Tienda local con los mejores productos frescos y atención personalizada. Calidad garantizada.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),

          // Beneficios especiales para tienda oficial
          if (widget.isOfficialStore) ...[
            const SizedBox(height: 16),
            _buildOfficialStoreBenefits(),
          ],
        ],
      ),
    );
  }

  // Item de información
  Widget _buildInfoItem(IconData icon, String title, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF05386B), size: 24),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF05386B),
            ),
          ),
        ],
      ),
    );
  }

  // Badge de tienda oficial
  Widget _buildOfficialStoreBadge() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF6B00).withOpacity(0.1),
            const Color(0xFF05386B).withOpacity(0.1),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFF6B00), width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.verified_outlined,
            color: const Color(0xFFFF6B00),
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tienda Oficial Manda2',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Envío gratuito • Precios especiales • Productos seleccionados',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Beneficios de tienda oficial
  Widget _buildOfficialStoreBenefits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Beneficios Exclusivos',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF05386B),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildBenefitChip('🚚 Envío Gratuito'),
            _buildBenefitChip('💰 Precios Especiales'),
            _buildBenefitChip('⭐ Productos Premium'),
            _buildBenefitChip('⏱️ Envío Prioritario'),
            _buildBenefitChip('🎁 Descuentos Exclusivos'),
            _buildBenefitChip('📦 Empaque Especial'),
          ],
        ),
      ],
    );
  }

  Widget _buildBenefitChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF05386B).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF05386B),
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
      ),
    );
  }

  // Grid de productos
  Widget _buildProductGrid() {
    final crossAxisCount = ResponsiveLayout.isMobile(context) ? 2 : 3;

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final product = filteredProducts[index];
        return _buildProductCard(product);
      }, childCount: filteredProducts.length),
    );
  }

  // Tarjeta de producto
  Widget _buildProductCard(Product product) {
    return Container(
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
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del producto
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: 60,
                    color: Colors.grey[400],
                  ),
                ),
              ),

              // Contenido
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre y categoría
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF05386B),
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.category,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),

                    // Descripción
                    const SizedBox(height: 4),
                    Text(
                      product.description,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Precio
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF05386B),
                          ),
                        ),
                        if (product.originalPrice != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              '\$${product.originalPrice!.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                      ],
                    ),

                    // Stock y unidad
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${product.stock} en stock',
                          style: TextStyle(
                            fontSize: 11,
                            color: product.stock > 5
                                ? Colors.green[600]
                                : Colors.orange[600],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '• ${product.unit}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    // Botón agregar
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _addToCart(product),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B00),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Agregar',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Botón de favorito
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Icon(
                product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border_outlined,
                color: product.isFavorite ? Colors.red : Colors.grey[600],
              ),
              onPressed: () => _toggleFavorite(product.id),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),

          // Badge de oferta (si hay descuento)
          if (product.originalPrice != null &&
              product.originalPrice! > product.price)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B00),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'OFERTA',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

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
          child: Row(
            children: [
              // Total del carrito
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total en carrito',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      '\$${_cartItems.fold(0.0, (sum, item) => sum + item.price).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF05386B),
                      ),
                    ),
                  ],
                ),
              ),

              // Botón de pagar
              ElevatedButton(
                onPressed: _cartItemCount > 0
                    ? () {
                        // Ir a pagar
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B00),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(
                    0,
                    50,
                  ), // Override global infinite width
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Pagar Ahora',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Delegate para filtros de categoría
class _CategoryFilterDelegate extends SliverPersistentHeaderDelegate {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  _CategoryFilterDelegate({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Título de filtros
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                const Icon(
                  Icons.filter_list_outlined,
                  color: Color(0xFF05386B),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Filtrar por categoría',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF05386B),
                  ),
                ),
                const Spacer(),
                if (selectedCategory != 'Todos')
                  TextButton(
                    onPressed: () => onCategorySelected('Todos'),
                    child: const Text(
                      'Limpiar',
                      style: TextStyle(color: Color(0xFFFF6B00)),
                    ),
                  ),
              ],
            ),
          ),

          // Lista de categorías
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedCategory;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      onCategorySelected(category);
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
              },
            ),
          ),

          // Línea separadora
          Container(
            height: 1,
            color: Colors.grey[200],
            margin: const EdgeInsets.only(top: 8),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 110;

  @override
  double get minExtent => 110;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

// Modelo de producto
class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String category;
  final String imageUrl;
  bool isFavorite;
  final double rating;
  final int stock;
  final String unit;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.category,
    required this.imageUrl,
    this.isFavorite = false,
    this.rating = 0.0,
    this.stock = 0,
    required this.unit,
  });
}

// Clase para responsividad
class ResponsiveLayout {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;
}
