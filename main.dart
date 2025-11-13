import 'package:flutter/material.dart';

void main() => runApp(const MedOrderApp());

class MedOrderApp extends StatelessWidget {
  const MedOrderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedOrder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          shadowColor: Colors.teal.shade100,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}

// ---------- DATA MODELS ----------
class Medicine {
  final String id;
  final String name;
  final String description; // ✅ fixed "finalString" typo
  final double price;
  final String category;
  final String imageUrl;

  const Medicine({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
  });
}

class CartItem {
  final Medicine medicine;
  int qty;
  CartItem({required this.medicine, this.qty = 1});
}

// ---------- HOME PAGE ----------
enum SortBy { none, priceLowHigh, priceHighLow, nameAZ, nameZA }

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Medicine> _allMeds = [
    Medicine(
      id: 'm1',
      name: 'Aspirin 75mg',
      description: 'Pain relief and fever reducer.',
      price: 49,
      category: 'Painkiller',
      imageUrl: 'https://via.placeholder.com/200x120?text=Aspirin',
    ),
    Medicine(
      id: 'm2',
      name: 'Paracetamol 650mg',
      description: 'Effective for fever and mild pain.',
      price: 39,
      category: 'Painkiller',
      imageUrl: 'https://via.placeholder.com/200x120?text=Paracetamol',
    ),
    Medicine(
      id: 'm3',
      name: 'Vitamin C 500mg',
      description: 'Boosts immunity and reduces cold duration.',
      price: 129,
      category: 'Supplements',
      imageUrl: 'https://via.placeholder.com/200x120?text=Vitamin+C',
    ),
    Medicine(
      id: 'm4',
      name: 'Antacid Tablets',
      description: 'Fast relief for acidity and indigestion.',
      price: 59,
      category: 'Digestive',
      imageUrl: 'https://via.placeholder.com/200x120?text=Antacid',
    ),
    Medicine(
      id: 'm5',
      name: 'Amoxicillin 500mg',
      description: 'Broad-spectrum antibiotic for bacterial infections.',
      price: 149,
      category: 'Antibiotic',
      imageUrl: 'https://via.placeholder.com/200x120?text=Amoxicillin',
    ),
    Medicine(
      id: 'm6',
      name: 'Cetirizine 10mg',
      description: 'Allergy relief for sneezing and runny nose.',
      price: 25,
      category: 'Cough & Cold',
      imageUrl: 'https://via.placeholder.com/200x120?text=Cetirizine',
    ),
    Medicine(
      id: 'm7',
      name: 'Cough Syrup 100ml',
      description: 'Soothes sore throat and cough.',
      price: 85,
      category: 'Cough & Cold',
      imageUrl: 'https://via.placeholder.com/200x120?text=Cough+Syrup',
    ),
    Medicine(
      id: 'm8',
      name: 'Multivitamin Tablets',
      description: 'Improves overall energy and wellness.',
      price: 199,
      category: 'Supplements',
      imageUrl: 'https://via.placeholder.com/200x120?text=Multivitamin',
    ),
    Medicine(
      id: 'm9',
      name: 'Digene Gel 200ml',
      description: 'Quick relief from acidity and gas.',
      price: 110,
      category: 'Digestive',
      imageUrl: 'https://via.placeholder.com/200x120?text=Digene',
    ),
    Medicine(
      id: 'm10',
      name: 'Skin Ointment 15g',
      description: 'For minor burns, rashes, and cuts.',
      price: 75,
      category: 'Skincare',
      imageUrl: 'https://via.placeholder.com/200x120?text=Skin+Ointment',
    ),
    Medicine(
      id: 'm11',
      name: 'Ibuprofen 200mg',
      description: 'Reduces inflammation and body pain.',
      price: 55,
      category: 'Painkiller',
      imageUrl: 'https://via.placeholder.com/200x120?text=Ibuprofen',
    ),
    Medicine(
      id: 'm12',
      name: 'Aloe Vera Gel',
      description: 'Hydrating gel for skin healing and soothing.',
      price: 145,
      category: 'Skincare',
      imageUrl: 'https://via.placeholder.com/200x120?text=Aloe+Vera+Gel',
    ),
  ];

  List<CartItem> cart = [];
  String _search = '';
  String _selectedCategory = 'All';
  SortBy _sortBy = SortBy.none;

  List<String> get categories => ['All', ..._allMeds.map((e) => e.category).toSet()];

  List<Medicine> get displayedMeds {
    List<Medicine> list = _allMeds.where((m) {
      final matchesCat = _selectedCategory == 'All' || m.category == _selectedCategory;
      final matchesSearch = m.name.toLowerCase().contains(_search.toLowerCase());
      return matchesCat && matchesSearch;
    }).toList();

    switch (_sortBy) {
      case SortBy.priceLowHigh:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortBy.priceHighLow:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortBy.nameAZ:
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortBy.nameZA:
        list.sort((a, b) => b.name.compareTo(a.name));
        break;
      default:
        break;
    }
    return list;
  }

  void addToCart(Medicine med) {
    setState(() {
      final index = cart.indexWhere((c) => c.medicine.id == med.id);
      if (index >= 0) {
        cart[index].qty++;
      } else {
        cart.add(CartItem(medicine: med));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${med.name} added to cart'),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  void changeQty(String id, int delta) {
    setState(() {
      final i = cart.indexWhere((c) => c.medicine.id == id);
      if (i >= 0) {
        cart[i].qty += delta;
        if (cart[i].qty <= 0) cart.removeAt(i);
      }
    });
  }

  void removeItem(String id) {
    setState(() => cart.removeWhere((c) => c.medicine.id == id));
  }

  double get total => cart.fold(0, (sum, item) => sum + item.medicine.price * item.qty);

  void checkout() {
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Cart is empty!')));
      return;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Order'),
        content: Text('Your total is ₹${total.toStringAsFixed(0)}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => cart.clear());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ Order placed successfully!')),
              );
            },
            child: const Text('Place Order'),
          ),
        ],
      ),
    );
  }

  void openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CartPage(
          cart: cart,
          total: total,
          onQtyChange: changeQty,
          onRemove: removeItem,
          onCheckout: checkout,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final meds = displayedMeds;
    final cartCount = cart.fold<int>(0, (p, c) => p + c.qty);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MedOrder'),
        actions: [
          PopupMenuButton<SortBy>(
            icon: const Icon(Icons.sort),
            onSelected: (v) => setState(() => _sortBy = v),
            itemBuilder: (_) => const [
              PopupMenuItem(value: SortBy.priceLowHigh, child: Text('Price ↑')),
              PopupMenuItem(value: SortBy.priceHighLow, child: Text('Price ↓')),
              PopupMenuItem(value: SortBy.nameAZ, child: Text('Name A–Z')),
              PopupMenuItem(value: SortBy.nameZA, child: Text('Name Z–A')),
              PopupMenuItem(value: SortBy.none, child: Text('None')),
            ],
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: openCart,
              ),
              if (cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.orange,
                    child: Text(
                      cartCount.toString(),
                      style: const TextStyle(
                          fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search + Filter
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search medicines...',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (v) => setState(() => _search = v),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedCategory,
                  items: categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedCategory = v!),
                ),
              ],
            ),
          ),
          // Medicines List
          Expanded(
            child: meds.isEmpty
                ? const Center(child: Text('No medicines found'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    itemCount: meds.length,
                    itemBuilder: (_, i) {
                      final m = meds[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              m.imageUrl,
                              width: 70,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.medical_services_outlined),
                            ),
                          ),
                          title: Text(
                            m.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            '${m.category} • ₹${m.price.toStringAsFixed(0)}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade400,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () => addToCart(m),
                            child: const Text('Add'),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        onPressed: openCart,
        label: Text('Cart ₹${total.toStringAsFixed(0)}'),
        icon: const Icon(Icons.shopping_bag_outlined),
      ),
    );
  }
}

// ---------- CART PAGE ----------
class CartPage extends StatelessWidget {
  final List<CartItem> cart;
  final void Function(String, int) onQtyChange;
  final void Function(String) onRemove;
  final double total;
  final VoidCallback onCheckout;

  const CartPage({
    super.key,
    required this.cart,
    required this.onQtyChange,
    required this.onRemove,
    required this.total,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: cart.isEmpty
          ? const Center(child: Text('Your cart is empty 🛒'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (_, i) {
                      final item = cart[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.medicine.imageUrl,
                              width: 60,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.medical_services),
                            ),
                          ),
                          title: Text(item.medicine.name),
                          subtitle: Text(
                              '₹${item.medicine.price.toStringAsFixed(0)} x ${item.qty}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => onQtyChange(item.medicine.id, -1),
                                icon: const Icon(Icons.remove_circle_outline),
                              ),
                              Text(item.qty.toString(),
                                  style: const TextStyle(fontSize: 16)),
                              IconButton(
                                onPressed: () => onQtyChange(item.medicine.id, 1),
                                icon: const Icon(Icons.add_circle_outline),
                              ),
                              IconButton(
                                onPressed: () => onRemove(item.medicine.id),
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Total:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        '₹${total.toStringAsFixed(0)}',
                        style:
                            const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ElevatedButton.icon(
                    onPressed: onCheckout,
                    icon: const Icon(Icons.payments_outlined),
                    label: const Text('Checkout'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
