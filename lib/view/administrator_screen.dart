import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  int _selectedIndex = 0;

  // Datos de ejemplo
  final List<ActiveUser> _activeUsers = [
    ActiveUser(
      id: 'USR001',
      name: 'Juan Pérez',
      email: 'juan@negocio.com',
      type: UserType.business,
      lastActive: DateTime.now().subtract(const Duration(minutes: 5)),
      status: UserStatus.active,
    ),
    ActiveUser(
      id: 'USR002',
      name: 'María García',
      email: 'maria@cliente.com',
      type: UserType.customer,
      lastActive: DateTime.now().subtract(const Duration(minutes: 15)),
      status: UserStatus.active,
    ),
    ActiveUser(
      id: 'DLV001',
      name: 'Carlos Rodríguez',
      email: 'carlos@repartidor.com',
      type: UserType.delivery,
      lastActive: DateTime.now().subtract(const Duration(minutes: 30)),
      status: UserStatus.active,
    ),
    ActiveUser(
      id: 'USR003',
      name: 'Ana Martínez',
      email: 'ana@negocio.com',
      type: UserType.business,
      lastActive: DateTime.now().subtract(const Duration(hours: 2)),
      status: UserStatus.idle,
    ),
  ];

  final List<Business> _businesses = [
    Business(
      id: 'BUS001',
      name: 'Restaurante La Esquina',
      email: 'contacto@laesquina.com',
      status: BusinessStatus.active,
      registrationDate: DateTime.now().subtract(const Duration(days: 30)),
      totalSales: 125000,
    ),
    Business(
      id: 'BUS002',
      name: 'Cafetería Central',
      email: 'info@cafeteria.com',
      status: BusinessStatus.pending,
      registrationDate: DateTime.now().subtract(const Duration(days: 15)),
      totalSales: 45000,
    ),
    Business(
      id: 'BUS003',
      name: 'Pizzería Italiana',
      email: 'italiana@pizza.com',
      status: BusinessStatus.suspended,
      registrationDate: DateTime.now().subtract(const Duration(days: 45)),
      totalSales: 89000,
    ),
  ];

  final List<DeliveryPerson> _deliveryPersons = [
    DeliveryPerson(
      id: 'DLV001',
      name: 'Carlos Rodríguez',
      email: 'carlos@repartidor.com',
      status: DeliveryStatus.active,
      rating: 4.8,
      totalDeliveries: 156,
      phone: '+52 55 1234 5678',
    ),
    DeliveryPerson(
      id: 'DLV002',
      name: 'Luis Fernández',
      email: 'luis@repartidor.com',
      status: DeliveryStatus.offline,
      rating: 4.5,
      totalDeliveries: 89,
      phone: '+52 55 2345 6789',
    ),
    DeliveryPerson(
      id: 'DLV003',
      name: 'Pedro Sánchez',
      email: 'pedro@repartidor.com',
      status: DeliveryStatus.onDelivery,
      rating: 4.9,
      totalDeliveries: 210,
      phone: '+52 55 3456 7890',
    ),
  ];

  final List<AppStat> _appStats = [
    AppStat(
      title: 'Usuarios Activos',
      value: '1,245',
      change: '+12%',
      icon: Icons.people_outlined,
      color: const Color(0xFF05386B),
    ),
    AppStat(
      title: 'Pedidos Hoy',
      value: '356',
      change: '+8%',
      icon: Icons.shopping_cart_outlined,
      color: const Color(0xFFFF6B00),
    ),
    AppStat(
      title: 'Negocios Activos',
      value: '89',
      change: '+5%',
      icon: Icons.store_outlined,
      color: const Color(0xFF00A86B),
    ),
    AppStat(
      title: 'Repartidores',
      value: '45',
      change: '+15%',
      icon: Icons.delivery_dining_outlined,
      color: const Color(0xFF6B5BEF),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 768;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _showNotifications(context);
            },
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Notificaciones',
          ),
          IconButton(
            onPressed: () {
              _showAdminProfile(context);
            },
            icon: const Icon(Icons.person_outlined),
            tooltip: 'Perfil de Administrador',
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar para pantallas grandes
          if (isLargeScreen) _buildSidebar(isLargeScreen),

          // Contenido principal
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isLargeScreen ? 24 : 16,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Encabezado y estadísticas
                  _buildHeader(),

                  const SizedBox(height: 24),

                  // Estadísticas rápidas
                  _buildQuickStats(context, isLargeScreen),

                  const SizedBox(height: 24),

                  // Contenido según selección
                  _buildSelectedContent(context, isLargeScreen),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      // BottomNavigationBar para pantallas pequeñas
      bottomNavigationBar: !isLargeScreen ? _buildBottomNavBar() : null,
    );
  }

  Widget _buildSidebar(bool isLargeScreen) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        children: [
          // Logo y título
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF05386B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Administrador',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF05386B),
                  ),
                ),
                Text(
                  'Panel de Control',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Menú de navegación
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 20),
              children: [
                _buildSidebarItem(
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                  index: 0,
                ),
                _buildSidebarItem(
                  icon: Icons.people_outlined,
                  label: 'Usuarios Activos',
                  index: 1,
                ),
                _buildSidebarItem(
                  icon: Icons.store_outlined,
                  label: 'Negocios',
                  index: 2,
                ),
                _buildSidebarItem(
                  icon: Icons.delivery_dining_outlined,
                  label: 'Repartidores',
                  index: 3,
                ),
                _buildSidebarItem(
                  icon: Icons.settings_outlined,
                  label: 'Configuración',
                  index: 4,
                ),
                _buildSidebarItem(
                  icon: Icons.receipt_long_outlined,
                  label: 'Reportes',
                  index: 5,
                ),
                _buildSidebarItem(
                  icon: Icons.security_outlined,
                  label: 'Seguridad',
                  index: 6,
                ),
              ],
            ),
          ),

          // Pie del sidebar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _showAddUserDialog(context);
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Agregar Usuario'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B00),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () {
                    // Acción para cerrar sesión
                  },
                  icon: const Icon(Icons.logout_outlined, size: 18),
                  label: const Text('Cerrar Sesión'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF05386B),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? const Color(0xFFFF6B00) : const Color(0xFF05386B),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? const Color(0xFFFF6B00) : Colors.black,
        ),
      ),
      selected: isSelected,
      selectedTileColor: const Color(0xFFFF6B00).withOpacity(0.1),
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: const Color(0xFFFF6B00),
      unselectedItemColor: const Color(0xFF05386B),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outlined),
          label: 'Usuarios',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.store_outlined),
          label: 'Negocios',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.delivery_dining_outlined),
          label: 'Repartidores',
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Panel de Administración',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF05386B),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _getSubtitle(),
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF05386B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time_outlined, color: Colors.white),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('EEEE, d MMMM y').format(DateTime.now()),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Última actualización: ${DateFormat('HH:mm').format(DateTime.now())}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getSubtitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Resumen general y estadísticas de la plataforma';
      case 1:
        return 'Gestión de usuarios activos y sus permisos';
      case 2:
        return 'Administración de negocios registrados';
      case 3:
        return 'Control de repartidores y sus asignaciones';
      case 4:
        return 'Configuración de la plataforma';
      case 5:
        return 'Reportes y análisis de datos';
      case 6:
        return 'Configuración de seguridad y permisos';
      default:
        return 'Panel de administración';
    }
  }

  Widget _buildQuickStats(BuildContext context, bool isLargeScreen) {
    if (isLargeScreen) {
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
        children: _appStats.map((stat) => _buildStatCard(stat)).toList(),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: _appStats.map((stat) => _buildStatCard(stat)).toList(),
    );
  }

  Widget _buildStatCard(AppStat stat) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: stat.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(stat.icon, color: stat.color, size: 20),
                ),
                Text(
                  stat.change,
                  style: TextStyle(
                    color: stat.change.startsWith('+')
                        ? const Color(0xFF00A86B)
                        : const Color(0xFFFF3B30),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              stat.value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: stat.color,
              ),
            ),
            Text(
              stat.title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedContent(BuildContext context, bool isLargeScreen) {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardContent(context, isLargeScreen);
      case 1:
        return _buildUsersContent(context, isLargeScreen);
      case 2:
        return _buildBusinessesContent(context, isLargeScreen);
      case 3:
        return _buildDeliveryContent(context, isLargeScreen);
      case 4:
        return _buildSettingsContent(context, isLargeScreen);
      case 5:
        return _buildReportsContent(context, isLargeScreen);
      case 6:
        return _buildSecurityContent(context, isLargeScreen);
      default:
        return _buildDashboardContent(context, isLargeScreen);
    }
  }

  Widget _buildDashboardContent(BuildContext context, bool isLargeScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Actividad Reciente',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF05386B),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _viewAllActivity(context);
              },
              child: const Text('Ver Todo'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildActivityItem(
                  icon: Icons.person_add_outlined,
                  title: 'Nuevo Negocio Registrado',
                  subtitle:
                      'Panadería Dulce Hogar se registró en la plataforma',
                  time: 'Hace 15 minutos',
                  color: const Color(0xFF00A86B),
                ),
                const Divider(height: 32),
                _buildActivityItem(
                  icon: Icons.warning_outlined,
                  title: 'Reporte de Problema',
                  subtitle: 'Usuario reportó problema con pedido #ORD12345',
                  time: 'Hace 30 minutos',
                  color: const Color(0xFFFF6B00),
                ),
                const Divider(height: 32),
                _buildActivityItem(
                  icon: Icons.attach_money_outlined,
                  title: 'Liquidación Completada',
                  subtitle: 'Liquidación #LIQ789 procesada exitosamente',
                  time: 'Hace 2 horas',
                  color: const Color(0xFF6B5BEF),
                ),
                const Divider(height: 32),
                _buildActivityItem(
                  icon: Icons.security_outlined,
                  title: 'Intento de Acceso Sospechoso',
                  subtitle:
                      'Intento de acceso bloqueado desde IP 192.168.1.100',
                  time: 'Hace 5 horas',
                  color: const Color(0xFFFF3B30),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  _showAddBusinessDialog(context);
                },
                icon: const Icon(Icons.store_outlined),
                label: const Text('Agregar Negocio'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF05386B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  _showAddDeliveryDialog(context);
                },
                icon: const Icon(Icons.delivery_dining_outlined),
                label: const Text('Agregar Repartidor'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B00),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUsersContent(BuildContext context, bool isLargeScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Usuarios Activos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF05386B),
                ),
              ),
            ),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _showAddUserDialog(context);
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Agregar Usuario'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF05386B),
                    foregroundColor: Colors.white,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () {
                    _refreshUsers();
                  },
                  icon: const Icon(Icons.refresh_outlined),
                  tooltip: 'Actualizar',
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: isLargeScreen ? _buildUsersTable() : _buildUsersList(),
          ),
        ),
      ],
    );
  }

  Widget _buildUsersTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 32,
        columns: const [
          DataColumn(label: Text('Usuario')),
          DataColumn(label: Text('Tipo')),
          DataColumn(label: Text('Estado')),
          DataColumn(label: Text('Última Actividad')),
          DataColumn(label: Text('Acciones')),
        ],
        rows: _activeUsers.map((user) {
          return DataRow(
            cells: [
              DataCell(
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getUserTypeColor(user.type).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getUserTypeIcon(user.type),
                        color: _getUserTypeColor(user.type),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          user.email,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              DataCell(Text(_getUserTypeText(user.type))),
              DataCell(_buildStatusChip(user.status)),
              DataCell(Text(_getTimeAgo(user.lastActive))),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility_outlined, size: 18),
                      onPressed: () {
                        _viewUserDetails(user);
                      },
                      color: const Color(0xFF05386B),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      onPressed: () {
                        _editUser(user);
                      },
                      color: const Color(0xFFFF6B00),
                    ),
                    IconButton(
                      icon: const Icon(Icons.block_outlined, size: 18),
                      onPressed: () {
                        _blockUser(user);
                      },
                      color: const Color(0xFFFF3B30),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildUsersList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _activeUsers.length,
      separatorBuilder: (context, index) => const Divider(height: 24),
      itemBuilder: (context, index) {
        final user = _activeUsers[index];
        return ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _getUserTypeColor(user.type).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getUserTypeIcon(user.type),
              color: _getUserTypeColor(user.type),
            ),
          ),
          title: Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.email),
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildStatusChip(user.status),
                  const SizedBox(width: 8),
                  Text(
                    _getTimeAgo(user.lastActive),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          trailing: PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'view',
                child: Row(
                  children: [
                    Icon(Icons.visibility_outlined, size: 18),
                    SizedBox(width: 8),
                    Text('Ver Detalles'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 18),
                    SizedBox(width: 8),
                    Text('Editar'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'block',
                child: Row(
                  children: [
                    Icon(Icons.block_outlined, size: 18),
                    SizedBox(width: 8),
                    Text('Bloquear'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'view':
                  _viewUserDetails(user);
                  break;
                case 'edit':
                  _editUser(user);
                  break;
                case 'block':
                  _blockUser(user);
                  break;
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildBusinessesContent(BuildContext context, bool isLargeScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Negocios Registrados',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF05386B),
                ),
              ),
            ),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _showAddBusinessDialog(context);
                  },
                  icon: const Icon(Icons.add_business_outlined, size: 18),
                  label: const Text('Agregar Negocio'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF05386B),
                    foregroundColor: Colors.white,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () {
                    _refreshBusinesses();
                  },
                  icon: const Icon(Icons.filter_list_outlined),
                  tooltip: 'Filtrar',
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if (isLargeScreen)
                  _buildBusinessesTable()
                else
                  _buildBusinessesList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessesTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 32,
        columns: const [
          DataColumn(label: Text('Negocio')),
          DataColumn(label: Text('Estado')),
          DataColumn(label: Text('Registro')),
          DataColumn(label: Text('Ventas Totales')),
          DataColumn(label: Text('Acciones')),
        ],
        rows: _businesses.map((business) {
          return DataRow(
            cells: [
              DataCell(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      business.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      business.email,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              DataCell(_buildBusinessStatusChip(business.status)),
              DataCell(Text(_dateFormat.format(business.registrationDate))),
              DataCell(Text('\$${business.totalSales.toStringAsFixed(0)}')),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility_outlined, size: 18),
                      onPressed: () {
                        _viewBusinessDetails(business);
                      },
                      color: const Color(0xFF05386B),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      onPressed: () {
                        _editBusiness(business);
                      },
                      color: const Color(0xFFFF6B00),
                    ),
                    IconButton(
                      icon: const Icon(Icons.email_outlined, size: 18),
                      onPressed: () {
                        _contactBusiness(business);
                      },
                      color: const Color(0xFF00A86B),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBusinessesList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _businesses.length,
      separatorBuilder: (context, index) => const Divider(height: 24),
      itemBuilder: (context, index) {
        final business = _businesses[index];
        return ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF05386B).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.store_outlined, color: Color(0xFF05386B)),
          ),
          title: Text(
            business.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(business.email),
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildBusinessStatusChip(business.status),
                  const SizedBox(width: 8),
                  Text(
                    'Registro: ${_dateFormat.format(business.registrationDate)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          trailing: Text(
            '\$${business.totalSales.toStringAsFixed(0)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF00A86B),
            ),
          ),
          onTap: () {
            _viewBusinessDetails(business);
          },
        );
      },
    );
  }

  Widget _buildDeliveryContent(BuildContext context, bool isLargeScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Repartidores',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF05386B),
                ),
              ),
            ),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _showAddDeliveryDialog(context);
                  },
                  icon: const Icon(Icons.person_add_outlined, size: 18),
                  label: const Text('Agregar Repartidor'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF05386B),
                    foregroundColor: Colors.white,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () {
                    _refreshDeliveryPersons();
                  },
                  icon: const Icon(Icons.refresh_outlined),
                  tooltip: 'Actualizar',
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if (isLargeScreen)
                  _buildDeliveryTable()
                else
                  _buildDeliveryList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 32,
        columns: const [
          DataColumn(label: Text('Repartidor')),
          DataColumn(label: Text('Estado')),
          DataColumn(label: Text('Calificación')),
          DataColumn(label: Text('Entregas')),
          DataColumn(label: Text('Acciones')),
        ],
        rows: _deliveryPersons.map((delivery) {
          return DataRow(
            cells: [
              DataCell(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      delivery.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      delivery.email,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              DataCell(_buildDeliveryStatusChip(delivery.status)),
              DataCell(
                Row(
                  children: [
                    Text(delivery.rating.toStringAsFixed(1)),
                    const SizedBox(width: 4),
                    const Icon(Icons.star, size: 16, color: Color(0xFFFF6B00)),
                  ],
                ),
              ),
              DataCell(Text(delivery.totalDeliveries.toString())),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility_outlined, size: 18),
                      onPressed: () {
                        _viewDeliveryDetails(delivery);
                      },
                      color: const Color(0xFF05386B),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      onPressed: () {
                        _editDelivery(delivery);
                      },
                      color: const Color(0xFFFF6B00),
                    ),
                    IconButton(
                      icon: const Icon(Icons.location_on_outlined, size: 18),
                      onPressed: () {
                        _trackDelivery(delivery);
                      },
                      color: const Color(0xFF00A86B),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDeliveryList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _deliveryPersons.length,
      separatorBuilder: (context, index) => const Divider(height: 24),
      itemBuilder: (context, index) {
        final delivery = _deliveryPersons[index];
        return ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF6B5BEF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.delivery_dining_outlined,
              color: Color(0xFF6B5BEF),
            ),
          ),
          title: Text(
            delivery.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(delivery.email),
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildDeliveryStatusChip(delivery.status),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      Text(delivery.rating.toStringAsFixed(1)),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.star,
                        size: 14,
                        color: Color(0xFFFF6B00),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${delivery.totalDeliveries} entregas',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                delivery.phone,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          onTap: () {
            _viewDeliveryDetails(delivery);
          },
        );
      },
    );
  }

  Widget _buildSettingsContent(BuildContext context, bool isLargeScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Configuración de la Plataforma',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF05386B),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildSettingItem(
                  icon: Icons.percent_outlined,
                  title: 'Comisiones',
                  subtitle: 'Configurar porcentajes de comisión',
                  onTap: () {
                    _configureCommissions();
                  },
                ),
                const Divider(),
                _buildSettingItem(
                  icon: Icons.credit_card_outlined,
                  title: 'Métodos de Pago',
                  subtitle: 'Gestionar métodos de pago aceptados',
                  onTap: () {
                    _configurePaymentMethods();
                  },
                ),
                const Divider(),
                _buildSettingItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notificaciones',
                  subtitle: 'Configurar sistema de notificaciones',
                  onTap: () {
                    _configureNotifications();
                  },
                ),
                const Divider(),
                _buildSettingItem(
                  icon: Icons.language_outlined,
                  title: 'Región y Zonas',
                  subtitle: 'Configurar zonas de cobertura',
                  onTap: () {
                    _configureZones();
                  },
                ),
                const Divider(),
                _buildSettingItem(
                  icon: Icons.backup_outlined,
                  title: 'Backup y Restauración',
                  subtitle: 'Gestionar copias de seguridad',
                  onTap: () {
                    _configureBackup();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReportsContent(BuildContext context, bool isLargeScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reportes y Análisis',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF05386B),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildReportCard(
              title: 'Reporte de Ventas',
              icon: Icons.trending_up_outlined,
              onTap: () {
                _generateSalesReport();
              },
            ),
            _buildReportCard(
              title: 'Reporte de Usuarios',
              icon: Icons.people_outlined,
              onTap: () {
                _generateUsersReport();
              },
            ),
            _buildReportCard(
              title: 'Reporte de Negocios',
              icon: Icons.store_outlined,
              onTap: () {
                _generateBusinessesReport();
              },
            ),
            _buildReportCard(
              title: 'Reporte de Repartidores',
              icon: Icons.delivery_dining_outlined,
              onTap: () {
                _generateDeliveryReport();
              },
            ),
            _buildReportCard(
              title: 'Reporte Financiero',
              icon: Icons.attach_money_outlined,
              onTap: () {
                _generateFinancialReport();
              },
            ),
            _buildReportCard(
              title: 'Reporte de Comisiones',
              icon: Icons.percent_outlined,
              onTap: () {
                _generateCommissionReport();
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSecurityContent(BuildContext context, bool isLargeScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Seguridad y Permisos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF05386B),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Autenticación de Dos Factores'),
                  subtitle: const Text('Requerir 2FA para administradores'),
                  value: true,
                  activeColor: const Color(0xFF05386B),
                  onChanged: (value) {},
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Registro de Actividad'),
                  subtitle: const Text(
                    'Guardar registro de todas las acciones',
                  ),
                  value: true,
                  activeColor: const Color(0xFF05386B),
                  onChanged: (value) {},
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Verificación de Email'),
                  subtitle: const Text(
                    'Requerir verificación de email para nuevos usuarios',
                  ),
                  value: true,
                  activeColor: const Color(0xFF05386B),
                  onChanged: (value) {},
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.security_outlined,
                    color: Color(0xFF05386B),
                  ),
                  title: const Text('Roles y Permisos'),
                  subtitle: const Text('Gestionar permisos de usuarios'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 16,
                  ),
                  onTap: () {
                    _manageRoles();
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.history_outlined,
                    color: Color(0xFF05386B),
                  ),
                  title: const Text('Historial de Seguridad'),
                  subtitle: const Text('Ver eventos de seguridad recientes'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 16,
                  ),
                  onTap: () {
                    _viewSecurityHistory();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ),
        Text(time, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
      ],
    );
  }

  Widget _buildStatusChip(UserStatus status) {
    final color = _getStatusColor(status);
    final text = _getStatusText(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildBusinessStatusChip(BusinessStatus status) {
    final color = _getBusinessStatusColor(status);
    final text = _getBusinessStatusText(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDeliveryStatusChip(DeliveryStatus status) {
    final color = _getDeliveryStatusColor(status);
    final text = _getDeliveryStatusText(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF05386B)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios_outlined, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildReportCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 150,
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF05386B).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: const Color(0xFF05386B), size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Métodos de utilidad
  Color _getUserTypeColor(UserType type) {
    switch (type) {
      case UserType.business:
        return const Color(0xFF05386B);
      case UserType.customer:
        return const Color(0xFF00A86B);
      case UserType.delivery:
        return const Color(0xFF6B5BEF);
      case UserType.admin:
        return const Color(0xFFFF6B00);
    }
  }

  IconData _getUserTypeIcon(UserType type) {
    switch (type) {
      case UserType.business:
        return Icons.store_outlined;
      case UserType.customer:
        return Icons.person_outlined;
      case UserType.delivery:
        return Icons.delivery_dining_outlined;
      case UserType.admin:
        return Icons.admin_panel_settings_outlined;
    }
  }

  String _getUserTypeText(UserType type) {
    switch (type) {
      case UserType.business:
        return 'Negocio';
      case UserType.customer:
        return 'Cliente';
      case UserType.delivery:
        return 'Repartidor';
      case UserType.admin:
        return 'Administrador';
    }
  }

  Color _getStatusColor(UserStatus status) {
    switch (status) {
      case UserStatus.active:
        return const Color(0xFF00A86B);
      case UserStatus.idle:
        return const Color(0xFFFF6B00);
      case UserStatus.inactive:
        return const Color(0xFF6B5BEF);
      case UserStatus.blocked:
        return const Color(0xFFFF3B30);
    }
  }

  String _getStatusText(UserStatus status) {
    switch (status) {
      case UserStatus.active:
        return 'Activo';
      case UserStatus.idle:
        return 'Inactivo';
      case UserStatus.inactive:
        return 'Desconectado';
      case UserStatus.blocked:
        return 'Bloqueado';
    }
  }

  Color _getBusinessStatusColor(BusinessStatus status) {
    switch (status) {
      case BusinessStatus.active:
        return const Color(0xFF00A86B);
      case BusinessStatus.pending:
        return const Color(0xFFFF6B00);
      case BusinessStatus.suspended:
        return const Color(0xFFFF3B30);
      case BusinessStatus.inactive:
        return const Color(0xFF6B5BEF);
    }
  }

  String _getBusinessStatusText(BusinessStatus status) {
    switch (status) {
      case BusinessStatus.active:
        return 'Activo';
      case BusinessStatus.pending:
        return 'Pendiente';
      case BusinessStatus.suspended:
        return 'Suspendido';
      case BusinessStatus.inactive:
        return 'Inactivo';
    }
  }

  Color _getDeliveryStatusColor(DeliveryStatus status) {
    switch (status) {
      case DeliveryStatus.active:
        return const Color(0xFF00A86B);
      case DeliveryStatus.offline:
        return const Color(0xFF6B5BEF);
      case DeliveryStatus.onDelivery:
        return const Color(0xFFFF6B00);
      case DeliveryStatus.unavailable:
        return const Color(0xFFFF3B30);
    }
  }

  String _getDeliveryStatusText(DeliveryStatus status) {
    switch (status) {
      case DeliveryStatus.active:
        return 'Disponible';
      case DeliveryStatus.offline:
        return 'Sin conexión';
      case DeliveryStatus.onDelivery:
        return 'En entrega';
      case DeliveryStatus.unavailable:
        return 'No disponible';
    }
  }

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Ahora mismo';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} h';
    } else {
      return 'Hace ${difference.inDays} días';
    }
  }

  // Métodos de diálogos y acciones
  void _showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Nuevo Usuario'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Se enviará un correo con credenciales temporales'),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Usuario',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'business', child: Text('Negocio')),
                    DropdownMenuItem(
                      value: 'delivery',
                      child: Text('Repartidor'),
                    ),
                    DropdownMenuItem(
                      value: 'admin',
                      child: Text('Administrador'),
                    ),
                  ],
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Correo enviado exitosamente'),
                    backgroundColor: Color(0xFF00A86B),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF05386B),
                foregroundColor: Colors.white,
              ),
              child: const Text('Enviar Invitación'),
            ),
          ],
        );
      },
    );
  }

  void _showAddBusinessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Nuevo Negocio'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'El negocio recibirá un correo para configurar su cuenta',
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nombre del Negocio',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Teléfono de Contacto',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Negocio agregado exitosamente'),
                    backgroundColor: Color(0xFF00A86B),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF05386B),
                foregroundColor: Colors.white,
              ),
              child: const Text('Agregar Negocio'),
            ),
          ],
        );
      },
    );
  }

  void _showAddDeliveryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Nuevo Repartidor'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'El repartidor recibirá un correo para configurar su cuenta',
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nombre Completo',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Repartidor agregado exitosamente'),
                    backgroundColor: Color(0xFF00A86B),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF05386B),
                foregroundColor: Colors.white,
              ),
              child: const Text('Agregar Repartidor'),
            ),
          ],
        );
      },
    );
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notificaciones',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF05386B),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _buildNotificationItem(
                      title: 'Nuevo registro de negocio',
                      subtitle: 'Panadería Dulce Hogar se registró',
                      time: 'Hace 15 min',
                      isRead: false,
                    ),
                    _buildNotificationItem(
                      title: 'Reporte resuelto',
                      subtitle: 'Problema con pedido #ORD12345 solucionado',
                      time: 'Hace 2 h',
                      isRead: true,
                    ),
                    _buildNotificationItem(
                      title: 'Actualización del sistema',
                      subtitle: 'Nueva versión disponible',
                      time: 'Hace 5 h',
                      isRead: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String subtitle,
    required String time,
    required bool isRead,
  }) {
    return ListTile(
      leading: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: isRead ? Colors.transparent : const Color(0xFFFF6B00),
          shape: BoxShape.circle,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: Text(
        time,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }

  void _showAdminProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Perfil de Administrador'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF05386B),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outlined,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Administrador Principal',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text('admin@manda2.com'),
              const SizedBox(height: 16),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.security_outlined),
                title: const Text('Cambiar Contraseña'),
                onTap: () {
                  Navigator.pop(context);
                  // Acción para cambiar contraseña
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Preferencias'),
                onTap: () {
                  Navigator.pop(context);
                  // Acción para preferencias
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  // Métodos para acciones (simulados)
  void _viewAllActivity(BuildContext context) {}
  void _refreshUsers() {}
  void _viewUserDetails(ActiveUser user) {}
  void _editUser(ActiveUser user) {}
  void _blockUser(ActiveUser user) {}
  void _refreshBusinesses() {}
  void _viewBusinessDetails(Business business) {}
  void _editBusiness(Business business) {}
  void _contactBusiness(Business business) {}
  void _refreshDeliveryPersons() {}
  void _viewDeliveryDetails(DeliveryPerson delivery) {}
  void _editDelivery(DeliveryPerson delivery) {}
  void _trackDelivery(DeliveryPerson delivery) {}
  void _configureCommissions() {}
  void _configurePaymentMethods() {}
  void _configureNotifications() {}
  void _configureZones() {}
  void _configureBackup() {}
  void _generateSalesReport() {}
  void _generateUsersReport() {}
  void _generateBusinessesReport() {}
  void _generateDeliveryReport() {}
  void _generateFinancialReport() {}
  void _generateCommissionReport() {}
  void _manageRoles() {}
  void _viewSecurityHistory() {}
}

// Enums y modelos de datos
enum UserType { business, customer, delivery, admin }

enum UserStatus { active, idle, inactive, blocked }

enum BusinessStatus { active, pending, suspended, inactive }

enum DeliveryStatus { active, offline, onDelivery, unavailable }

class ActiveUser {
  final String id;
  final String name;
  final String email;
  final UserType type;
  final DateTime lastActive;
  final UserStatus status;

  ActiveUser({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
    required this.lastActive,
    required this.status,
  });
}

class Business {
  final String id;
  final String name;
  final String email;
  final BusinessStatus status;
  final DateTime registrationDate;
  final double totalSales;

  Business({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.registrationDate,
    required this.totalSales,
  });
}

class DeliveryPerson {
  final String id;
  final String name;
  final String email;
  final DeliveryStatus status;
  final double rating;
  final int totalDeliveries;
  final String phone;

  DeliveryPerson({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.rating,
    required this.totalDeliveries,
    required this.phone,
  });
}

class AppStat {
  final String title;
  final String value;
  final String change;
  final IconData icon;
  final Color color;

  AppStat({
    required this.title,
    required this.value,
    required this.change,
    required this.icon,
    required this.color,
  });
}
