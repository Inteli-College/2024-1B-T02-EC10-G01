import 'package:flutter/material.dart';

class Constants {
  static const String baseUrl = 'https://8321-187-32-154-202.ngrok-free.app';
  static const Color askyBlue = Color(0xFF1A365D);
  static const Color offWhite = Color(0xFFF5F5F5);
  static const Color gradientTop = Color(0xFF1A365D);
  static const Color gradientBottom = Color(0xFF3771C3);
  static const Map<String, String> assistanceTypes = {
    'stuckDoor': 'Porta Emperrada',
    'expiredMedication': 'Medicamento Vencido',
    'frozenDisplay': 'Display Congelado',
  };
}

enum Status {
  pending,
  accepted,
  preparing,
  inTransit,
  rejected,
  completed,
}

extension StatusExtension on Status {
  String get description {
    switch (this) {
      case Status.pending:
        return 'Pendente';
      case Status.accepted:
        return 'Aceito';
      case Status.rejected:
        return 'Rejeitado';
      case Status.completed:
        return 'Concluído';
      case Status.preparing:
        return 'Preparando';
      case Status.inTransit:
        return 'Em trânsito';
      default:
        return '';
    }
  }
}

List<String> getStatusLabels() {
  return Status.values.map((status) => status.description).toList();
}

getIndexFromStatus(String status) {
  return Status.values.indexWhere((element) => element.description == status);
}
