import 'package:flutter/material.dart';
import 'package:manda2_frontend/view/tienda.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  bool _isFavorite = false;
  final PageController _imagePageController = PageController();
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;
  int _currentImageIndex = 0;

  // Imágenes de ejemplo para el producto
  final List<String> productImages = [
    'https://ilacad.com/BO/data/logos_cadenas/logo_la_colonia_honduras.jpg',
    'https://ilacad.com/BO/data/logos_cadenas/logo_la_colonia_honduras.jpg',
    'https://ilacad.com/BO/data/logos_cadenas/logo_la_colonia_honduras.jpg',
  ];

  // Especificaciones del producto
  final List<ProductSpec> specifications = [
    ProductSpec('Marca', 'Del Valle'),
    ProductSpec('Peso', '1 Litro'),
    ProductSpec('Tipo', 'Entera'),
    ProductSpec('Caducidad', '30 días'),
    ProductSpec('Origen', 'Local'),
    ProductSpec('Envasado', 'Tetra Pak'),
  ];

  // Información nutricional
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
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }

  void _addToCart() {
    // Lógica para agregar al carrito
    final cartItem = CartItem(
      product: widget.product,
      quantity: _quantity,
      subtotal: widget.product.price * _quantity,
    );

    // Mostrar confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} x$_quantity agregado al carrito'),
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

    // Navegar de regreso
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pop(context, cartItem);
    });
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    // Mostrar feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite ? 'Agregado a favoritos' : 'Removido de favoritos',
        ),
        backgroundColor: const Color(0xFF05386B),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  double get subtotal => widget.product.price * _quantity;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    final appBarHeight = AppBar().preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final totalAppBarHeight = appBarHeight + statusBarHeight;

    final bannerHeight = 200.0;

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // AppBar con imagen del producto
          SliverAppBar(
            expandedHeight: bannerHeight,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: _scrollOffset > bannerHeight - totalAppBarHeight
                  ? Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
              background: _buildProductImages(),
            ),
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
              // IconButton(
              //   icon: Container(
              //     padding: const EdgeInsets.all(6),
              //     decoration: BoxDecoration(
              //       color: Colors.black.withOpacity(0.5),
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //     child: const Icon(Icons.share_outlined, color: Colors.white),
              //   ),
              //   onPressed: () {
              //     // Compartir producto
              //   },
              // ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    _isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                    color: _isFavorite ? Colors.red : Colors.white,
                  ),
                ),
                onPressed: _toggleFavorite,
              ),
            ],
          ),

          // Contenido principal
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre del producto y tienda
                  _buildProductHeader(product),

                  // Precio y rating
                  _buildPriceAndRating(product),

                  // Selector de cantidad
                  _buildQuantitySelector(),

                  // Descripción del producto
                  _buildProductDescription(product),

                  // Especificaciones
                  _buildSpecifications(),

                  // Información nutricional
                  _buildNutritionInfo(),

                  // Reviews (opcional)
                  _buildReviewsSection(),
                ],
              ),
            ),
          ),
        ],
      ),

      // Barra inferior fija con precio y botón
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // Banner de imágenes del producto
  Widget _buildProductImages() {
    return Stack(
      children: [
        // Carousel de imágenes
        PageView.builder(
          controller: _imagePageController,
          itemCount: productImages.length,
          onPageChanged: (index) {
            setState(() {
              _currentImageIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return Container(
              color: Colors.grey[100],
              child: Center(
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 150,
                  color: Colors.grey[300],
                ),
              ),
            );
          },
        ),

        // Indicador de página
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              productImages.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentImageIndex == index
                      ? const Color(0xFFFF6B00)
                      : Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ),

        // Badge de descuento (si aplica)
        if (widget.product.originalPrice != null &&
            widget.product.originalPrice! > widget.product.price)
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B00),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '-${((1 - widget.product.price / widget.product.originalPrice!) * 100).toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Header del producto con nombre y tienda
  Widget _buildProductHeader(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Categoría
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF05386B).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            product.category,
            style: const TextStyle(
              color: Color(0xFF05386B),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Nombre del producto
        Text(
          product.name,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF05386B),
            height: 1.2,
          ),
        ),

        const SizedBox(height: 8),

        // Tienda que lo vende
        GestureDetector(
          onTap: () {
            // Navegar a la tienda
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StoreScreen(
                  storeName: product.storeName,
                  storeCategory: product.category,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF05386B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.store_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.storeName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF05386B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.storeCategory,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_outlined,
                  color: Color(0xFF05386B),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Precio y rating del producto
  Widget _buildPriceAndRating(Product product) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(16),
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
          // Precio
          Row(
            children: [
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF05386B),
                ),
              ),
              if (product.originalPrice != null)
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    '\$${product.originalPrice!.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[500],
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ),
              const Spacer(),
              // Stock
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: product.stock > 10
                      ? Colors.green[50]
                      : product.stock > 0
                      ? Colors.orange[50]
                      : Colors.red[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  product.stock > 0 ? '${product.stock} en stock' : 'Agotado',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: product.stock > 10
                        ? Colors.green[700]
                        : product.stock > 0
                        ? Colors.orange[700]
                        : Colors.red[700],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Rating y otras métricas
          Row(
            children: [
              // Rating
              _buildMetricItem(
                Icons.star,
                product.rating.toStringAsFixed(1),
                'Rating',
                Colors.amber,
              ),

              const SizedBox(width: 24),

              // Ventas
              _buildMetricItem(
                Icons.shopping_bag_outlined,
                '${product.salesCount}+',
                'Ventas',
                const Color(0xFF05386B),
              ),

              const SizedBox(width: 24),

              // Tiempo de entrega
              _buildMetricItem(
                Icons.timer_outlined,
                '${product.deliveryTime} min',
                'Entrega',
                const Color(0xFFFF6B00),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Item de métrica
  Widget _buildMetricItem(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  // Selector de cantidad
  Widget _buildQuantitySelector() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(16),
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
            'Cantidad',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF05386B),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              // Botón disminuir
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _quantity > 1
                      ? const Color(0xFF05386B).withOpacity(0.1)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.remove, color: Color(0xFF05386B)),
                  onPressed: _quantity > 1
                      ? () {
                          setState(() {
                            _quantity--;
                          });
                        }
                      : null,
                ),
              ),

              // Cantidad actual
              Expanded(
                child: Center(
                  child: Text(
                    '$_quantity',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF05386B),
                    ),
                  ),
                ),
              ),

              // Botón aumentar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF05386B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Color(0xFF05386B)),
                  onPressed: () {
                    setState(() {
                      _quantity++;
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Subtotal
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF05386B).withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Subtotal',
                  style: TextStyle(fontSize: 16, color: Color(0xFF05386B)),
                ),
                Text(
                  '\$${subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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

  // Descripción del producto
  Widget _buildProductDescription(Product product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Descripción',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF05386B),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            product.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),

          const SizedBox(height: 12),

          // Características destacadas
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFeatureChip('✅ Fresco diario'),
              _buildFeatureChip('✅ 100% Natural'),
              _buildFeatureChip('✅ Sin conservantes'),
              _buildFeatureChip('✅ Envasado higiénico'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF05386B).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFF05386B), fontSize: 13),
      ),
    );
  }

  // Especificaciones del producto
  Widget _buildSpecifications() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Especificaciones',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF05386B),
            ),
          ),

          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3,
            ),
            itemCount: specifications.length,
            itemBuilder: (context, index) {
              final spec = specifications[index];
              return _buildSpecItem(spec);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSpecItem(ProductSpec spec) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              spec.label,
              style: const TextStyle(
                color: Color(0xFF05386B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            spec.value,
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Información nutricional
  Widget _buildNutritionInfo() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información Nutricional',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF05386B),
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
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
              children: nutritionInfo
                  .map((info) => _buildNutritionRow(info))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionRow(NutritionInfo info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            info.nutrient,
            style: TextStyle(color: Colors.grey[700], fontSize: 15),
          ),
          Text(
            info.value,
            style: const TextStyle(
              color: Color(0xFF05386B),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  // Sección de reviews (opcional)
  Widget _buildReviewsSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 100), // Espacio para el bottom bar
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Reseñas (42)',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF05386B),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Ver todas las reseñas
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

          const SizedBox(height: 12),

          // Review de ejemplo
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const Icon(Icons.star_half, color: Colors.amber, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      '4.5',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Excelente producto, muy fresco y de buena calidad. Lo recomiendo totalmente.',
                  style: TextStyle(color: Color(0xFF05386B)),
                ),
                const SizedBox(height: 8),
                Text(
                  'Por Juan Pérez • Hace 2 días',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Barra inferior fija
  Widget _buildBottomBar() {
    return Container(
      height: 90,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Precio total
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  Text(
                    '\$${subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF05386B),
                    ),
                  ),
                ],
              ),
            ),

            // Botón agregar al carrito
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: widget.product.stock > 0 ? _addToCart : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.product.stock > 0
                      ? const Color(0xFFFF6B00)
                      : Colors.grey[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_cart_outlined, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      widget.product.stock > 0
                          ? 'Agregar al Carrito'
                          : 'Agotado',
                      style: const TextStyle(
                        fontSize: 16,
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
    );
  }
}

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
  storeName: 'Pulpería "El Buen Precio"',
  storeCategory: 'Supermercado',
  isFavorite: false,
  rating: 4.5,
  stock: 15,
  unit: 'litro',
  salesCount: 342,
  deliveryTime: 20,
);
