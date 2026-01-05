import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;

  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  // Controladores
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _referencesController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _selectedMunicipality;

  final List<String> _municipalities = [
    'Selecciona tu municipio',
    'Municipio Centro',
    'Municipio Norte',
    'Municipio Sur',
    'Municipio Este',
    'Municipio Oeste',
  ];

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.3, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  void _nextStep() {
    if (_formKeys[_currentStep].currentState!.validate()) {
      if (_currentStep < 1) {
        setState(() => _currentStep++);
        _animationController.reset();
        _animationController.forward();
      } else {
        // Registro exitoso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('¡Cuenta creada exitosamente!'),
            backgroundColor: const Color(0xFF05386B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _animationController.reset();
      _animationController.forward();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _neighborhoodController.dispose();
    _houseController.dispose();
    _referencesController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 1200;
    final isTablet = MediaQuery.of(context).size.width >= 600 && !isDesktop;
    final maxWidth = isDesktop
        ? 600.0
        : isTablet
        ? 700.0
        : double.infinity;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Cuenta'),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 32 : 24,
              vertical: 32,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                children: [
                  // Indicador de progreso moderno
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildProgressStep(
                        1,
                        'Datos Personales',
                        _currentStep >= 0,
                      ),
                      _buildProgressLine(_currentStep >= 1),
                      _buildProgressStep(2, 'Cuenta', _currentStep >= 1),
                    ],
                  ),

                  const SizedBox(height: 48),

                  // Contenido animado
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: child,
                        ),
                      );
                    },
                    child: _currentStep == 0
                        ? _buildPersonalDataForm()
                        : _buildAccountForm(),
                  ),

                  const SizedBox(height: 40),

                  // Botones de navegación
                  Row(
                    children: [
                      if (_currentStep != 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _previousStep,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color(0xFF05386B),
                                width: 2,
                              ),
                              minimumSize: const Size(0, 56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Atrás',
                              style: TextStyle(
                                color: Color(0xFF05386B),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      if (_currentStep != 0) const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _nextStep,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            _currentStep == 1 ? 'Crear Cuenta' : 'Continuar',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
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
      ),
    );
  }

  Widget _buildProgressStep(int number, String label, bool isActive) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFFF6B00) : Colors.grey[300],
              shape: BoxShape.circle,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: const Color(0xFFFF6B00).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey[600],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF05386B) : Colors.grey[600],
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressLine(bool isActive) {
    return Container(
      height: 4,
      width: 80,
      color: isActive ? const Color(0xFFFF6B00) : Colors.grey[300],
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildPersonalDataForm() {
    return Form(
      key: _formKeys[0],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Datos Personales',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: const Color(0xFF05386B),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),

          TextFormField(
            controller: _firstNameController,
            decoration: const InputDecoration(
              labelText: 'Nombre',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (v) => v?.isEmpty ?? true ? 'Ingresa tu nombre' : null,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _lastNameController,
            decoration: const InputDecoration(
              labelText: 'Apellido',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (v) => v?.isEmpty ?? true ? 'Ingresa tu apellido' : null,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Número de teléfono',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
            validator: (v) => (v?.isEmpty ?? true)
                ? 'Ingresa tu teléfono'
                : (v!.length < 8 ? 'Teléfono inválido' : null),
          ),
          const SizedBox(height: 20),

          DropdownButtonFormField<String>(
            value: _selectedMunicipality,
            decoration: const InputDecoration(
              labelText: 'Municipio',
              prefixIcon: Icon(Icons.location_city_outlined),
            ),
            items: _municipalities
                .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                .toList(),
            onChanged: (v) => setState(() => _selectedMunicipality = v),
            validator: (v) => v == null || v == 'Selecciona tu municipio'
                ? 'Selecciona un municipio'
                : null,
          ),
          const SizedBox(height: 32),

          Text(
            'Dirección exacta',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF05386B),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _neighborhoodController,
            decoration: const InputDecoration(
              labelText: 'Barrio/Colonia',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
            validator: (v) => v?.isEmpty ?? true ? 'Ingresa tu barrio' : null,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _houseController,
            decoration: const InputDecoration(
              labelText: 'Casa/Edificio/Apartamento',
              prefixIcon: Icon(Icons.home_outlined),
            ),
            validator: (v) =>
                v?.isEmpty ?? true ? 'Ingresa tu dirección' : null,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _referencesController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Referencias (opcional)',
              hintText: 'Ej: Frente al parque, casa azul',
              prefixIcon: Icon(Icons.description_outlined),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountForm() {
    return Form(
      key: _formKeys[1],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Crea tu cuenta',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: const Color(0xFF05386B),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),

          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Correo electrónico',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (v) {
              if (v?.isEmpty ?? true) return 'Ingresa tu correo';
              if (!v!.contains('@') || !v.contains('.'))
                return 'Correo inválido';
              return null;
            },
          ),
          const SizedBox(height: 20),

          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (v) => (v?.isEmpty ?? true)
                ? 'Ingresa contraseña'
                : (v!.length < 6 ? 'Mínimo 6 caracteres' : null),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              'Mínimo 6 caracteres',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),

          const SizedBox(height: 20),

          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: 'Confirmar contraseña',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                ),
              ),
            ),
            validator: (v) {
              if (v?.isEmpty ?? true) return 'Confirma tu contraseña';
              if (v != _passwordController.text)
                return 'Las contraseñas no coinciden';
              return null;
            },
          ),
        ],
      ),
    );
  }
}
