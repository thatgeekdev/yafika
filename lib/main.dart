import 'package:flutter/material.dart';

void main() {
  runApp(const YafikaApp());
}

// ============================================================
// THEME
// ============================================================

class YafikaColors {
  static const wine = Color(0xFF780E22);
  static const wineDark = Color(0xFF590A19);
  static const wineSoft = Color(0xFFF7EDEF);

  static const white = Color(0xFFFFFFFF);
  static const background = Color(0xFFF7F7F7);

  static const text = Color(0xFF222222);
  static const textMuted = Color(0xFF767676);
  static const border = Color(0xFFE8E0E2);

  static const green = Color(0xFF2E9D5B);
  static const orange = Color(0xFFF3A11A);
  static const red = Color(0xFFC93A3A);
}

// ============================================================
// AUTH
// ============================================================

enum UserRole {
  customer,
  partner,
  driver,
  admin,
}

extension UserRoleUi on UserRole {
  String get label {
    switch (this) {
      case UserRole.customer:
        return 'Cliente';
      case UserRole.partner:
        return 'Parceiro';
      case UserRole.driver:
        return 'Motorista';
      case UserRole.admin:
        return 'Administrador';
    }
  }

  IconData get icon {
    switch (this) {
      case UserRole.customer:
        return Icons.person_outline;
      case UserRole.partner:
        return Icons.storefront_outlined;
      case UserRole.driver:
        return Icons.delivery_dining;
      case UserRole.admin:
        return Icons.admin_panel_settings_outlined;
    }
  }
}

class AppUser {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String password;
  final UserRole role;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.role,
  });
}

// ============================================================
// MARKETPLACE
// ============================================================

class Product {
  final int id;
  final String name;
  final String category;
  final String partner;
  final String unit;
  final double price;
  final IconData icon;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.partner,
    required this.unit,
    required this.price,
    required this.icon,
  });
}

class OrderLine {
  final Product product;
  final int quantity;

  const OrderLine({
    required this.product,
    required this.quantity,
  });

  double get subtotal => product.price * quantity;
}

// ============================================================
// PAYMENT + DELIVERY
// ============================================================

enum PaymentMethod {
  mpesa,
  emola,
  card,
}

extension PaymentMethodUi on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.mpesa:
        return 'M-Pesa';
      case PaymentMethod.emola:
        return 'e-Mola';
      case PaymentMethod.card:
        return 'Cartão';
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentMethod.mpesa:
        return Icons.phone_android;
      case PaymentMethod.emola:
        return Icons.smartphone;
      case PaymentMethod.card:
        return Icons.credit_card;
    }
  }
}

enum DriverPayoutStatus {
  pending,
  paid,
}

extension DriverPayoutStatusUi on DriverPayoutStatus {
  String get label {
    switch (this) {
      case DriverPayoutStatus.pending:
        return 'Pendente';
      case DriverPayoutStatus.paid:
        return 'Pago';
    }
  }
}

class PartnerPaymentProfile {
  final String partnerName;
  final String merchantName;
  final String mpesaNumber;
  final String emolaNumber;

  const PartnerPaymentProfile({
    required this.partnerName,
    required this.merchantName,
    required this.mpesaNumber,
    required this.emolaNumber,
  });
}

class DeliveryZone {
  final String name;

  /// MVP: distância aproximada pré-configurada.
  /// Mais tarde este valor será substituído por Google Maps / Routes API.
  final double estimatedDistanceKm;

  const DeliveryZone({
    required this.name,
    required this.estimatedDistanceKm,
  });
}

enum OrderStatus {
  received,
  preparing,
  ready,
  delivering,
  delivered,
}

extension OrderStatusUi on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.received:
        return 'Pedido recebido';
      case OrderStatus.preparing:
        return 'Em preparação';
      case OrderStatus.ready:
        return 'Pronto para recolha';
      case OrderStatus.delivering:
        return 'Em entrega';
      case OrderStatus.delivered:
        return 'Entregue';
    }
  }

  IconData get icon {
    switch (this) {
      case OrderStatus.received:
        return Icons.receipt_long_outlined;
      case OrderStatus.preparing:
        return Icons.inventory_2_outlined;
      case OrderStatus.ready:
        return Icons.shopping_bag_outlined;
      case OrderStatus.delivering:
        return Icons.delivery_dining;
      case OrderStatus.delivered:
        return Icons.check_circle_outline;
    }
  }
}

class YafikaOrder {
  final String id;
  final String customerName;
  final String phone;
  final String address;
  final String partnerName;
  final List<OrderLine> items;

  final PaymentMethod paymentMethod;

  /// MVP: referência/código fornecido pelo cliente depois de efectuar o
  /// pagamento manual ao parceiro. Não substitui confirmação por API.
  final String paymentReference;

  /// Código escolhido pelo cliente no MVP e confirmado pelo motorista
  /// no momento da entrega. Em produção deve ser gerado no backend.
  final String deliveryCode;

  final String deliveryZone;
  final double distanceKm;
  final double deliveryFee;

  OrderStatus status;
  DriverPayoutStatus driverPayoutStatus;

  final DateTime createdAt;

  YafikaOrder({
    required this.id,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.partnerName,
    required this.items,
    required this.paymentMethod,
    required this.paymentReference,
    required this.deliveryCode,
    required this.deliveryZone,
    required this.distanceKm,
    required this.deliveryFee,
    required this.status,
    required this.driverPayoutStatus,
    required this.createdAt,
  });

  double get productsTotal {
    return items.fold(
      0,
      (value, item) => value + item.subtotal,
    );
  }

  double get grandTotal => productsTotal + deliveryFee;
}

// ============================================================
// STORE
// ============================================================

class AppStore extends ChangeNotifier {
  AppUser? currentUser;

  final List<AppUser> users = [
    const AppUser(
      id: 1,
      name: 'Elton Mucavele',
      email: 'cliente@yafika.co.mz',
      phone: '84 123 4567',
      password: '123456',
      role: UserRole.customer,
    ),
    const AppUser(
      id: 2,
      name: 'Shoprite Beira',
      email: 'parceiro@yafika.co.mz',
      phone: '84 111 1111',
      password: '123456',
      role: UserRole.partner,
    ),
    const AppUser(
      id: 3,
      name: 'Joaquim',
      email: 'motorista@yafika.co.mz',
      phone: '85 222 2222',
      password: '123456',
      role: UserRole.driver,
    ),
    const AppUser(
      id: 4,
      name: 'Administrador Yafika',
      email: 'admin@yafika.co.mz',
      phone: '87 333 3333',
      password: '123456',
      role: UserRole.admin,
    ),
  ];

  final List<Product> products = const [
    Product(
      id: 1,
      name: 'Arroz Tastic',
      category: 'Supermercado',
      partner: 'Shoprite Beira',
      unit: '5 Kg',
      price: 335,
      icon: Icons.rice_bowl,
    ),
    Product(
      id: 2,
      name: 'Óleo de Cozinha',
      category: 'Supermercado',
      partner: 'Shoprite Beira',
      unit: '2 L',
      price: 264,
      icon: Icons.local_drink_outlined,
    ),
    Product(
      id: 3,
      name: 'Açúcar Branco',
      category: 'Supermercado',
      partner: 'Shoprite Beira',
      unit: '2 Kg',
      price: 180,
      icon: Icons.shopping_bag_outlined,
    ),
    Product(
      id: 4,
      name: 'Leite Longa Vida',
      category: 'Supermercado',
      partner: 'Shoprite Beira',
      unit: '1 L',
      price: 130,
      icon: Icons.local_drink,
    ),
    Product(
      id: 5,
      name: 'Pizza Familiar',
      category: 'Restaurante',
      partner: 'Yafika Food',
      unit: '1 unidade',
      price: 650,
      icon: Icons.local_pizza_outlined,
    ),
    Product(
      id: 6,
      name: 'Hambúrguer Especial',
      category: 'Restaurante',
      partner: 'Yafika Food',
      unit: '1 unidade',
      price: 420,
      icon: Icons.lunch_dining,
    ),
  ];

  final List<PartnerPaymentProfile> partnerPaymentProfiles = const [
    PartnerPaymentProfile(
      partnerName: 'Shoprite Beira',
      merchantName: 'Shoprite Beira - DEMO',
      mpesaNumber: '84 000 0000',
      emolaNumber: '86 000 0000',
    ),
    PartnerPaymentProfile(
      partnerName: 'Yafika Food',
      merchantName: 'Yafika Food - DEMO',
      mpesaNumber: '84 111 0000',
      emolaNumber: '86 111 0000',
    ),
  ];

  final List<DeliveryZone> deliveryZones = const [
    DeliveryZone(
      name: 'Ponta-Gêa',
      estimatedDistanceKm: 4.2,
    ),
    DeliveryZone(
      name: 'Macuti',
      estimatedDistanceKm: 6.0,
    ),
    DeliveryZone(
      name: 'Munhava',
      estimatedDistanceKm: 5.5,
    ),
    DeliveryZone(
      name: 'Chingussura',
      estimatedDistanceKm: 8.0,
    ),
  ];

  final Map<int, int> _cart = {};
  final List<YafikaOrder> orders = [];

  AppStore() {
    orders.add(
      YafikaOrder(
        id: '#YF5486',
        customerName: 'Maria da Luz',
        phone: '84 000 0000',
        address: 'Chingussura, Beira',
        partnerName: 'Shoprite Beira',
        items: [
          OrderLine(
            product: products[0],
            quantity: 2,
          ),
          OrderLine(
            product: products[3],
            quantity: 1,
          ),
        ],
        paymentMethod: PaymentMethod.mpesa,
        paymentReference: 'DEMO-001',
        deliveryCode: '4321',
        deliveryZone: 'Chingussura',
        distanceKm: 8.0,
        deliveryFee: 170,
        status: OrderStatus.ready,
        driverPayoutStatus: DriverPayoutStatus.pending,
        createdAt: DateTime.now(),
      ),
    );
  }

  bool login({
    required String email,
    required String password,
    required UserRole role,
  }) {
    try {
      final user = users.firstWhere(
        (user) =>
            user.email.toLowerCase() == email.trim().toLowerCase() &&
            user.password == password &&
            user.role == role,
      );

      currentUser = user;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  String? register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required UserRole role,
  }) {
    if (role == UserRole.admin) {
      return 'O cadastro público de administrador não é permitido.';
    }

    if (users.any(
      (user) => user.email.toLowerCase() == email.trim().toLowerCase(),
    )) {
      return 'Já existe uma conta com este email.';
    }

    final user = AppUser(
      id: users.length + 1,
      name: name.trim(),
      email: email.trim(),
      phone: phone.trim(),
      password: password,
      role: role,
    );

    users.add(user);
    currentUser = user;
    notifyListeners();
    return null;
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }

  Map<int, int> get cart => Map.unmodifiable(_cart);

  int get cartCount {
    return _cart.values.fold(
      0,
      (value, quantity) => value + quantity,
    );
  }

  List<OrderLine> get cartLines {
    final lines = <OrderLine>[];

    for (final entry in _cart.entries) {
      final product = products.firstWhere(
        (product) => product.id == entry.key,
      );

      lines.add(
        OrderLine(
          product: product,
          quantity: entry.value,
        ),
      );
    }

    return lines;
  }

  String? get currentCartPartner {
    if (cartLines.isEmpty) {
      return null;
    }

    return cartLines.first.product.partner;
  }

  double get cartProductsTotal {
    return cartLines.fold(
      0,
      (value, item) => value + item.subtotal,
    );
  }

  bool addToCart(Product product) {
    final partner = currentCartPartner;

    if (partner != null && partner != product.partner) {
      return false;
    }

    _cart.update(
      product.id,
      (quantity) => quantity + 1,
      ifAbsent: () => 1,
    );

    notifyListeners();
    return true;
  }

  void removeFromCart(Product product) {
    if (!_cart.containsKey(product.id)) {
      return;
    }

    final quantity = _cart[product.id]!;

    if (quantity <= 1) {
      _cart.remove(product.id);
    } else {
      _cart[product.id] = quantity - 1;
    }

    notifyListeners();
  }

  PartnerPaymentProfile paymentProfileFor(String partnerName) {
    return partnerPaymentProfiles.firstWhere(
      (profile) => profile.partnerName == partnerName,
    );
  }

  double calculateDeliveryFee(double distanceKm) {
    // MVP: 50 MT base + 15 MT/km, mínimo 100 MT.
    // Depois este cálculo passa para configuração/backend.
    final calculated = 50 + (distanceKm * 15);
    return calculated < 100 ? 100 : calculated;
  }

  YafikaOrder createOrder({
    required String customerName,
    required String phone,
    required String address,
    required PaymentMethod paymentMethod,
    required String paymentReference,
    required String deliveryCode,
    required DeliveryZone deliveryZone,
  }) {
    final lines = List<OrderLine>.from(cartLines);

    if (lines.isEmpty) {
      throw StateError('Carrinho vazio.');
    }

    final partnerName = lines.first.product.partner;
    final distance = deliveryZone.estimatedDistanceKm;
    final deliveryFee = calculateDeliveryFee(distance);

    final order = YafikaOrder(
      id: '#YF${5487 + orders.length}',
      customerName: customerName,
      phone: phone,
      address: address,
      partnerName: partnerName,
      items: lines,
      paymentMethod: paymentMethod,
      paymentReference: paymentReference,
      deliveryCode: deliveryCode,
      deliveryZone: deliveryZone.name,
      distanceKm: distance,
      deliveryFee: deliveryFee,
      status: OrderStatus.received,
      driverPayoutStatus: DriverPayoutStatus.pending,
      createdAt: DateTime.now(),
    );

    orders.insert(0, order);
    _cart.clear();
    notifyListeners();

    return order;
  }

  void updateOrderStatus(
    YafikaOrder order,
    OrderStatus status,
  ) {
    order.status = status;
    notifyListeners();
  }

  bool confirmDelivery({
    required YafikaOrder order,
    required String code,
  }) {
    if (order.status != OrderStatus.delivering) {
      return false;
    }

    if (code.trim() != order.deliveryCode) {
      return false;
    }

    order.status = OrderStatus.delivered;
    order.driverPayoutStatus = DriverPayoutStatus.paid;
    notifyListeners();

    return true;
  }

  int countByStatus(OrderStatus status) {
    return orders.where((order) => order.status == status).length;
  }
}

// ============================================================
// APP
// ============================================================

class YafikaApp extends StatefulWidget {
  const YafikaApp({super.key});

  @override
  State<YafikaApp> createState() => _YafikaAppState();
}

class _YafikaAppState extends State<YafikaApp> {
  final AppStore store = AppStore();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yafika Delivery Market',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: YafikaColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: YafikaColors.wine,
          primary: YafikaColors.wine,
          surface: YafikaColors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: YafikaColors.wine,
          foregroundColor: YafikaColors.white,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: YafikaColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: YafikaColors.border,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: YafikaColors.wine,
              width: 1.5,
            ),
          ),
        ),
      ),
      home: AuthGate(
        store: store,
      ),
    );
  }
}

// ============================================================
// AUTH GATE
// ============================================================

class AuthGate extends StatelessWidget {
  final AppStore store;

  const AuthGate({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (_, __) {
        final user = store.currentUser;

        if (user == null) {
          return LoginPage(
            store: store,
          );
        }

        switch (user.role) {
          case UserRole.customer:
            return CustomerShell(
              store: store,
            );
          case UserRole.partner:
            return PartnerPage(
              store: store,
              rootMode: true,
            );
          case UserRole.driver:
            return DriverPage(
              store: store,
              rootMode: true,
            );
          case UserRole.admin:
            return AdminPage(
              store: store,
              rootMode: true,
            );
        }
      },
    );
  }
}

// ============================================================
// LOGIN
// ============================================================

class LoginPage extends StatefulWidget {
  final AppStore store;

  const LoginPage({
    super.key,
    required this.store,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController(
    text: 'cliente@yafika.co.mz',
  );
  final passwordController = TextEditingController(
    text: '123456',
  );

  UserRole selectedRole = UserRole.customer;
  bool hidePassword = true;
  String? error;

  void fillDemo(UserRole role) {
    setState(() {
      selectedRole = role;

      switch (role) {
        case UserRole.customer:
          emailController.text = 'cliente@yafika.co.mz';
          break;
        case UserRole.partner:
          emailController.text = 'parceiro@yafika.co.mz';
          break;
        case UserRole.driver:
          emailController.text = 'motorista@yafika.co.mz';
          break;
        case UserRole.admin:
          emailController.text = 'admin@yafika.co.mz';
          break;
      }

      passwordController.text = '123456';
      error = null;
    });
  }

  void submit() {
    final ok = widget.store.login(
      email: emailController.text,
      password: passwordController.text,
      role: selectedRole,
    );

    if (!ok) {
      setState(() {
        error = 'Email, palavra-passe ou tipo de conta inválido.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YafikaColors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 460,
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/yafika_logo.jpeg',
                    height: 145,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Bem-vindo à Yafika',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Fast. Reliable. Delivered.',
                    style: TextStyle(
                      color: YafikaColors.wine,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 30),
                  DropdownButtonFormField<UserRole>(
                    value: selectedRole,
                    decoration: const InputDecoration(
                      labelText: 'Entrar como',
                      prefixIcon: Icon(
                        Icons.switch_account_outlined,
                      ),
                    ),
                    items: UserRole.values
                        .map(
                          (role) => DropdownMenuItem(
                            value: role,
                            child: Text(role.label),
                          ),
                        )
                        .toList(),
                    onChanged: (role) {
                      if (role != null) {
                        fillDemo(role);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                      labelText: 'Palavra-passe',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      error!,
                      style: const TextStyle(
                        color: YafikaColors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: YafikaColors.wine,
                      ),
                      onPressed: submit,
                      child: const Text(
                        'ENTRAR',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RegisterPage(
                            store: widget.store,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Não tem conta? Criar conta',
                      style: TextStyle(
                        color: YafikaColors.wine,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: YafikaColors.wineSoft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      'MVP DEMO\n'
                      'Cliente / Parceiro / Motorista / Admin\n'
                      'Palavra-passe das contas demo: 123456',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: YafikaColors.wineDark,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// REGISTER
// ============================================================

class RegisterPage extends StatefulWidget {
  final AppStore store;

  const RegisterPage({
    super.key,
    required this.store,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  UserRole selectedRole = UserRole.customer;
  bool hidePassword = true;
  String? error;

  void submit() {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        passwordController.text.length < 6) {
      setState(() {
        error = 'Preencha todos os campos. A palavra-passe deve ter pelo menos 6 caracteres.';
      });
      return;
    }

    final message = widget.store.register(
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      password: passwordController.text,
      role: selectedRole,
    );

    if (message != null) {
      setState(() {
        error = message;
      });
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final allowedRoles = [
      UserRole.customer,
      UserRole.partner,
      UserRole.driver,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar conta'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 460,
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/yafika_logo.jpeg',
                  height: 125,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 18),
                const Text(
                  'Junte-se à Yafika',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 22),
                DropdownButtonFormField<UserRole>(
                  value: selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de conta',
                    prefixIcon: Icon(
                      Icons.badge_outlined,
                    ),
                  ),
                  items: allowedRoles
                      .map(
                        (role) => DropdownMenuItem(
                          value: role,
                          child: Text(role.label),
                        ),
                      )
                      .toList(),
                  onChanged: (role) {
                    if (role != null) {
                      setState(() {
                        selectedRole = role;
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome / nome do estabelecimento',
                    prefixIcon: Icon(
                      Icons.person_outline,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(
                      Icons.email_outlined,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Telefone',
                    prefixIcon: Icon(
                      Icons.phone_outlined,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                    labelText: 'Palavra-passe',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      icon: Icon(
                        hidePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                ),
                if (error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    error!,
                    style: const TextStyle(
                      color: YafikaColors.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: YafikaColors.wine,
                    ),
                    onPressed: submit,
                    child: const Text(
                      'CRIAR CONTA',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
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

// ============================================================
// CUSTOMER SHELL
// ============================================================

class CustomerShell extends StatefulWidget {
  final AppStore store;

  const CustomerShell({
    super.key,
    required this.store,
  });

  @override
  State<CustomerShell> createState() => _CustomerShellState();
}

class _CustomerShellState extends State<CustomerShell> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) {
        final pages = [
          HomeView(
            store: widget.store,
          ),
          OrdersView(
            store: widget.store,
          ),
          CartView(
            store: widget.store,
          ),
          ProfileView(
            store: widget.store,
          ),
        ];

        return Scaffold(
          body: SafeArea(
            child: pages[currentIndex],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: YafikaColors.wine,
            unselectedItemColor: YafikaColors.textMuted,
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Início',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined),
                label: 'Pedidos',
              ),
              BottomNavigationBarItem(
                icon: Badge(
                  label: Text(
                    '${widget.store.cartCount}',
                  ),
                  isLabelVisible: widget.store.cartCount > 0,
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                  ),
                ),
                label: 'Carrinho',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Conta',
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// HOME
// ============================================================

class HomeView extends StatefulWidget {
  final AppStore store;

  const HomeView({
    super.key,
    required this.store,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final user = widget.store.currentUser;

    final filteredProducts = widget.store.products.where((product) {
      final query = search.toLowerCase();

      return product.name.toLowerCase().contains(query) ||
          product.partner.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);
    }).toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            color: YafikaColors.wine,
            padding: const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              28,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.delivery_dining,
                      size: 42,
                      color: YafikaColors.white,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'YAFIKA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          'DELIVERY MARKET',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  'Olá, ${user?.name ?? 'Cliente'} 👋',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Entregamos tudo\naté você!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 22),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      search = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Buscar produtos, lojas...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(18),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                const Text(
                  'O que procura?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CategoryButton(
                      icon: Icons.storefront_outlined,
                      label: 'Supermercado',
                    ),
                    CategoryButton(
                      icon: Icons.restaurant_outlined,
                      label: 'Restaurantes',
                    ),
                    CategoryButton(
                      icon: Icons.local_pharmacy_outlined,
                      label: 'Farmácias',
                    ),
                    CategoryButton(
                      icon: Icons.shopping_bag_outlined,
                      label: 'Lojas',
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CategoryButton(
                      icon: Icons.flight_outlined,
                      label: 'Aeroporto',
                    ),
                    CategoryButton(
                      icon: Icons.local_shipping_outlined,
                      label: 'Entregas',
                    ),
                    CategoryButton(
                      icon: Icons.business_outlined,
                      label: 'Empresas',
                    ),
                    CategoryButton(
                      icon: Icons.more_horiz,
                      label: 'Mais',
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: YafikaColors.wine,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'OFERTAS ESPECIAIS',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Descontos até 30%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Nas lojas selecionadas',
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.shopping_basket_outlined,
                        color: Colors.white,
                        size: 55,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Produtos populares',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Ver todos',
                      style: TextStyle(
                        color: YafikaColors.wine,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ...filteredProducts.map(
                  (product) => ProductCard(
                    product: product,
                    onAdd: () {
                      final added = widget.store.addToCart(product);

                      ScaffoldMessenger.of(context).hideCurrentSnackBar();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            added
                                ? '${product.name} adicionado ao carrinho.'
                                : 'Neste MVP, cada pedido deve pertencer a um único parceiro. Finalize o carrinho actual primeiro.',
                          ),
                          duration: const Duration(
                            milliseconds: 1500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CategoryButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const CategoryButton({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: YafikaColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: YafikaColors.border,
              ),
            ),
            child: Icon(
              icon,
              color: YafikaColors.wine,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: YafikaColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: YafikaColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: YafikaColors.wineSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              product.icon,
              color: YafikaColors.wine,
              size: 34,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.partner,
                  style: const TextStyle(
                    color: YafikaColors.textMuted,
                    fontSize: 11,
                  ),
                ),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                Text(
                  product.unit,
                  style: const TextStyle(
                    color: YafikaColors.textMuted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${product.price.toStringAsFixed(0)} MT',
                  style: const TextStyle(
                    color: YafikaColors.wine,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          IconButton.filled(
            onPressed: onAdd,
            style: IconButton.styleFrom(
              backgroundColor: YafikaColors.wine,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CART
// ============================================================

class CartView extends StatelessWidget {
  final AppStore store;

  const CartView({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    if (store.cartLines.isEmpty) {
      return const EmptyView(
        icon: Icons.shopping_cart_outlined,
        title: 'O seu carrinho está vazio',
        subtitle: 'Adicione alguns produtos para continuar.',
      );
    }

    return Scaffold(
      backgroundColor: YafikaColors.background,
      appBar: AppBar(
        title: const Text('Meu carrinho'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          if (store.currentCartPartner != null)
            Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: YafikaColors.wineSoft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.storefront_outlined,
                    color: YafikaColors.wine,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Parceiro: ${store.currentCartPartner}',
                      style: const TextStyle(
                        color: YafikaColors.wineDark,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ...store.cartLines.map(
            (line) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    line.product.icon,
                    color: YafikaColors.wine,
                    size: 36,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          line.product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${line.product.price.toStringAsFixed(0)} MT',
                          style: const TextStyle(
                            color: YafikaColors.wine,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      store.removeFromCart(
                        line.product,
                      );
                    },
                    icon: const Icon(
                      Icons.remove_circle_outline,
                    ),
                  ),
                  Text(
                    '${line.quantity}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      store.addToCart(
                        line.product,
                      );
                    },
                    icon: const Icon(
                      Icons.add_circle,
                      color: YafikaColors.wine,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          PriceLine(
            label: 'Produtos',
            value: store.cartProductsTotal,
          ),
          const Divider(height: 30),
          PriceLine(
            label: 'Subtotal dos produtos',
            value: store.cartProductsTotal,
            strong: true,
          ),
          const SizedBox(height: 12),
          const Text(
            'O valor de entrega será calculado no checkout conforme a zona/distância.',
            style: TextStyle(
              color: YafikaColors.textMuted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            height: 54,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: YafikaColors.wine,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CheckoutPage(
                      store: store,
                    ),
                  ),
                );
              },
              child: const Text(
                'CONTINUAR PARA PAGAMENTO',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PriceLine extends StatelessWidget {
  final String label;
  final double value;
  final bool strong;

  const PriceLine({
    super.key,
    required this.label,
    required this.value,
    this.strong = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: strong ? 18 : 14,
              fontWeight:
                  strong ? FontWeight.w800 : FontWeight.normal,
            ),
          ),
          Text(
            '${value.toStringAsFixed(0)} MT',
            style: TextStyle(
              fontSize: strong ? 19 : 14,
              color: strong
                  ? YafikaColors.wine
                  : YafikaColors.text,
              fontWeight:
                  strong ? FontWeight.w900 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CHECKOUT
// ============================================================

class CheckoutPage extends StatefulWidget {
  final AppStore store;

  const CheckoutPage({
    super.key,
    required this.store,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late final TextEditingController nameController;
  late final TextEditingController phoneController;

  final addressController = TextEditingController(
    text: 'Ponta-Gêa, Beira',
  );

  final paymentReferenceController = TextEditingController();
  final deliveryCodeController = TextEditingController();

  PaymentMethod selectedPaymentMethod = PaymentMethod.mpesa;
  late DeliveryZone selectedZone;

  String? error;

  @override
  void initState() {
    super.initState();

    final user = widget.store.currentUser;

    nameController = TextEditingController(
      text: user?.name ?? '',
    );

    phoneController = TextEditingController(
      text: user?.phone ?? '',
    );

    selectedZone = widget.store.deliveryZones.first;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    paymentReferenceController.dispose();
    deliveryCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final partnerName = widget.store.currentCartPartner!;

    final paymentProfile =
        widget.store.paymentProfileFor(partnerName);

    final deliveryFee = widget.store.calculateDeliveryFee(
      selectedZone.estimatedDistanceKm,
    );

    final grandTotal =
        widget.store.cartProductsTotal + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SectionTitle(
            title: '1. Dados da entrega',
          ),
          const SizedBox(height: 14),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Nome',
              prefixIcon: Icon(
                Icons.person_outline,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Telefone',
              prefixIcon: Icon(
                Icons.phone_outlined,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: addressController,
            decoration: const InputDecoration(
              labelText: 'Endereço de entrega',
              prefixIcon: Icon(
                Icons.location_on_outlined,
              ),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<DeliveryZone>(
            value: selectedZone,
            decoration: const InputDecoration(
              labelText: 'Zona de entrega',
              prefixIcon: Icon(
                Icons.map_outlined,
              ),
            ),
            items: widget.store.deliveryZones
                .map(
                  (zone) => DropdownMenuItem(
                    value: zone,
                    child: Text(
                      '${zone.name} • ${zone.estimatedDistanceKm.toStringAsFixed(1)} km',
                    ),
                  ),
                )
                .toList(),
            onChanged: (zone) {
              if (zone != null) {
                setState(() {
                  selectedZone = zone;
                });
              }
            },
          ),
          const SizedBox(height: 12),
          DeliveryFeeCard(
            distanceKm: selectedZone.estimatedDistanceKm,
            fee: deliveryFee,
          ),
          const SizedBox(height: 28),
          const SectionTitle(
            title: '2. Pagamento dos produtos',
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<PaymentMethod>(
            value: selectedPaymentMethod,
            decoration: const InputDecoration(
              labelText: 'Método de pagamento',
              prefixIcon: Icon(
                Icons.account_balance_wallet_outlined,
              ),
            ),
            items: PaymentMethod.values
                .map(
                  (method) => DropdownMenuItem(
                    value: method,
                    child: Row(
                      children: [
                        Icon(
                          method.icon,
                          size: 20,
                          color: YafikaColors.wine,
                        ),
                        const SizedBox(width: 10),
                        Text(method.label),
                      ],
                    ),
                  ),
                )
                .toList(),
            onChanged: (method) {
              if (method != null) {
                setState(() {
                  selectedPaymentMethod = method;
                });
              }
            },
          ),
          const SizedBox(height: 12),
          PartnerPaymentCard(
            profile: paymentProfile,
            method: selectedPaymentMethod,
            productsTotal: widget.store.cartProductsTotal,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: paymentReferenceController,
            decoration: InputDecoration(
              labelText: selectedPaymentMethod == PaymentMethod.card
                  ? 'Referência do pagamento (demo)'
                  : 'Código / referência da transacção',
              prefixIcon: const Icon(
                Icons.confirmation_number_outlined,
              ),
              helperText:
                  'MVP: o pagamento é registado pela referência. A confirmação automática entra quando integrarmos a API do provedor.',
            ),
          ),
          const SizedBox(height: 28),
          const SectionTitle(
            title: '3. Código de entrega',
          ),
          const SizedBox(height: 10),
          const Text(
            'Escolha um código de 4 dígitos. O motorista terá de introduzir este código ao concluir a entrega. Só depois disso a entrega será marcada como concluída e o pagamento do motorista será libertado no MVP.',
            style: TextStyle(
              color: YafikaColors.textMuted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: deliveryCodeController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Código de entrega',
              prefixIcon: Icon(
                Icons.pin_outlined,
              ),
              counterText: '',
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: YafikaColors.border,
              ),
            ),
            child: Column(
              children: [
                PriceLine(
                  label: 'Produtos → Parceiro',
                  value: widget.store.cartProductsTotal,
                ),
                PriceLine(
                  label: 'Entrega → Motorista',
                  value: deliveryFee,
                ),
                const Divider(height: 28),
                PriceLine(
                  label: 'Total',
                  value: grandTotal,
                  strong: true,
                ),
              ],
            ),
          ),
          if (error != null) ...[
            const SizedBox(height: 12),
            Text(
              error!,
              style: const TextStyle(
                color: YafikaColors.red,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            height: 56,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: YafikaColors.wine,
              ),
              onPressed: () {
                final deliveryCode =
                    deliveryCodeController.text.trim();

                if (nameController.text.trim().isEmpty ||
                    phoneController.text.trim().isEmpty ||
                    addressController.text.trim().isEmpty) {
                  setState(() {
                    error = 'Preencha os dados da entrega.';
                  });
                  return;
                }

                if (paymentReferenceController.text.trim().isEmpty) {
                  setState(() {
                    error = 'Informe a referência do pagamento dos produtos.';
                  });
                  return;
                }

                if (deliveryCode.length != 4 ||
                    int.tryParse(deliveryCode) == null) {
                  setState(() {
                    error = 'O código de entrega deve ter exactamente 4 dígitos.';
                  });
                  return;
                }

                final order = widget.store.createOrder(
                  customerName: nameController.text.trim(),
                  phone: phoneController.text.trim(),
                  address: addressController.text.trim(),
                  paymentMethod: selectedPaymentMethod,
                  paymentReference:
                      paymentReferenceController.text.trim(),
                  deliveryCode: deliveryCode,
                  deliveryZone: selectedZone,
                );

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrderSuccessPage(
                      order: order,
                    ),
                  ),
                );
              },
              child: const Text(
                'CONFIRMAR PEDIDO',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Nota do MVP: M-Pesa/e-Mola/cartão ainda estão simulados. Não introduza PIN, OTP ou dados reais de cartão nesta versão.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: YafikaColors.textMuted,
              fontSize: 11,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class DeliveryFeeCard extends StatelessWidget {
  final double distanceKm;
  final double fee;

  const DeliveryFeeCard({
    super.key,
    required this.distanceKm,
    required this.fee,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: YafikaColors.wineSoft,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: YafikaColors.wine,
            foregroundColor: Colors.white,
            child: Icon(
              Icons.delivery_dining,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Entrega calculada',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '${distanceKm.toStringAsFixed(1)} km • valor estimado',
                  style: const TextStyle(
                    color: YafikaColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${fee.toStringAsFixed(0)} MT',
            style: const TextStyle(
              color: YafikaColors.wine,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class PartnerPaymentCard extends StatelessWidget {
  final PartnerPaymentProfile profile;
  final PaymentMethod method;
  final double productsTotal;

  const PartnerPaymentCard({
    super.key,
    required this.profile,
    required this.method,
    required this.productsTotal,
  });

  @override
  Widget build(BuildContext context) {
    String instruction;

    switch (method) {
      case PaymentMethod.mpesa:
        instruction = 'M-Pesa: ${profile.mpesaNumber}';
        break;
      case PaymentMethod.emola:
        instruction = 'e-Mola: ${profile.emolaNumber}';
        break;
      case PaymentMethod.card:
        instruction =
            'Cartão: pagamento seguro via gateway será integrado na próxima fase.';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: YafikaColors.wine,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dados do parceiro',
            style: TextStyle(
              color: YafikaColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            profile.merchantName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                method.icon,
                color: YafikaColors.wine,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  instruction,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Valor dos produtos: ${productsTotal.toStringAsFixed(0)} MT',
            style: const TextStyle(
              color: YafikaColors.wine,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ORDER SUCCESS
// ============================================================

class OrderSuccessPage extends StatelessWidget {
  final YafikaOrder order;

  const OrderSuccessPage({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: YafikaColors.wine,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 62,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Pedido realizado!',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${order.id}\n'
                'Pagamento dos produtos registado via ${order.paymentMethod.label}.\n'
                'Entrega: ${order.deliveryFee.toStringAsFixed(0)} MT.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: YafikaColors.textMuted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: YafikaColors.wineSoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      'CÓDIGO DE ENTREGA',
                      style: TextStyle(
                        color: YafikaColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      order.deliveryCode,
                      style: const TextStyle(
                        color: YafikaColors.wine,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 8,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Partilhe apenas no momento da entrega.',
                      style: TextStyle(
                        color: YafikaColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: YafikaColors.wine,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'CONTINUAR',
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

// ============================================================
// CUSTOMER ORDERS
// ============================================================

class OrdersView extends StatelessWidget {
  final AppStore store;

  const OrdersView({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    if (store.orders.isEmpty) {
      return const EmptyView(
        icon: Icons.receipt_long_outlined,
        title: 'Sem pedidos',
        subtitle: 'Os seus pedidos aparecerão aqui.',
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus pedidos'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: store.orders.length,
        itemBuilder: (_, index) {
          final order = store.orders[index];

          return OrderCard(
            order: order,
          );
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final YafikaOrder order;

  const OrderCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: YafikaColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                order.id,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              Text(
                '${order.grandTotal.toStringAsFixed(0)} MT',
                style: const TextStyle(
                  color: YafikaColors.wine,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            order.partnerName,
            style: const TextStyle(
              color: YafikaColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                order.status.icon,
                color: YafikaColors.wine,
              ),
              const SizedBox(width: 8),
              Text(
                order.status.label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Text(
            'Produtos: ${order.productsTotal.toStringAsFixed(0)} MT • '
            'Entrega: ${order.deliveryFee.toStringAsFixed(0)} MT • '
            '${order.distanceKm.toStringAsFixed(1)} km',
            style: const TextStyle(
              color: YafikaColors.textMuted,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 15),
          OrderProgress(
            status: order.status,
          ),
        ],
      ),
    );
  }
}

class OrderProgress extends StatelessWidget {
  final OrderStatus status;

  const OrderProgress({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        OrderStatus.values.length,
        (index) {
          final active = index <= status.index;

          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 2,
              ),
              height: 5,
              decoration: BoxDecoration(
                color: active
                    ? YafikaColors.wine
                    : YafikaColors.border,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// PROFILE
// ============================================================

class ProfileView extends StatelessWidget {
  final AppStore store;

  const ProfileView({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    final user = store.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conta'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: YafikaColors.wine,
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 44,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              user?.name ?? '',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Center(
            child: Text(
              user?.email ?? '',
              style: const TextStyle(
                color: YafikaColors.textMuted,
              ),
            ),
          ),
          const SizedBox(height: 30),
          ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            leading: const Icon(
              Icons.badge_outlined,
              color: YafikaColors.wine,
            ),
            title: const Text('Tipo de conta'),
            trailing: Text(
              user?.role.label ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            height: 52,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: YafikaColors.wine,
                side: const BorderSide(
                  color: YafikaColors.wine,
                ),
              ),
              onPressed: store.logout,
              icon: const Icon(
                Icons.logout,
              ),
              label: const Text(
                'TERMINAR SESSÃO',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PARTNER
// ============================================================

class PartnerPage extends StatelessWidget {
  final AppStore store;
  final bool rootMode;

  const PartnerPage({
    super.key,
    required this.store,
    this.rootMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (_, __) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: !rootMode,
            title: const Text(
              'Parceiro • Shoprite Beira',
            ),
            actions: [
              if (rootMode)
                IconButton(
                  onPressed: store.logout,
                  icon: const Icon(
                    Icons.logout,
                  ),
                ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const Text(
                'Pedidos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 18),
              ...store.orders
                  .where(
                    (order) =>
                        order.partnerName == 'Shoprite Beira' &&
                        order.status != OrderStatus.delivered &&
                        order.status != OrderStatus.delivering,
                  )
                  .map(
                    (order) => OperationalOrderCard(
                      order: order,
                      buttonLabel:
                          partnerButtonLabel(order.status),
                      onPressed:
                          partnerAction(store, order),
                      extra: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pagamento produtos: ${order.paymentMethod.label}',
                            style: const TextStyle(
                              color: YafikaColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Ref.: ${order.paymentReference}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }

  static String partnerButtonLabel(
    OrderStatus status,
  ) {
    switch (status) {
      case OrderStatus.received:
        return 'ACEITAR PEDIDO';
      case OrderStatus.preparing:
        return 'MARCAR COMO PRONTO';
      case OrderStatus.ready:
        return 'AGUARDANDO MOTORISTA';
      default:
        return 'PROCESSADO';
    }
  }

  static VoidCallback? partnerAction(
    AppStore store,
    YafikaOrder order,
  ) {
    if (order.status == OrderStatus.received) {
      return () {
        store.updateOrderStatus(
          order,
          OrderStatus.preparing,
        );
      };
    }

    if (order.status == OrderStatus.preparing) {
      return () {
        store.updateOrderStatus(
          order,
          OrderStatus.ready,
        );
      };
    }

    return null;
  }
}

// ============================================================
// DRIVER
// ============================================================

class DriverPage extends StatelessWidget {
  final AppStore store;
  final bool rootMode;

  const DriverPage({
    super.key,
    required this.store,
    this.rootMode = false,
  });

  Future<void> askDeliveryCode(
    BuildContext context,
    YafikaOrder order,
  ) async {
    final controller = TextEditingController();
    String? localError;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'Confirmar entrega',
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${order.id}\n'
                    'Introduza o código fornecido pelo cliente.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Código de entrega',
                      counterText: '',
                      prefixIcon: Icon(
                        Icons.pin_outlined,
                      ),
                    ),
                  ),
                  if (localError != null)
                    Text(
                      localError!,
                      style: const TextStyle(
                        color: YafikaColors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: YafikaColors.wine,
                  ),
                  onPressed: () {
                    final ok = store.confirmDelivery(
                      order: order,
                      code: controller.text,
                    );

                    if (!ok) {
                      setState(() {
                        localError = 'Código inválido.';
                      });
                      return;
                    }

                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Entrega concluída. Pagamento do motorista: ${order.deliveryFee.toStringAsFixed(0)} MT.',
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'CONFIRMAR',
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (_, __) {
        final deliveries = store.orders.where(
          (order) =>
              order.status == OrderStatus.ready ||
              order.status == OrderStatus.delivering,
        );

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: !rootMode,
            title: const Text('Motorista'),
            actions: [
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Center(
                  child: Text(
                    '● Online',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (rootMode)
                IconButton(
                  onPressed: store.logout,
                  icon: const Icon(
                    Icons.logout,
                  ),
                ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const Text(
                'Entregas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 18),
              if (deliveries.isEmpty)
                const EmptyView(
                  icon: Icons.delivery_dining,
                  title: 'Sem entregas',
                  subtitle:
                      'Novas solicitações aparecerão aqui.',
                ),
              ...deliveries.map(
                (order) => OperationalOrderCard(
                  order: order,
                  extra: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${order.distanceKm.toStringAsFixed(1)} km • '
                        '${order.deliveryFee.toStringAsFixed(0)} MT de entrega',
                        style: const TextStyle(
                          color: YafikaColors.wine,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pagamento motorista: ${order.driverPayoutStatus.label}',
                        style: TextStyle(
                          color: order.driverPayoutStatus ==
                                  DriverPayoutStatus.paid
                              ? YafikaColors.green
                              : YafikaColors.orange,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  buttonLabel:
                      order.status == OrderStatus.ready
                          ? 'ACEITAR ENTREGA'
                          : 'CONFIRMAR COM CÓDIGO',
                  onPressed: () {
                    if (order.status == OrderStatus.ready) {
                      store.updateOrderStatus(
                        order,
                        OrderStatus.delivering,
                      );
                    } else {
                      askDeliveryCode(
                        context,
                        order,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// ADMIN
// ============================================================

class AdminPage extends StatelessWidget {
  final AppStore store;
  final bool rootMode;

  const AdminPage({
    super.key,
    required this.store,
    this.rootMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (_, __) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: !rootMode,
            title: const Text(
              'Yafika Admin',
            ),
            actions: [
              if (rootMode)
                IconButton(
                  onPressed: store.logout,
                  icon: const Icon(
                    Icons.logout,
                  ),
                ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 18),
              GridView.count(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.55,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  MetricCard(
                    title: 'Pedidos',
                    value: '${store.orders.length}',
                    icon: Icons.receipt_long_outlined,
                  ),
                  const MetricCard(
                    title: 'Motoristas online',
                    value: '12',
                    icon: Icons.delivery_dining,
                  ),
                  const MetricCard(
                    title: 'Parceiros activos',
                    value: '8',
                    icon: Icons.storefront_outlined,
                  ),
                  MetricCard(
                    title: 'Entregues',
                    value:
                        '${store.countByStatus(OrderStatus.delivered)}',
                    icon: Icons.check_circle_outline,
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const Text(
                'Pedidos recentes',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              ...store.orders.map(
                (order) => Container(
                  margin:
                      const EdgeInsets.only(bottom: 10),
                  padding:
                      const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.id,
                                  style: const TextStyle(
                                    fontWeight:
                                        FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  order.customerName,
                                ),
                                Text(
                                  order.partnerName,
                                  style: const TextStyle(
                                    color: YafikaColors.textMuted,
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  '${order.grandTotal.toStringAsFixed(0)} MT',
                                  style: const TextStyle(
                                    color:
                                        YafikaColors.wine,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DropdownButton<OrderStatus>(
                            value: order.status,
                            underline:
                                const SizedBox.shrink(),
                            items: OrderStatus.values
                                .map(
                                  (status) =>
                                      DropdownMenuItem(
                                    value: status,
                                    child: Text(
                                      status.label,
                                      style:
                                          const TextStyle(
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (status) {
                              if (status == null) {
                                return;
                              }

                              store.updateOrderStatus(
                                order,
                                status,
                              );
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Entrega: ${order.deliveryFee.toStringAsFixed(0)} MT',
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            'Motorista: ${order.driverPayoutStatus.label}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: order.driverPayoutStatus ==
                                      DriverPayoutStatus.paid
                                  ? YafikaColors.green
                                  : YafikaColors.orange,
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
        );
      },
    );
  }
}

// ============================================================
// SHARED CARDS
// ============================================================

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: YafikaColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            icon,
            color: YafikaColors.wine,
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: YafikaColors.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class OperationalOrderCard extends StatelessWidget {
  final YafikaOrder order;
  final String buttonLabel;
  final VoidCallback? onPressed;
  final Widget? extra;

  const OperationalOrderCard({
    super.key,
    required this.order,
    required this.buttonLabel,
    required this.onPressed,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: YafikaColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                order.id,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              Text(
                order.status.label,
                style: const TextStyle(
                  color: YafikaColors.wine,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            order.customerName,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '${order.address} • ${order.deliveryZone}',
            style: const TextStyle(
              color: YafikaColors.textMuted,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${order.items.length} itens • Produtos ${order.productsTotal.toStringAsFixed(0)} MT',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (extra != null) ...[
            const SizedBox(height: 10),
            extra!,
          ],
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor:
                    YafikaColors.wine,
              ),
              onPressed: onPressed,
              child: Text(
                buttonLabel,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const EmptyView({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(35),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 70,
              color: YafikaColors.wine,
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: YafikaColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}