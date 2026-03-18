import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/food_item.dart';
import '../providers/food_provider.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.withAlpha(30),
              Colors.pink.withAlpha(20),
              colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(theme, colorScheme),
              _buildTabBar(theme, colorScheme),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildToBuyList(context),
                    _buildRecommendationsList(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade600, Colors.pink.shade400],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withAlpha(80),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            ),
          ),
          const SizedBox(width: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade600, Colors.pink.shade400],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withAlpha(80),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(Icons.shopping_cart, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lista de Compras',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Gestiona lo que necesitas comprar',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade600, Colors.pink.shade400],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withAlpha(80),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white.withAlpha(50),
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(4),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withAlpha(180),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Por Comprar'),
          Tab(text: 'Recomendaciones'),
        ],
      ),
    );
  }

  Widget _buildToBuyList(BuildContext context) {
    final foodProvider = Provider.of<FoodProvider>(context);
    final allItems = foodProvider.getAllItems();
    final itemsToBuy = allItems.where((item) => 
      item.quantity == 0 && 
      (item.category == 'Refrigeración' || item.category == 'Alacena')
    ).toList();

    if (itemsToBuy.isEmpty) {
      return _buildEmptyState(
        icon: Icons.check_circle_outline,
        title: 'Todo listo!',
        subtitle: 'No hay productos agotados',
        gradientColors: [Colors.green.shade600, Colors.teal.shade400],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: itemsToBuy.length,
      itemBuilder: (context, index) {
        final item = itemsToBuy[index];
        return _buildShoppingItemCard(context, item);
      },
    );
  }

  Widget _buildRecommendationsList(BuildContext context) {
    final foodProvider = Provider.of<FoodProvider>(context);
    final allItems = foodProvider.getAllItems();
    final now = DateTime.now();

    final recommendedItems = allItems.where((item) {
      if (item.quantity == 0) return false;
      if (item.category != 'Refrigeración' && item.category != 'Alacena') return false;
      
      final daysUntilExpiry = item.expirationDate.difference(now).inDays;
      final isExpiring = daysUntilExpiry <= 3 && daysUntilExpiry >= 0;
      final isLowStock = item.quantity <= 2;
      
      return isExpiring || isLowStock;
    }).toList();

    if (recommendedItems.isEmpty) {
      return _buildEmptyState(
        icon: Icons.thumb_up_outlined,
        title: 'Todo bien!',
        subtitle: 'No hay productos próximos a terminarse',
        gradientColors: [Colors.blue.shade600, Colors.cyan.shade400],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: recommendedItems.length,
      itemBuilder: (context, index) {
        final item = recommendedItems[index];
        return _buildRecommendationCard(context, item);
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColors),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: gradientColors[0].withAlpha(100),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(icon, size: 64, color: Colors.white),
          ),
          const SizedBox(height: 28),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShoppingItemCard(BuildContext context, FoodItem item) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.purple.shade600, Colors.pink.shade400],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withAlpha(80),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(50),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(50),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${item.category}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _showQuantityDialog(context, item),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.add, color: Colors.purple.shade600, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(BuildContext context, FoodItem item) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final daysLeft = item.expirationDate.difference(now).inDays;
    final isLowStock = item.quantity <= 2;
    final isExpiring = daysLeft <= 3 && daysLeft >= 0;

    Color badgeColor;
    String badgeText;
    if (isExpiring) {
      badgeColor = Colors.red.shade700;
      badgeText = daysLeft == 0 ? 'Vence hoy' : 'Caduca en $daysLeft días';
    } else {
      badgeColor = Colors.orange.shade700;
      badgeText = 'Poco stock (${item.quantity})';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.orange.shade600, Colors.amber.shade400],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withAlpha(80),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(50),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                isLowStock ? Icons.inventory_2 : Icons.warning_amber_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          badgeText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _showQuantityDialog(context, item),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.add, color: Colors.orange.shade600, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuantityDialog(BuildContext context, FoodItem item) {
    final controller = TextEditingController(text: '1');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('¿Cuántos ${item.name} compraste?'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Cantidad',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final quantity = int.tryParse(controller.text) ?? 1;
              if (quantity > 0) {
                final foodProvider = Provider.of<FoodProvider>(context, listen: false);
                final updatedItem = item.copyWith(
                  quantity: item.quantity + quantity,
                  entryDate: DateTime.now(),
                );
                foodProvider.updateItem(updatedItem);
                setState(() {});
              }
              Navigator.pop(context);
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}
