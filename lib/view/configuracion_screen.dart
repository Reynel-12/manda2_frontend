import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  UserProfile _userProfile = UserProfile(
    name: 'Juan Pérez',
    email: 'juan.perez@email.com',
    phone: '+504 1234-5678',
    profileImage: '',
    joinDate: DateTime(2024, 1, 15),
  );

  final List<DeliveryAddress> _deliveryAddresses = [];
  bool _isEditingProfile = false;
  final GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadAddresses();
    _initializeControllers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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

  void _toggleEditProfile() {
    setState(() {
      _isEditingProfile = !_isEditingProfile;
      if (!_isEditingProfile) {
        _initializeControllers(); // Restaurar valores originales
      }
    });
  }

  void _saveProfileChanges() {
    if (_profileFormKey.currentState!.validate()) {
      setState(() {
        _userProfile = _userProfile.copyWith(
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
        );
        _isEditingProfile = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil actualizado correctamente'),
          backgroundColor: Color(0xFF05386B),
        ),
      );
    }
  }

  void _addNewAddress() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAddressScreen(
          onAddressAdded: (newAddress) {
            setState(() {
              _deliveryAddresses.add(newAddress);
            });
          },
        ),
      ),
    );
  }

  void _editAddress(DeliveryAddress address) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAddressScreen(
          address: address,
          onAddressAdded: (updatedAddress) {
            setState(() {
              final index = _deliveryAddresses.indexWhere(
                (a) => a.id == address.id,
              );
              if (index != -1) {
                _deliveryAddresses[index] = updatedAddress;
              }
            });
          },
        ),
      ),
    );
  }

  void _deleteAddress(String addressId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Eliminar Dirección',
          style: TextStyle(
            color: Color(0xFF05386B),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          '¿Estás seguro de que quieres eliminar esta dirección?',
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
                _deliveryAddresses.removeWhere(
                  (address) => address.id == addressId,
                );
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Dirección eliminada'),
                  backgroundColor: Color(0xFF05386B),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B00),
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _setDefaultAddress(String addressId) {
    setState(() {
      for (var address in _deliveryAddresses) {
        address.isDefault = address.id == addressId;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dirección predeterminada actualizada'),
        backgroundColor: Color(0xFF05386B),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_isEditingProfile)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveProfileChanges,
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Perfil del usuario
            _buildProfileSection(),

            // Direcciones de entrega
            _buildAddressesSection(),

            // Configuración adicional
            _buildAdditionalSettings(),

            // Espacio final
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Sección de perfil
  Widget _buildProfileSection() {
    return Container(
      margin: const EdgeInsets.all(16),
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
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Mi Perfil',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF05386B),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isEditingProfile ? Icons.close : Icons.edit_outlined,
                    color: const Color(0xFFFF6B00),
                  ),
                  onPressed: _toggleEditProfile,
                ),
              ],
            ),
          ),

          // Contenido del perfil
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _isEditingProfile
                ? _buildProfileEditForm()
                : _buildProfileInfo(),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Información del perfil (modo visualización)
  Widget _buildProfileInfo() {
    return Column(
      children: [
        // Avatar y nombre
        Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF05386B),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _userProfile.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _userProfile.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF05386B),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Información de contacto
        _buildInfoRow(
          Icons.email_outlined,
          'Correo electrónico',
          _userProfile.email,
        ),

        const SizedBox(height: 16),

        _buildInfoRow(Icons.phone_outlined, 'Teléfono', _userProfile.phone),

        const SizedBox(height: 16),

        _buildInfoRow(
          Icons.calendar_today_outlined,
          'Miembro desde',
          '${_userProfile.joinDate.day}/${_userProfile.joinDate.month}/${_userProfile.joinDate.year}',
        ),

        const SizedBox(height: 24),

        // Estadísticas
        const Text(
          'Estadísticas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF05386B),
          ),
        ),

        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('12', 'Pedidos', Icons.shopping_bag_outlined),
            _buildStatItem(
              '\$245.50',
              'Total gastado',
              Icons.attach_money_outlined,
            ),
            _buildStatItem('4.8', 'Rating', Icons.star_outlined),
          ],
        ),
      ],
    );
  }

  // Formulario de edición de perfil
  Widget _buildProfileEditForm() {
    return Form(
      key: _profileFormKey,
      child: Column(
        children: [
          // Avatar editable
          GestureDetector(
            onTap: () {
              // Cambiar foto de perfil
            },
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF05386B),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFF6B00), width: 3),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      _nameController.text.isNotEmpty
                          ? _nameController.text.substring(0, 1).toUpperCase()
                          : 'J',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B00),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Campo de nombre
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Nombre completo',
              prefixIcon: const Icon(
                Icons.person_outlined,
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
                return 'Por favor ingresa tu nombre';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Campo de email
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Correo electrónico',
              prefixIcon: const Icon(
                Icons.email_outlined,
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
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu correo electrónico';
              }
              if (!value.contains('@') || !value.contains('.')) {
                return 'Por favor ingresa un correo válido';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Campo de teléfono
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Número de teléfono',
              prefixIcon: const Icon(
                Icons.phone_outlined,
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
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu número de teléfono';
              }
              if (value.length < 8) {
                return 'Número de teléfono inválido';
              }
              return null;
            },
          ),

          const SizedBox(height: 24),

          // Botones de acción
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _toggleEditProfile,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF05386B)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Color(0xFF05386B)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveProfileChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B00),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Guardar Cambios',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF05386B), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF05386B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF05386B).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF05386B), size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF05386B),
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  // Sección de direcciones
  Widget _buildAddressesSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Direcciones de Entrega',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF05386B),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_circle_outlined,
                    color: Color(0xFFFF6B00),
                  ),
                  onPressed: _addNewAddress,
                  tooltip: 'Agregar nueva dirección',
                ),
              ],
            ),
          ),

          // Lista de direcciones
          if (_deliveryAddresses.isEmpty)
            _buildEmptyAddresses()
          else
            Column(
              children: _deliveryAddresses.map((address) {
                return _buildAddressCard(address);
              }).toList(),
            ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEmptyAddresses() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(Icons.location_on_outlined, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'No hay direcciones guardadas',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF05386B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega una dirección para recibir tus pedidos',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _addNewAddress,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B00),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Agregar Primera Dirección',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(DeliveryAddress address) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: address.isDefault
              ? const Color(0xFFFF6B00)
              : Colors.grey[200]!,
          width: address.isDefault ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // Header de la dirección
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _getAddressIcon(address.title),
                  color: const Color(0xFF05386B),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            address.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF05386B),
                            ),
                          ),
                          if (address.isDefault)
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFFF6B00,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'PREDETERMINADA',
                                  style: TextStyle(
                                    color: Color(0xFFFF6B00),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        address.address,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF05386B),
                        ),
                      ),
                      if (address.additionalInfo.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            address.additionalInfo,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        '${address.neighborhood}, ${address.municipality}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Acciones
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!address.isDefault)
                  TextButton(
                    onPressed: () => _setDefaultAddress(address.id),
                    child: const Text(
                      'Establecer como predeterminada',
                      style: TextStyle(color: Color(0xFF05386B)),
                    ),
                  ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: () => _editAddress(address),
                  color: const Color(0xFF05386B),
                  tooltip: 'Editar dirección',
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: () => _deleteAddress(address.id),
                  color: const Color(0xFFFF6B00),
                  tooltip: 'Eliminar dirección',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getAddressIcon(String title) {
    switch (title.toLowerCase()) {
      case 'casa':
        return Icons.home_outlined;
      case 'trabajo':
        return Icons.work_outlined;
      case 'universidad':
        return Icons.school_outlined;
      default:
        return Icons.location_on_outlined;
    }
  }

  // Configuración adicional
  Widget _buildAdditionalSettings() {
    return Container(
      margin: const EdgeInsets.all(16),
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
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Configuración Adicional',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF05386B),
              ),
            ),
          ),

          // Notificaciones
          _buildSettingsItem(
            Icons.notifications_outlined,
            'Notificaciones',
            'Gestiona tus preferencias de notificaciones',
            onTap: () {
              // Navegar a configuración de notificaciones
            },
            trailing: Switch(
              value: true,
              onChanged: (value) {},
              activeColor: const Color(0xFFFF6B00),
            ),
          ),

          const Divider(height: 1),

          // Privacidad
          _buildSettingsItem(
            Icons.lock_outlined,
            'Privacidad y Seguridad',
            'Gestiona tu privacidad y datos',
            onTap: () {
              // Navegar a privacidad
            },
          ),

          const Divider(height: 1),

          // Métodos de pago
          _buildSettingsItem(
            Icons.payment_outlined,
            'Métodos de Pago',
            'Gestiona tus tarjetas y métodos de pago',
            onTap: () {
              // Navegar a métodos de pago
            },
          ),

          const Divider(height: 1),

          // Ayuda
          _buildSettingsItem(
            Icons.help_outline_outlined,
            'Ayuda y Soporte',
            'Centro de ayuda y contacto',
            onTap: () {
              // Navegar a ayuda
            },
          ),

          const Divider(height: 1),

          // Acerca de
          _buildSettingsItem(
            Icons.info_outline_rounded,
            'Acerca de Manda2',
            'Información sobre la aplicación',
            onTap: () {
              // Navegar a acerca de
            },
          ),

          const Divider(height: 1),

          // Cerrar sesión
          _buildSettingsItem(
            Icons.logout_outlined,
            'Cerrar Sesión',
            'Salir de tu cuenta',
            onTap: () {
              _showLogoutConfirmation();
            },
            isDangerous: true,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    IconData icon,
    String title,
    String subtitle, {
    Widget? trailing,
    VoidCallback? onTap,
    bool isDangerous = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDangerous
                      ? Colors.red.withOpacity(0.1)
                      : const Color(0xFF05386B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isDangerous ? Colors.red : const Color(0xFF05386B),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDangerous
                            ? Colors.red
                            : const Color(0xFF05386B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing,
              ] else if (onTap != null)
                Icon(
                  Icons.chevron_right_outlined,
                  color: isDangerous ? Colors.red : const Color(0xFF05386B),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Cerrar Sesión',
          style: TextStyle(
            color: Color(0xFF05386B),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
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
              Navigator.pop(context);
              // Cerrar sesión y navegar al login
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sesión cerrada correctamente'),
                  backgroundColor: Color(0xFF05386B),
                ),
              );
              // En una app real, aquí iría la navegación al login
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
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
