import 'package:flutter/material.dart';

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
  bool _isLoading = false;

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

  void _addNewProduct() {
    _clearForm();
    _showProductDialog(isEditing: false);
  }

  void _editProduct(BusinessProduct product) {
    _fillForm(product);
    _showProductDialog(isEditing: true, product: product);
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

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _stockController.clear();
    _unitController.clear();
  }

  void _fillForm(BusinessProduct product) {
    _nameController.text = product.name;
    _descriptionController.text = product.description;
    _priceController.text = product.price.toString();
    _stockController.text = product.stock.toString();
    _unitController.text = product.unit;
  }

  void _showProductDialog({required bool isEditing, BusinessProduct? product}) {
    String? selectedCategory = isEditing ? product?.category : null;
    bool isAvailable = isEditing ? product?.isAvailable ?? true : true;
    bool isFeatured = isEditing ? product?.isFeatured ?? false : false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                isEditing ? 'Editar Producto' : 'Agregar Producto',
                style: const TextStyle(
                  color: Color(0xFF05386B),
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imágenes del producto
                    _buildImageUploadSection(isEditing, product),

                    const SizedBox(height: 16),

                    // Nombre del producto
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del producto',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF05386B),
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el nombre';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // Descripción
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF05386B),
                            width: 2,
                          ),
                        ),
                      ),
                      maxLines: 3,
                    ),

                    const SizedBox(height: 12),

                    // Categoría
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Categoría',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF05386B),
                            width: 2,
                          ),
                        ),
                      ),
                      items: _categories.where((cat) => cat != 'Todos').map((
                        category,
                      ) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor selecciona una categoría';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // Precio y stock
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _priceController,
                            decoration: const InputDecoration(
                              labelText: 'Precio (\$)',
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF05386B),
                                  width: 2,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa el precio';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Precio inválido';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _stockController,
                            decoration: const InputDecoration(
                              labelText: 'Stock',
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF05386B),
                                  width: 2,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa el stock';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Stock inválido';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Unidad de medida
                    TextFormField(
                      controller: _unitController,
                      decoration: const InputDecoration(
                        labelText: 'Unidad (kg, litro, unidad, etc.)',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF05386B),
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa la unidad';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Opciones adicionales
                    Row(
                      children: [
                        Checkbox(
                          value: isAvailable,
                          onChanged: (value) {
                            setState(() {
                              isAvailable = value ?? true;
                            });
                          },
                          activeColor: const Color(0xFF05386B),
                        ),
                        const Text('Disponible'),

                        const SizedBox(width: 20),

                        Checkbox(
                          value: isFeatured,
                          onChanged: (value) {
                            setState(() {
                              isFeatured = value ?? false;
                            });
                          },
                          activeColor: const Color(0xFFFF6B00),
                        ),
                        const Text('Destacado'),
                      ],
                    ),
                  ],
                ),
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
                    if (_nameController.text.isNotEmpty &&
                        selectedCategory != null &&
                        _priceController.text.isNotEmpty &&
                        _stockController.text.isNotEmpty &&
                        _unitController.text.isNotEmpty) {
                      final newProduct = BusinessProduct(
                        id: isEditing
                            ? product!.id
                            : DateTime.now().millisecondsSinceEpoch.toString(),
                        name: _nameController.text,
                        description: _descriptionController.text,
                        price: double.parse(_priceController.text),
                        category: selectedCategory!,
                        unit: _unitController.text,
                        stock: int.parse(_stockController.text),
                        isAvailable: isAvailable,
                        images: [],
                        rating: isEditing ? product?.rating ?? 4.0 : 4.0,
                        salesCount: isEditing ? product?.salesCount ?? 0 : 0,
                        createdAt: isEditing
                            ? product!.createdAt
                            : DateTime.now(),
                        isFeatured: isFeatured,
                      );

                      if (isEditing) {
                        final productIndex = _products.indexWhere(
                          (p) => p.id == product!.id,
                        );
                        if (productIndex != -1) {
                          setState(() {
                            _products[productIndex] = newProduct;
                          });
                        }
                      } else {
                        setState(() {
                          _products.insert(0, newProduct);
                        });
                      }

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isEditing
                                ? 'Producto actualizado'
                                : 'Producto agregado',
                          ),
                          backgroundColor: const Color(0xFF05386B),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Por favor completa todos los campos obligatorios',
                          ),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B00),
                  ),
                  child: Text(isEditing ? 'Actualizar' : 'Agregar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildImageUploadSection(bool isEditing, BusinessProduct? product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Imágenes del producto',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF05386B),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.camera_alt_outlined,
                  color: Color(0xFF05386B),
                  size: 30,
                ),
                const SizedBox(height: 8),
                Text(
                  isEditing ? 'Cambiar imágenes' : 'Agregar imágenes',
                  style: const TextStyle(color: Color(0xFF05386B)),
                ),
              ],
            ),
          ),
        ),
      ],
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
            onPressed: _addNewProduct,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewProduct,
        backgroundColor: const Color(0xFFFF6B00),
        icon: const Icon(Icons.add),
        label: const Text('Agregar Producto'),
      ),
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
          const Text(
            'Filtrar Productos',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF05386B),
            ),
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
                    onPressed: () => _editProduct(product),
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
                        value: 'images',
                        child: Row(
                          children: [
                            Icon(
                              Icons.image_outlined,
                              color: Colors.grey[700],
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            const Text('Gestionar imágenes'),
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
