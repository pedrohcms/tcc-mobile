import 'package:intl/intl.dart';

class Format {
  /// MÉTODO RESPONSÁVEL POR FORMATAR DA DATA PARA SER MOSTRADA NA TELA
  static String formatDate(DateTime date) {
    return DateFormat.yMd('pt_BR').format(date);
  }

  /// MÉTODO RESPONSÁVEL POR FORMATAR UM NÚMERO COM AS CASAS E ALGARISMOS CORRETOS
  static formatNumber(double value) {
    return NumberFormat("###,###,###.##", 'pt_BR').format(value);
  }

  /// MÉTODO RESPONSÁVEL POR FORMATAR A O RESULTADO NA MOEDA BRASILEIRA
  static String formatCurrency(double value) {
    return NumberFormat.currency(decimalDigits: 2, locale: 'pt_BR', name: 'R\$')
        .format(value);
  }
}
