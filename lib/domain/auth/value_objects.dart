// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dartz/dartz.dart';

import '../core/failure.dart';
import '../core/value_object.dart';
import '../core/value_validators.dart';


class EmailAddress extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory EmailAddress(String input) {
    return EmailAddress._(
      validateEmailAddress(input),
    );
  }

  const EmailAddress._(this.value);
}


class Password extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Password(String input) {
    return Password._(
      validatePassword(input),
    );
  }

  const Password._(this.value);
}




// void showingTheEmailAddressOrFailure() {
//   final emailAddress = EmailAddress('afdslj');
//   String emailText =
//       emailAddress.value.fold((l) => 'failure happened $l', (r) => r);
// }
