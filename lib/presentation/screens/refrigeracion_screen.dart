import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../providers/food_provider.dart';
import '../widgets/food_item_card.dart';
import '../widgets/add_food_item_form.dart';

class RefrigeracionScreen extends StatefulWidget {
  const RefrigeracionScreen({super.key});

  @override
  State<RefrigeracionScreen> createState() => _RefrigeracionScreenState();
}

class _RefrigeracionScreenState extends State<RefrigeracionScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoodProvider>().loadItemsByCategory(
        AppConstants.categoryRefrigeracion,
      );
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _showAddItemForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddFoodItemForm(
        showTypeSelector: true,
        onSave: (name, quantity, entryDate, type) async {
          final provider = context.read<FoodProvider>();
          final success = await provider.addItem(
            name: name,
            quantity: quantity,
            entryDate: entryDate,
            type: type,
          );
          
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(
                      success ? Icons.check_circle : Icons.error,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      success
                          ? AppConstants.successItemAdded
                          : AppConstants.errorGeneric,
                    ),
                  ],
                ),
                backgroundColor: success ? Colors.green : Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _showEditItemForm(item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddFoodItemForm(
        showTypeSelector: true,
        initialName: item.name,
        initialQuantity: item.quantity,
        initialDate: item.entryDate,
        initialType: item.type,
        isEditing: true,
        onSave: (name, quantity, entryDate, type) async {
          final provider = context.read<FoodProvider>();
          final updatedItem = item.copyWith(
            name: name,
            quantity: quantity,
            entryDate: entryDate,
            type: type,
          );
          final success = await provider.updateItem(updatedItem);
          
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(
                      success ? Icons.check_circle : Icons.error,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      success
                          ? AppConstants.successItemUpdated
                          : AppConstants.errorGeneric,
                    ),
                  ],
                ),
                backgroundColor: success ? Colors.green : Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary.withAlpha(30),
              colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(theme, colorScheme),
              _buildSearchBar(colorScheme),
              Expanded(
                child: Consumer<FoodProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (provider.items.isEmpty) {
                      return _buildEmptyState(theme, colorScheme);
                    }

                    return _buildItemsList(provider);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFab(colorScheme),
    );
  }

  Widget _buildAppBar(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.cyan.shade400],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withAlpha(60),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.kitchen,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Refrigeración',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withAlpha(20),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Buscar artículos...',
            prefixIcon: Icon(Icons.search, color: colorScheme.primary),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      context.read<FoodProvider>().searchItems('');
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withAlpha(100),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          onChanged: (value) {
            context.read<FoodProvider>().searchItems(value);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withAlpha(50),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.kitchen,
              size: 64,
              color: colorScheme.primary.withAlpha(150),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No hay artículos',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega tu primer artículo tocando +',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(FoodProvider provider) {
    return RefreshIndicator(
      onRefresh: () async {
        provider.loadItemsByCategory(AppConstants.categoryRefrigeracion);
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 100),
        itemCount: provider.items.length,
        itemBuilder: (context, index) {
          final item = provider.items[index];
          return FoodItemCard(
            item: item,
            onEdit: () => _showEditItemForm(item),
            onDelete: () async {
              final success = await provider.deleteItem(item.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? AppConstants.successItemDeleted
                          : AppConstants.errorGeneric,
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildFab(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.cyan.shade400],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withAlpha(100),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: _showAddItemForm,
        backgroundColor: Colors.transparent,
        elevation: 0,
        label: const Text(
          'Agregar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
