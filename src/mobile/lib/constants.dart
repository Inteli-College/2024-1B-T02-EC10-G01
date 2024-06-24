import 'package:asky/views/history_page.dart';
import 'package:flutter/material.dart';

class Constants {
  static const String baseUrl = 'https://e512-2804-1b3-a543-8b0a-64ea-10a9-bd85-7b4a.ngrok-free.app';
  static const Color askyBlue = Color(0xFF1A365D);
  static const Color offWhite = Color(0xFFF5F5F5);
  static const Color gradientTop = Color(0xFF1A365D);
  static const Color gradientBottom = Color(0xFF3771C3);
  static const Map<String, String> assistanceTypes = {
    'stuckDoor': 'Porta Emperrada',
    'expiredMedication': 'Medicamento Vencido',
    'frozenDisplay': 'Display Congelado',
  };
  static const statuses = {
  'pending': 'Pendente',
  'accepted': 'Aceito',
  'preparing': 'Preparando',
  'inTransit': 'Em trânsito',
  'completed': 'Concluído',
};

static const AssistanceStatus = {
  'pending': 'Pendente',
  'accepted': 'Aceito',
  'resolved': 'Resolvido',
};
}
enum Status {
  pending,
  accepted,
  preparing,
  inTransit,
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
        return Colors.blue.shade900;
      case Status.inTransit:
        return Colors.purple.shade900;
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
  if (status == 'pending') {
    return 0;
  } else if (status == 'accepted') {
    return 1;
  } else if (status == 'preparing') {
    return 2;
  } else if (status == 'inTransit') {
    return 3;
  } else if (status == 'completed') {
    return 4;
  } else {
    return 0; // Default to "Pendente" if status is unknown
  }
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