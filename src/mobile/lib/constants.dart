import 'package:flutter/material.dart';

class Constants {
  static const String baseUrl = 'https://51cf-177-69-182-113.ngrok-free.app';
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
      case Status.preparing:
        return 'Preparando';
      case Status.inTransit:
        return 'Em trânsito';
      case Status.rejected:
        return 'Rejeitado';
      case Status.completed:
        return 'Concluído';
      default:
        return '';
    }
  }

  Color get color {
    switch (this) {
      case Status.pending:
        return Colors.orange;
      case Status.accepted:
        return Colors.blue;
      case Status.preparing:
        return Colors.blue;
      case Status.inTransit:
        return Colors.blue;
      case Status.rejected:
        return Colors.red;
      case Status.completed:
        return Colors.green;
      default:
        return Colors.black;
    }
  }
}

List<String> getStatusLabels() {
  return Status.values.map((status) => status.description).toList();
}

int getIndexFromStatus(String status) {
  return Status.values.indexWhere((element) => element.description == status);
}

Status? parseStatus(String statusString) {
  for (Status status in Status.values) {
    if (status.toString().split('.').last == statusString) {
      return status;
    }
  }
  return null;
}

// Corrected function to get the description from a string status
String getDescription(String statusString) {
  Status? status = parseStatus(statusString);
  return status?.description ?? 'Status desconhecido';
}

Color getColorFromStatus(String statusString) {
  Status? status = parseStatus(statusString);
  return status?.color ?? Colors.black; // Default color if status is unknown
}