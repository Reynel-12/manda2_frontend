import 'package:flutter/material.dart';
import 'package:manda2_frontend/view/business/business_add_product.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class BusinessProductsScreen extends StatefulWidget {
  const BusinessProductsScreen({Key? key}) : super(key: key);

  @override
  State<BusinessProductsScreen> createState() => _BusinessProductsScreenState();
}

class _BusinessProductsScreenState extends State<BusinessProductsScreen>
    with TickerProviderStateMixin {
  List<BusinessProduct> _products = [];
  String _selectedCategory = 'Todos';
  String _selectedAvailability = 'Todos';
  String _searchQuery = '';
  String _sortBy = 'Nombre'; // Nuevo: sort options
  // bool _isGridView = true; // Default to grid for better UX

  late AnimationController _animationController;

  final List<String> _categories = [
    'Todos',
    'Lácteos',
    'Panadería',
    'Bebidas',
    'Enlatados',
    'Snacks',
    'Limpieza',
    'Carnes',
  ];
  final List<String> _availabilityFilters = ['Todos', 'Disponible', 'Agotado'];
  final List<String> _sortOptions = ['Nombre', 'Ventas', 'Rating', 'Stock'];

  // Controladores para el diálogo de agregar/editar
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _unitController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _loadProducts() {
    // Productos de ejemplo
    _products = [
      BusinessProduct(
        id: '1',
        name: 'Leche Entera 1L',
        description: 'Leche fresca pasteurizada',
        price: 2.50,
        originalPrice: 2.80,
        category: 'Lácteos',
        unit: 'litro',
        stock: 20,
        isAvailable: true,
        images: [],
        rating: 4.5,
        salesCount: 342,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        isFeatured: true,
      ),
      BusinessProduct(
        id: '2',
        name: 'Pan Integral Fresco',
        description: 'Pan integral recién horneado',
        price: 1.75,
        category: 'Panadería',
        unit: 'bolsa',
        stock: 15,
        isAvailable: true,
        images: [],
        rating: 4.2,
        salesCount: 215,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        isFeatured: false,
      ),
      BusinessProduct(
        id: '3',
        name: 'Huevos Blancos x12',
        description: 'Huevos frescos grado A',
        price: 3.20,
        category: 'Lácteos',
        unit: 'docena',
        stock: 8,
        isAvailable: true,
        images: [],
        rating: 4.7,
        salesCount: 189,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        isFeatured: true,
      ),
      BusinessProduct(
        id: '4',
        name: 'Jugo de Naranja 100%',
        description: 'Jugo natural sin conservantes',
        price: 3.50,
        originalPrice: 3.90,
        category: 'Bebidas',
        unit: 'caja',
        stock: 0,
        isAvailable: false,
        images: [],
        rating: 4.4,
        salesCount: 156,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        isFeatured: false,
      ),
      BusinessProduct(
        id: '5',
        name: 'Galletas de Chocolate',
        description: 'Galletas con chispas de chocolate',
        price: 2.20,
        category: 'Snacks',
        unit: 'paquete',
        stock: 30,
        isAvailable: true,
        images: [],
        rating: 4.6,
        salesCount: 278,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        isFeatured: true,
      ),
      BusinessProduct(
        id: '6',
        name: 'Arroz Integral 5kg',
        description: 'Arroz integral de grano largo',
        price: 7.50,
        originalPrice: 8.90,
        category: 'Enlatados',
        unit: 'bolsa',
        stock: 12,
        isAvailable: true,
        images: [],
        rating: 4.3,
        salesCount: 94,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        isFeatured: false,
      ),
      BusinessProduct(
        id: '7',
        name: 'Detergente Líquido 2L',
        description: 'Detergente para ropa concentrado',
        price: 6.80,
        category: 'Limpieza',
        unit: 'botella',
        stock: 10,
        isAvailable: true,
        images: [],
        rating: 4.5,
        salesCount: 67,
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
        isFeatured: false,
      ),
      BusinessProduct(
        id: '8',
        name: 'Pechuga de Pollo 1kg',
        description: 'Pechuga de pollo fresca',
        price: 7.90,
        category: 'Carnes',
        unit: 'kg',
        stock: 6,
        isAvailable: true,
        images: [],
        rating: 4.7,
        salesCount: 123,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        isFeatured: true,
      ),
    ];
  }

  List<BusinessProduct> get _filteredProducts {
    var filtered = _products.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchesCategory =
          _selectedCategory == 'Todos' || p.category == _selectedCategory;
      final matchesAvailability =
          _selectedAvailability == 'Todos' ||
          (_selectedAvailability == 'Disponible'
              ? p.isAvailable
              : !p.isAvailable);
      return matchesSearch && matchesCategory && matchesAvailability;
    }).toList();

    // Sort
    filtered.sort((a, b) {
      switch (_sortBy) {
        case 'Ventas':
          return b.salesCount.compareTo(a.salesCount);
        case 'Rating':
          return b.rating.compareTo(a.rating);
        case 'Stock':
          return b.stock.compareTo(a.stock);
        default:
          return a.name.compareTo(b.name);
      }
    });

    return filtered;
  }

  // void _toggleView() {
  //   setState(() => _isGridView = !_isGridView);
  //   _animationController.reset();
  //   _animationController.forward();
  // }

  void _toggleProductAvailability(String productId) {
    final productIndex = _products.indexWhere(
      (product) => product.id == productId,
    );
    if (productIndex != -1) {
      setState(() {
        _products[productIndex] = _products[productIndex].copyWith(
          isAvailable: !_products[productIndex].isAvailable,
        );
      });

      final product = _products[productIndex];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            product.isAvailable
                ? '${product.name} ahora está disponible'
                : '${product.name} marcado como agotado',
          ),
          backgroundColor: const Color(0xFF05386B),
        ),
      );
    }
  }

  void _deleteProduct(String productId) {
    final productIndex = _products.indexWhere(
      (product) => product.id == productId,
    );
    if (productIndex != -1) {
      final productName = _products[productIndex].name;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Eliminar Producto',
            style: TextStyle(
              color: Color(0xFF05386B),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '¿Estás seguro de que quieres eliminar "$productName"?',
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
                setState(() {
                  _products.removeAt(productIndex);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('"$productName" eliminado'),
                    backgroundColor: const Color(0xFF05386B),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        ),
      );
    }
  }

  void _toggleFeatured(String productId) {
    final productIndex = _products.indexWhere(
      (product) => product.id == productId,
    );
    if (productIndex != -1) {
      setState(() {
        _products[productIndex] = _products[productIndex].copyWith(
          isFeatured: !_products[productIndex].isFeatured,
        );
      });

      final product = _products[productIndex];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            product.isFeatured
                ? '${product.name} destacado'
                : '${product.name} removido de destacados',
          ),
          backgroundColor: const Color(0xFF05386B),
        ),
      );
    }
  }

  void _showDiscountDialog(BusinessProduct product) {
    final TextEditingController discountController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    double originalPrice = product.originalPrice ?? product.price;

    // Si ya tiene descuento, inicializar controladores
    if (product.originalPrice != null) {
      priceController.text = product.price.toStringAsFixed(2);
      double discountPercent =
          (1 - (product.price / product.originalPrice!)) * 100;
      discountController.text = discountPercent.toStringAsFixed(0);
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            product.originalPrice != null
                ? 'Editar Descuento'
                : 'Aplicar Descuento',
            style: const TextStyle(
              color: Color(0xFF05386B),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Precio original: \$${originalPrice.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),

              // Campo para porcentaje
              TextField(
                controller: discountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Porcentaje de descuento (%)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.percent),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    double percent = double.tryParse(value) ?? 0;
                    if (percent > 100) percent = 100;
                    double newPrice = originalPrice * (1 - (percent / 100));
                    priceController.text = newPrice.toStringAsFixed(2);
                  } else {
                    priceController.clear();
                  }
                },
              ),
              const SizedBox(height: 16),

              const Center(child: Text('O')),
              const SizedBox(height: 16),

              // Campo para precio final
              TextField(
                controller: priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Nuevo precio con descuento (\$)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    double newPrice = double.tryParse(value) ?? 0;
                    if (newPrice > originalPrice) newPrice = originalPrice;
                    double percent = (1 - (newPrice / originalPrice)) * 100;
                    discountController.text = percent.toStringAsFixed(0);
                  } else {
                    discountController.clear();
                  }
                },
              ),

              if (product.originalPrice != null) ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () {
                      final productIndex = _products.indexWhere(
                        (p) => p.id == product.id,
                      );
                      if (productIndex != -1) {
                        setState(() {
                          _products[productIndex] = _products[productIndex]
                              .copyWith(
                                price: originalPrice,
                                originalPrice: null,
                              );
                        });
                      }
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Descuento eliminado')),
                      );
                    },
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text(
                      'Eliminar descuento',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                double? newPrice = double.tryParse(priceController.text);
                if (newPrice != null && newPrice < originalPrice) {
                  final productIndex = _products.indexWhere(
                    (p) => p.id == product.id,
                  );
                  if (productIndex != -1) {
                    setState(() {
                      _products[productIndex] = _products[productIndex]
                          .copyWith(
                            price: newPrice,
                            originalPrice: originalPrice,
                          );
                    });
                  }
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Descuento aplicado a ${product.name}'),
                      backgroundColor: const Color(0xFF05386B),
                    ),
                  );
                } else if (newPrice != null && newPrice >= originalPrice) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'El precio con descuento debe ser menor al original',
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B00),
              ),
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageUploadDialog(String productId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Subir Imágenes',
          style: TextStyle(
            color: Color(0xFF05386B),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.photo_library_outlined,
              size: 60,
              color: Color(0xFF05386B),
            ),
            const SizedBox(height: 16),
            const Text('Selecciona imágenes desde tu galería'),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Función de subir imágenes en desarrollo',
                          ),
                          backgroundColor: Color(0xFF05386B),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF05386B)),
                    ),
                    child: const Text(
                      'Galería',
                      style: TextStyle(color: Color(0xFF05386B)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Función de tomar foto en desarrollo'),
                          backgroundColor: Color(0xFF05386B),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B00),
                    ),
                    child: const Text('Tomar Foto'),
                  ),
                ),
              ],
            ),
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
      appBar: AppBar(
        title: const Text('Mis Productos'),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProductFormScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(isDesktop || isTablet),
          Expanded(
            child: _filteredProducts.isEmpty
                ? _buildEmptyState()
                : AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: AnimationLimiter(
                      child: ListView.builder(
                        key: const ValueKey('list'),
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: _buildProductCard(product, isList: true),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(bool isWide) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: const InputDecoration(
              hintText: 'Buscar producto...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'Categoría:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories
                        .map(
                          (c) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(c),
                              selected: _selectedCategory == c,
                              onSelected: (_) =>
                                  setState(() => _selectedCategory = c),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'Disponibilidad:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _availabilityFilters
                        .map(
                          (f) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(f),
                              selected: _selectedAvailability == f,
                              onSelected: (_) =>
                                  setState(() => _selectedAvailability = f),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'Ordenar por:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButton<String>(
                  value: _sortBy,
                  items: _sortOptions
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) => setState(() => _sortBy = val!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
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
                Icons.inventory,
                size: 80,
                color: Color(0xFF05386B),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'No hay productos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF05386B),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Agrega tu primer producto para comenzar',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProductFormScreen()),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Agregar Producto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B00),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(BusinessProduct product, {bool isList = false}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: isList ? 80 : 70,
                  height: isList ? 80 : 70,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.image, size: 30, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      Text(
                        product.category,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onPressed: () => _showProductActions(product),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              product.description,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
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
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.inventory, color: Colors.grey, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Stock: ${product.stock}',
                    style: TextStyle(
                      fontSize: 13,
                      color: product.stock < 5 ? Colors.red : Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${product.rating} • ${product.salesCount} ventas',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ToggleButtons(
                  isSelected: [product.isAvailable, product.isFeatured],
                  onPressed: (i) {
                    if (i == 0) _toggleProductAvailability(product.id);
                    if (i == 1) _toggleFeatured(product.id);
                  },
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 32,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  children: const [
                    Icon(Icons.check_circle, size: 18),
                    Icon(Icons.star, size: 18),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showProductActions(BusinessProduct product) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Editar'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.discount),
            title: const Text('Descuento'),
            onTap: () => _showDiscountDialog(product),
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Imágenes'),
            onTap: () => _showImageUploadDialog(product.id),
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            onTap: () => _deleteProduct(product.id),
          ),
        ],
      ),
    );
  }

  // void _showAddCategoryDialog({Function(String)? onAdded}) {
  //   final TextEditingController categoryController = TextEditingController();
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text(
  //         'Nueva Categoría',
  //         style: TextStyle(
  //           color: Color(0xFF05386B),
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       content: TextField(
  //         controller: categoryController,
  //         decoration: const InputDecoration(
  //           labelText: 'Nombre de la categoría',
  //           border: OutlineInputBorder(),
  //         ),
  //         autofocus: true,
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             final name = categoryController.text.trim();
  //             if (name.isNotEmpty) {
  //               if (!_categories.contains(name)) {
  //                 setState(() {
  //                   _categories.add(name);
  //                 });
  //                 if (onAdded != null) onAdded(name);
  //                 Navigator.pop(context);
  //               } else {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   const SnackBar(content: Text('La categoría ya existe')),
  //                 );
  //               }
  //             }
  //           },
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: const Color(0xFFFF6B00),
  //           ),
  //           child: const Text('Agregar'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class BusinessProduct {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String category;
  final String unit;
  final int stock;
  final bool isAvailable;
  final List<String> images;
  final double rating;
  final int salesCount;
  final DateTime createdAt;
  final bool isFeatured;

  BusinessProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.category,
    required this.unit,
    required this.stock,
    required this.isAvailable,
    required this.images,
    required this.rating,
    required this.salesCount,
    required this.createdAt,
    this.isFeatured = false,
  });

  BusinessProduct copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    String? category,
    String? unit,
    int? stock,
    bool? isAvailable,
    List<String>? images,
    double? rating,
    int? salesCount,
    DateTime? createdAt,
    bool? isFeatured,
  }) {
    return BusinessProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      stock: stock ?? this.stock,
      isAvailable: isAvailable ?? this.isAvailable,
      images: images ?? this.images,
      rating: rating ?? this.rating,
      salesCount: salesCount ?? this.salesCount,
      createdAt: createdAt ?? this.createdAt,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }
}
