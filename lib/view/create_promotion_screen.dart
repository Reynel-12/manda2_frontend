import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreatePromotionScreen extends StatefulWidget {
  const CreatePromotionScreen({super.key});

  @override
  State<CreatePromotionScreen> createState() => _CreatePromotionScreenState();
}

class _CreatePromotionScreenState extends State<CreatePromotionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Tipos de promoción
  final List<String> _promotionTypes = [
    'Descuento Porcentual',
    'Descuento en Monto Fijo',
    '2x1',
    '3x2',
    'Combo Especial',
    'Envío Gratis',
    'Producto Gratis',
    'Happy Hour',
    'Promoción por Tiempo Limitado',
    'Oferta del Día',
  ];

  final List<String> _targetTypes = [
    'Todos los productos',
    'Categoría específica',
    'Producto específico',
    'Pedido mínimo',
    'Nuevos clientes',
    'Clientes recurrentes',
  ];

  // Estados del formulario
  String _selectedPromotionType = 'Descuento Porcentual';
  String _selectedTargetType = 'Todos los productos';
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _isActive = true;
  bool _isFeatured = false;
  bool _requiresCode = false;
  String? _selectedCategory;
  String? _selectedProduct;

  // Controladores
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _discountValueController =
      TextEditingController();
  final TextEditingController _minimumOrderController = TextEditingController();
  final TextEditingController _usageLimitController = TextEditingController();
  final TextEditingController _maxDiscountController = TextEditingController();

  // Imágenes de la promoción
  List<String> _promotionImages = [];

  // Categorías y productos de ejemplo
  final List<String> _categories = [
    'Comida Rápida',
    'Bebidas',
    'Postres',
    'Platillos Principales',
    'Ensaladas',
    'Snacks',
  ];

  final List<String> _products = [
    'Pizza Margarita',
    'Hamburguesa Clásica',
    'Ensalada César',
    'Refresco de Cola',
    'Helado de Vainilla',
    'Tacos al Pastor',
  ];

  @override
  void initState() {
    super.initState();
    // Establecer fechas por defecto
    _startDate = DateTime.now();
    _endDate = DateTime.now().add(const Duration(days: 7));
    _startTime = const TimeOfDay(hour: 9, minute: 0);
    _endTime = const TimeOfDay(hour: 21, minute: 0);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _codeController.dispose();
    _discountValueController.dispose();
    _minimumOrderController.dispose();
    _usageLimitController.dispose();
    _maxDiscountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate! : _endDate!,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF05386B)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime! : _endTime!,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF05386B)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _addPromotionImage() {
    // En una aplicación real, aquí se implementaría la selección de imágenes
    setState(() {
      _promotionImages.add(
        'https://via.placeholder.com/300x200/05386B/FFFFFF?text=Promo+${_promotionImages.length + 1}',
      );
    });
  }

  void _removePromotionImage(int index) {
    setState(() {
      _promotionImages.removeAt(index);
    });
  }

  void _submitPromotion() {
    if (_formKey.currentState!.validate()) {
      if (_promotionImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Por favor, agrega al menos una imagen para la promoción',
            ),
            backgroundColor: Color(0xFFFF6B00),
          ),
        );
        return;
      }

      if (_endDate!.isBefore(_startDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'La fecha de fin debe ser posterior a la fecha de inicio',
            ),
            backgroundColor: Color(0xFFFF6B00),
          ),
        );
        return;
      }

      // En una aplicación real, aquí enviaríamos los datos al servidor
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Promoción creada exitosamente'),
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
        _promotionImages.clear();
        _selectedPromotionType = 'Descuento Porcentual';
        _selectedTargetType = 'Todos los productos';
        _startDate = DateTime.now();
        _endDate = DateTime.now().add(const Duration(days: 7));
        _startTime = const TimeOfDay(hour: 9, minute: 0);
        _endTime = const TimeOfDay(hour: 21, minute: 0);
        _isActive = true;
        _isFeatured = false;
        _requiresCode = false;
        _selectedCategory = null;
        _selectedProduct = null;
        _codeController.clear();
      });
    }
  }

  String? _getDiscountHint() {
    switch (_selectedPromotionType) {
      case 'Descuento Porcentual':
        return 'Ej: 20 (para 20% de descuento)';
      case 'Descuento en Monto Fijo':
        return 'Ej: 50 (para \$50 de descuento)';
      case '2x1':
      case '3x2':
        return 'Automático';
      case 'Combo Especial':
        return 'Ej: Precio del combo';
      case 'Envío Gratis':
        return 'Automático';
      case 'Producto Gratis':
        return 'Ej: ID del producto gratis';
      case 'Happy Hour':
        return 'Ej: Descuento durante horas específicas';
      case 'Promoción por Tiempo Limitado':
        return 'Ej: Descuento especial';
      case 'Oferta del Día':
        return 'Ej: Precio especial del día';
      default:
        return 'Ingresa el valor';
    }
  }

  String? _getDiscountLabel() {
    switch (_selectedPromotionType) {
      case 'Descuento Porcentual':
        return 'Porcentaje de Descuento (%)';
      case 'Descuento en Monto Fijo':
        return 'Monto de Descuento (\$)';
      case '2x1':
      case '3x2':
        return 'Tipo de Promoción';
      case 'Combo Especial':
        return 'Precio del Combo (\$)';
      case 'Envío Gratis':
        return 'Tipo de Descuento';
      case 'Producto Gratis':
        return 'Producto a Regalar';
      case 'Happy Hour':
        return 'Descuento Aplicado';
      case 'Promoción por Tiempo Limitado':
        return 'Valor de la Promoción';
      case 'Oferta del Día':
        return 'Precio de Oferta (\$)';
      default:
        return 'Valor';
    }
  }

  bool _showDiscountField() {
    return !['2x1', '3x2', 'Envío Gratis'].contains(_selectedPromotionType);
  }

  bool _showMaxDiscountField() {
    return _selectedPromotionType == 'Descuento Porcentual';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 768;
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = MaterialLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Promoción'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Acción para ver promociones existentes
            },
            icon: const Icon(Icons.list_outlined),
            tooltip: 'Ver promociones',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isLargeScreen ? 32 : 16,
          vertical: 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado
              _buildHeader(),

              const SizedBox(height: 24),

              // Imágenes de la promoción
              _buildImageSection(context, isLargeScreen),

              const SizedBox(height: 24),

              // Información básica
              _buildBasicInfoSection(isLargeScreen),

              const SizedBox(height: 24),

              // Configuración de la promoción
              _buildPromotionConfigSection(isLargeScreen),

              const SizedBox(height: 24),

              // Fechas y horarios
              _buildDateTimeSection(
                context,
                dateFormat,
                timeFormat,
                isLargeScreen,
              ),

              const SizedBox(height: 24),

              // Configuraciones adicionales
              _buildAdditionalSettingsSection(isLargeScreen),

              const SizedBox(height: 32),

              // Botón de creación
              _buildCreateButton(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Crear Nueva Promoción',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF05386B),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Diseña promociones atractivas para aumentar tus ventas',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildImageSection(BuildContext context, bool isLargeScreen) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Imágenes de la Promoción',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF05386B),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _addPromotionImage,
                  icon: const Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 18,
                  ),
                  label: const Text('Agregar Imagen'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF05386B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Agrega imágenes atractivas para mostrar tu promoción',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            if (_promotionImages.isEmpty)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF05386B),
                    // style: BorderStyle.dashed,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.image_outlined,
                      size: 48,
                      color: Color(0xFF05386B),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Sin imágenes agregadas',
                      style: TextStyle(
                        color: Color(0xFF05386B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Haz clic en "Agregar Imagen" para comenzar',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isLargeScreen ? 3 : 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                ),
                itemCount: _promotionImages.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(_promotionImages[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => _removePromotionImage(index),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(
                              Icons.close,
                              color: Color(0xFFFF6B00),
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                      if (index == 0)
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B00),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Principal',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection(bool isLargeScreen) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información Básica',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF05386B),
              ),
            ),
            const SizedBox(height: 16),

            // Título de la promoción
            _buildTextField(
              controller: _titleController,
              label: 'Título de la Promoción',
              hintText: 'Ej: ¡2x1 en Pizzas!',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El título es obligatorio';
                }
                return null;
              },
            ),

            // Descripción
            _buildTextField(
              controller: _descriptionController,
              label: 'Descripción',
              hintText: 'Describe tu promoción de manera atractiva...',
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La descripción es obligatoria';
                }
                if (value.length < 20) {
                  return 'La descripción debe tener al menos 20 caracteres';
                }
                return null;
              },
            ),

            // Tipo de promoción
            _buildDropdown(
              value: _selectedPromotionType,
              items: _promotionTypes,
              label: 'Tipo de Promoción',
              hint: 'Selecciona un tipo',
              onChanged: (value) {
                setState(() {
                  _selectedPromotionType = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotionConfigSection(bool isLargeScreen) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configuración de la Promoción',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF05386B),
              ),
            ),
            const SizedBox(height: 16),

            // Valor del descuento
            if (_showDiscountField())
              _buildTextField(
                controller: _discountValueController,
                label: _getDiscountLabel()!,
                hintText: _getDiscountHint()!,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (_selectedPromotionType == 'Descuento Porcentual' ||
                      _selectedPromotionType == 'Descuento en Monto Fijo') {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    final numValue = double.tryParse(value);
                    if (numValue == null || numValue <= 0) {
                      return 'Ingresa un número válido mayor a 0';
                    }
                  }
                  return null;
                },
              ),

            // Descuento máximo (solo para porcentual)
            if (_showMaxDiscountField())
              _buildTextField(
                controller: _maxDiscountController,
                label: 'Descuento Máximo (\$)',
                hintText: 'Ej: 100 (opcional)',
                keyboardType: TextInputType.number,
              ),

            // Pedido mínimo
            _buildTextField(
              controller: _minimumOrderController,
              label: 'Pedido Mínimo (\$)',
              hintText: 'Ej: 200 (opcional)',
              keyboardType: TextInputType.number,
            ),

            // Límite de usos
            _buildTextField(
              controller: _usageLimitController,
              label: 'Límite de Usos',
              hintText: 'Ej: 100 (opcional)',
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),

            // Tipo de objetivo
            _buildDropdown(
              value: _selectedTargetType,
              items: _targetTypes,
              label: 'Aplicar a',
              hint: 'Selecciona el objetivo',
              onChanged: (value) {
                setState(() {
                  _selectedTargetType = value!;
                });
              },
            ),

            // Selector de categoría (si aplica)
            if (_selectedTargetType == 'Categoría específica')
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: _buildDropdown(
                  value: _selectedCategory,
                  items: _categories,
                  label: 'Seleccionar Categoría',
                  hint: 'Elige una categoría',
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  validator: (value) {
                    if (_selectedTargetType == 'Categoría específica' &&
                        (value == null || value.isEmpty)) {
                      return 'Debes seleccionar una categoría';
                    }
                    return null;
                  },
                ),
              ),

            // Selector de producto (si aplica)
            if (_selectedTargetType == 'Producto específico')
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: _buildDropdown(
                  value: _selectedProduct,
                  items: _products,
                  label: 'Seleccionar Producto',
                  hint: 'Elige un producto',
                  onChanged: (value) {
                    setState(() {
                      _selectedProduct = value;
                    });
                  },
                  validator: (value) {
                    if (_selectedTargetType == 'Producto específico' &&
                        (value == null || value.isEmpty)) {
                      return 'Debes seleccionar un producto';
                    }
                    return null;
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeSection(
    BuildContext context,
    DateFormat dateFormat,
    MaterialLocalizations timeFormat,
    bool isLargeScreen,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fechas y Horarios',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF05386B),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Define el período de vigencia de tu promoción',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            if (isLargeScreen)
              Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                      context: context,
                      label: 'Fecha de Inicio',
                      date: _startDate!,
                      dateFormat: dateFormat,
                      onTap: () => _selectDate(context, true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDateField(
                      context: context,
                      label: 'Fecha de Fin',
                      date: _endDate!,
                      dateFormat: dateFormat,
                      onTap: () => _selectDate(context, false),
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  _buildDateField(
                    context: context,
                    label: 'Fecha de Inicio',
                    date: _startDate!,
                    dateFormat: dateFormat,
                    onTap: () => _selectDate(context, true),
                  ),
                  const SizedBox(height: 16),
                  _buildDateField(
                    context: context,
                    label: 'Fecha de Fin',
                    date: _endDate!,
                    dateFormat: dateFormat,
                    onTap: () => _selectDate(context, false),
                  ),
                ],
              ),

            const SizedBox(height: 16),

            if (isLargeScreen)
              Row(
                children: [
                  Expanded(
                    child: _buildTimeField(
                      context: context,
                      label: 'Hora de Inicio',
                      time: _startTime!,
                      timeFormat: timeFormat,
                      onTap: () => _selectTime(context, true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTimeField(
                      context: context,
                      label: 'Hora de Fin',
                      time: _endTime!,
                      timeFormat: timeFormat,
                      onTap: () => _selectTime(context, false),
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  _buildTimeField(
                    context: context,
                    label: 'Hora de Inicio',
                    time: _startTime!,
                    timeFormat: timeFormat,
                    onTap: () => _selectTime(context, true),
                  ),
                  const SizedBox(height: 16),
                  _buildTimeField(
                    context: context,
                    label: 'Hora de Fin',
                    time: _endTime!,
                    timeFormat: timeFormat,
                    onTap: () => _selectTime(context, false),
                  ),
                ],
              ),

            const SizedBox(height: 16),

            // Código de promoción
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Requiere Código',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: const Text(
                'Los clientes necesitarán ingresar un código',
              ),
              value: _requiresCode,
              activeColor: const Color(0xFF05386B),
              onChanged: (value) {
                setState(() {
                  _requiresCode = value;
                });
              },
            ),

            if (_requiresCode)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: _buildTextField(
                  controller: _codeController,
                  label: 'Código de Promoción',
                  hintText: 'Ej: VERANO2024',
                  validator: (value) {
                    if (_requiresCode && (value == null || value.isEmpty)) {
                      return 'El código es obligatorio';
                    }
                    return null;
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalSettingsSection(bool isLargeScreen) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configuraciones Adicionales',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF05386B),
              ),
            ),
            const SizedBox(height: 16),

            // Estado activo
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Promoción Activa',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: const Text(
                'La promoción será visible para los clientes',
              ),
              value: _isActive,
              activeColor: const Color(0xFF05386B),
              onChanged: (value) {
                setState(() {
                  _isActive = value;
                });
              },
            ),

            // Destacar promoción
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Destacar Promoción',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: const Text(
                'Aparecerá en secciones destacadas de la app',
              ),
              value: _isFeatured,
              activeColor: const Color(0xFFFF6B00),
              onChanged: (value) {
                setState(() {
                  _isFeatured = value;
                });
              },
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF05386B).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF05386B).withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFF05386B)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Consejo para mejores resultados:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF05386B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '• Usa imágenes atractivas y claras\n'
                          '• Define fechas realistas\n'
                          '• Ofrece descuentos relevantes\n'
                          '• Verifica que los precios sean correctos',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                      ],
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

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _submitPromotion,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF6B00),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Crear Promoción',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType? keyboardType,
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
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: Colors.white,
            ),
            validator: validator,
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
    String? Function(String?)? validator,
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

  Widget _buildDateField({
    required BuildContext context,
    required String label,
    required DateTime date,
    required DateFormat dateFormat,
    required VoidCallback onTap,
  }) {
    return Column(
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
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    dateFormat.format(date),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  color: Color(0xFF05386B),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField({
    required BuildContext context,
    required String label,
    required TimeOfDay time,
    required MaterialLocalizations timeFormat,
    required VoidCallback onTap,
  }) {
    return Column(
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
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    time.format(context),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const Icon(
                  Icons.access_time_outlined,
                  color: Color(0xFF05386B),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
