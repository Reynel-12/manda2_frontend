import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BusinessSettingsScreen extends StatefulWidget {
  const BusinessSettingsScreen({super.key});

  @override
  State<BusinessSettingsScreen> createState() => _BusinessSettingsScreenState();
}

class _BusinessSettingsScreenState extends State<BusinessSettingsScreen> {
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
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _websiteController;
  late TextEditingController _deliveryRadiusController;
  late TextEditingController _preparationTimeController;

  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: _businessProfile.name);
    _descriptionController = TextEditingController(
      text: _businessProfile.description,
    );
    _addressController = TextEditingController(text: _businessProfile.address);
    _cityController = TextEditingController(text: _businessProfile.city);
    _phoneController = TextEditingController(text: _businessProfile.phone);
    _emailController = TextEditingController(text: _businessProfile.email);
    _websiteController = TextEditingController(text: _businessProfile.website);
    _deliveryRadiusController = TextEditingController(
      text: _businessProfile.deliveryRadius.toString(),
    );
    _preparationTimeController = TextEditingController(
      text: _businessProfile.preparationTime.toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _deliveryRadiusController.dispose();
    _preparationTimeController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Si salimos del modo edición, restauramos los valores originales
        _initializeControllers();
      }
    });
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simular una petición a la API
      await Future.delayed(const Duration(seconds: 1));

      // Actualizar el perfil con los nuevos datos
      setState(() {
        _businessProfile = _businessProfile.copyWith(
          name: _nameController.text,
          description: _descriptionController.text,
          address: _addressController.text,
          city: _cityController.text,
          phone: _phoneController.text,
          email: _emailController.text,
          website: _websiteController.text,
          deliveryRadius:
              double.tryParse(_deliveryRadiusController.text) ?? 5.0,
          preparationTime: int.tryParse(_preparationTimeController.text) ?? 25,
        );
        _isEditing = false;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Cambios guardados exitosamente'),
          backgroundColor: const Color(0xFF05386B),
          action: SnackBarAction(label: 'OK', onPressed: () {}),
        ),
      );
    }
  }

  void _addBannerImage() {
    // En una aplicación real, aquí se implementaría la selección de imágenes
    setState(() {
      _businessProfile.bannerUrls.add(
        'https://via.placeholder.com/400x200/00A86B/FFFFFF?text=BANNER+NUEVO',
      );
    });
  }

  void _removeBannerImage(int index) {
    setState(() {
      _businessProfile.bannerUrls.removeAt(index);
    });
  }

  void _updateLogo() {
    // En una aplicación real, aquí se implementaría la selección de logo
    setState(() {
      _businessProfile = _businessProfile.copyWith(
        logoUrl:
            'https://via.placeholder.com/150/FF6B00/FFFFFF?text=NUEVO+LOGO',
      );
    });
  }

  void _updateSchedule(int index) async {
    final day = _businessProfile.schedule[index];

    final newOpenTime = await showTimePicker(
      context: context,
      initialTime: day.openTime,
    );

    if (newOpenTime != null) {
      final newCloseTime = await showTimePicker(
        context: context,
        initialTime: day.closeTime,
      );

      if (newCloseTime != null) {
        setState(() {
          final newSchedule = List<BusinessDay>.from(_businessProfile.schedule);
          newSchedule[index] = day.copyWith(
            openTime: newOpenTime,
            closeTime: newCloseTime,
          );
          _businessProfile = _businessProfile.copyWith(schedule: newSchedule);
        });
      }
    }
  }

  void _toggleDayStatus(int index) {
    setState(() {
      final newSchedule = List<BusinessDay>.from(_businessProfile.schedule);
      newSchedule[index] = newSchedule[index].copyWith(
        isOpen: !newSchedule[index].isOpen,
      );
      _businessProfile = _businessProfile.copyWith(schedule: newSchedule);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 768;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración del Negocio'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _toggleEditMode,
            icon: Icon(
              _isEditing ? Icons.close : Icons.edit_outlined,
              color: Colors.black,
            ),
            tooltip: _isEditing ? 'Cancelar' : 'Editar',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF05386B)),
            )
          : SingleChildScrollView(
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

                    // Logo del negocio
                    _buildLogoSection(),

                    const SizedBox(height: 24),

                    // Imágenes del banner
                    _buildBannerSection(context, isLargeScreen),

                    const SizedBox(height: 24),

                    // Información básica
                    _buildBasicInfoSection(isLargeScreen),

                    const SizedBox(height: 24),

                    // Dirección
                    _buildAddressSection(isLargeScreen),

                    const SizedBox(height: 24),

                    // Horario
                    _buildScheduleSection(),

                    const SizedBox(height: 24),

                    // Configuración de delivery
                    _buildDeliverySection(isLargeScreen),

                    const SizedBox(height: 32),

                    // Botones de acción
                    if (_isEditing) _buildActionButtons(),

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
          'Perfil del Negocio',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF05386B),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _isEditing
              ? 'Edita la información de tu negocio'
              : 'Gestiona la información pública de tu negocio',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Negocio Activo',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            _businessProfile.isActive
                ? 'Tu negocio está visible para los clientes'
                : 'Tu negocio está oculto temporalmente',
          ),
          value: _businessProfile.isActive,
          activeColor: const Color(0xFF05386B),
          onChanged: _isEditing
              ? (value) {
                  setState(() {
                    _businessProfile = _businessProfile.copyWith(
                      isActive: value,
                    );
                  });
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildLogoSection() {
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
                    'Logo del Negocio',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF05386B),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (_isEditing)
                  ElevatedButton(
                    onPressed: _updateLogo,
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.camera_alt_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('Cambiar Logo'),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(_businessProfile.logoUrl),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: Colors.grey[300]!, width: 2),
                ),
                child: _isEditing
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Tamaño recomendado: 500x500 px',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerSection(BuildContext context, bool isLargeScreen) {
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
                    'Imágenes del Negocio',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF05386B),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (_isEditing)
                  ElevatedButton(
                    onPressed: _addBannerImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B00),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.add_photo_alternate_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('Agregar Imagen'),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Máximo 5 imágenes. Muestra lo mejor de tu negocio',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isLargeScreen ? 3 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2,
              ),
              itemCount: _businessProfile.bannerUrls.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(
                            _businessProfile.bannerUrls[index],
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (_isEditing)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => _removeBannerImage(index),
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

            // Nombre del negocio
            _buildEditableField(
              controller: _nameController,
              label: 'Nombre del Negocio',
              hintText: 'Ingresa el nombre de tu negocio',
              isEditing: _isEditing,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El nombre es requerido';
                }
                if (value.length < 3) {
                  return 'El nombre debe tener al menos 3 caracteres';
                }
                return null;
              },
            ),

            // Descripción
            _buildEditableField(
              controller: _descriptionController,
              label: 'Descripción',
              hintText: 'Describe tu negocio',
              maxLines: 3,
              isEditing: _isEditing,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La descripción es requerida';
                }
                if (value.length < 10) {
                  return 'La descripción debe tener al menos 10 caracteres';
                }
                return null;
              },
            ),

            if (isLargeScreen)
              _buildContactInfoRow()
            else
              Column(
                children: [
                  // Teléfono
                  _buildEditableField(
                    controller: _phoneController,
                    label: 'Teléfono',
                    hintText: '+52 55 1234 5678',
                    isEditing: _isEditing,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El teléfono es requerido';
                      }
                      return null;
                    },
                  ),

                  // Email
                  _buildEditableField(
                    controller: _emailController,
                    label: 'Correo Electrónico',
                    hintText: 'contacto@negocio.com',
                    isEditing: _isEditing,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El email es requerido';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Ingresa un email válido';
                      }
                      return null;
                    },
                  ),

                  // Sitio web
                  _buildEditableField(
                    controller: _websiteController,
                    label: 'Sitio Web',
                    hintText: 'www.tunegocio.com',
                    isEditing: _isEditing,
                    keyboardType: TextInputType.url,
                  ),
                ],
              ),

            // Categorías
            const SizedBox(height: 16),
            const Text(
              'Categorías',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF05386B),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _businessProfile.categories.map((category) {
                return Chip(
                  label: Text(category),
                  backgroundColor: const Color(0xFF05386B).withOpacity(0.1),
                  deleteIcon: _isEditing
                      ? const Icon(Icons.close, size: 16)
                      : null,
                  onDeleted: _isEditing
                      ? () {
                          setState(() {
                            _businessProfile.categories.remove(category);
                          });
                        }
                      : null,
                );
              }).toList(),
            ),
            if (_isEditing)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Acción para agregar categoría
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Agregar Categoría'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: const Color(0xFF05386B),
                    elevation: 0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildEditableField(
            controller: _phoneController,
            label: 'Teléfono',
            hintText: '+52 55 1234 5678',
            isEditing: _isEditing,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El teléfono es requerido';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildEditableField(
            controller: _emailController,
            label: 'Correo Electrónico',
            hintText: 'contacto@negocio.com',
            isEditing: _isEditing,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El email es requerido';
              }
              if (!value.contains('@') || !value.contains('.')) {
                return 'Ingresa un email válido';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildEditableField(
            controller: _websiteController,
            label: 'Sitio Web',
            hintText: 'www.tunegocio.com',
            isEditing: _isEditing,
            keyboardType: TextInputType.url,
          ),
        ),
      ],
    );
  }

  Widget _buildAddressSection(bool isLargeScreen) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ubicación y Dirección',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF05386B),
              ),
            ),
            const SizedBox(height: 16),

            if (isLargeScreen)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildEditableField(
                      controller: _addressController,
                      label: 'Dirección',
                      hintText: 'Calle y número',
                      isEditing: _isEditing,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La dirección es requerida';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildEditableField(
                      controller: _cityController,
                      label: 'Ciudad',
                      hintText: 'Nombre de la ciudad',
                      isEditing: _isEditing,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La ciudad es requerida';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  _buildEditableField(
                    controller: _addressController,
                    label: 'Dirección',
                    hintText: 'Calle y número',
                    isEditing: _isEditing,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La dirección es requerida';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildEditableField(
                    controller: _cityController,
                    label: 'Ciudad',
                    hintText: 'Nombre de la ciudad',
                    isEditing: _isEditing,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La ciudad es requerida';
                      }
                      return null;
                    },
                  ),
                ],
              ),

            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[100],
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map_outlined,
                      size: 48,
                      color: Color(0xFF05386B),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Mapa de ubicación',
                      style: TextStyle(
                        color: Color(0xFF05386B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Haz clic para ver en el mapa',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            if (_isEditing)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Acción para actualizar ubicación en mapa
                  },
                  icon: const Icon(Icons.location_on_outlined, size: 18),
                  label: const Text('Actualizar Ubicación en Mapa'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF05386B),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleSection() {
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
                    'Horario de Atención',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF05386B),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (_isEditing)
                  ElevatedButton(
                    onPressed: () {
                      // Acción para copiar horario a todos los días
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B00),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.copy_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('Copiar Horario'),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Configura los horarios de atención por día',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _businessProfile.schedule.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final day = _businessProfile.schedule[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  leading: Checkbox(
                    value: day.isOpen,
                    activeColor: const Color(0xFF05386B),
                    onChanged: _isEditing
                        ? (value) => _toggleDayStatus(index)
                        : null,
                  ),
                  title: Text(
                    day.day,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: day.isOpen ? Colors.black : Colors.grey,
                    ),
                  ),
                  subtitle: day.isOpen
                      ? Text(
                          '${_formatTime(day.openTime)} - ${_formatTime(day.closeTime)}',
                          style: const TextStyle(fontSize: 14),
                        )
                      : const Text(
                          'Cerrado',
                          style: TextStyle(color: Colors.grey),
                        ),
                  trailing: _isEditing && day.isOpen
                      ? IconButton(
                          onPressed: () => _updateSchedule(index),
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: Color(0xFF05386B),
                          ),
                        )
                      : null,
                  onTap: _isEditing && day.isOpen
                      ? () => _updateSchedule(index)
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliverySection(bool isLargeScreen) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configuración de Delivery',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF05386B),
              ),
            ),
            const SizedBox(height: 16),

            if (isLargeScreen)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildEditableField(
                      controller: _deliveryRadiusController,
                      label: 'Radio de Entrega (km)',
                      hintText: '5',
                      isEditing: _isEditing,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El radio es requerido';
                        }
                        final radius = double.tryParse(value);
                        if (radius == null || radius <= 0) {
                          return 'Ingresa un número válido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildEditableField(
                      controller: _preparationTimeController,
                      label: 'Tiempo de Preparación (min)',
                      hintText: '25',
                      isEditing: _isEditing,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El tiempo es requerido';
                        }
                        final time = int.tryParse(value);
                        if (time == null || time <= 0) {
                          return 'Ingresa un número válido';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  _buildEditableField(
                    controller: _deliveryRadiusController,
                    label: 'Radio de Entrega (km)',
                    hintText: '5',
                    isEditing: _isEditing,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El radio es requerido';
                      }
                      final radius = double.tryParse(value);
                      if (radius == null || radius <= 0) {
                        return 'Ingresa un número válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildEditableField(
                    controller: _preparationTimeController,
                    label: 'Tiempo de Preparación (min)',
                    hintText: '25',
                    isEditing: _isEditing,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El tiempo es requerido';
                      }
                      final time = int.tryParse(value);
                      if (time == null || time <= 0) {
                        return 'Ingresa un número válido';
                      }
                      return null;
                    },
                  ),
                ],
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
                    child: Text(
                      'El radio de entrega determina la zona geográfica donde ofreces delivery. '
                      'Los clientes fuera de esta zona no podrán realizar pedidos.',
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
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

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _toggleEditMode,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Cancelar',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _saveChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B00),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Guardar Cambios',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required bool isEditing,
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
          isEditing
              ? TextFormField(
                  controller: controller,
                  maxLines: maxLines,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    hintText: hintText,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: validator,
                )
              : Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Text(
                    controller.text.isNotEmpty
                        ? controller.text
                        : 'No especificado',
                    style: TextStyle(
                      fontSize: 16,
                      color: controller.text.isNotEmpty
                          ? Colors.black
                          : Colors.grey,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    return DateFormat('h:mm a').format(dateTime);
  }
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
