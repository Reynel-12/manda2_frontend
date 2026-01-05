import 'package:flutter/material.dart';
import 'package:manda2_frontend/view/client/carrito_screen.dart';
import 'package:manda2_frontend/view/general/configuracion_screen.dart';
import 'package:manda2_frontend/view/client/favorite_screen.dart'
    hide StoreScreen;
import 'package:manda2_frontend/view/client/order_history_screen.dart';
import 'package:manda2_frontend/view/client/order_tracking_screen.dart';
import 'package:manda2_frontend/view/client/tienda.dart';
import 'package:manda2_frontend/view/general/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Datos de ejemplo
  final List<Category> categories = [
    Category('Supermercado', Icons.shopping_cart_outlined),
    Category('Restaurantes', Icons.restaurant_outlined),
    Category('Farmacia', Icons.local_pharmacy_outlined),
    Category('Licorería', Icons.local_drink_outlined),
    Category('Tiendas', Icons.store_outlined),
    Category('Más', Icons.more_horiz),
  ];

  final List<Store> featuredStores = [
    Store('Pulpería "El Buen Precio"', '15-20 min', '4.5', 'Supermercado'),
    Store('Restaurante "Sabor Local"', '20-25 min', '4.3', 'Restaurante'),
    Store('Farmacia "Salud Total"', '10-15 min', '4.2', 'Farmacia'),
    Store('Licorería "La Bodega"', '15-20 min', '4.4', 'Licorería'),
    Store('Tienda Variada', '12-18 min', '4.6', 'Tiendas'),
    Store('Panadería Dulce', '10-15 min', '4.8', 'Restaurante'),
  ];

  final List<String> storeImages = [
    'https://ilacad.com/BO/data/logos_cadenas/logo_la_colonia_honduras.jpg',
  ];

  final List<Promotion> _promotions = [];

  @override
  void initState() {
    super.initState();
    _loadPromotions();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _animationController.forward();
  }

  void _loadPromotions() {
    _promotions.addAll([
      Promotion(
        id: 1,
        title: 'Envío Gratis en tu Primera Compra',
        description:
            'Obtén envío gratis en tu primer pedido con código: BIENVENIDO',
        discount: 'ENVÍO GRATIS',
        color: const Color(0xFF05386B),
        icon: Icons.local_shipping_outlined,
      ),
      Promotion(
        id: 2,
        title: '20% de Descuento en Supermercados',
        description:
            'Ahorra 20% en todas las compras de supermercado este fin de semana',
        discount: '20% OFF',
        color: const Color(0xFFFF6B00),
        icon: Icons.local_grocery_store_outlined,
      ),
      Promotion(
        id: 3,
        title: '2x1 en Restaurantes Participantes',
        description:
            'Lleva 2 platos por el precio de 1 en restaurantes seleccionados',
        discount: '2x1',
        color: Colors.green,
        icon: Icons.restaurant_outlined,
      ),
      Promotion(
        id: 4,
        title: 'Descuento Especial en Farmacia',
        description: '15% de descuento en productos de farmacia',
        discount: '15% OFF',
        color: Colors.purple,
        icon: Icons.local_pharmacy_outlined,
      ),
    ]);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final isDesktop = MediaQuery.of(context).size.width >= 1200;
    final crossAxisCount = isDesktop
        ? 4
        : isTablet
        ? 3
        : 2;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: GestureDetector(
          onTap: () => _showAddressDialog(),
          child: Row(
            children: [
              Icon(Icons.location_on_outlined, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Entregar en',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    const Text(
                      'Barrio Los Pinos, Casa #45',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.keyboard_arrow_down, color: theme.primaryColor),
            ],
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart_outlined, color: Colors.white),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildDrawer(), // ← ¡Menú hamburguesa de vuelta!
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 48 : 16,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              const SizedBox(height: 24),

              _buildOfficialStoreCard(isDesktop || isTablet),
              const SizedBox(height: 32),

              Text(
                'Categorías',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildCategoriesGrid(isDesktop, isTablet),
              const SizedBox(height: 32),

              if (_promotions.isNotEmpty) ...[
                Text(
                  'Promociones Activas',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildPromotionsSection(isDesktop), // ← Corregido para desktop
                const SizedBox(height: 32),
              ],

              Text(
                'Tiendas Destacadas',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: isDesktop ? 1.1 : 0.75,
                ),
                itemCount: featuredStores.length,
                itemBuilder: (context, index) =>
                    _buildStoreCard(featuredStores[index], index),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildModernBottomNav(),
    );
  }

  // Drawer (menú lateral) - restaurado y modernizado
  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF05386B), Color(0xFF0A5A9B)],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Color(0xFF05386B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Juan Pérez',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'juan.perez@email.com',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildDrawerItem(
                  Icons.history_outlined,
                  'Historial de Pedidos',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OrderHistoryScreen(),
                    ),
                  ),
                ),
                _buildDrawerItem(
                  Icons.favorite_outline,
                  'Favoritos',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => FavoritesScreen()),
                  ),
                ),
                _buildDrawerItem(
                  Icons.settings_outlined,
                  'Configuración',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  ),
                ),
                const Divider(),
                _buildDrawerItem(Icons.logout_outlined, 'Cerrar Sesión', () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                }, color: Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? const Color(0xFF05386B)),
      title: Text(
        title,
        style: TextStyle(color: color ?? const Color(0xFF05386B)),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar productos, tiendas o categorías...',
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor),
          suffixIcon: IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {},
            color: Theme.of(context).primaryColor,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildOfficialStoreCard(bool isWide) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StoreScreen(
            storeName: 'Pulpería Oficial Manda2',
            storeCategory: 'Pulpería',
            isOfficialStore: true,
            storeImage: storeImages,
          ),
        ),
      ),
      child: Container(
        height: isWide ? 180 : 160,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF05386B), Color(0xFF0A5A9B)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF05386B).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  storeImages.first,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Pulpería Oficial Manda2',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Precios especiales • Envío prioritario • Siempre abierto',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid(bool isDesktop, bool isTablet) {
    final int crossCount = isDesktop
        ? 6
        : isTablet
        ? 5
        : 4;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(cat.icon, size: 28, color: const Color(0xFF05386B)),
              ),
              const SizedBox(height: 8),
              Text(
                cat.name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        );
      },
    );
  }

  // Promociones corregidas para desktop
  Widget _buildPromotionsSection(bool isDesktop) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: _promotions.length,
        itemBuilder: (context, index) {
          final promo = _promotions[index];
          return Container(
            width: isDesktop ? 400 : 320, // ← Ancho fijo razonable en desktop
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: promo.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: promo.color.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: promo.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(promo.icon, color: promo.color, size: 28),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: promo.color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          promo.discount,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    promo.title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: promo.color,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    promo.description,
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Ver detalles →',
                      style: TextStyle(
                        color: Color(0xFF05386B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Tarjetas de tiendas SIN offset alternado → todas alineadas
  Widget _buildStoreCard(Store store, int index) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StoreScreen(
                storeName: store.name,
                storeCategory: store.category,
                storeImage: storeImages,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.network(
                  storeImages.first,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xFFFF6B00),
                          size: 16,
                        ),
                        Text(
                          ' ${store.rating}',
                          style: const TextStyle(fontSize: 13),
                        ),
                        const Spacer(),
                        Text(
                          store.deliveryTime,
                          style: const TextStyle(
                            color: Color(0xFFFF6B00),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xFFFF6B00),
        unselectedItemColor: Colors.grey[600],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
        onTap: (i) {
          if (i == 1)
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const OrderTrackingScreen(
                  orderId: '1',
                  storeName: 'Tienda',
                  totalAmount: 100,
                ),
              ),
            );
          if (i == 2)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
        },
      ),
    );
  }

  void _showAddressDialog() {
    // Mantén tu lógica original o mejora con un modal más bonito
    showModalBottomSheet(
      context: context,
      builder: (_) => const Center(child: Text('Selector de dirección')),
    );
  }
}

// Modelos (mantén los tuyos)
class Category {
  final String name;
  final IconData icon;
  Category(this.name, this.icon);
}

class Store {
  final String name;
  final String deliveryTime;
  final String rating;
  final String category;
  Store(this.name, this.deliveryTime, this.rating, this.category);
}

class Promotion {
  final int id;
  final String title;
  final String description;
  final String discount;
  final Color color;
  final IconData icon;
  Promotion({
    required this.id,
    required this.title,
    required this.description,
    required this.discount,
    required this.color,
    required this.icon,
  });
}
