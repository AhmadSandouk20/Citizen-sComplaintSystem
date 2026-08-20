import 'package:bloc/bloc.dart';
import 'package:final_flutter/features/auth/data/models/user_model.dart';
import 'package:final_flutter/features/auth/data/models/user_role_enum.dart';
import 'package:final_flutter/features/auth/presentation/bloc/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  // AuthCubit() : super(AuthInitState());

  // AuthCubit()
  //   : super(
  //       LoginSuccessState(
  //         UserModel(
  //           id: 1,
  //           name: "ahmad",
  //           role: UserRole.citizen,
  //           token: "adsf79843",
  //         ),
  //       ),
  //     );
  AuthCubit()
    : super(
        LoginSuccessState(
          UserModel(
            id: 1,
            name: "ahmad",
            role: UserRole.admin,
            token: "adsf79843",
          ),
        ),
      );
}
