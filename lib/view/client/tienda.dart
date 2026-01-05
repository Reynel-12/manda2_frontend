import 'package:flutter/material.dart';
import 'package:manda2_frontend/view/client/producto_details.dart';

class StoreScreen extends StatefulWidget {
  final bool isOfficialStore;
  final String storeName;
  final String storeCategory;
  final List<String> storeImage;

  const StoreScreen({
    super.key,
    this.isOfficialStore = false,
    required this.storeName,
    required this.storeCategory,
    required this.storeImage,
  });

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen>
    with TickerProviderStateMixin {
  int _cartItemCount = 0;
  String _selectedCategory = 'Todos';
  final List<Product> _cartItems = [];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late ScrollController _scrollController;
  final ValueNotifier<double> _titleOpacity = ValueNotifier<double>(0.0);

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
      'Leche Entera 1L',
      id: 1,
      name: 'Leche Entera 1L',
      description: 'Leche fresca pasteurizada',
      price: 2.50,
      originalPrice: 2.80,
      category: 'Lácteos',
      storeName: 'Tienda 1',
      storeCategory: 'Tienda 1',
      image: [
        'https://ilacad.com/BO/data/logos_cadenas/logo_la_colonia_honduras.jpg',
      ],
      isFavorite: false,
      stock: 20,
      unit: 'unidad',
    ),
    Product(
      'Pan Integral Bolsa',
      id: 2,
      name: 'Pan Integral Bolsa',
      description: 'Pan integral fresco 500g',
      price: 1.75,
      originalPrice: 2.00,
      category: 'Panadería',
      storeName: 'Tienda 1',
      storeCategory: 'Tienda 1',
      image: [
        'https://ilacad.com/BO/data/logos_cadenas/logo_la_colonia_honduras.jpg',
      ],
      isFavorite: true,
      stock: 15,
      unit: 'bolsa',
    ),
    Product(
      'Huevos Blancos x12',
      id: 3,
      name: 'Huevos Blancos x12',
      description: 'Huevos frescos grado A',
      price: 3.20,
      originalPrice: 3.50,
      category: 'Lácteos',
      storeName: 'Tienda 1',
      storeCategory: 'Tienda 1',
      image: [
        'https://ilacad.com/BO/data/logos_cadenas/logo_la_colonia_honduras.jpg',
      ],
      isFavorite: false,
      stock: 8,
      unit: 'docena',
    ),
    Product(
      'Arroz 5kg',
      id: 4,
      name: 'Arroz 5kg',
      description: 'Arroz grano largo premium',
      price: 8.90,
      originalPrice: 9.50,
      category: 'Enlatados',
      storeName: 'Tienda 1',
      storeCategory: 'Tienda 1',
      image: [
        'https://ilacad.com/BO/data/logos_cadenas/logo_la_colonia_honduras.jpg',
      ],
      isFavorite: false,
      stock: 12,
      unit: 'bolsa',
    ),
    Product(
      'Aceite Vegetal 1L',
      id: 5,
      name: 'Aceite Vegetal 1L',
      description: 'Aceite de girasol',
      price: 4.30,
      originalPrice: 4.80,
      category: 'Enlatados',
      storeName: 'Tienda 1',
      storeCategory: 'Tienda 1',
      image: [
        'https://ilacad.com/BO/data/logos_cadenas/logo_la_colonia_honduras.jpg',
      ],
      isFavorite: false,
      stock: 25,
      unit: 'botella',
    ),
    Product(
      'Jugo de Naranja 1L',
      id: 6,
      name: 'Jugo de Naranja 1L',
      description: 'Jugo 100% natural',
      price: 3.50,
      originalPrice: 3.90,
      category: 'Bebidas',
      storeName: 'Tienda 1',
      storeCategory: 'Tienda 1',
      image: [
        'https://ilacad.com/BO/data/logos_cadenas/logo_la_colonia_honduras.jpg',
      ],
      isFavorite: true,
      stock: 18,
      unit: 'caja',
    ),
    Product(
      'Galletas de Chocolate',
      id: 7,
      name: 'Galletas de Chocolate',
      description: 'Galletas con chispas de chocolate',
      price: 2.20,
      originalPrice: 2.50,
      category: 'Snacks',
      storeName: 'Tienda 1',
      storeCategory: 'Tienda 1',
      image: [
        'https://ilacad.com/BO/data/logos_cadenas/logo_la_colonia_honduras.jpg',
      ],
      isFavorite: false,
      stock: 30,
      unit: 'paquete',
    ),
    Product(
      'Detergente Líquido 2L',
      id: 8,
      name: 'Detergente Líquido 2L',
      description: 'Detergente para ropa',
      price: 6.80,
      originalPrice: 7.50,
      category: 'Limpieza',
      storeName: 'Tienda 1',
      storeCategory: 'Tienda 1',
      image: [
        'https://ilacad.com/BO/data/logos_cadenas/logo_la_colonia_honduras.jpg',
      ],
      isFavorite: false,
      stock: 10,
      unit: 'botella',
    ),
    Product(
      'Pechuga de Pollo 1kg',
      id: 9,
      name: 'Pechuga de Pollo 1kg',
      description: 'Pechuga de pollo fresca',
      price: 7.90,
      originalPrice: 8.50,
      category: 'Carnes',
      storeName: 'Tienda 1',
      storeCategory: 'Tienda 1',
      image: [
        'https://ilacad.com/BO/data/logos_cadenas/logo_la_colonia_honduras.jpg',
      ],
      isFavorite: false,
      stock: 6,
      unit: 'kg',
    ),
    Product(
      'Yogurt Natural 1kg',
      id: 10,
      name: 'Yogurt Natural 1kg',
      description: 'Yogurt natural sin azúcar',
      price: 3.80,
      originalPrice: 4.20,
      category: 'Lácteos',
      storeName: 'Tienda 1',
      storeCategory: 'Tienda 1',
      image: [
        'https://ilacad.com/BO/data/logos_cadenas/logo_la_colonia_honduras.jpg',
      ],
      isFavorite: false,
      stock: 22,
      unit: 'pote',
    ),
  ];

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

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      double offset = _scrollController.offset;
      double newOpacity = 0.0;
      // expandedHeight is 240. Start showing title when offset > 160.
      if (offset > 160) {
        newOpacity = (offset - 160) / 40;
        if (newOpacity > 1.0) newOpacity = 1.0;
      }
      if (newOpacity != _titleOpacity.value) {
        _titleOpacity.value = newOpacity;
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    _titleOpacity.dispose();
    super.dispose();
  }

  void _addToCart(Product product) {
    setState(() {
      _cartItems.add(product);
      _cartItemCount = _cartItems.length;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} agregado al carrito'),
        backgroundColor: const Color(0xFF05386B),
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          label: 'Deshacer',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _cartItems.remove(product);
              _cartItemCount = _cartItems.length;
            });
          },
        ),
      ),
    );
  }

  List<Product> get filteredProducts => _selectedCategory == 'Todos'
      ? products
      : products.where((p) => p.category == _selectedCategory).toList();

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final isDesktop = MediaQuery.of(context).size.width >= 1200;
    // final crossAxisCount = isDesktop
    //     ? 4
    //     : isTablet
    //     ? 3
    //     : 2;

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // SliverAppBar moderno
            SliverAppBar(
              expandedHeight: 240,
              pinned: true,
              title: ValueListenableBuilder<double>(
                valueListenable: _titleOpacity,
                builder: (context, opacity, child) {
                  return Opacity(
                    opacity: opacity,
                    child: Text(
                      widget.storeName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              flexibleSpace: FlexibleSpaceBar(background: _buildStoreBanner()),
              leading: IconButton(
                icon: const CircleAvatar(
                  backgroundColor: Colors.white70,
                  child: Icon(Icons.arrow_back, color: Colors.black87),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined),
                      onPressed: () {},
                    ),
                    if (_cartItemCount > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: const Color(0xFFFF6B00),
                          child: Text(
                            _cartItemCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 8),
              ],
            ),

            // Información de tienda + badge oficial
            SliverToBoxAdapter(child: _buildStoreHeader(isDesktop || isTablet)),

            // Filtro de categorías pinned
            SliverPersistentHeader(
              pinned: true,
              delegate: _CategoryFilterDelegate(
                categories: categories,
                selectedCategory: _selectedCategory,
                onCategorySelected: (cat) =>
                    setState(() => _selectedCategory = cat),
              ),
            ),

            // Grid de productos con animación staggered
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 48 : 16,
                vertical: 16,
              ),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: isDesktop
                      ? 300
                      : isTablet
                      ? 280
                      : 200, // Ancho máximo por card
                  mainAxisExtent:
                      380, // Altura fija suficiente para todo el contenido (ajusta si necesitas más/menos)
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final product = filteredProducts[index];
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Interval(
                            0.0 + index * 0.05,
                            1.0,
                            curve: Curves.easeOutBack,
                          ),
                        ),
                      ),
                      child: _buildProductCard(product),
                    ),
                  );
                }, childCount: filteredProducts.length),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: _cartItemCount > 0
      //     ? FloatingActionButton.extended(
      //         onPressed: () {},
      //         backgroundColor: const Color(0xFFFF6B00),
      //         icon: const Icon(Icons.shopping_cart_checkout),
      //         label: Text(
      //           'Ver carrito • \$${_cartItems.fold(0.0, (sum, p) => sum + p.price).toStringAsFixed(2)}',
      //           style: const TextStyle(fontWeight: FontWeight.bold),
      //         ),
      //       )
      //     : null,
    );
  }

  Widget _buildStoreBanner() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(widget.storeImage.first, fit: BoxFit.cover),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            ),
          ),
        ),
        Positioned(
          bottom: 24,
          left: 24,
          right: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.storeName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.storeCategory,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              if (widget.isOfficialStore)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B00),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'TIENDA OFICIAL',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.delivery_dining,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Envío: ${widget.isOfficialStore ? 'GRATIS' : '\$1.50'} • 15-25 min',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStoreHeader(bool isWide) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 48 : 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoChip(Icons.access_time, '7:00 AM - 10:00 PM'),
              _buildInfoChip(Icons.timer, '15-25 min'),
              _buildInfoChip(Icons.star, '4.8 (120+)'),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Descripción',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: const Color(0xFF05386B)),
          ),
          const SizedBox(height: 8),
          Text(
            widget.isOfficialStore
                ? 'Tienda oficial de Manda2 con productos seleccionados, precios especiales y envío gratuito.'
                : 'Tienda local con productos frescos y atención personalizada.',
            style: TextStyle(color: Colors.grey[700], height: 1.5),
          ),
          if (widget.isOfficialStore) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children:
                  [
                        'Envío Gratis',
                        'Precios Especiales',
                        'Productos Premium',
                        'Envío Prioritario',
                      ]
                      .map(
                        (t) => Chip(
                          label: Text(t),
                          backgroundColor: const Color(
                            0xFF05386B,
                          ).withOpacity(0.1),
                        ),
                      )
                      .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF05386B)),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Hero(
                    tag: 'product_${product.id}',
                    child: Image.network(
                      product.image.first,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white70,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 20,
                      icon: Icon(
                        product.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: product.isFavorite
                            ? Colors.red
                            : Colors.grey[700],
                      ),
                      onPressed: () => setState(
                        () => product.isFavorite = !product.isFavorite,
                      ),
                    ),
                  ),
                ),
                if (product.originalPrice != null &&
                    product.originalPrice! > product.price)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B00),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'OFERTA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              // ← Esto permite que el contenido se expanda correctamente
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.description,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF05386B),
                          ),
                        ),
                        if (product.originalPrice != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            '\$${product.originalPrice!.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.grey[500],
                              decoration: TextDecoration.lineThrough,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const Spacer(), // ← Empuja el botón hacia abajo
                    SizedBox(
                      width: double.infinity,
                      height: 42, // ← Altura fija más compacta
                      child: ElevatedButton(
                        onPressed: () => _addToCart(product),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B00),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ), // ← Menos padding vertical
                        ),
                        child: const Text(
                          'Agregar',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Delegate de filtro moderno
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
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: categories.map((cat) {
            final isSelected = cat == selectedCategory;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                onSelected: (_) => onCategorySelected(cat),
                selectedColor: const Color(0xFFFF6B00),
                backgroundColor: Colors.grey[100],
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF05386B),
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 70;
  @override
  double get minExtent => 70;
  @override
  bool shouldRebuild(covariant _CategoryFilterDelegate old) =>
      old.selectedCategory != selectedCategory || old.categories != categories;
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
