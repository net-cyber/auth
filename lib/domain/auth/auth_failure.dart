
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_failure.freezed.dart';
part 'auth_failure.g.dart';

@freezed
class AuthFailure with _$AuthFailure {
  factory AuthFailure.cancelledByUser() = CancelledByUser;
  factory AuthFailure.serverError() = ServerError;
  factory AuthFailure.emailAlreadyInUse() = EmailAlreadyInUse;
	factory AuthFailure.invalidEmailAndPasswordCombination() = InvalidEmailAndPasswordCombination;
  factory AuthFailure.fromJson(Map<String, dynamic> json) =>
			_$AuthFailureFromJson(json);
}
