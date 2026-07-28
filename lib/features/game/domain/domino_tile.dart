import 'package:equatable/equatable.dart';

class DominoTile extends Equatable {
  const DominoTile(this.left, this.right) : assert(left >= 0 && left <= 6), assert(right >= 0 && right <= 6);
  final int left;
  final int right;

  int get points => left + right;
  bool get isDouble => left == right;
  bool matches(int value) => left == value || right == value;
  DominoTile flipped() => DominoTile(right, left);

  @override
  List<Object?> get props => [left, right];

  @override
  String toString() => '[$left|$right]';
}
