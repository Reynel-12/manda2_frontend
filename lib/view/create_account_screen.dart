// Pantalla de Registro
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _currentStep = 0;
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  // Datos personales
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _referencesController = TextEditingController();
  String? _selectedMunicipality;

  // Datos de cuenta
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Municipios de ejemplo
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

  @override
  void dispose() {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Cuenta'),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Indicador de pasos
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StepIndicator(
                      number: 1,
                      label: 'Datos Personales',
                      isActive: _currentStep == 0,
                    ),
                    Container(
                      height: 2,
                      width: 40,
                      color: _currentStep >= 1
                          ? const Color(0xFFFF6B00)
                          : Colors.grey[300],
                    ),
                    StepIndicator(
                      number: 2,
                      label: 'Crear Cuenta',
                      isActive: _currentStep == 1,
                    ),
                  ],
                ),

                // Formulario de pasos
                const SizedBox(height: 40),
                Stepper(
                  currentStep: _currentStep,
                  onStepContinue: () {
                    if (_currentStep < 1) {
                      if (_formKeys[_currentStep].currentState!.validate()) {
                        setState(() {
                          _currentStep += 1;
                        });
                      }
                    } else {
                      if (_formKeys[_currentStep].currentState!.validate()) {
                        // Registro completo
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cuenta creada exitosamente'),
                            backgroundColor: Color(0xFF05386B),
                          ),
                        );
                        Future.delayed(const Duration(seconds: 1), () {
                          Navigator.pop(context);
                        });
                      }
                    }
                  },
                  onStepCancel: () {
                    if (_currentStep > 0) {
                      setState(() {
                        _currentStep -= 1;
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  controlsBuilder: (context, details) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Row(
                        children: [
                          if (_currentStep != 0)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: details.onStepCancel,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFF05386B),
                                    width: 2,
                                  ),
                                  minimumSize: const Size(0, 56),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Atrás',
                                  style: TextStyle(
                                    color: Color(0xFF05386B),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          if (_currentStep != 0) const SizedBox(width: 16),
                          Expanded(
                            flex: _currentStep == 0 ? 2 : 1,
                            child: ElevatedButton(
                              onPressed: details.onStepContinue,
                              child: Text(
                                _currentStep == 1
                                    ? 'Crear Cuenta'
                                    : 'Continuar',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  steps: [
                    // Paso 1: Datos personales
                    Step(
                      title: const Text(
                        'Datos Personales',
                        style: TextStyle(
                          color: Color(0xFF05386B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Form(
                        key: _formKeys[0],
                        child: Column(
                          children: [
                            // Nombre
                            TextFormField(
                              controller: _firstNameController,
                              decoration: const InputDecoration(
                                labelText: 'Nombre',
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: Color(0xFF05386B),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu nombre';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Apellido
                            TextFormField(
                              controller: _lastNameController,
                              decoration: const InputDecoration(
                                labelText: 'Apellido',
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: Color(0xFF05386B),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu apellido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Teléfono
                            TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                labelText: 'Número de teléfono',
                                prefixIcon: Icon(
                                  Icons.phone_outlined,
                                  color: Color(0xFF05386B),
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu número de teléfono';
                                }
                                if (value.length < 8) {
                                  return 'Número de teléfono inválido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Municipio
                            DropdownButtonFormField<String>(
                              value: _selectedMunicipality,
                              decoration: const InputDecoration(
                                labelText: 'Municipio',
                                prefixIcon: Icon(
                                  Icons.location_city_outlined,
                                  color: Color(0xFF05386B),
                                ),
                              ),
                              items: _municipalities.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedMunicipality = value;
                                });
                              },
                              validator: (value) {
                                if (value == null ||
                                    value == 'Selecciona tu municipio') {
                                  return 'Por favor selecciona tu municipio';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Dirección exacta
                            const Text(
                              'Dirección exacta',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF05386B),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _neighborhoodController,
                              decoration: const InputDecoration(
                                labelText: 'Barrio/Colonia',
                                prefixIcon: Icon(
                                  Icons.location_on_outlined,
                                  color: Color(0xFF05386B),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu barrio/colonia';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _houseController,
                              decoration: const InputDecoration(
                                labelText: 'Casa/Edificio/Apartamento',
                                prefixIcon: Icon(
                                  Icons.home_outlined,
                                  color: Color(0xFF05386B),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu dirección exacta';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _referencesController,
                              decoration: const InputDecoration(
                                labelText: 'Referencias para ubicación',
                                hintText:
                                    'Ej: Frente al parque, casa color azul',
                                prefixIcon: Icon(
                                  Icons.description_outlined,
                                  color: Color(0xFF05386B),
                                ),
                              ),
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                      isActive: _currentStep == 0,
                    ),

                    // Paso 2: Crear cuenta
                    Step(
                      title: const Text(
                        'Crear Cuenta',
                        style: TextStyle(
                          color: Color(0xFF05386B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Form(
                        key: _formKeys[1],
                        child: Column(
                          children: [
                            // Correo electrónico
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Correo electrónico',
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Color(0xFF05386B),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu correo electrónico';
                                }
                                if (!value.contains('@') ||
                                    !value.contains('.')) {
                                  return 'Correo electrónico inválido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Contraseña
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Contraseña',
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: Color(0xFF05386B),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: const Color(0xFF05386B),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              obscureText: _obscurePassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu contraseña';
                                }
                                if (value.length < 6) {
                                  return 'La contraseña debe tener al menos 6 caracteres';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Mínimo 6 caracteres',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Confirmar contraseña
                            TextFormField(
                              controller: _confirmPasswordController,
                              decoration: InputDecoration(
                                labelText: 'Confirmar contraseña',
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: Color(0xFF05386B),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: const Color(0xFF05386B),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                              ),
                              obscureText: _obscureConfirmPassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor confirma tu contraseña';
                                }
                                if (value != _passwordController.text) {
                                  return 'Las contraseñas no coinciden';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      isActive: _currentStep == 1,
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

// Widget para indicador de pasos
class StepIndicator extends StatelessWidget {
  final int number;
  final String label;
  final bool isActive;

  const StepIndicator({
    super.key,
    required this.number,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFFF6B00) : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF05386B) : Colors.grey[600],
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
