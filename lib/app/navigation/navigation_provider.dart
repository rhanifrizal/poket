import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poket/app/navigation/app_destination.dart';

final selectedDestinationProvider =
    NotifierProvider<SelectedDestinationNotifier, AppDestination>(
      SelectedDestinationNotifier.new,
    );

class SelectedDestinationNotifier extends Notifier<AppDestination> {
  @override
  AppDestination build() => AppDestination.home;

  void select(AppDestination destination) {
    state = destination;
  }
}
