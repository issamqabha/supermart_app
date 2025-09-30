import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../shared/widgets/product_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/services/api_service.dart';
import '../../../shared/animations/opaque_transition.dart';
import '../../../core/themes/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isDarkMode = false;
  List<Map<String, dynamic>> _cartItems = [];
  List<Map<String, dynamic>> _products = [];
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await ApiService.fetchProducts();
      setState(() => _products = products ?? []);
      print('منتجات في HomeScreen: ${_products.length} - $_products');
      if (_products.isEmpty) {
        AppUtils.showSnackBar(context, 'لا توجد منتجات متاحة حاليًا', color: AppColors.warning);
      }
    } catch (e) {
      setState(() => _products = []);
      AppUtils.showSnackBar(context, 'فشل تحميل المنتجات: $e', color: AppColors.error);
    }
  }

  void _toggleTheme() {
    setState(() => _isDarkMode = !_isDarkMode);
  }

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      _cartItems.add(product);
    });
    AppUtils.showSnackBar(context, 'تم إضافة ${product['name']} إلى السلة', color: AppColors.success);
  }

  void _removeFromCart(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
    AppUtils.showSnackBar(context, 'تم إزالة المنتج من السلة', color: AppColors.warning);
  }

  void _navigateToCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _currentIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
        bottomNavigationBar: _buildBottomNavBar(),
        floatingActionButton: _buildFloatingCart(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        title: Row(
          children: [
            Icon(Icons.location_on, color: Theme.of(context).primaryColor, size: 20),
            const SizedBox(width: 5),
            const Text('الرياض، السعودية', style: TextStyle(fontSize: 14)),
          ],
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Badge(
              label: const Text('3', style: TextStyle(color: Colors.white)),
              child: Icon(Icons.notifications_none, color: Theme.of(context).primaryColor),
            ),
            onPressed: () {
              AppUtils.showSnackBar(context, 'إشعارات جديدة!', color: AppColors.primary);
            },
          ),
          IconButton(
            icon: Icon(_isDarkMode ? Icons.wb_sunny : Icons.nightlight_round, color: Theme.of(context).primaryColor),
            onPressed: _toggleTheme,
          ),
        ],
      ).animate().fadeIn(delay: 200.ms),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return HomePage(onAddToCart: _addToCart, products: _products, onCategoryTap: _navigateToCategory);
      case 1:
        return _products.isNotEmpty
            ? CategoriesPage(onAddToCart: _addToCart, products: _products, selectedCategory: _selectedCategory, onBack: () => setState(() => _currentIndex = 0))
            : const Center(child: CircularProgressIndicator());
      case 2:
        return CartPage(cartItems: _cartItems, onRemove: _removeFromCart);
      case 3:
        return const ProfilePage();
      default:
        return const SizedBox();
    }
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'الأقسام'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'السلة'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildFloatingCart() {
    return FloatingActionButton(
      onPressed: () => setState(() => _currentIndex = 2),
      backgroundColor: Theme.of(context).primaryColor,
      child: Badge(
        label: Text(_cartItems.length.toString(), style: const TextStyle(color: Colors.white)),
        child: const Icon(Icons.shopping_basket, color: Colors.white),
      ),
    ).animate().scale(delay: 600.ms);
  }
}

class HomePage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddToCart;
  final List<Map<String, dynamic>> products;
  final Function(String) onCategoryTap;

  const HomePage({super.key, required this.onAddToCart, required this.products, required this.onCategoryTap});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          OpaqueTransition(
            child: _buildSearchBar(),
            delay: const Duration(milliseconds: 300),
          ),
          OpaqueTransition(
            child: _buildBannerSlider(),
            delay: const Duration(milliseconds: 500),
          ),
          OpaqueTransition(
            child: _buildCategories(),
            delay: const Duration(milliseconds: 700),
          ),
          OpaqueTransition(
            child: _buildSectionTitle('منتجات مميزة'),
            delay: const Duration(milliseconds: 900),
          ),
          OpaqueTransition(
            child: _buildProductGrid(),
            delay: const Duration(milliseconds: 1100),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: AppColors.textLight),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'ابحث عن منتج...',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: Theme.of(context).primaryColor),
            onPressed: () {
              AppUtils.showSnackBar(context, 'فلترة المنتجات', color: AppColors.primary);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBannerSlider() {
    return SizedBox(
      height: 180,
      child: PageView(
        children: [
          _buildBanner('عروض خاصة', 'خصم 50% على الفواكه', AppColors.primary),
          _buildBanner('توصيل مجاني', 'للطلبات فوق 100 ر.س', AppColors.secondary),
          _buildBanner('منتجات جديدة', 'اكتشف الآن!', AppColors.accent),
        ],
      ),
    );
  }

  Widget _buildBanner(String title, String subtitle, Color color) {
    return GestureDetector(
      onTap: () {
        AppUtils.showSnackBar(context, '$title - انقر للمزيد', color: color);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: AppUtils.getGradient(color, color.withOpacity(0.7)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 20,
              bottom: 20,
              child: Icon(Icons.local_offer, size: 80, color: Colors.white.withOpacity(0.2)),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final categories = [
      {'icon': Icons.local_grocery_store, 'name': 'بقالة', 'color': AppColors.warning},
      {'icon': Icons.local_drink, 'name': 'مشروبات', 'color': AppColors.accent},
      {'icon': Icons.kitchen, 'name': 'مطبخ', 'color': AppColors.primary},
      {'icon': Icons.clean_hands, 'name': 'تنظيف', 'color': Colors.purple},
      {'icon': Icons.child_care, 'name': 'أطفال', 'color': Colors.pink},
      {'icon': Icons.pets, 'name': 'حيوانات', 'color': Colors.brown},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('الأقسام'),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return GestureDetector(
                onTap: () => widget.onCategoryTap(cat['name'] as String),
                child: Container(
                  width: 90,
                  margin: EdgeInsets.only(left: 16, right: index == categories.length - 1 ? 16 : 0),
                  child: Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          gradient: AppUtils.getGradient(cat['color'] as Color, (cat['color'] as Color).withOpacity(0.7)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(cat['icon'] as IconData, color: Colors.white, size: 35),
                      ).animate().scale(delay: (100 * index).ms, curve: Curves.easeOut),
                      const SizedBox(height: 8),
                      Text(cat['name'] as String, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: widget.products.length,
      itemBuilder: (context, index) {
        final product = widget.products[index];
        return ProductCard(
          name: product['name'] as String,
          price: product['price'] as String,
          image: product['image'] as String,
          color: Color(int.parse(product['color'].replaceAll('#', '0xFF'))),
          onAdd: () => widget.onAddToCart(product),
        );
      },
    );
  }
}

class CategoriesPage extends StatelessWidget {
  final Function(Map<String, dynamic>) onAddToCart;
  final List<Map<String, dynamic>> products;
  final String? selectedCategory;
  final VoidCallback onBack;

  const CategoriesPage({super.key, required this.onAddToCart, required this.products, this.selectedCategory, required this.onBack});

  final List<Map<String, dynamic>> _categories = const [
    {'name': 'بقالة', 'keywords': ['تفاح', 'موز', 'برتقال', 'عنب', 'مانجو', 'تين', 'كيوي', 'فراولة', 'ليمون', 'بيض']},
    {'name': 'مشروبات', 'keywords': ['عصير', 'لبن', 'ماء', 'قهوة', 'شاي', 'كولا', 'ميلك شيك']},
    {'name': 'مطبخ', 'keywords': ['خبز', 'أرز', 'معكرونة', 'زيت', 'سكر', 'ملح', 'توابل', 'دقيق', 'شوفان']},
    {'name': 'تنظيف', 'keywords': ['منظف', 'صابون', 'مطهر', 'مسحوق', 'إسفنجة', 'كفوف', 'مبيض', 'ديتول']},
  ];

  @override
  Widget build(BuildContext context) {
    final currentCategory = selectedCategory != null
        ? _categories.firstWhere((cat) => cat['name'] == selectedCategory, orElse: () => _categories.first)
        : _categories.first;

    return Scaffold(
      appBar: AppBar(
        title: Text(currentCategory['name'] as String),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: SafeArea(
        child: _buildBody(context, currentCategory),
      ),
    );
  }

  Widget _buildBody(BuildContext context, Map<String, dynamic> cat) {
    if (products.isEmpty) {
      return const Center(child: Text('لا توجد منتجات متاحة حاليًا', style: TextStyle(fontSize: 18)));
    }

    List<Map<String, dynamic>> categoryProducts = [];
    try {
      final keywords = cat['keywords'] as List<String>;
      categoryProducts = products.where((p) => keywords.any((keyword) => p['name'].toLowerCase().contains(keyword.toLowerCase()))).toList();
      print('عدد المنتجات في القسم ${cat['name']}: ${categoryProducts.length}'); // للتصحيح
      if (categoryProducts.isEmpty) {
        AppUtils.showSnackBar(context, 'لا توجد منتجات تتطابق مع هذا القسم - يتم عرض جميع المنتجات', color: AppColors.warning);
        categoryProducts = products; // عرض جميع المنتجات كبديل
      }
    } catch (e) {
      AppUtils.showSnackBar(context, 'خطأ في تحميل المنتجات: $e', color: AppColors.error);
      categoryProducts = products; // عرض جميع المنتجات كبديل
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCategorySelector(context),
          _buildCategorySection(context, cat, categoryProducts),
        ],
      ),
    );
  }

  Widget _buildCategorySelector(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          return GestureDetector(
            onTap: () {
              onBack();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: selectedCategory == cat['name'] ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  cat['name'] as String,
                  style: TextStyle(
                    color: selectedCategory == cat['name'] ? Colors.white : AppColors.textDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, Map<String, dynamic> cat, List<Map<String, dynamic>> categoryProducts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(cat['name'] as String, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 250,
          child: categoryProducts.isEmpty
              ? const Center(child: Text('لا توجد منتجات في هذا القسم حاليًا'))
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoryProducts.length,
            itemBuilder: (context, index) {
              final product = categoryProducts[index];
              return Padding(
                padding: EdgeInsets.only(left: 16, right: index == categoryProducts.length - 1 ? 16 : 0),
                child: SizedBox(
                  width: 160,
                  child: ProductCard(
                    name: product['name'] as String,
                    price: product['price'] as String,
                    image: product['image'] as String,
                    color: Color(int.parse(product['color'].replaceAll('#', '0xFF'))),
                    onAdd: () => onAddToCart(product),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CartPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(int) onRemove;

  const CartPage({super.key, required this.cartItems, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final double total = AppUtils.calculateTotal(cartItems);

    return Column(
      children: [
        Expanded(
          child: cartItems.isEmpty
              ? const Center(child: Text('السلة فارغة 🛒', style: TextStyle(fontSize: 18)))
              : ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return Dismissible(
                key: Key(item['name'] as String),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => onRemove(index),
                background: Container(
                  color: AppColors.error,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(int.parse(item['color'].replaceAll('#', '0xFF'))),
                    child: Text(item['image'] as String, style: const TextStyle(fontSize: 20)),
                  ),
                  title: Text(item['name'] as String),
                  subtitle: Text(AppUtils.formatPrice(double.parse(item['price'] as String))),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => onRemove(index),
                  ),
                ).animate().fadeIn(delay: (100 * index).ms).slideX(),
              );
            },
          ),
        ),
        if (cartItems.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('الإجمالي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(AppUtils.formatPrice(total), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'إكمال الطلب',
                  onPressed: () {
                    AppUtils.showSnackBar(context, 'جاري معالجة الطلب...', color: AppColors.success);
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController(text: 'اسم المستخدم');
  final TextEditingController _emailController = TextEditingController(text: 'example@email.com');
  final TextEditingController _phoneController = TextEditingController(text: '0123456789');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          OpaqueTransition(
            child: const CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, size: 80, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          _buildTextField(_nameController, 'الاسم', Icons.person),
          const SizedBox(height: 16),
          _buildTextField(_emailController, 'البريد الإلكتروني', Icons.email),
          const SizedBox(height: 16),
          _buildTextField(_phoneController, 'رقم الهاتف', Icons.phone),
          const SizedBox(height: 32),
          CustomButton(
            text: 'حفظ التغييرات',
            onPressed: () {
              AppUtils.showSnackBar(context, 'تم حفظ التغييرات', color: AppColors.success);
            },
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Text('تسجيل الخروج', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: (value) => setState(() {}),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2);
  }
}