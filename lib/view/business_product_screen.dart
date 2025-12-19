import 'package:flutter/material.dart';
import 'package:manda2_frontend/view/business_add_product.dart';

class BusinessProductsScreen extends StatefulWidget {
  const BusinessProductsScreen({Key? key}) : super(key: key);

  @override
  State<BusinessProductsScreen> createState() => _BusinessProductsScreenState();
}

class _BusinessProductsScreenState extends State<BusinessProductsScreen> {
  List<BusinessProduct> _products = [];
  String _selectedCategory = 'Todos';
  String _selectedAvailability = 'Todos';
  bool _isGridView = false;

  List<String> _categories = [
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
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _unitController.dispose();
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
    var filtered = _products;

    // Filtrar por categoría
    if (_selectedCategory != 'Todos') {
      filtered = filtered
          .where((product) => product.category == _selectedCategory)
          .toList();
    }

    // Filtrar por disponibilidad
    if (_selectedAvailability != 'Todos') {
      final isAvailable = _selectedAvailability == 'Disponible';
      filtered = filtered
          .where((product) => product.isAvailable == isAvailable)
          .toList();
    }

    return filtered;
  }

  void _toggleGridView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

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
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final filteredProducts = _filteredProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Productos'),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Botón para cambiar vista
          IconButton(
            icon: Icon(
              _isGridView ? Icons.list_outlined : Icons.grid_view_outlined,
              color: Colors.white,
            ),
            onPressed: _toggleGridView,
            tooltip: _isGridView ? 'Vista de lista' : 'Vista de grid',
          ),
          // Botón para agregar producto
          IconButton(
            icon: const Icon(Icons.add_circle_outlined),
            // onPressed: _addNewProduct,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductFormScreen()),
              );
            },
            tooltip: 'Agregar producto',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros
          _buildFiltersSection(),

          // Resumen
          _buildSummarySection(),

          // Lista de productos
          Expanded(
            child: filteredProducts.isEmpty
                ? _buildEmptyState()
                : _isGridView
                ? _buildProductsGrid(isTablet)
                : _buildProductsList(isTablet),
          ),
        ],
      ),

      // Botón flotante para agregar producto
      // floatingActionButton: FloatingActionButton.extended(
      //   // onPressed: _addNewProduct,
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => ProductFormScreen()),
      //     );
      //   },
      //   backgroundColor: const Color(0xFFFF6B00),
      //   icon: const Icon(Icons.add),
      //   label: const Text('Agregar Producto'),
      // ),
    );
  }

  // Sección de filtros
  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filtrar Productos',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF05386B),
                ),
              ),
              IconButton(
                onPressed: _showManageCategoriesDialog,
                icon: const Icon(Icons.settings_outlined, size: 20),
                color: const Color(0xFF05386B),
                tooltip: 'Gestionar categorías',
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Filtro por categoría
          Row(
            children: [
              const Icon(
                Icons.category_outlined,
                color: Color(0xFF05386B),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Categoría:',
                style: TextStyle(fontSize: 14, color: Color(0xFF05386B)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) {
                      final isSelected = category == _selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: const Color(
                            0xFF05386B,
                          ).withOpacity(0.2),
                          checkmarkColor: const Color(0xFF05386B),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? const Color(0xFF05386B)
                                : const Color(0xFF05386B),
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? const Color(0xFF05386B)
                                : Colors.grey[300]!,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Filtro por disponibilidad
          Row(
            children: [
              const Icon(
                Icons.inventory_outlined,
                color: Color(0xFF05386B),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Disponibilidad:',
                style: TextStyle(fontSize: 14, color: Color(0xFF05386B)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _availabilityFilters.map((filter) {
                      final isSelected = filter == _selectedAvailability;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() {
                              _selectedAvailability = filter;
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: const Color(
                            0xFF05386B,
                          ).withOpacity(0.2),
                          checkmarkColor: const Color(0xFF05386B),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? const Color(0xFF05386B)
                                : const Color(0xFF05386B),
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? const Color(0xFF05386B)
                                : Colors.grey[300]!,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Resumen de productos
  Widget _buildSummarySection() {
    final availableProducts = _products.where((p) => p.isAvailable).length;
    final outOfStockProducts = _products.length - availableProducts;
    final featuredProducts = _products.where((p) => p.isFeatured).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            _products.length.toString(),
            'Productos totales',
            Icons.shopping_bag_outlined,
            const Color(0xFF05386B),
          ),
          _buildSummaryItem(
            availableProducts.toString(),
            'Disponibles',
            Icons.check_circle_outlined,
            Colors.green,
          ),
          _buildSummaryItem(
            outOfStockProducts.toString(),
            'Agotados',
            Icons.cancel_outlined,
            Colors.orange,
          ),
          _buildSummaryItem(
            featuredProducts.toString(),
            'Destacados',
            Icons.star_outlined,
            const Color(0xFFFF6B00),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
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
    );
  }

  // Estado vacío
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 24),
            Text(
              _selectedCategory != 'Todos' || _selectedAvailability != 'Todos'
                  ? 'No hay productos con estos filtros'
                  : 'No hay productos registrados',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF05386B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _selectedCategory != 'Todos' || _selectedAvailability != 'Todos'
                  ? 'Intenta con otros filtros o agrega nuevos productos'
                  : 'Agrega tu primer producto para comenzar',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                // textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            if (_selectedCategory != 'Todos' ||
                _selectedAvailability != 'Todos')
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedCategory = 'Todos';
                    _selectedAvailability = 'Todos';
                  });
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
                  'Ver Todos los Productos',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showAddCategoryDialog({Function(String)? onAdded}) {
    final TextEditingController categoryController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Nueva Categoría',
          style: TextStyle(
            color: Color(0xFF05386B),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: categoryController,
          decoration: const InputDecoration(
            labelText: 'Nombre de la categoría',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              final name = categoryController.text.trim();
              if (name.isNotEmpty) {
                if (!_categories.contains(name)) {
                  setState(() {
                    _categories.add(name);
                  });
                  if (onAdded != null) onAdded(name);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('La categoría ya existe')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B00),
            ),
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  void _showManageCategoriesDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text(
            'Gestionar Categorías',
            style: TextStyle(
              color: Color(0xFF05386B),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      if (category == 'Todos') return const SizedBox.shrink();
                      return ListTile(
                        title: Text(category),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            // Verificar si hay productos usando esta categoría
                            final hasProducts = _products.any(
                              (p) => p.category == category,
                            );
                            if (hasProducts) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'No se puede eliminar una categoría en uso',
                                  ),
                                ),
                              );
                              return;
                            }
                            setState(() {
                              _categories.removeAt(index);
                            });
                            setDialogState(() {});
                          },
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.add, color: Color(0xFFFF6B00)),
                  title: const Text(
                    'Agregar nueva categoría',
                    style: TextStyle(color: Color(0xFFFF6B00)),
                  ),
                  onTap: () => _showAddCategoryDialog(
                    onAdded: (_) => setDialogState(() {}),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cerrar',
                style: TextStyle(color: Color(0xFF05386B)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Lista de productos
  Widget _buildProductsList(bool isTablet) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return _buildProductCard(product, isList: true);
      },
    );
  }

  // Grid de productos
  Widget _buildProductsGrid(bool isTablet) {
    final crossAxisCount = MediaQuery.of(context).size.width >= 900
        ? 3
        : isTablet
        ? 2
        : 1;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: isTablet ? 0.85 : 1.2,
      ),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return _buildProductCard(product, isList: false);
      },
    );
  }

  // Tarjeta de producto
  Widget _buildProductCard(BusinessProduct product, {bool isList = true}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del producto
          Stack(
            children: [
              Container(
                height: isList ? 120 : 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: 50,
                    color: Colors.grey[400],
                  ),
                ),
              ),

              // Badges
              Positioned(
                top: 8,
                left: 8,
                child: Row(
                  children: [
                    if (product.isFeatured)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B00),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'DESTACADO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (product.originalPrice != null)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '-${((1 - product.price / product.originalPrice!) * 100).toInt()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: product.isAvailable ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    product.isAvailable ? 'DISPONIBLE' : 'AGOTADO',
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

          // Contenido
          // Contenido
          isList
              ? _buildCardContent(product, isList)
              : Expanded(child: _buildCardContent(product, isList)),
        ],
      ),
    );
  }

  Widget _buildCardContent(BusinessProduct product, bool isList) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre y categoría
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
            product.category,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),

          const SizedBox(height: 8),

          // Descripción (solo en vista de lista)
          if (isList)
            Text(
              product.description,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

          const SizedBox(height: 8),

          // Precio y stock
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          padding: const EdgeInsets.only(left: 4),
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
                  const SizedBox(height: 4),
                  Text(
                    '${product.stock} ${product.unit} disponibles',
                    style: TextStyle(
                      fontSize: 12,
                      color: product.stock < 5 ? Colors.red : Colors.grey[600],
                      fontWeight: product.stock < 5
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),

              // Botones de acción
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: Color(0xFF05386B),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductFormScreen(),
                        ),
                      );
                    },
                    tooltip: 'Editar',
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    onSelected: (value) {
                      switch (value) {
                        case 'availability':
                          _toggleProductAvailability(product.id);
                          break;
                        case 'featured':
                          _toggleFeatured(product.id);
                          break;
                        case 'images':
                          _showImageUploadDialog(product.id);
                          break;
                        case 'discount':
                          _showDiscountDialog(product);
                          break;
                        case 'delete':
                          _deleteProduct(product.id);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'availability',
                        child: Row(
                          children: [
                            Icon(
                              product.isAvailable
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey[700],
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              product.isAvailable
                                  ? 'Marcar agotado'
                                  : 'Marcar disponible',
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'featured',
                        child: Row(
                          children: [
                            Icon(
                              product.isFeatured
                                  ? Icons.star_border
                                  : Icons.star,
                              color: Colors.grey[700],
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              product.isFeatured
                                  ? 'Quitar destacado'
                                  : 'Destacar',
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'discount',
                        child: Row(
                          children: [
                            Icon(
                              Icons.local_offer_outlined,
                              color: Colors.grey[700],
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              product.originalPrice != null
                                  ? 'Editar descuento'
                                  : 'Aplicar descuento',
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Eliminar',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
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
