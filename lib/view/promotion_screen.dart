import 'package:flutter/material.dart';

class PromotionsScreen extends StatefulWidget {
  const PromotionsScreen({Key? key}) : super(key: key);

  @override
  State<PromotionsScreen> createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends State<PromotionsScreen> {
  final List<Promotion> _promotions = [];
  final List<Product> _discountedProducts = [];
  String _selectedCategory = 'Todos';
  final List<String> _categories = [
    'Todos',
    'Supermercado',
    'Restaurantes',
    'Farmacia',
    'Licorería',
  ];

  @override
  void initState() {
    super.initState();
    _loadPromotions();
    _loadDiscountedProducts();
  }

  void _loadPromotions() {
    // Promociones activas
    _promotions.addAll([
      Promotion(
        id: 1,
        title: 'Envío Gratis en tu Primera Compra',
        description:
            'Obtén envío gratis en tu primer pedido con código: BIENVENIDO',
        discount: 'ENVÍO GRATIS',
        color: const Color(0xFF05386B),
        icon: Icons.local_shipping_outlined,
        validUntil: DateTime.now().add(const Duration(days: 30)),
        terms: 'Válido solo para nuevas cuentas',
      ),
      Promotion(
        id: 2,
        title: '20% de Descuento en Supermercados',
        description:
            'Ahorra 20% en todas las compras de supermercado este fin de semana',
        discount: '20% OFF',
        color: const Color(0xFFFF6B00),
        icon: Icons.local_grocery_store_outlined,
        validUntil: DateTime.now().add(const Duration(days: 3)),
        terms: 'Válido solo sábados y domingos',
      ),
      Promotion(
        id: 3,
        title: '2x1 en Restaurantes Participantes',
        description:
            'Lleva 2 platos por el precio de 1 en restaurantes seleccionados',
        discount: '2x1',
        color: Colors.green,
        icon: Icons.restaurant_outlined,
        validUntil: DateTime.now().add(const Duration(days: 7)),
        terms: 'Válido de lunes a jueves',
      ),
      Promotion(
        id: 4,
        title: 'Descuento Especial en Farmacia',
        description:
            '15% de descuento en productos de farmacia para clientes frecuentes',
        discount: '15% OFF',
        color: Colors.purple,
        icon: Icons.local_pharmacy_outlined,
        validUntil: DateTime.now().add(const Duration(days: 15)),
        terms: 'Válido para pedidos mayores a \$10',
      ),
    ]);
  }

  void _loadDiscountedProducts() {
    // Productos con descuento
    _discountedProducts.addAll([
      Product(
        id: 1,
        name: 'Leche Entera 1L',
        price: 2.20,
        originalPrice: 2.80,
        discountPercentage: 21,
        storeName: 'Pulpería "El Buen Precio"',
        category: 'Supermercado',
        unit: 'litro',
        rating: 4.5,
        isInStock: true,
        imageUrl: '',
        promotionEnds: DateTime.now().add(const Duration(days: 2)),
        isOfficialStore: true,
      ),
      Product(
        id: 2,
        name: 'Arroz Integral 5kg',
        price: 7.50,
        originalPrice: 9.90,
        discountPercentage: 24,
        storeName: 'Supermercado Central',
        category: 'Supermercado',
        unit: 'bolsa',
        rating: 4.3,
        isInStock: true,
        imageUrl: '',
        promotionEnds: DateTime.now().add(const Duration(days: 5)),
        isOfficialStore: false,
      ),
      Product(
        id: 3,
        name: 'Pizza Familiar',
        price: 12.99,
        originalPrice: 16.99,
        discountPercentage: 24,
        storeName: 'Restaurante "Sabor Local"',
        category: 'Restaurantes',
        unit: 'pizza',
        rating: 4.7,
        isInStock: true,
        imageUrl: '',
        promotionEnds: DateTime.now().add(const Duration(days: 1)),
        isOfficialStore: false,
      ),
      Product(
        id: 4,
        name: 'Vitaminas Complejo B',
        price: 8.50,
        originalPrice: 11.00,
        discountPercentage: 23,
        storeName: 'Farmacia "Salud Total"',
        category: 'Farmacia',
        unit: 'frasco',
        rating: 4.4,
        isInStock: true,
        imageUrl: '',
        promotionEnds: DateTime.now().add(const Duration(days: 12)),
        isOfficialStore: false,
      ),
      Product(
        id: 5,
        name: 'Vino Tinto Reserva',
        price: 15.99,
        originalPrice: 19.99,
        discountPercentage: 20,
        storeName: 'Licorería "La Bodega"',
        category: 'Licorería',
        unit: 'botella',
        rating: 4.8,
        isInStock: true,
        imageUrl: '',
        promotionEnds: DateTime.now().add(const Duration(days: 3)),
        isOfficialStore: false,
      ),
      Product(
        id: 6,
        name: 'Aceite de Oliva Extra Virgen',
        price: 6.75,
        originalPrice: 8.50,
        discountPercentage: 21,
        storeName: 'Pulpería "El Buen Precio"',
        category: 'Supermercado',
        unit: 'botella',
        rating: 4.6,
        isInStock: true,
        imageUrl: '',
        promotionEnds: DateTime.now().add(const Duration(days: 4)),
        isOfficialStore: true,
      ),
      Product(
        id: 7,
        name: 'Hamburguesa Especial + Papas',
        price: 8.99,
        originalPrice: 11.50,
        discountPercentage: 22,
        storeName: 'Restaurante "Burger House"',
        category: 'Restaurantes',
        unit: 'combo',
        rating: 4.5,
        isInStock: true,
        imageUrl: '',
        promotionEnds: DateTime.now().add(const Duration(days: 2)),
        isOfficialStore: false,
      ),
      Product(
        id: 8,
        name: 'Jabón Líquido Antibacterial 2L',
        price: 5.99,
        originalPrice: 7.50,
        discountPercentage: 20,
        storeName: 'Supermercado Central',
        category: 'Supermercado',
        unit: 'botella',
        rating: 4.2,
        isInStock: true,
        imageUrl: '',
        promotionEnds: DateTime.now().add(const Duration(days: 7)),
        isOfficialStore: false,
      ),
      Product(
        id: 9,
        name: 'Cerveza Artesanal 6-pack',
        price: 13.50,
        originalPrice: 16.00,
        discountPercentage: 16,
        storeName: 'Licorería "La Bodega"',
        category: 'Licorería',
        unit: 'paquete',
        rating: 4.7,
        isInStock: true,
        imageUrl: '',
        promotionEnds: DateTime.now().add(const Duration(days: 1)),
        isOfficialStore: false,
      ),
      Product(
        id: 10,
        name: 'Analgésico 500mg x24',
        price: 3.25,
        originalPrice: 4.00,
        discountPercentage: 19,
        storeName: 'Farmacia "Salud Total"',
        category: 'Farmacia',
        unit: 'caja',
        rating: 4.3,
        isInStock: true,
        imageUrl: '',
        promotionEnds: DateTime.now().add(const Duration(days: 6)),
        isOfficialStore: false,
      ),
    ]);
  }

  List<Product> get _filteredProducts {
    if (_selectedCategory == 'Todos') {
      return _discountedProducts;
    }
    return _discountedProducts
        .where((product) => product.category == _selectedCategory)
        .toList();
  }

  void _copyPromoCode(String code) {
    // Simular copiado al portapapeles
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Código "$code" copiado al portapapeles'),
        backgroundColor: const Color(0xFF05386B),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addToCart(Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} agregado al carrito'),
        backgroundColor: const Color(0xFF05386B),
        action: SnackBarAction(
          label: 'Ver Carrito',
          textColor: Colors.white,
          onPressed: () {
            // Navegar al carrito
          },
        ),
      ),
    );
  }

  void _navigateToProduct(Product product) {
    // Navegar a la pantalla del producto
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  void _showPromotionDetails(Promotion promotion) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildPromotionDetails(promotion),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Promociones'),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.inbox_outlined),
            onPressed: () {
              // Mostrar información sobre promociones
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner promocional
            _buildPromotionalBanner(),

            // Promociones activas
            _buildPromotionsSection(),

            // Filtros por categoría
            _buildCategoryFilter(),

            // Productos con descuento
            _buildDiscountedProductsSection(isTablet),

            // Espacio final
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Banner promocional
  Widget _buildPromotionalBanner() {
    return Container(
      height: 180,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF05386B), Color(0xFF1A5A9C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Patrón de fondo
          Positioned(
            right: 20,
            top: 20,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.local_offer_outlined,
                size: 100,
                color: Colors.white,
              ),
            ),
          ),

          // Contenido
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B00),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'OFERTAS ESPECIALES',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Ahorra hasta 50%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'En productos seleccionados y promociones exclusivas',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  maxLines: 2,
                ),
              ],
            ),
          ),

          // Contador de productos
          Positioned(
            bottom: 16,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_discountedProducts.length} productos en oferta',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Sección de promociones activas
  Widget _buildPromotionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Promociones Activas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF05386B),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Ver todas las promociones
                },
                child: const Text(
                  'Ver todas',
                  style: TextStyle(
                    color: Color(0xFFFF6B00),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Lista horizontal de promociones
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _promotions.length,
            itemBuilder: (context, index) {
              return _buildPromotionCard(_promotions[index]);
            },
          ),
        ),
      ],
    );
  }

  // Tarjeta de promoción
  Widget _buildPromotionCard(Promotion promotion) {
    final daysLeft = promotion.validUntil.difference(DateTime.now()).inDays;

    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: promotion.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: promotion.color.withOpacity(0.3), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showPromotionDetails(promotion),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con icono y descuento
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: promotion.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        promotion.icon,
                        color: promotion.color,
                        size: 24,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: promotion.color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        promotion.discount,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Título
                Text(
                  promotion.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: promotion.color,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Descripción
                Expanded(
                  child: Text(
                    promotion.description,
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(height: 8),

                // Tiempo restante
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      daysLeft > 0 ? 'Válido por $daysLeft días' : 'Último día',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    TextButton(
                      onPressed: () => _copyPromoCode('PROMO${promotion.id}'),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                      ),
                      child: const Text(
                        'Copiar código',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF05386B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Filtros por categoría
  Widget _buildCategoryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Productos en Descuento',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF05386B),
                ),
              ),
              Text(
                '${_filteredProducts.length} productos',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),

        // Chips de categorías
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = category == _selectedCategory;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _selectedCategory = category;
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
            },
          ),
        ),
      ],
    );
  }

  // Sección de productos con descuento
  Widget _buildDiscountedProductsSection(bool isTablet) {
    if (_filteredProducts.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: isTablet ? _buildProductsGrid() : _buildProductsList(),
    );
  }

  // Lista de productos (móvil)
  Widget _buildProductsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        return _buildProductCard(_filteredProducts[index]);
      },
    );
  }

  // Grid de productos (tablet)
  Widget _buildProductsGrid() {
    final crossAxisCount = MediaQuery.of(context).size.width >= 900 ? 3 : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        return _buildProductCard(_filteredProducts[index], isGrid: true);
      },
    );
  }

  // Tarjeta de producto
  Widget _buildProductCard(Product product, {bool isGrid = false}) {
    final hoursLeft = product.promotionEnds.difference(DateTime.now()).inHours;

    return Container(
      margin: isGrid ? EdgeInsets.zero : const EdgeInsets.only(bottom: 16),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToProduct(product),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del producto con badge de descuento
              Stack(
                children: [
                  // Imagen del producto
                  Container(
                    height: isGrid ? 140 : 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),

                  // Badge de descuento
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B00),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '-${product.discountPercentage}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Badge de tienda oficial
                  if (product.isOfficialStore)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF05386B),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'OFICIAL',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Contador de tiempo
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.access_time_outlined,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            hoursLeft > 24
                                ? '${(hoursLeft / 24).ceil()} días restantes'
                                : '$hoursLeft horas restantes',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Contenido
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre del producto
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF05386B),
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Tienda y categoría
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.storeName,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF05386B).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            product.category,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF05386B),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Precios
                    Row(
                      children: [
                        // Precio con descuento
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF05386B),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Precio original
                        Text(
                          '\$${product.originalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[500],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),

                        const Spacer(),

                        // Ahorro
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Ahorras \$${(product.originalPrice - product.price).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Rating y unidad
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              product.rating.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Por ${product.unit}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    // Botón de acción
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _addToCart(product),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B00),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Agregar al Carrito',
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
        ),
      ),
    );
  }

  // Estado vacío
  Widget _buildEmptyState() {
    return Padding(
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
              Icons.local_offer_outlined,
              size: 60,
              color: Color(0xFF05386B),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No hay promociones en esta categoría',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF05386B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Intenta con otra categoría o revisa más tarde',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              // textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedCategory = 'Todos';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B00),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Ver Todas las Categorías',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // Detalles de la promoción (bottom sheet)
  Widget _buildPromotionDetails(Promotion promotion) {
    final daysLeft = promotion.validUntil.difference(DateTime.now()).inDays;

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

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: promotion.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(promotion.icon, color: promotion.color, size: 32),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: promotion.color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        promotion.discount,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      promotion.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: promotion.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Descripción
          const Text(
            'Descripción',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF05386B),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            promotion.description,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),

          const SizedBox(height: 24),

          // Términos y condiciones
          const Text(
            'Términos y Condiciones',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF05386B),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            promotion.terms,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),

          const SizedBox(height: 24),

          // Información de validez
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time_outlined,
                  color: Color(0xFF05386B),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Válido hasta',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF05386B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${promotion.validUntil.day}/${promotion.validUntil.month}/${promotion.validUntil.year}',
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: daysLeft <= 2
                        ? Colors.orange[50]
                        : const Color(0xFF05386B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    daysLeft > 0 ? '$daysLeft días restantes' : 'Último día',
                    style: TextStyle(
                      color: daysLeft <= 2
                          ? Colors.orange[700]
                          : const Color(0xFF05386B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Código de promoción
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF05386B).withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF05386B).withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Código de promoción',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF05386B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Center(
                          child: Text(
                            'PROMO${promotion.id}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF05386B),
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => _copyPromoCode('PROMO${promotion.id}'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B00),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Copiar',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Usa este código al finalizar tu pedido',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Botón para usar promoción
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Navegar a la tienda o producto correspondiente
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: promotion.color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Usar esta Promoción',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}

// Modelos de datos
class Promotion {
  final int id;
  final String title;
  final String description;
  final String discount;
  final Color color;
  final IconData icon;
  final DateTime validUntil;
  final String terms;

  const Promotion({
    required this.id,
    required this.title,
    required this.description,
    required this.discount,
    required this.color,
    required this.icon,
    required this.validUntil,
    required this.terms,
  });
}

class Product {
  final int id;
  final String name;
  final double price;
  final double originalPrice;
  final int discountPercentage;
  final String storeName;
  final String category;
  final String unit;
  final double rating;
  final bool isInStock;
  final String imageUrl;
  final DateTime promotionEnds;
  final bool isOfficialStore;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.discountPercentage,
    required this.storeName,
    required this.category,
    required this.unit,
    required this.rating,
    required this.isInStock,
    required this.imageUrl,
    required this.promotionEnds,
    required this.isOfficialStore,
  });
}

// Pantalla placeholder para navegación
class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({required this.product, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Producto'),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
      ),
      body: Center(child: Text('Detalles de ${product.name}')),
    );
  }
}
