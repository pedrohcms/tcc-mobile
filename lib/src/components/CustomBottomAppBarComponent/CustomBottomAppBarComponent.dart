import 'package:flutter/material.dart';
import 'package:mobile/src/models/Button.dart';
import 'package:mobile/src/services/TokenService.dart';

class CustomBottomAppBarComponent extends StatelessWidget {
  /// MÉTODO RESPONSÁVEL POR DEFINIR QUAIS BOTÕES DEVEM APARECER NA TELA
  List<Button> getAvailableButtons(
      String currentRoute, Map<String, Button> buttons) {
    switch (currentRoute) {
      case '/farm_list':
        return [
          buttons['/register_farm'],
          buttons['/register_user'],
          buttons['/profile']
        ];

      case '/home':
        return [
          buttons['/report'],
          buttons['/link_customer'],
          buttons['/farm_configuration']
        ];

      case '/report':
        return [
          buttons['/home'],
          buttons['/link_customer'],
          buttons['/farm_configuration']
        ];

      case '/link_customer':
        return [
          buttons['/home'],
          buttons['/report'],
          buttons['/farm_configuration']
        ];

      case '/farm_configuration':
        return [
          buttons['/home'],
          buttons['/report'],
          buttons['/link_customer']
        ];
      default:
        return [];
    }
  }

  /// MÉTODO RESPONSÁVEL POR DEFINIR COMO OS BOTÕES DEVEM SE COMPORTAR
  getButtonOnPressedFunction(String currentRoute, BuildContext context) {
    switch (currentRoute) {
      case '/report':
      case '/link_customer':
      case '/farm_configuration':
        return (String routeName) {
          Navigator.popAndPushNamed(context, routeName);
        };
        break;

      case '/home':
      case '/farm_list':
        return (String routeName) {
          Navigator.pushNamed(context, routeName);
        };
        break;
    }
  }

  List<Widget> getButtons(String currentRoute, BuildContext context) {
    Map<String, Button> buttons = {
      "/register_farm": Button(
        title: 'Adicionar Fazenda',
        icon: Icons.add,
        route: '/register_farm',
      ),
      "/home": Button(
        title: 'Home',
        icon: Icons.home,
        route: '/home',
      ),
      "/report": Button(
        title: 'Relatórios',
        icon: Icons.trending_up,
        route: '/report',
      ),
      "/register_user": Button(
        title: 'Adicionar Usuário',
        icon: Icons.person_add,
        route: '/register_user',
      ),
      "/link_customer": Button(
        title: 'Vincular Conta',
        icon: Icons.person_add,
        route: '/link_customer',
      ),
      "/farm_configuration": Button(
        title: 'Cálculos',
        icon: Icons.exposure,
        route: '/farm_configuration',
      ),
      "/logout": Button(
        title: 'Logout',
        icon: Icons.exit_to_app,
        route: '/logout',
        onPress: (String routeName) {
          TokenService.deleteToken();

          Navigator.pushNamedAndRemoveUntil(
            context,
            '/',
            (Route<dynamic> route) => false,
          );
        },
      ),
      "/profile": Button(
        title: 'Permissões',
        icon: Icons.how_to_reg,
        route: "/profile",
      ),
      "/farm_list": Button(),
    };

    List<Button> availableOption = getAvailableButtons(currentRoute, buttons);

    Function onPress = getButtonOnPressedFunction(currentRoute, context);

    availableOption.forEach((button) {
      button.onPress = onPress;
    });

    // Adiciono a opção de logout que sempre existe
    availableOption.add(buttons['/logout']);

    List<Widget> preparedButtons = [];

    // Monto o componente com as configurações do botão
    availableOption.forEach(
      (button) {
        preparedButtons.add(
          Expanded(
            flex: 1,
            child: FlatButton(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    button.icon,
                    color: Colors.white,
                  ),
                  Text(
                    "${button.title}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                button.onPress(button.route);
              },
            ),
          ),
        );
      },
    );

    return preparedButtons;
  }

  @override
  Widget build(BuildContext context) {
    // Recupero a rota atual
    String currentRoute = ModalRoute.of(context).settings.name;

    return BottomAppBar(
      color: Colors.lightBlue,
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: getButtons(currentRoute, context),
        ),
      ),
    );
  }
}
