import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  int _quantity = 1;
  bool _isFavorite = false;
  int _currentImageIndex = 0;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final List<ProductSpec> specifications = [
    ProductSpec('Marca', 'Del Valle'),
    ProductSpec('Peso', '1 Litro'),
    ProductSpec('Tipo', 'Entera'),
    ProductSpec('Caducidad', '30 días'),
    ProductSpec('Origen', 'Local'),
    ProductSpec('Envasado', 'Tetra Pak'),
  ];

  final List<NutritionInfo> nutritionInfo = [
    NutritionInfo('Calorías', '120 kcal'),
    NutritionInfo('Proteínas', '8g'),
    NutritionInfo('Grasas', '5g'),
    NutritionInfo('Carbohidratos', '12g'),
    NutritionInfo('Calcio', '30% VD'),
    NutritionInfo('Vitamina D', '25% VD'),
  ];

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.product.isFavorite;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _addToCart() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} ×$_quantity agregado al carrito'),
        backgroundColor: const Color(0xFF05386B),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Ver carrito',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
    // Aquí puedes actualizar el carrito global
  }

  double get subtotal => widget.product.price * _quantity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final isDesktop = MediaQuery.of(context).size.width >= 1200;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            // Hero AppBar con carousel
            SliverAppBar(
              expandedHeight: 400,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildImageCarousel(),
                title: AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    widget.product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.white70,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              actions: [
                CircleAvatar(
                  backgroundColor: Colors.white70,
                  child: IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.black87,
                    ),
                    onPressed: () => setState(() => _isFavorite = !_isFavorite),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),

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
                          Expanded(flex: 2, child: _buildMainContent()),
                          const SizedBox(width: 32),
                          Expanded(flex: 1, child: _buildStickyBuyCard()),
                        ],
                      )
                    : Column(
                        children: [
                          _buildMainContent(),
                          const SizedBox(
                            height: 100,
                          ), // Espacio para el bottom bar
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
      // Bottom bar solo en móvil
      bottomNavigationBar: isTablet || isDesktop
          ? null
          : _buildMobileBottomBar(),
    );
  }

  Widget _buildImageCarousel() {
    return Stack(
      children: [
        PageView.builder(
          itemCount: widget.product.image.length,
          onPageChanged: (i) => setState(() => _currentImageIndex = i),
          itemBuilder: (context, index) {
            return InteractiveViewer(
              child: Hero(
                tag: 'product_${widget.product.id}',
                child: Image.network(
                  widget.product.image[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, size: 80),
                  ),
                ),
              ),
            );
          },
        ),
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.product.image.length,
              (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentImageIndex == i
                      ? const Color(0xFFFF6B00)
                      : Colors.white.withOpacity(0.6),
                ),
              ),
            ),
          ),
        ),
        if (widget.product.originalPrice != null)
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B00),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '-${((1 - widget.product.price / widget.product.originalPrice!) * 100).toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMainContent() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.product.category,
          style: TextStyle(
            color: const Color(0xFF05386B),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.product.name,
          style: theme.textTheme.displaySmall?.copyWith(
            color: const Color(0xFF05386B),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildStoreLink(),
        const SizedBox(height: 24),
        Text(
          widget.product.description,
          style: TextStyle(color: Colors.grey[700], fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 32),
        _buildExpandableSection(
          'Especificaciones',
          specifications.map((s) => MapEntry(s.label, s.value)).toList(),
        ),
        const SizedBox(height: 24),
        _buildExpandableSection(
          'Información Nutricional',
          nutritionInfo.map((n) => MapEntry(n.nutrient, n.value)).toList(),
        ),
      ],
    );
  }

  Widget _buildStoreLink() {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF05386B),
          child: const Icon(Icons.store, color: Colors.white),
        ),
        title: Text(
          widget.product.storeName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(widget.product.storeCategory),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildExpandableSection(
    String title,
    List<MapEntry<String, String>> items,
  ) {
    final theme = Theme.of(context);
    return ExpansionTile(
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          color: const Color(0xFF05386B),
        ),
      ),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: items
          .map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.key),
                  Text(
                    e.value,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildStickyBuyCard() {
    final theme = Theme.of(context);
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '\$${widget.product.price.toStringAsFixed(2)}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: const Color(0xFF05386B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.product.originalPrice != null) ...[
                  const SizedBox(width: 12),
                  Text(
                    '\$${widget.product.originalPrice!.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.grey[500],
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Text('Cantidad', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton.filled(
                  onPressed: _quantity > 1
                      ? () => setState(() => _quantity--)
                      : null,
                  icon: const Icon(Icons.remove),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    '$_quantity',
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
                IconButton.filled(
                  onPressed: () => setState(() => _quantity++),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Total: \$${subtotal.toStringAsFixed(2)}',
              style: theme.textTheme.titleLarge?.copyWith(
                color: const Color(0xFF05386B),
              ),
            ),
            const SizedBox(height: 24),
            ScaleTransition(
              scale: _scaleAnimation,
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: widget.product.stock > 0 ? _addToCart : null,
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: Text(
                    widget.product.stock > 0 ? 'Agregar al Carrito' : 'Agotado',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 20),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total', style: TextStyle(color: Colors.grey[600])),
                Text(
                  '\$${subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF05386B),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: widget.product.stock > 0 ? _addToCart : null,
              icon: const Icon(Icons.shopping_cart_checkout),
              label: const Text(
                'Agregar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B00),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Mantén tus modelos Product, ProductSpec, NutritionInfo, etc.

// Modelos de datos
class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String category;
  final String storeName;
  final String storeCategory;
  final List<String> image;
  bool isFavorite;
  final double rating;
  final int stock;
  final String unit;
  final int salesCount;
  final int deliveryTime;

  Product(
    String s, {
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.category,
    required this.storeName,
    required this.storeCategory,
    required this.image,
    this.isFavorite = false,
    this.rating = 0.0,
    this.stock = 0,
    required this.unit,
    this.salesCount = 0,
    this.deliveryTime = 20,
  });
}

class ProductSpec {
  final String label;
  final String value;

  ProductSpec(this.label, this.value);
}

class NutritionInfo {
  final String nutrient;
  final String value;

  NutritionInfo(this.nutrient, this.value);
}

class CartItem {
  final Product product;
  final int quantity;
  final double subtotal;

  CartItem({
    required this.product,
    required this.quantity,
    required this.subtotal,
  });
}

// Widget para mostrar esta pantalla desde otra
void navigateToProductDetail(BuildContext context, Product product) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProductDetailScreen(product: product),
    ),
  );
}

// Ejemplo de producto para testing
Product exampleProduct = Product(
  'Leche Entera Fresca 1L',
  id: 1,
  name: 'Leche Entera Fresca 1L',
  description:
      'Leche 100% natural pasteurizada, sin conservantes añadidos. Ideal para el consumo diario de toda la familia. Producida localmente con los más altos estándares de calidad.',
  price: 2.50,
  originalPrice: 2.80,
  category: 'Lácteos',
  image: [
    'https://ilacad.com/BO/data/logos_cadenas/logo_la_colonia_honduras.jpg',
  ],
  storeName: 'Pulpería "El Buen Precio"',
  storeCategory: 'Supermercado',
  isFavorite: false,
  rating: 4.5,
  stock: 15,
  unit: 'litro',
  salesCount: 342,
  deliveryTime: 20,
);
