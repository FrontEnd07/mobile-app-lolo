import 'package:reactive_forms/reactive_forms.dart';

class AppValidators {
  AppValidators._();

  static List<ValidatorFunction> get emailRules => <ValidatorFunction>[
    Validators.required,
    Validators.email,
  ];

  static List<ValidatorFunction> get passwordRules => <ValidatorFunction>[
    Validators.required,
    Validators.minLength(6),
  ];

  static List<ValidatorFunction> get requiredRules => <ValidatorFunction>[
    Validators.required,
  ];

  static List<ValidatorFunction> get phoneRules => <ValidatorFunction>[
    Validators.required,
    Validators.pattern(r'^\+?\d{9,15}$'),
  ];
}
