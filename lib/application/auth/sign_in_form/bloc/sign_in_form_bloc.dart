// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:auth/domain/auth/i_auth_facade.dart';
import 'package:auth/domain/auth/value_objects.dart';

import '../../../../domain/auth/auth_failure.dart';

part 'sign_in_form_bloc.freezed.dart';
part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';

class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final IAuthFacade _authFacade;
  SignInFormBloc(
    this._authFacade,
  ) : super(SignInFormState.initial()) {
    on<EmailChanged>((event, emit) async {
      emit(
        state.copyWith(
          emailAddress: EmailAddress(event.emailStr),
          authFailureOrSuccess: none(),
        ),
      );
    });

    on<PasswordChanged>((event, emit) async {
      emit(
        state.copyWith(
          password: Password(event.passwordStr),
          authFailureOrSuccess: none(),
        ),
      );
    });

    on<RegisterWithEmailPasswordPressed>((event, emit) async {
       _performActionOnAuthFacadeWithEmailAndPassword(
        event: event,
        emit: emit,
        forwardedCall: _authFacade.registerWithEmailAndPassword,
      );
    });
    on<SignInWithEmailAndPasswordPressed>((event, emit) async {
      _performActionOnAuthFacadeWithEmailAndPassword(
        event: event,
        emit: emit,
        forwardedCall: _authFacade.signInWithEmailAndPassword
      );
    });
    on<SignInWithGooglePressed>((event, emit) async {
      emit(
        state.copyWith(
          isSubmitting: false,
          authFailureOrSuccess: none(),
        ),
      );
      final failureOrSuccess = await _authFacade.signInWithGoogle();
      emit(
        state.copyWith(
          isSubmitting: false,
          authFailureOrSuccess: some(failureOrSuccess),
        ),
      );
    });
  }

  Stream<SignInFormState> _performActionOnAuthFacadeWithEmailAndPassword({
    required SignInFormEvent event,
    required Emitter<SignInFormState> emit,
    required Future<Either<AuthFailure, Unit>> Function({
      required EmailAddress emailAddress,
      required Password password,
    })
        forwardedCall,
  }) async* {
    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();
    late Either<AuthFailure, Unit> failureOrSuccess;
    if (isEmailValid && isPasswordValid) {
      emit(
        state.copyWith(
          isSubmitting: true,
          authFailureOrSuccess: none(),
        ),
      );
      failureOrSuccess = await forwardedCall(
        emailAddress: state.emailAddress,
        password: state.password,
      );
    }

    emit(
      state.copyWith(
        isSubmitting: false,
        showErrorMessages: true,
        authFailureOrSuccess: optionOf(failureOrSuccess),
      ),
    );
  }
}
