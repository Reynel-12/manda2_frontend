import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _finalPriceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  String? _selectedCategory;
  String? _selectedUnit;
  bool _isAvailable = true;
  bool _isFeatured = false;
  bool _hasDiscount = false;

  List<String> _images = [];

  final _categories = [
    'Lácteos',
    'Panadería',
    'Bebidas',
    'Enlatados',
    'Snacks',
    'Limpieza',
    'Carnes',
    'Otros',
  ];
  final _units = ['Unidad', 'kg', 'g', 'L', 'mL', 'Paquete', 'Docena'];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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

    // Mock images
    _images = List.filled(
      3,
      'https://ilacad.com/BO/data/logos_cadenas/logo_la_colonia_honduras.jpg',
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _finalPriceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate() && _images.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Producto agregado exitosamente!'),
          backgroundColor: Color(0xFF05386B),
        ),
      );
      Navigator.pop(context);
    } else if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agrega al menos una imagen'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _calculateDiscount() {
    final base = double.tryParse(_priceController.text) ?? 0;
    if (base <= 0) return;

    final percent = double.tryParse(_discountController.text) ?? 0;
    final finalPrice = base * (1 - percent / 100);
    _finalPriceController.text = finalPrice.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Producto'),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 64 : 24,
              vertical: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Información General',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: const Color(0xFF05386B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),

                // Imágenes
                _buildImageGallery(isWide),

                const SizedBox(height: 40),

                // Campos en 1 o 2 columnas
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildLeftColumn()),
                      const SizedBox(width: 40),
                      Expanded(child: _buildRightColumn()),
                    ],
                  )
                else
                  Column(
                    children: [
                      _buildLeftColumn(),
                      const SizedBox(height: 40),
                      _buildRightColumn(),
                    ],
                  ),

                const SizedBox(height: 40),

                // Opciones
                _buildOptionsSection(),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onSubmit,
        backgroundColor: const Color(0xFFFF6B00),
        icon: const Icon(Icons.save),
        label: const Text(
          'Guardar Producto',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildImageGallery(bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Imágenes del producto',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF05386B),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ..._images.map(
                (url) => Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          url,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            iconSize: 16,
                            icon: const Icon(Icons.close),
                            onPressed: () =>
                                setState(() => _images.remove(url)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(
                  () => _images.add(
                    'https://ilacad.com/BO/data/logos_cadenas/logo_la_colonia_honduras.jpg',
                  ),
                ),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF05386B),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[100],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        size: 36,
                        color: Color(0xFF05386B),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Agregar',
                        style: TextStyle(color: Color(0xFF05386B)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      children: [
        _buildField(
          _nameController,
          'Nombre del producto',
          'Ej: Pizza Margarita',
          validator: (v) => v!.isEmpty ? 'Requerido' : null,
        ),
        const SizedBox(height: 24),
        _buildField(
          _descriptionController,
          'Descripción',
          'Describe tu producto...',
          maxLines: 4,
          validator: (v) => v!.length < 10 ? 'Mínimo 10 caracteres' : null,
        ),
        const SizedBox(height: 24),
        _buildDropdown(
          'Categoría',
          _selectedCategory,
          _categories,
          (v) => setState(() => _selectedCategory = v),
          validator: (v) => v == null ? 'Selecciona una' : null,
        ),
      ],
    );
  }

  Widget _buildRightColumn() {
    return Column(
      children: [
        _buildField(
          _priceController,
          'Precio base',
          '0.00',
          prefix: '\$ ',
          keyboard: TextInputType.number,
          onChanged: (_) => _hasDiscount ? _calculateDiscount() : null,
          validator: (v) => double.tryParse(v!) == null || double.parse(v) <= 0
              ? 'Precio válido > 0'
              : null,
        ),
        const SizedBox(height: 24),
        _buildDiscountToggle(),
        const SizedBox(height: 24),
        _buildField(
          _stockController,
          'Stock disponible',
          '0',
          keyboard: TextInputType.number,
          validator: (v) => int.tryParse(v!) == null || int.parse(v) < 0
              ? 'Stock válido'
              : null,
        ),
        const SizedBox(height: 24),
        _buildDropdown(
          'Unidad',
          _selectedUnit,
          _units,
          (v) => setState(() => _selectedUnit = v),
        ),
      ],
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    String hint, {
    int maxLines = 1,
    TextInputType? keyboard,
    String? prefix,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
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
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboard,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefix,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF05386B), width: 2),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged, {
    String? Function(String?)? validator,
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
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF05386B), width: 2),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDiscountToggle() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF05386B).withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF05386B).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.local_offer, color: Color(0xFF05386B)),
                  SizedBox(width: 12),
                  Text(
                    'Aplicar descuento',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Switch(
                value: _hasDiscount,
                activeColor: const Color(0xFFFF6B00),
                onChanged: (v) => setState(() => _hasDiscount = v),
              ),
            ],
          ),
          if (_hasDiscount) ...[
            const SizedBox(height: 20),
            _buildField(
              _discountController,
              'Porcentaje de descuento',
              '0',
              prefix: '% ',
              keyboard: TextInputType.number,
              onChanged: (_) => _calculateDiscount(),
            ),
            const SizedBox(height: 16),
            Text(
              'Precio final: \$${((double.tryParse(_priceController.text) ?? 0) * (1 - (double.tryParse(_discountController.text) ?? 0) / 100)).toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF05386B),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Opciones',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF05386B),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Checkbox(
              value: _isAvailable,
              activeColor: const Color(0xFF05386B),
              onChanged: (v) => setState(() => _isAvailable = v!),
            ),
            const Text('Disponible para venta'),
          ],
        ),
        Row(
          children: [
            Checkbox(
              value: _isFeatured,
              activeColor: const Color(0xFFFF6B00),
              onChanged: (v) => setState(() => _isFeatured = v!),
            ),
            const Text('Destacar en tienda'),
          ],
        ),
      ],
    );
  }
}
