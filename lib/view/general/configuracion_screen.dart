import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  UserProfile _userProfile = UserProfile(
    name: 'Juan Pérez',
    email: 'juan.perez@email.com',
    phone: '+504 1234-5678',
    profileImage: '',
    joinDate: DateTime(2024, 1, 15),
  );

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final List<DeliveryAddress> _deliveryAddresses = [];
  bool _isEditingProfile = false;
  // final GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadAddresses();
    _initializeControllers();
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
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    // Datos del usuario (en una app real vendrían de una API o base de datos)
    _userProfile = UserProfile(
      name: 'Juan Pérez',
      email: 'juan.perez@email.com',
      phone: '+504 1234-5678',
      profileImage: '',
      joinDate: DateTime(2024, 1, 15),
    );
  }

  void _loadAddresses() {
    // Direcciones de ejemplo
    _deliveryAddresses.addAll([
      DeliveryAddress(
        id: '1',
        title: 'Casa',
        address: 'Barrio Los Pinos, Casa #45',
        neighborhood: 'Los Pinos',
        city: 'Tegucigalpa',
        municipality: 'Distrito Central',
        additionalInfo: 'Casa color azul, portón negro',
        isDefault: true,
        latitude: 14.0723,
        longitude: -87.1921,
      ),
      DeliveryAddress(
        id: '2',
        title: 'Trabajo',
        address: 'Colonia San José, Apartamento 302, Edificio B',
        neighborhood: 'San José',
        city: 'Tegucigalpa',
        municipality: 'Distrito Central',
        additionalInfo: 'Recepción en el lobby',
        isDefault: false,
        latitude: 14.0823,
        longitude: -87.1821,
      ),
      DeliveryAddress(
        id: '3',
        title: 'Casa de Mamá',
        address: 'Residencial Las Flores, Casa #12',
        neighborhood: 'Las Flores',
        city: 'Tegucigalpa',
        municipality: 'Distrito Central',
        additionalInfo: 'Pedir en la caseta de seguridad',
        isDefault: false,
        latitude: 14.0923,
        longitude: -87.1721,
      ),
    ]);
  }

  void _initializeControllers() {
    _nameController.text = _userProfile.name;
    _emailController.text = _userProfile.email;
    _phoneController.text = _userProfile.phone;
  }

  void _toggleEdit() {
    setState(() {
      _isEditingProfile = !_isEditingProfile;
      if (!_isEditingProfile) {
        _initializeControllers(); // Restaurar valores originales
      }
    });
  }

  // void _saveProfileChanges() {
  //   if (_profileFormKey.currentState!.validate()) {
  //     setState(() {
  //       _userProfile = _userProfile.copyWith(
  //         name: _nameController.text,
  //         email: _emailController.text,
  //         phone: _phoneController.text,
  //       );
  //       _isEditingProfile = false;
  //     });

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Perfil actualizado correctamente'),
  //         backgroundColor: Color(0xFF05386B),
  //       ),
  //     );
  //   }
  // }

  // void _addNewAddress() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => AddAddressScreen(
  //         onAddressAdded: (newAddress) {
  //           setState(() {
  //             _deliveryAddresses.add(newAddress);
  //           });
  //         },
  //       ),
  //     ),
  //   );
  // }

  // void _editAddress(DeliveryAddress address) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => AddAddressScreen(
  //         address: address,
  //         onAddressAdded: (updatedAddress) {
  //           setState(() {
  //             final index = _deliveryAddresses.indexWhere(
  //               (a) => a.id == address.id,
  //             );
  //             if (index != -1) {
  //               _deliveryAddresses[index] = updatedAddress;
  //             }
  //           });
  //         },
  //       ),
  //     ),
  //   );
  // }

  // void _deleteAddress(String addressId) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text(
  //         'Eliminar Dirección',
  //         style: TextStyle(
  //           color: Color(0xFF05386B),
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       content: const Text(
  //         '¿Estás seguro de que quieres eliminar esta dirección?',
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text(
  //             'Cancelar',
  //             style: TextStyle(color: Color(0xFF05386B)),
  //           ),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             setState(() {
  //               _deliveryAddresses.removeWhere(
  //                 (address) => address.id == addressId,
  //               );
  //             });
  //             Navigator.pop(context);
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(
  //                 content: Text('Dirección eliminada'),
  //                 backgroundColor: Color(0xFF05386B),
  //               ),
  //             );
  //           },
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: const Color(0xFFFF6B00),
  //           ),
  //           child: const Text('Eliminar'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // void _setDefaultAddress(String addressId) {
  //   setState(() {
  //     for (var address in _deliveryAddresses) {
  //       address.isDefault = address.id == addressId;
  //     }
  //   });

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('Dirección predeterminada actualizada'),
  //       backgroundColor: Color(0xFF05386B),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final isDesktop = MediaQuery.of(context).size.width >= 1200;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          _isEditingProfile
              ? IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () => setState(() => _isEditingProfile = false),
                )
              : const SizedBox(),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 64 : 24,
            vertical: 24,
          ),
          child: isDesktop || isTablet
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildProfileSection()),
                    const SizedBox(width: 32),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          _buildAddressesSection(),
                          const SizedBox(height: 32),
                          _buildAdditionalSettings(),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _buildProfileSection(),
                    const SizedBox(height: 32),
                    _buildAddressesSection(),
                    const SizedBox(height: 32),
                    _buildAdditionalSettings(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: _isEditingProfile ? _buildEditForm() : _buildProfileView(),
        ),
      ),
    );
  }

  Widget _buildProfileView() {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: const Color(0xFF05386B),
          child: Text(
            _userProfile.name[0].toUpperCase(),
            style: const TextStyle(fontSize: 48, color: Colors.white),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          _userProfile.name,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: const Color(0xFF05386B),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 32),
        _buildInfoTile(Icons.email_outlined, 'Correo', _userProfile.email),
        _buildInfoTile(Icons.phone_outlined, 'Teléfono', _userProfile.phone),
        _buildInfoTile(Icons.calendar_today, 'Miembro desde', '15 Ene 2024'),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStat('12', 'Pedidos', Icons.shopping_bag),
            _buildStat('\$245', 'Gastado', Icons.attach_money),
            _buildStat('4.8', 'Rating', Icons.star),
          ],
        ),
        const SizedBox(height: 40),
        OutlinedButton.icon(
          onPressed: _toggleEdit,
          icon: const Icon(Icons.edit),
          label: const Text('Editar Perfil'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFFF6B00),
            side: const BorderSide(color: Color(0xFFFF6B00)),
          ),
        ),
      ],
    );
  }

  Widget _buildEditForm() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: const Color(0xFF05386B),
              child: Text(
                _nameController.text[0].toUpperCase(),
                style: const TextStyle(fontSize: 48, color: Colors.white),
              ),
            ),
            CircleAvatar(
              backgroundColor: const Color(0xFFFF6B00),
              radius: 20,
              child: const Icon(Icons.camera_alt, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 32),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Nombre',
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Correo',
            prefixIcon: Icon(Icons.email),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Teléfono',
            prefixIcon: Icon(Icons.phone),
          ),
        ),
        const SizedBox(height: 40),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _toggleEdit,
                child: const Text('Cancelar'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _toggleEdit,
                child: const Text('Guardar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B00),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF05386B)),
      title: Text(label, style: TextStyle(color: Colors.grey[600])),
      subtitle: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildStat(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: const Color(0xFF05386B)),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildAddressesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Direcciones de Entrega',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF05386B),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Color(0xFFFF6B00)),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_deliveryAddresses.isEmpty)
          _buildEmptyAddresses()
        else
          ..._deliveryAddresses.map(
            (addr) => Dismissible(
              key: Key(addr.id),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 32),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) =>
                  setState(() => _deliveryAddresses.remove(addr)),
              child: _buildAddressCard(addr),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyAddresses() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 60,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Sin direcciones',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Agrega una para recibir tus pedidos',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(DeliveryAddress addr) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: addr.isDefault
            ? const BorderSide(color: Color(0xFFFF6B00), width: 2)
            : BorderSide.none,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF05386B),
          child: Icon(
            addr.isDefault ? Icons.home : Icons.location_on,
            color: Colors.white,
          ),
        ),
        title: Text(
          addr.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(addr.address),
        trailing: addr.isDefault
            ? const Chip(
                label: Text(
                  'Predeterminada',
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
                backgroundColor: Color(0xFFFF6B00),
              )
            : const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }

  Widget _buildAdditionalSettings() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          _buildSettingTile(
            Icons.notifications,
            'Notificaciones',
            trailing: Switch(
              value: true,
              onChanged: (_) {},
              activeColor: const Color(0xFFFF6B00),
            ),
          ),
          const Divider(height: 1),
          _buildSettingTile(Icons.lock, 'Privacidad y Seguridad'),
          const Divider(height: 1),
          _buildSettingTile(Icons.payment, 'Métodos de Pago'),
          const Divider(height: 1),
          _buildSettingTile(Icons.help_outline, 'Ayuda y Soporte'),
          const Divider(height: 1),
          _buildSettingTile(Icons.info_outline, 'Acerca de Manda2'),
          const Divider(height: 1),
          _buildSettingTile(Icons.logout, 'Cerrar Sesión', isDangerous: true),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    IconData icon,
    String title, {
    Widget? trailing,
    bool isDangerous = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDangerous ? Colors.red : const Color(0xFF05386B),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDangerous ? Colors.red : null,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}

// Pantalla para agregar/editar direcciones
class AddAddressScreen extends StatefulWidget {
  final DeliveryAddress? address;
  final Function(DeliveryAddress) onAddressAdded;

  const AddAddressScreen({Key? key, this.address, required this.onAddressAdded})
    : super(key: key);

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();
  final TextEditingController _additionalInfoController =
      TextEditingController();
  String? _selectedMunicipality;
  bool _isDefault = false;

  final List<String> _municipalities = [
    'Selecciona tu municipio',
    'Distrito Central',
    'San Pedro Sula',
    'La Ceiba',
    'Choloma',
    'El Progreso',
    'Comayagua',
    'Choluteca',
    'Danlí',
    'Tocoa',
    'Siguatepeque',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _loadAddressData(widget.address!);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _neighborhoodController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  void _loadAddressData(DeliveryAddress address) {
    _titleController.text = address.title;
    _addressController.text = address.address;
    _neighborhoodController.text = address.neighborhood;
    _additionalInfoController.text = address.additionalInfo;
    _selectedMunicipality = address.municipality;
    _isDefault = address.isDefault;
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate() &&
        _selectedMunicipality != null &&
        _selectedMunicipality != 'Selecciona tu municipio') {
      final newAddress = DeliveryAddress(
        id:
            widget.address?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        address: _addressController.text,
        neighborhood: _neighborhoodController.text,
        city: 'Tegucigalpa', // En una app real esto vendría de la selección
        municipality: _selectedMunicipality!,
        additionalInfo: _additionalInfoController.text,
        isDefault: _isDefault,
        latitude: 14.0723,
        longitude: -87.1921,
      );

      widget.onAddressAdded(newAddress);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.address != null
                ? 'Dirección actualizada correctamente'
                : 'Dirección agregada correctamente',
          ),
          backgroundColor: const Color(0xFF05386B),
        ),
      );
    } else if (_selectedMunicipality == null ||
        _selectedMunicipality == 'Selecciona tu municipio') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona un municipio'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.address != null ? 'Editar Dirección' : 'Agregar Dirección',
        ),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _saveAddress),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Información de la Dirección',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF05386B),
                ),
              ),

              const SizedBox(height: 20),

              // Título de la dirección
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título (Ej: Casa, Trabajo)',
                  prefixIcon: const Icon(
                    Icons.title_outlined,
                    color: Color(0xFF05386B),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF05386B),
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un título para la dirección';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Dirección completa
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Dirección completa',
                  prefixIcon: const Icon(
                    Icons.location_on_outlined,
                    color: Color(0xFF05386B),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF05386B),
                      width: 2,
                    ),
                  ),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la dirección completa';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Barrio/Colonia
              TextFormField(
                controller: _neighborhoodController,
                decoration: InputDecoration(
                  labelText: 'Barrio/Colonia',
                  prefixIcon: const Icon(
                    Icons.location_city_outlined,
                    color: Color(0xFF05386B),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF05386B),
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el barrio o colonia';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Municipio
              DropdownButtonFormField<String>(
                value: _selectedMunicipality,
                decoration: InputDecoration(
                  labelText: 'Municipio',
                  prefixIcon: const Icon(
                    Icons.map_outlined,
                    color: Color(0xFF05386B),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF05386B),
                      width: 2,
                    ),
                  ),
                ),
                items: _municipalities.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMunicipality = value;
                  });
                },
                validator: (value) {
                  if (value == null || value == 'Selecciona tu municipio') {
                    return 'Por favor selecciona un municipio';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Información adicional
              TextFormField(
                controller: _additionalInfoController,
                decoration: InputDecoration(
                  labelText: 'Información adicional (opcional)',
                  hintText: 'Ej: Casa color azul, portón negro, referencias...',
                  prefixIcon: const Icon(
                    Icons.info_outlined,
                    color: Color(0xFF05386B),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF05386B),
                      width: 2,
                    ),
                  ),
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 24),

              // Checkbox para dirección predeterminada
              Row(
                children: [
                  Checkbox(
                    value: _isDefault,
                    onChanged: (value) {
                      setState(() {
                        _isDefault = value ?? false;
                      });
                    },
                    activeColor: const Color(0xFFFF6B00),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Establecer como dirección predeterminada',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF05386B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Los pedidos se enviarán a esta dirección por defecto',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Botón para guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B00),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    widget.address != null
                        ? 'Actualizar Dirección'
                        : 'Guardar Dirección',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Botón para usar ubicación actual
              if (widget.address == null)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      // Obtener ubicación actual
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Obteniendo tu ubicación actual...'),
                          backgroundColor: Color(0xFF05386B),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF05386B)),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.gps_fixed_outlined,
                          color: Color(0xFF05386B),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Usar mi ubicación actual',
                          style: TextStyle(
                            color: Color(0xFF05386B),
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
      ),
    );
  }
}

// Modelos de datos
class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String profileImage;
  final DateTime joinDate;

  const UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.joinDate,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    DateTime? joinDate,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      joinDate: joinDate ?? this.joinDate,
    );
  }
}

class DeliveryAddress {
  final String id;
  final String title;
  final String address;
  final String neighborhood;
  final String city;
  final String municipality;
  final String additionalInfo;
  bool isDefault;
  final double latitude;
  final double longitude;

  DeliveryAddress({
    required this.id,
    required this.title,
    required this.address,
    required this.neighborhood,
    required this.city,
    required this.municipality,
    required this.additionalInfo,
    required this.isDefault,
    required this.latitude,
    required this.longitude,
  });
}
