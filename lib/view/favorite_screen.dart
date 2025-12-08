import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  // Productos favoritos
  final List<Product> _favoriteProducts = [
    Product(
      id: 1,
      name: 'Leche Entera 1L',
      price: 2.50,
      originalPrice: 2.80,
      storeName: 'Pulpería "El Buen Precio"',
      category: 'Lácteos',
      unit: 'litro',
      rating: 4.5,
      isInStock: true,
      imageUrl: '',
    ),
    Product(
      id: 2,
      name: 'Pan Integral Fresco',
      price: 1.75,
      storeName: 'Pulpería "El Buen Precio"',
      category: 'Panadería',
      unit: 'bolsa',
      rating: 4.2,
      isInStock: true,
      imageUrl: '',
    ),
    Product(
      id: 3,
      name: 'Huevos Blancos x12',
      price: 3.20,
      storeName: 'Supermercado Central',
      category: 'Lácteos',
      unit: 'docena',
      rating: 4.7,
      isInStock: true,
      imageUrl: '',
    ),
    Product(
      id: 4,
      name: 'Jugo de Naranja 100% Natural',
      price: 3.50,
      originalPrice: 3.90,
      storeName: 'Pulpería "El Buen Precio"',
      category: 'Bebidas',
      unit: 'caja',
      rating: 4.4,
      isInStock: false,
      imageUrl: '',
    ),
    Product(
      id: 5,
      name: 'Galletas de Chocolate Premium',
      price: 2.20,
      storeName: 'Supermercado Central',
      category: 'Snacks',
      unit: 'paquete',
      rating: 4.6,
      isInStock: true,
      imageUrl: '',
    ),
  ];

  // Tiendas favoritas
  final List<Store> _favoriteStores = [
    Store(
      id: 1,
      name: 'Pulpería "El Buen Precio"',
      category: 'Supermercado',
      rating: 4.8,
      deliveryTime: '15-20 min',
      deliveryFee: 1.50,
      isOpen: true,
      isOfficial: true,
      imageUrl: '',
    ),
    Store(
      id: 2,
      name: 'Restaurante "Sabor Local"',
      category: 'Restaurante',
      rating: 4.9,
      deliveryTime: '20-25 min',
      deliveryFee: 2.00,
      isOpen: true,
      isOfficial: false,
      imageUrl: '',
    ),
    Store(
      id: 3,
      name: 'Farmacia "Salud Total"',
      category: 'Farmacia',
      rating: 4.7,
      deliveryTime: '10-15 min',
      deliveryFee: 1.00,
      isOpen: true,
      isOfficial: false,
      imageUrl: '',
    ),
    Store(
      id: 4,
      name: 'Licorería "La Bodega"',
      category: 'Licorería',
      rating: 4.6,
      deliveryTime: '15-20 min',
      deliveryFee: 1.50,
      isOpen: false,
      isOfficial: false,
      imageUrl: '',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      _selectedTabIndex = _tabController.index;
    });
  }

  void _removeFavoriteProduct(int productId) {
    setState(() {
      _favoriteProducts.removeWhere((product) => product.id == productId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Producto removido de favoritos'),
        backgroundColor: const Color(0xFF05386B),
        action: SnackBarAction(
          label: 'Deshacer',
          textColor: Colors.white,
          onPressed: () {
            // Podríamos re-agregar aquí si tuviéramos el producto guardado
          },
        ),
      ),
    );
  }

  void _removeFavoriteStore(int storeId) {
    setState(() {
      _favoriteStores.removeWhere((store) => store.id == storeId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Tienda removida de favoritos'),
        backgroundColor: const Color(0xFF05386B),
      ),
    );
  }

  void _clearAllFavorites() {
    if (_selectedTabIndex == 0 && _favoriteProducts.isEmpty ||
        _selectedTabIndex == 1 && _favoriteStores.isEmpty) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          _selectedTabIndex == 0
              ? 'Vaciar productos favoritos'
              : 'Vaciar tiendas favoritas',
          style: const TextStyle(
            color: Color(0xFF05386B),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          _selectedTabIndex == 0
              ? '¿Estás seguro de que quieres eliminar todos los productos de tus favoritos?'
              : '¿Estás seguro de que quieres eliminar todas las tiendas de tus favoritos?',
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
              Navigator.pop(context);
              setState(() {
                if (_selectedTabIndex == 0) {
                  _favoriteProducts.clear();
                } else {
                  _favoriteStores.clear();
                }
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _selectedTabIndex == 0
                        ? 'Productos favoritos eliminados'
                        : 'Tiendas favoritas eliminadas',
                  ),
                  backgroundColor: const Color(0xFF05386B),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B00),
            ),
            child: const Text('Vaciar'),
          ),
        ],
      ),
    );
  }

  void _navigateToProduct(Product product) {
    // Navegar a la pantalla del producto
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  void _navigateToStore(Store store) {
    // Navegar a la pantalla de la tienda
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoreScreen(
          storeName: store.name,
          storeCategory: store.category,
          isOfficialStore: store.isOfficial,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Favoritos'),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if ((_selectedTabIndex == 0 && _favoriteProducts.isNotEmpty) ||
              (_selectedTabIndex == 1 && _favoriteStores.isNotEmpty))
            IconButton(
              icon: const Icon(Icons.delete_outline_outlined),
              onPressed: _clearAllFavorites,
              tooltip: 'Vaciar favoritos',
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: const Color(0xFF05386B),
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFFFF6B00),
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopping_bag_outlined, size: 20),
                      const SizedBox(width: 8),
                      const Text('Productos'),
                      if (_favoriteProducts.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B00),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _favoriteProducts.length.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.store_outlined, size: 20),
                      const SizedBox(width: 8),
                      const Text('Tiendas'),
                      if (_favoriteStores.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B00),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _favoriteStores.length.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Pestaña de productos
          _favoriteProducts.isEmpty
              ? _buildEmptyState(
                  icon: Icons.favorite_border_outlined,
                  title: 'No hay productos favoritos',
                  subtitle: 'Agrega productos a tus favoritos para verlos aquí',
                )
              : _buildProductList(),

          // Pestaña de tiendas
          _favoriteStores.isEmpty
              ? _buildEmptyState(
                  icon: Icons.store_outlined,
                  title: 'No hay tiendas favoritas',
                  subtitle: 'Agrega tiendas a tus favoritos para verlas aquí',
                )
              : _buildStoreList(),
        ],
      ),

      // Botón flotante para ir de compras
      floatingActionButton:
          (_favoriteProducts.isEmpty && _selectedTabIndex == 0) ||
              (_favoriteStores.isEmpty && _selectedTabIndex == 1)
          ? FloatingActionButton.extended(
              onPressed: () {
                // Navegar a la pantalla principal
                Navigator.pop(context);
              },
              backgroundColor: const Color(0xFFFF6B00),
              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text('Ir de Compras'),
            )
          : null,
    );
  }

  // Estado vacío
  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF05386B).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 60, color: const Color(0xFF05386B)),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF05386B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                // textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Lista de productos favoritos
  Widget _buildProductList() {
    return Column(
      children: [
        // Contador y acciones
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey[200]!, width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_favoriteProducts.length} ${_favoriteProducts.length == 1 ? 'producto' : 'productos'}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF05386B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (_favoriteProducts.isNotEmpty)
                TextButton(
                  onPressed: _clearAllFavorites,
                  child: const Text(
                    'Vaciar todo',
                    style: TextStyle(
                      color: Color(0xFFFF6B00),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Lista de productos
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _favoriteProducts.length,
            itemBuilder: (context, index) {
              final product = _favoriteProducts[index];
              return _buildProductItem(product);
            },
          ),
        ),
      ],
    );
  }

  // Item de producto favorito
  Widget _buildProductItem(Product product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToProduct(product),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen del producto
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(width: 16),

                // Información del producto
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre y precio
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF05386B),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.storeName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            icon: const Icon(
                              Icons.favorite,
                              color: Color(0xFFFF6B00),
                            ),
                            onPressed: () => _removeFavoriteProduct(product.id),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),

                      // Rating y categoría
                      Row(
                        children: [
                          // Row(
                          //   children: [
                          //     const Icon(
                          //       Icons.star,
                          //       color: Colors.amber,
                          //       size: 16,
                          //     ),
                          //     const SizedBox(width: 4),
                          //     Text(
                          //       product.rating.toString(),
                          //       style: TextStyle(
                          //         fontSize: 14,
                          //         color: Colors.grey[700],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF05386B).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              product.category,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF05386B),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Precio y stock
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF05386B),
                                    ),
                                  ),
                                  if (product.originalPrice != null)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        '\$${product.originalPrice!.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[500],
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              Text(
                                'Por ${product.unit}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),

                          // Estado de stock
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: product.isInStock
                                  ? Colors.green[50]
                                  : Colors.red[50],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              product.isInStock ? 'Disponible' : 'Agotado',
                              style: TextStyle(
                                color: product.isInStock
                                    ? Colors.green[700]
                                    : Colors.red[700],
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Botón de acción
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: product.isInStock
                              ? () {
                                  // Agregar al carrito
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${product.name} agregado al carrito',
                                      ),
                                      backgroundColor: const Color(0xFF05386B),
                                    ),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B00),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            product.isInStock
                                ? 'Agregar al Carrito'
                                : 'No Disponible',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Lista de tiendas favoritas
  Widget _buildStoreList() {
    return Column(
      children: [
        // Contador y acciones
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey[200]!, width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_favoriteStores.length} ${_favoriteStores.length == 1 ? 'tienda' : 'tiendas'}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF05386B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (_favoriteStores.isNotEmpty)
                TextButton(
                  onPressed: _clearAllFavorites,
                  child: const Text(
                    'Vaciar todo',
                    style: TextStyle(
                      color: Color(0xFFFF6B00),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Lista de tiendas
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _favoriteStores.length,
            itemBuilder: (context, index) {
              final store = _favoriteStores[index];
              return _buildStoreItem(store);
            },
          ),
        ),
      ],
    );
  }

  // Item de tienda favorita
  Widget _buildStoreItem(Store store) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToStore(store),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Logo/Imagen de la tienda
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: store.isOfficial
                        ? const Color(0xFF05386B)
                        : Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      store.isOfficial
                          ? Icons.storefront_outlined
                          : Icons.store_outlined,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Información de la tienda
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre y favorito
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      store.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF05386B),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (store.isOfficial)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFF6B00),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: const Text(
                                            'OFICIAL',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  store.category,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            icon: const Icon(
                              Icons.favorite,
                              color: Color(0xFFFF6B00),
                            ),
                            onPressed: () => _removeFavoriteStore(store.id),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),

                      // Rating y tiempo de entrega
                      Row(
                        children: [
                          // Row(
                          //   children: [
                          //     const Icon(
                          //       Icons.star,
                          //       color: Colors.amber,
                          //       size: 16,
                          //     ),
                          //     const SizedBox(width: 4),
                          //     Text(
                          //       store.rating.toString(),
                          //       style: TextStyle(
                          //         fontSize: 14,
                          //         color: Colors.grey[700],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // const SizedBox(width: 16),
                          Row(
                            children: [
                              const Icon(
                                Icons.timer_outlined,
                                size: 16,
                                color: Color(0xFF05386B),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                store.deliveryTime,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF05386B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Estado y tarifa
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: store.isOpen
                                  ? Colors.green[50]
                                  : Colors.red[50],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              store.isOpen ? 'Abierto ahora' : 'Cerrado',
                              style: TextStyle(
                                color: store.isOpen
                                    ? Colors.green[700]
                                    : Colors.red[700],
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          Text(
                            'Envío: \$${store.deliveryFee.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF05386B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      // Botón de acción
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: store.isOpen
                              ? () {
                                  // Ver tienda
                                  _navigateToStore(store);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF05386B),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            store.isOpen ? 'Ver Tienda' : 'Cerrado',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Modelos de datos
class Product {
  final int id;
  final String name;
  final double price;
  final double? originalPrice;
  final String storeName;
  final String category;
  final String unit;
  final double rating;
  final bool isInStock;
  final String imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.originalPrice,
    required this.storeName,
    required this.category,
    required this.unit,
    required this.rating,
    required this.isInStock,
    required this.imageUrl,
  });
}

class Store {
  final int id;
  final String name;
  final String category;
  final double rating;
  final String deliveryTime;
  final double deliveryFee;
  final bool isOpen;
  final bool isOfficial;
  final String imageUrl;

  const Store({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.isOpen,
    required this.isOfficial,
    required this.imageUrl,
  });
}

// Pantallas placeholder para navegación
class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({required this.product, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Producto'),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
      ),
      body: Center(child: Text('Detalles de ${product.name}')),
    );
  }
}

class StoreScreen extends StatelessWidget {
  final String storeName;
  final String storeCategory;
  final bool isOfficialStore;

  const StoreScreen({
    required this.storeName,
    required this.storeCategory,
    required this.isOfficialStore,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tienda'),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
      ),
      body: Center(child: Text('Tienda: $storeName')),
    );
  }
}

// Widget de Grid para vista de tablet
class _FavoriteProductsGrid extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onRemove;
  final Function(Product) onProductTap;

  const _FavoriteProductsGrid({
    required this.products,
    required this.onRemove,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final crossAxisCount = isTablet ? 2 : 1;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: isTablet ? 1.5 : 1.8,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildGridProductItem(product, context);
      },
    );
  }

  Widget _buildGridProductItem(Product product, BuildContext context) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onProductTap(product),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con nombre y botón de favorito
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF05386B),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.favorite,
                        color: Color(0xFFFF6B00),
                        size: 20,
                      ),
                      onPressed: () => onRemove(product),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

                // Tienda y categoría
                Text(
                  product.storeName,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Rating y categoría
                Row(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF05386B).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        product.category,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF05386B),
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Precio y stock
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF05386B),
                              ),
                            ),
                            if (product.originalPrice != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  '\$${product.originalPrice!.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Text(
                          'Por ${product.unit}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: product.isInStock
                            ? Colors.green[50]
                            : Colors.red[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        product.isInStock ? 'Disponible' : 'Agotado',
                        style: TextStyle(
                          color: product.isInStock
                              ? Colors.green[700]
                              : Colors.red[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
