import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BusinessSettingsScreen extends StatefulWidget {
  const BusinessSettingsScreen({super.key});

  @override
  State<BusinessSettingsScreen> createState() => _BusinessSettingsScreenState();
}

class _BusinessSettingsScreenState extends State<BusinessSettingsScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Datos del negocio
  BusinessProfile _businessProfile = BusinessProfile(
    name: 'Restaurante La Esquina',
    description: 'Comida tradicional con sabor casero',
    logoUrl:
        'https://ilacad.com/BO/data/logos_cadenas/logo_la_colonia_honduras.jpg',
    bannerUrls: [
      'https://ilacad.com/BO/data/logos_cadenas/logo_la_colonia_honduras.jpg',
      'https://ilacad.com/BO/data/logos_cadenas/logo_la_colonia_honduras.jpg',
    ],
    address: 'Av. Principal #123, Colonia Centro',
    city: 'Ciudad de México',
    phone: '+52 55 1234 5678',
    email: 'contacto@laesquina.com',
    website: 'www.laesquina.com',
    schedule: [
      BusinessDay(
        day: 'Lunes',
        openTime: TimeOfDay(hour: 8, minute: 0),
        closeTime: TimeOfDay(hour: 22, minute: 0),
        isOpen: true,
      ),
      BusinessDay(
        day: 'Martes',
        openTime: TimeOfDay(hour: 8, minute: 0),
        closeTime: TimeOfDay(hour: 22, minute: 0),
        isOpen: true,
      ),
      BusinessDay(
        day: 'Miércoles',
        openTime: TimeOfDay(hour: 8, minute: 0),
        closeTime: TimeOfDay(hour: 22, minute: 0),
        isOpen: true,
      ),
      BusinessDay(
        day: 'Jueves',
        openTime: TimeOfDay(hour: 8, minute: 0),
        closeTime: TimeOfDay(hour: 22, minute: 0),
        isOpen: true,
      ),
      BusinessDay(
        day: 'Viernes',
        openTime: TimeOfDay(hour: 8, minute: 0),
        closeTime: TimeOfDay(hour: 23, minute: 0),
        isOpen: true,
      ),
      BusinessDay(
        day: 'Sábado',
        openTime: TimeOfDay(hour: 9, minute: 0),
        closeTime: TimeOfDay(hour: 23, minute: 0),
        isOpen: true,
      ),
      BusinessDay(
        day: 'Domingo',
        openTime: TimeOfDay(hour: 10, minute: 0),
        closeTime: TimeOfDay(hour: 18, minute: 0),
        isOpen: true,
      ),
    ],
    categories: ['Restaurante', 'Comida Mexicana', 'Desayunos'],
    deliveryRadius: 5.0,
    preparationTime: 25,
    isActive: true,
  );

  // Controladores para los campos editables
  late TextEditingController _nameCtrl,
      _descCtrl,
      _addrCtrl,
      _cityCtrl,
      _phoneCtrl,
      _emailCtrl,
      _webCtrl,
      _radiusCtrl,
      _prepCtrl;

  bool _isEditing = false;
  bool _isLoading = false;

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _initControllers();

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _addrCtrl.dispose();
    _cityCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _webCtrl.dispose();
    _radiusCtrl.dispose();
    _prepCtrl.dispose();
    super.dispose();
  }

  void _initControllers() {
    _nameCtrl = TextEditingController(text: _businessProfile.name);
    _descCtrl = TextEditingController(text: _businessProfile.description);
    _addrCtrl = TextEditingController(text: _businessProfile.address);
    _cityCtrl = TextEditingController(text: _businessProfile.city);
    _phoneCtrl = TextEditingController(text: _businessProfile.phone);
    _emailCtrl = TextEditingController(text: _businessProfile.email);
    _webCtrl = TextEditingController(text: _businessProfile.website);
    _radiusCtrl = TextEditingController(
      text: _businessProfile.deliveryRadius.toString(),
    );
    _prepCtrl = TextEditingController(
      text: _businessProfile.preparationTime.toString(),
    );
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) _initControllers();
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _businessProfile = _businessProfile.copyWith(
        name: _nameCtrl.text,
        description: _descCtrl.text,
        address: _addrCtrl.text,
        city: _cityCtrl.text,
        phone: _phoneCtrl.text,
        email: _emailCtrl.text,
        website: _webCtrl.text,
        deliveryRadius: double.tryParse(_radiusCtrl.text) ?? 5.0,
        preparationTime: int.tryParse(_prepCtrl.text) ?? 25,
      );
      _isEditing = false;
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cambios guardados'),
        backgroundColor: Color(0xFF05386B),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración del Negocio'),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: _toggleEdit,
          ),
          if (_isEditing)
            IconButton(icon: const Icon(Icons.save), onPressed: _save),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF05386B)),
            )
          : FadeTransition(
              opacity: _fadeAnim,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 64 : 24,
                  vertical: 24,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 40),
                      _buildVisualSection(isWide),
                      const SizedBox(height: 40),
                      _buildInfoSection(isWide),
                      const SizedBox(height: 40),
                      _buildScheduleSection(),
                      const SizedBox(height: 40),
                      _buildDeliverySection(isWide),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Perfil del Negocio',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0xFF05386B),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Switch(
          value: _businessProfile.isActive,
          activeColor: const Color(0xFFFF6B00),
          onChanged: _isEditing
              ? (v) => setState(
                  () =>
                      _businessProfile = _businessProfile.copyWith(isActive: v),
                )
              : null,
        ),
      ],
    );
  }

  Widget _buildVisualSection(bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Visuales',
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
                _buildLogo(),
                const SizedBox(height: 40),
                _buildBanners(isWide),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        const Text(
          'Logo',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(_businessProfile.logoUrl),
            ),
            if (_isEditing)
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFFF6B00),
                child: const Icon(Icons.camera_alt, color: Colors.white),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildBanners(bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Banners',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            if (_isEditing)
              IconButton(
                icon: const Icon(Icons.add_photo_alternate),
                onPressed: () {},
              ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount:
                _businessProfile.bannerUrls.length + (_isEditing ? 1 : 0),
            itemBuilder: (context, i) {
              if (i == _businessProfile.bannerUrls.length) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 300,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF05386B),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        size: 48,
                        color: Color(0xFF05386B),
                      ),
                    ),
                  ),
                );
              }
              return Container(
                width: 300,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(_businessProfile.bannerUrls[i]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: _isEditing
                    ? Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.close, color: Colors.red),
                          ),
                          onPressed: () {},
                        ),
                      )
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(bool isWide) {
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
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildInfoLeft()),
                      const SizedBox(width: 40),
                      Expanded(child: _buildInfoRight()),
                    ],
                  )
                : Column(
                    children: [
                      _buildInfoLeft(),
                      const SizedBox(height: 40),
                      _buildInfoRight(),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoLeft() {
    return Column(
      children: [
        _field(
          'Nombre',
          _nameCtrl,
          validator: (v) => v!.isEmpty ? 'Requerido' : null,
        ),
        const SizedBox(height: 24),
        _field('Descripción', _descCtrl, maxLines: 4),
        const SizedBox(height: 24),
        _field('Teléfono', _phoneCtrl),
        const SizedBox(height: 24),
        _field('Email', _emailCtrl),
      ],
    );
  }

  Widget _buildInfoRight() {
    return Column(
      children: [
        _field('Dirección', _addrCtrl),
        const SizedBox(height: 24),
        _field('Ciudad', _cityCtrl),
        const SizedBox(height: 24),
        _field('Sitio Web', _webCtrl),
      ],
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl, {
    int maxLines = 1,
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
          enabled: _isEditing,
          maxLines: maxLines,
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

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Horario de Atención',
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
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _businessProfile.schedule.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final day = _businessProfile.schedule[i];
              return ListTile(
                leading: Checkbox(
                  value: day.isOpen,
                  activeColor: const Color(0xFF05386B),
                  onChanged: _isEditing
                      ? (v) => setState(
                          () => _businessProfile.schedule[i] = day.copyWith(
                            isOpen: v!,
                          ),
                        )
                      : null,
                ),
                title: Text(
                  day.day,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  day.isOpen
                      ? '${_formatTime(day.openTime)} - ${_formatTime(day.closeTime)}'
                      : 'Cerrado',
                ),
                trailing: _isEditing && day.isOpen
                    ? IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final open = await showTimePicker(
                            context: context,
                            initialTime: day.openTime,
                          );
                          if (open != null) {
                            final close = await showTimePicker(
                              context: context,
                              initialTime: day.closeTime,
                            );
                            if (close != null)
                              setState(
                                () => _businessProfile.schedule[i] = day
                                    .copyWith(openTime: open, closeTime: close),
                              );
                          }
                        },
                      )
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDeliverySection(bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery',
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
                        child: _field('Radio de entrega (km)', _radiusCtrl),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: _field('Tiempo preparación (min)', _prepCtrl),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      _field('Radio de entrega (km)', _radiusCtrl),
                      const SizedBox(height: 24),
                      _field('Tiempo preparación (min)', _prepCtrl),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  String _formatTime(TimeOfDay t) =>
      DateFormat('h:mm a').format(DateTime(2020, 1, 1, t.hour, t.minute));
}

// Modelos de datos
class BusinessProfile {
  final String name;
  final String description;
  final String logoUrl;
  final List<String> bannerUrls;
  final String address;
  final String city;
  final String phone;
  final String email;
  final String website;
  final List<BusinessDay> schedule;
  final List<String> categories;
  final double deliveryRadius;
  final int preparationTime;
  final bool isActive;

  BusinessProfile({
    required this.name,
    required this.description,
    required this.logoUrl,
    required this.bannerUrls,
    required this.address,
    required this.city,
    required this.phone,
    required this.email,
    required this.website,
    required this.schedule,
    required this.categories,
    required this.deliveryRadius,
    required this.preparationTime,
    required this.isActive,
  });

  BusinessProfile copyWith({
    String? name,
    String? description,
    String? logoUrl,
    List<String>? bannerUrls,
    String? address,
    String? city,
    String? phone,
    String? email,
    String? website,
    List<BusinessDay>? schedule,
    List<String>? categories,
    double? deliveryRadius,
    int? preparationTime,
    bool? isActive,
  }) {
    return BusinessProfile(
      name: name ?? this.name,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      bannerUrls: bannerUrls ?? this.bannerUrls,
      address: address ?? this.address,
      city: city ?? this.city,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      schedule: schedule ?? this.schedule,
      categories: categories ?? this.categories,
      deliveryRadius: deliveryRadius ?? this.deliveryRadius,
      preparationTime: preparationTime ?? this.preparationTime,
      isActive: isActive ?? this.isActive,
    );
  }
}

class BusinessDay {
  final String day;
  final TimeOfDay openTime;
  final TimeOfDay closeTime;
  final bool isOpen;

  BusinessDay({
    required this.day,
    required this.openTime,
    required this.closeTime,
    required this.isOpen,
  });

  BusinessDay copyWith({
    String? day,
    TimeOfDay? openTime,
    TimeOfDay? closeTime,
    bool? isOpen,
  }) {
    return BusinessDay(
      day: day ?? this.day,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      isOpen: isOpen ?? this.isOpen,
    );
  }
}
