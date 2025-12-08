import 'package:flutter/material.dart';
import 'package:manda2_frontend/view/carrito_screen.dart' hide Product;
import 'package:manda2_frontend/view/favorite_screen.dart'
    hide Product, StoreScreen, ProductDetailScreen;
import 'package:manda2_frontend/view/order_history_screen.dart';
import 'package:manda2_frontend/view/order_tracking_screen.dart';
import 'package:manda2_frontend/view/promotion_screen.dart'
    hide Product, ProductDetailScreen;
import 'package:manda2_frontend/view/tienda.dart';

// Pantalla Home
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _cartItemCount = 3; // Número de productos en el carrito
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Datos de ejemplo
  final List<Category> categories = [
    Category('Supermercado', Icons.shopping_cart_outlined),
    Category('Restaurantes', Icons.restaurant_outlined),
    Category('Farmacia', Icons.local_pharmacy_outlined),
    Category('Licorería', Icons.local_drink_outlined),
    Category('Tiendas', Icons.store_outlined),
  ];

  final List<Store> featuredStores = [
    Store('Pulpería "El Buen Precio"', '15-20 min', '4.5', 'Supermercado'),
    Store('Restaurante "Sabor Local"', '20-25 min', '4.3', 'Restaurante'),
    Store('Farmacia "Salud Total"', '10-15 min', '4.2', 'Farmacia'),
    Store('Licorería "La Bodega"', '15-20 min', '4.4', 'Licorería'),
  ];

  final List<String> storeImages = [
    'https://ilacad.com/BO/data/logos_cadenas/logo_la_colonia_honduras.jpg',
    'https://ilacad.com/BO/data/logos_cadenas/logo_la_colonia_honduras.jpg',
    'https://ilacad.com/BO/data/logos_cadenas/logo_la_colonia_honduras.jpg',
  ];

  // final List<Product> products = [
  //   Product(
  //     'Leche Entera 1L',
  //     id: 1,
  //     name: 'Leche Entera 1L',
  //     description: '',
  //     price: 2.50,
  //     category: 'Supermercado',
  //     storeName: 'Pulpería "El Buen Precio"',
  //     storeCategory: 'Supermercado',
  //     unit: '1L',
  //     stock: 10,
  //   ),
  //   Product(
  //     'Pan Integral',
  //     id: 2,
  //     name: 'Pan Integral',
  //     description: 'Pan integral de 500g',
  //     price: 1.75,
  //     category: 'Supermercado',
  //     storeName: 'Pulpería "El Buen Precio"',
  //     storeCategory: 'Supermercado',
  //     unit: '500g',
  //     stock: 10,
  //   ),
  //   Product(
  //     'Huevos x12',
  //     id: 3,
  //     name: 'Huevos x12',
  //     description: 'Huevos x12',
  //     price: 3.20,
  //     category: 'Supermercado',
  //     storeName: 'Pulpería "El Buen Precio"',
  //     storeCategory: 'Supermercado',
  //     unit: '12',
  //     stock: 10,
  //   ),
  //   Product(
  //     'Arroz 5kg',
  //     id: 4,
  //     name: 'Arroz 5kg',
  //     description: 'Arroz 5kg',
  //     price: 8.90,
  //     category: 'Supermercado',
  //     storeName: 'Pulpería "El Buen Precio"',
  //     storeCategory: 'Supermercado',
  //     unit: '5kg',
  //     stock: 10,
  //   ),
  //   Product(
  //     'Aceite Vegetal 1L',
  //     id: 5,
  //     name: 'Aceite Vegetal 1L',
  //     description: 'Aceite vegetal 1L',
  //     price: 4.30,
  //     category: 'Supermercado',
  //     storeName: 'Pulpería "El Buen Precio"',
  //     storeCategory: 'Supermercado',
  //     unit: '1L',
  //     stock: 10,
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   'Entrega en',
            //   style: TextStyle(fontSize: 14, color: Colors.grey[300]),
            // ),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 20),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Barrio Los Pinos, Casa #45',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  onPressed: () {
                    // Cambiar dirección
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Icono del carrito con badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  // Navegar al carrito
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
              ),
              if (_cartItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B00),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _cartItemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Buscador
              _buildSearchBar(),
              const SizedBox(height: 24),

              // Botón Pulpería Oficial
              _buildOfficialStoreButton(),
              const SizedBox(height: 24),

              // Categorías
              _buildCategoriesSection(),
              const SizedBox(height: 24),

              // Tiendas destacadas
              _buildFeaturedStoresSection(),
              const SizedBox(height: 24),

              // Productos populares
              // _buildProductsSection(),
              // const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Acción rápida
      //   },
      //   backgroundColor: const Color(0xFFFF6B00),
      //   child: const Icon(Icons.flash_on_outlined, color: Colors.white),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Menú lateral (drawer)
  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          // Header del drawer
          Container(
            height: 200,
            decoration: const BoxDecoration(color: Color(0xFF05386B)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.person_outline,
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
                    style: TextStyle(color: Colors.grey[300], fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          // Opciones del menú
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  Icons.history_outlined,
                  'Historial de Pedidos',
                  () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrderHistoryScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(Icons.favorite_outline, 'Favoritos', () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavoritesScreen()),
                  );
                }),
                // _buildDrawerItem(
                //   Icons.payment_outlined,
                //   'Métodos de Pago',
                //   () {},
                // ),
                _buildDrawerItem(Icons.local_offer_outlined, 'Promociones', () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PromotionsScreen(),
                    ),
                  );
                }),
                // _buildDrawerItem(Icons.help_outline, 'Ayuda', () {}),
                _buildDrawerItem(
                  Icons.settings_outlined,
                  'Configuración',
                  () {},
                ),
                const Divider(),
                _buildDrawerItem(
                  Icons.logout_outlined,
                  'Cerrar Sesión',
                  () {},
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Item del drawer
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
        style: TextStyle(
          color: color ?? const Color(0xFF05386B),
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  // Barra de búsqueda
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar productos, tiendas...',
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: Color(0xFF05386B)),
          suffixIcon: IconButton(
            icon: const Icon(Icons.tune_outlined, color: Color(0xFF05386B)),
            onPressed: () {
              // Filtros
            },
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  // Botón Pulpería Oficial
  Widget _buildOfficialStoreButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF05386B), Color(0xFF1A5A9C)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StoreScreen(
                  storeName: 'Pulpería Oficial',
                  storeCategory: 'Pulpería',
                  isOfficialStore: true,
                  storeImage: storeImages,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Image.network(
                      storeImages.first,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pulpería Oficial Manda2',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Productos con precios especiales y envío prioritario',
                        style: TextStyle(color: Colors.grey[200], fontSize: 14),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Sección de categorías
  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Categorías',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF05386B),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Ver todas las categorías
                },
                child: const Text(
                  'Ver todas',
                  style: TextStyle(
                    color: Color(0xFFFF6B00),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _buildCategoryItem(category);
            },
          ),
        ),
      ],
    );
  }

  // Item de categoría
  Widget _buildCategoryItem(Category category) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
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
            child: Icon(
              category.icon,
              size: 32,
              color: const Color(0xFF05386B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF05386B),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Sección de tiendas destacadas
  Widget _buildFeaturedStoresSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tiendas Destacadas',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF05386B),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Ver todas las tiendas
                },
                child: const Text(
                  'Ver todas',
                  style: TextStyle(
                    color: Color(0xFFFF6B00),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.6,
          ),
          itemCount: featuredStores.length,
          itemBuilder: (context, index) {
            final store = featuredStores[index];
            return _buildStoreCard(store);
          },
        ),
        // SizedBox(
        //   height: 240,
        //   child: ListView.builder(
        //     scrollDirection: Axis.vertical,
        //     itemCount: featuredStores.length,
        //     itemBuilder: (context, index) {
        //       final store = featuredStores[index];
        //       return _buildStoreCard(store);
        //     },
        //   ),
        // ),
      ],
    );
  }

  // Tarjeta de tienda
  Widget _buildStoreCard(Store store) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoreScreen(
              storeName: store.name,
              storeCategory: store.category,
              storeImage: storeImages,
            ),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
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
            // Imagen de la tienda
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Image.network(
                  storeImages.first,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Información de la tienda
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          store.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF05386B),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Color(0xFFFF6B00)),
                            Text(
                              store.rating,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                store.category,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      store.deliveryTime,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFFF6B00),
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
    );
  }

  // Sección de productos
  // Widget _buildProductsSection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         'Productos Populares',
  //         style: TextStyle(
  //           fontSize: 22,
  //           fontWeight: FontWeight.bold,
  //           color: Color(0xFF05386B),
  //         ),
  //       ),
  //       const SizedBox(height: 12),
  //       GridView.builder(
  //         shrinkWrap: true,
  //         physics: const NeverScrollableScrollPhysics(),
  //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //           crossAxisCount: 2,
  //           crossAxisSpacing: 16,
  //           mainAxisSpacing: 16,
  //           childAspectRatio: 0.6,
  //         ),
  //         itemCount: products.length,
  //         itemBuilder: (context, index) {
  //           final product = products[index];
  //           return _buildProductCard(product);
  //         },
  //       ),
  //     ],
  //   );
  // }

  // Tarjeta de producto
  // Widget _buildProductCard(Product product) {
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => ProductDetailScreen(product: product),
  //         ),
  //       );
  //     },
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(16),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.grey.withOpacity(0.1),
  //             blurRadius: 10,
  //             spreadRadius: 2,
  //           ),
  //         ],
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // Imagen del producto
  //           Container(
  //             height: 120,
  //             decoration: BoxDecoration(
  //               color: Colors.grey[100],
  //               borderRadius: const BorderRadius.only(
  //                 topLeft: Radius.circular(16),
  //                 topRight: Radius.circular(16),
  //               ),
  //             ),
  //             child: Center(
  //               child: Icon(
  //                 Icons.shopping_bag_outlined,
  //                 size: 60,
  //                 color: Colors.grey[400],
  //               ),
  //             ),
  //           ),
  //           // Información del producto
  //           Expanded(
  //             child: Padding(
  //               padding: const EdgeInsets.all(12),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         product.name,
  //                         style: const TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 14,
  //                           color: Color(0xFF05386B),
  //                         ),
  //                         maxLines: 2,
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                       const SizedBox(height: 8),
  //                       Text(
  //                         product.price.toString(),
  //                         style: const TextStyle(
  //                           fontSize: 18,
  //                           fontWeight: FontWeight.bold,
  //                           color: Color(0xFF05386B),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       // Agregar al carrito
  //                       setState(() {
  //                         _cartItemCount++;
  //                       });
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         SnackBar(
  //                           content: Text(
  //                             '${product.name} agregado al carrito',
  //                           ),
  //                           backgroundColor: const Color(0xFF05386B),
  //                           action: SnackBarAction(
  //                             label: 'Deshacer',
  //                             textColor: Colors.white,
  //                             onPressed: () {
  //                               setState(() {
  //                                 _cartItemCount--;
  //                               });
  //                             },
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: const Color(0xFFFF6B00),
  //                       minimumSize: const Size(double.infinity, 36),
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(8),
  //                       ),
  //                     ),
  //                     child: const Text(
  //                       'Agregar',
  //                       style: TextStyle(
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Barra de navegación inferior
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF6B00),
        unselectedItemColor: Colors.grey[600],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Perfil',
          ),
        ],
        onTap: (index) {
          // Navegación
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OrderTrackingScreen(
                  orderId: '1',
                  storeName: 'Tienda 1',
                  totalAmount: 100.0,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

// Modelos de datos
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

// class Product {
//   final String name;
//   final String price;
//   final String imagePath;

//   Product(this.name, this.price, this.imagePath);
// }

// Widget para visualización responsive
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  }) : super(key: key);

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          return desktop;
        } else if (constraints.maxWidth >= 600) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}
