import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreatePromotionScreen extends StatefulWidget {
  const CreatePromotionScreen({super.key});

  @override
  State<CreatePromotionScreen> createState() => _CreatePromotionScreenState();
}

class _CreatePromotionScreenState extends State<CreatePromotionScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _discountCtrl = TextEditingController();
  final _minOrderCtrl = TextEditingController();
  final _usageLimitCtrl = TextEditingController();

  String _type = 'Descuento Porcentual';
  String _target = 'Todos';
  String? _selectedCategory;
  String? _selectedProduct;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));
  // TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  // TimeOfDay _endTime = const TimeOfDay(hour: 21, minute: 0);

  bool _active = true;
  bool _featured = false;
  bool _codeRequired = false;
  bool _hasDiscount = true;

  List<String> _images = [];

  final _types = [
    'Descuento Porcentual',
    'Descuento Fijo',
    '2x1',
    'Envío Gratis',
    'Combo',
  ];
  final _targets = ['Todos', 'Categoría', 'Producto', 'Pedido Mínimo'];
  final _categories = ['Comida', 'Bebidas', 'Postres'];
  final _products = ['Pizza', 'Hamburguesa', 'Ensalada'];

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();

    // Mock images
    _images = List.filled(
      2,
      'https://ilacad.com/BO/data/logos_cadenas/logo_la_colonia_honduras.jpg',
    );
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _codeCtrl.dispose();
    _discountCtrl.dispose();
    _minOrderCtrl.dispose();
    _usageLimitCtrl.dispose();
    super.dispose();
  }

  void _onCreate() {
    if (_formKey.currentState!.validate() && _images.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Promoción creada!'),
          backgroundColor: Color(0xFF05386B),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Promoción'),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
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
                  'Crea una promoción atractiva',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: const Color(0xFF05386B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),

                // Imágenes
                _buildImages(isWide),

                const SizedBox(height: 40),

                // Info básica
                _buildBasicInfo(isWide),

                const SizedBox(height: 40),

                // Config promoción
                _buildPromotionConfig(isWide),

                const SizedBox(height: 40),

                // Vigencia
                _buildValidity(context, isWide),

                const SizedBox(height: 40),

                // Opciones
                _buildOptions(),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onCreate,
        backgroundColor: const Color(0xFFFF6B00),
        icon: const Icon(Icons.check),
        label: const Text(
          'Crear Promoción',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildImages(bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Imágenes (mínimo 1)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF05386B),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ..._images.map(
                (url) => Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          url,
                          width: 280,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: CircleAvatar(
                          radius: 16,
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
                  width: 280,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF05386B),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    color: Colors.grey[100],
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          size: 48,
                          color: Color(0xFF05386B),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Agregar Imagen',
                          style: TextStyle(color: Color(0xFF05386B)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfo(bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Información Básica',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF05386B),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                _field(
                  'Título',
                  _titleCtrl,
                  validator: (v) => v!.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 24),
                _field('Descripción', _descCtrl, maxLines: 4),
                const SizedBox(height: 24),
                _dropdown(
                  'Tipo de Promoción',
                  _type,
                  _types,
                  (v) => setState(() => _type = v!),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPromotionConfig(bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Configuración',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF05386B),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                _dropdown(
                  'Aplicar a',
                  _target,
                  _targets,
                  (v) => setState(() => _target = v!),
                ),
                const SizedBox(height: 24),
                if (_target == 'Categoría')
                  _dropdown(
                    'Categoría',
                    _selectedCategory,
                    _categories,
                    (v) => setState(() => _selectedCategory = v),
                  ),
                if (_target == 'Producto')
                  _dropdown(
                    'Producto',
                    _selectedProduct,
                    _products,
                    (v) => setState(() => _selectedProduct = v),
                  ),
                const SizedBox(height: 24),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: _hasDiscount
                      ? Column(
                          children: [
                            _field(
                              'Valor del descuento',
                              _discountCtrl,
                              prefix: _type.contains('Porcentual')
                                  ? '%'
                                  : '\$ ',
                              keyboard: TextInputType.number,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Precio final: \$${(double.tryParse(_discountCtrl.text) ?? 0) > 0 ? 'Calculado' : '0.00'}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : null,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Aplicar descuento'),
                    Switch(
                      value: _hasDiscount,
                      activeColor: const Color(0xFFFF6B00),
                      onChanged: (v) => setState(() => _hasDiscount = v),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildValidity(BuildContext context, bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vigencia',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF05386B),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: isWide
                ? Row(
                    children: [
                      Expanded(
                        child: _dateField(
                          'Inicio',
                          _startDate,
                          () => _selectDate(context, true),
                        ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: _dateField(
                          'Fin',
                          _endDate,
                          () => _selectDate(context, false),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      _dateField(
                        'Inicio',
                        _startDate,
                        () => _selectDate(context, true),
                      ),
                      const SizedBox(height: 24),
                      _dateField(
                        'Fin',
                        _endDate,
                        () => _selectDate(context, false),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Opciones',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF05386B),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('Activa'),
                    const Spacer(),
                    Switch(
                      value: _active,
                      activeColor: const Color(0xFF05386B),
                      onChanged: (v) => setState(() => _active = v),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Destacada'),
                    const Spacer(),
                    Switch(
                      value: _featured,
                      activeColor: const Color(0xFFFF6B00),
                      onChanged: (v) => setState(() => _featured = v),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Requiere código'),
                    const Spacer(),
                    Switch(
                      value: _codeRequired,
                      activeColor: const Color(0xFF05386B),
                      onChanged: (v) => setState(() => _codeRequired = v),
                    ),
                  ],
                ),
                if (_codeRequired) ...[
                  const SizedBox(height: 16),
                  _field('Código', _codeCtrl),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl, {
    int maxLines = 1,
    TextInputType? keyboard,
    String? prefix,
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
          controller: ctrl,
          maxLines: maxLines,
          keyboardType: keyboard,
          decoration: InputDecoration(
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

  Widget _dropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
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
        ),
      ],
    );
  }

  Widget _dateField(String label, DateTime date, VoidCallback onTap) {
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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Text(DateFormat('dd/MM/yyyy').format(date)),
                const Spacer(),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, bool start) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: start ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null)
      setState(() => start ? _startDate = picked : _endDate = picked);
  }
}
