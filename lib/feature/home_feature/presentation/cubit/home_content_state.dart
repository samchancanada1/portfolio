import 'package:equatable/equatable.dart';

import '../../domain/entities/portfolio_content.dart';

enum HomeContentStatus { initial, loaded }

class HomeContentState extends Equatable {
  const HomeContentState({
    required this.status,
    this.content,
  });

  const HomeContentState.initial()
      : status = HomeContentStatus.initial,
        content = null;

  final HomeContentStatus status;
  final HomeContent? content;

  HomeContentState copyWith({
    final HomeContentStatus? status,
    final HomeContent? content,
  }) {
    return HomeContentState(
      status: status ?? this.status,
      content: content ?? this.content,
    );
  }

  @override
  List<Object?> get props => [status, content];
}
