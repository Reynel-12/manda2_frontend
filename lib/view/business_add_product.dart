import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountPercentageController =
      TextEditingController();
  final TextEditingController _finalPriceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();

  String? _selectedCategory;
  String? _selectedUnit;
  bool _isAvailable = true;
  bool _isFeatured = false;
  bool _hasDiscount = false;
  List<String> _productImages = [];

  final List<String> _categories = [
    'Comida Rápida',
    'Bebidas',
    'Postres',
    'Platillos Principales',
    'Ensaladas',
    'Snacks',
    'Especialidades',
    'Otros',
  ];

  final List<String> _units = [
    'Unidad',
    'Kilogramo (kg)',
    'Gramo (g)',
    'Litro (L)',
    'Mililitro (mL)',
    'Paquete',
    'Docena',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountPercentageController.dispose();
    _finalPriceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_productImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, agrega al menos una imagen del producto'),
            backgroundColor: Color(0xFFFF6B00),
          ),
        );
        return;
      }

      // En una aplicación real, aquí enviaríamos los datos al servidor
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Producto creado exitosamente'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );

      // Limpiar formulario después del envío exitoso
      _formKey.currentState!.reset();
      setState(() {
        _productImages.clear();
        _selectedCategory = null;
        _selectedUnit = null;
        _isAvailable = true;
        _isFeatured = false;
        _hasDiscount = false;
        _discountPercentageController.clear();
        _finalPriceController.clear();
      });
    }
  }

  void _addMockImage() {
    // En una aplicación real, aquí se implementaría la selección de imágenes
    // de la galería o cámara
    setState(() {
      _productImages.add(
        'https://ilacad.com/BO/data/logos_cadenas/logo_la_colonia_honduras.jpg',
      );
    });
  }

  void _removeImage(int index) {
    setState(() {
      _productImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Producto'),
        // centerTitle: true,
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.help_outline)),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 600 ? 40 : 16,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'Información del Producto',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF05386B),
                ),
              ),
            ),

            // Subtítulo
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                'Completa todos los campos para agregar un nuevo producto a tu catálogo',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ),

            // Formulario
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sección de imágenes
                  _buildImageSection(context),

                  // Nombre del producto
                  _buildTextField(
                    controller: _nameController,
                    label: 'Nombre del Producto',
                    hintText: 'Ej: Pizza Margarita',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa el nombre del producto';
                      }
                      return null;
                    },
                  ),

                  // Descripción
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Descripción',
                    hintText: 'Describe tu producto de manera detallada',
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa una descripción';
                      }
                      if (value.length < 10) {
                        return 'La descripción debe tener al menos 10 caracteres';
                      }
                      return null;
                    },
                  ),

                  // Categoría y Unidad en fila para pantallas grandes
                  MediaQuery.of(context).size.width > 600
                      ? _buildCategoryUnitRow()
                      : Column(
                          children: [
                            // Categoría
                            _buildDropdown(
                              value: _selectedCategory,
                              items: _categories,
                              label: 'Categoría',
                              hint: 'Selecciona una categoría',
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor selecciona una categoría';
                                }
                                return null;
                              },
                            ),

                            // Unidad
                            _buildTextField(
                              controller: _unitController,
                              label: 'Unidad',
                              hintText: 'Ej: kg, g, L, mL, paquete, docena',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa la unidad';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),

                  // Precio y Stock en fila para pantallas grandes
                  MediaQuery.of(context).size.width > 600
                      ? _buildPriceStockRow()
                      : Column(
                          children: [
                            // Precio
                            _buildTextField(
                              controller: _priceController,
                              label: 'Precio (\$)',
                              hintText: '0.00',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              prefixText: '\$ ',
                              onChanged: (value) {
                                if (_hasDiscount)
                                  _updateDiscountCalculations(
                                    fromBasePrice: true,
                                  );
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa el precio';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Por favor ingresa un número válido';
                                }
                                if (double.parse(value) <= 0) {
                                  return 'El precio debe ser mayor a 0';
                                }
                                return null;
                              },
                            ),

                            // Sección de Descuento
                            _buildDiscountSection(),

                            // Stock
                            _buildTextField(
                              controller: _stockController,
                              label: 'Stock Disponible',
                              hintText: '0',
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa el stock disponible';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Por favor ingresa un número válido';
                                }
                                if (int.parse(value) < 0) {
                                  return 'El stock no puede ser negativo';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),

                  // Checkboxes
                  _buildCheckboxesSection(),

                  // Botón de envío
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B00),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Guardar Producto',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Imágenes del Producto',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF05386B),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Agrega imágenes de alta calidad de tu producto',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),

        // Grid de imágenes reemplazado por Wrap
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ...List.generate(_productImages.length, (index) {
              return Stack(
                children: [
                  Container(
                    width:
                        (MediaQuery.of(context).size.width -
                            (MediaQuery.of(context).size.width > 600
                                ? 120
                                : 64)) /
                        (MediaQuery.of(context).size.width > 600 ? 4 : 3),
                    height:
                        (MediaQuery.of(context).size.width -
                            (MediaQuery.of(context).size.width > 600
                                ? 120
                                : 64)) /
                        (MediaQuery.of(context).size.width > 600 ? 4 : 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(_productImages[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removeImage(index),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.close,
                          color: Color(0xFFFF6B00),
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
            GestureDetector(
              onTap: _addMockImage,
              child: Container(
                width:
                    (MediaQuery.of(context).size.width -
                        (MediaQuery.of(context).size.width > 600 ? 120 : 64)) /
                    (MediaQuery.of(context).size.width > 600 ? 4 : 3),
                height:
                    (MediaQuery.of(context).size.width -
                        (MediaQuery.of(context).size.width > 600 ? 120 : 64)) /
                    (MediaQuery.of(context).size.width > 600 ? 4 : 3),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF05386B), width: 2),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      color: Color(0xFF05386B),
                      size: 32,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Agregar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF05386B),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? prefixText,
    void Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF05386B),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            inputFormatters: keyboardType == TextInputType.number
                ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
                : null,
            decoration: InputDecoration(
              hintText: hintText,
              prefixText: prefixText,
            ),
            validator: validator,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String label,
    required String hint,
    required void Function(String?) onChanged,
    required String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF05386B),
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            items: items.map((String item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: validator,
            isExpanded: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryUnitRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _buildDropdown(
              value: _selectedCategory,
              items: _categories,
              label: 'Categoría',
              hint: 'Selecciona una categoría',
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor selecciona una categoría';
                }
                return null;
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: _buildDropdown(
              value: _selectedUnit,
              items: _units,
              label: 'Unidad de Medida',
              hint: 'Selecciona una unidad',
              onChanged: (value) {
                setState(() {
                  _selectedUnit = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor selecciona una unidad';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceStockRow() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildTextField(
                  controller: _priceController,
                  label: 'Precio (\$)',
                  hintText: '0.00',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  prefixText: '\$ ',
                  onChanged: (value) {
                    if (_hasDiscount)
                      _updateDiscountCalculations(fromBasePrice: true);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el precio';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor ingresa un número válido';
                    }
                    if (double.parse(value) <= 0) {
                      return 'El precio debe ser mayor a 0';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _buildTextField(
                  controller: _stockController,
                  label: 'Stock Disponible',
                  hintText: '0',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el stock disponible';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Por favor ingresa un número válido';
                    }
                    if (int.parse(value) < 0) {
                      return 'El stock no puede ser negativo';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ],
        ),
        _buildDiscountSection(),
      ],
    );
  }

  Widget _buildDiscountSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF05386B).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF05386B).withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.local_offer_outlined,
                    color: Color(0xFF05386B),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Aplicar Descuento',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF05386B),
                    ),
                  ),
                ],
              ),
              Switch(
                value: _hasDiscount,
                activeColor: const Color(0xFFFF6B00),
                onChanged: (value) {
                  setState(() {
                    _hasDiscount = value;
                    if (!_hasDiscount) {
                      _discountPercentageController.clear();
                      _finalPriceController.clear();
                    }
                  });
                },
              ),
            ],
          ),
          if (_hasDiscount) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _discountPercentageController,
                    label: 'Descuento (%)',
                    hintText: '0',
                    keyboardType: TextInputType.number,
                    prefixText: '% ',
                    onChanged: (value) =>
                        _updateDiscountCalculations(fromPercentage: true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _finalPriceController,
                    label: 'Precio Final (\$)',
                    hintText: '0.00',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    prefixText: '\$ ',
                    onChanged: (value) =>
                        _updateDiscountCalculations(fromFinalPrice: true),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _updateDiscountCalculations({
    bool fromBasePrice = false,
    bool fromPercentage = false,
    bool fromFinalPrice = false,
  }) {
    double basePrice = double.tryParse(_priceController.text) ?? 0;
    if (basePrice <= 0) return;

    setState(() {
      if (fromPercentage || fromBasePrice) {
        double percentage =
            double.tryParse(_discountPercentageController.text) ?? 0;
        if (percentage > 100) percentage = 100;
        double finalPrice = basePrice * (1 - (percentage / 100));
        _finalPriceController.text = finalPrice.toStringAsFixed(2);
      } else if (fromFinalPrice) {
        double finalPrice = double.tryParse(_finalPriceController.text) ?? 0;
        if (finalPrice > basePrice) finalPrice = basePrice;
        double percentage = (1 - (finalPrice / basePrice)) * 100;
        _discountPercentageController.text = percentage.toStringAsFixed(0);
      }
    });
  }

  Widget _buildCheckboxesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Opciones del Producto',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF05386B),
          ),
        ),
        const SizedBox(height: 8),

        // Checkbox de disponibilidad
        Row(
          children: [
            Checkbox(
              value: _isAvailable,
              activeColor: const Color(0xFF05386B),
              onChanged: (value) {
                setState(() {
                  _isAvailable = value ?? false;
                });
              },
            ),
            const Expanded(
              child: Text(
                'Mostrar producto como disponible',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),

        // Checkbox de destacado
        Row(
          children: [
            Checkbox(
              value: _isFeatured,
              activeColor: const Color(0xFFFF6B00),
              onChanged: (value) {
                setState(() {
                  _isFeatured = value ?? false;
                });
              },
            ),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Destacar este producto',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'El producto aparecerá como destacado en su tienda',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
