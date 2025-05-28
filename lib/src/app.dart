import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrhaman/src/core/cubit/review_cubit.dart';
import 'package:vrhaman/src/core/cubit/user_cubit.dart';
import 'package:vrhaman/src/core/data/review_data_source.dart';
import 'package:vrhaman/src/core/data/user_data_sources.dart';
import 'package:vrhaman/src/core/repository/user_repository_imp.dart';
import 'package:vrhaman/src/core/usecase/user_usecases.dart';
import 'package:vrhaman/src/features/address/data/datasources/address_remote_data_source.dart';
import 'package:vrhaman/src/features/address/presentation/cubit/address_cubit.dart';
import 'package:vrhaman/src/features/auth/data/datasources/auth_remote_data_sources.dart';
import 'package:vrhaman/src/features/auth/data/repositories/auth_repositories_impl.dart';
import 'package:vrhaman/src/features/auth/domain/usecase/authUseCase.dart';
import 'package:vrhaman/src/features/auth/presentation/bloc/otp_cubit.dart';
import 'package:vrhaman/src/features/auth/presentation/bloc/resend_cubit.dart';
import 'package:vrhaman/src/features/booking/data/datasocurces/booking_vehicle_datasources.dart';
import 'package:vrhaman/src/features/booking/data/repositories/booking_vehicle_repositories_imp.dart';
import 'package:vrhaman/src/features/booking/domain/usecases/booking_vehicle_usecase.dart';
import 'package:vrhaman/src/features/document/data/data_sources/document_data_source.dart';
import 'package:vrhaman/src/features/document/data/repositories/document_repositories_imp.dart';
import 'package:vrhaman/src/features/document/domain/usecases/document_usecases.dart';
import 'package:vrhaman/src/features/document/presentation/cubit/document_cubit.dart';
import 'package:vrhaman/src/features/search/data/data_sources/search_data_sources.dart';
import 'package:vrhaman/src/features/search/data/repositories/add_search_repositories_imp.dart';
import 'package:vrhaman/src/features/search/domain/usecases/search_usecases.dart';
import 'package:vrhaman/src/features/search/presentation/cubit/search_cubit.dart';
import 'package:vrhaman/src/features/vehicle_details/data/repositories/vehicle_details_repositories_imp.dart';
import 'package:vrhaman/src/features/vehicle_details/domain/usecase/vehicle_details_usecases.dart';
import 'package:vrhaman/src/features/vehicle_details/data/datasources/vehicle_details_datasource.dart';
import 'package:vrhaman/src/features/vehicle_details/presentation/bloc/vehicle_details_cubit.dart';
import 'package:vrhaman/src/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:vrhaman/src/features/home/data/datasources/home_data_sources.dart';
import 'package:vrhaman/src/features/home/data/repositories/home_repositories_imp.dart';
import 'package:vrhaman/src/features/home/presentation/bloc/home_cubit.dart';
import 'package:vrhaman/src/features/home/presentation/pages/bottom_navigation_bar.dart';
import 'package:vrhaman/src/features/wishlist/data/data_source/wishlist_datasource.dart';
import 'package:vrhaman/src/features/wishlist/data/repositories/wishlist_repositories_imp.dart';
import 'package:vrhaman/src/features/wishlist/domain/usecases/wishlist_usecases.dart';
import 'package:vrhaman/src/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:vrhaman/themes/app_theme.dart';
import 'features/auth/presentation/pages/login_screen.dart'; // Import the LoginScreen
import 'features/auth/presentation/bloc/login_cubit.dart'; // Import the OtpCubit
import 'settings/settings_controller.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return ScreenUtilInit(
          designSize: Size(360, 690),
          builder: (context, child) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<LoginCubit>(
                  create: (context) => LoginCubit(
                    LoginUseCase(AuthRepositoryImpl(AuthRemoteDataSourceImpl())),
                  ),                
                ),
                 BlocProvider<HomeCubit>(
                  create: (context) => HomeCubit(
                    HomeRepositoryImpl(HomeRemoteDataSourceImpl()),
                  ),
                ),
                BlocProvider<OtpCubit>(
                  create: (context) => OtpCubit(
                    VerificationUseCase(AuthRepositoryImpl(AuthRemoteDataSourceImpl())),
                  ),
                ),
                BlocProvider<ResendCubit>(
                  create: (context) => ResendCubit(
                    ResendOtpUseCase(AuthRepositoryImpl(AuthRemoteDataSourceImpl())),
                  ),
                ),
                BlocProvider<VehicleDetailsCubit>(
                  create: (context) => VehicleDetailsCubit(
                 getVehicleDetailsUseCase:    VehicleDetailsUsecase(VehicleDetailsRepositoryImpl(VehicleDetailsDataSourceImpl())),
                  ),
                ),
                BlocProvider<ReviewCubit>(
                  create: (context) => ReviewCubit(
                    reviewDataSource: ReviewDataSourceImpl(),
                  ),
                ),

                BlocProvider<BookingCubit>(
                  create: (context) => BookingCubit(
                    GetAllBookingVehiclesUseCase(BookingVehicleRepositoriesImpl(BookingVehicleDataSourceImpl())),
                  ),
                ),
                BlocProvider<WishlistCubit>(
                  create: (context) => WishlistCubit(
                    addWishlistUseCase: AddWishlistUseCase(
                      WishlistRepositoryImpl(
                        wishlistDataSource: WishlistDataSourceImpl(), // Add the required argument
                      ),
                    ),
                  ),
                ),
                BlocProvider<SearchCubit>(
                  create: (context) => SearchCubit(
                    addSearchUseCase: AddSearchUseCase(AddSearchRepositoryImpl(searchDataSource: SearchDataSourceImpl())),
                  ),
                ),
                BlocProvider<DocumentCubit>(
                  create: (context) => DocumentCubit(
                    uploadDocumentUseCase: UploadDocumentUseCase(
                      DocumentRepositoryImpl(
                        dataSource: DocumentDataSourceImpl(), // Add the required argument
                      ),
                    ),
                  ),
                ),
                BlocProvider<UserCubit>(
                  create: (context) => UserCubit(
                    userUsecase: UserUsecase(
                      userRepository: UserRepositoryImpl(dataSource: UserDataSourceImpl()),
                    ),
                  ),
                ),
                BlocProvider<AddressCubit>(
                  create: (context) => AddressCubit(
                    addressRemoteDataSource: AddressRemoteDataSourceImpl(),
                  ),
                ),
              ],
              child: MaterialApp(
                // Providing a restorationScopeId allows the Navigator built by the
                // MaterialApp to restore the navigation stack when a user leaves and
                // returns to the app after it has been killed while running in the
                // background.

                restorationScopeId: 'app',
              
                // Provide the generated AppLocalizations to the MaterialApp. This
                // allows descendant Widgets to display the correct translations
                // depending on the user's locale.
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en', ''), // English, no country code
                ],
              
                // Use AppLocalizations to configure the correct application title
                // depending on the user's locale.
                //
                // The appTitle is defined in .arb files found in the localization
                // directory.
                onGenerateTitle: (BuildContext context) =>
                    AppLocalizations.of(context)!.appTitle,
              
                // Define a light and dark color theme. Then, read the user's
                // preferred ThemeMode (light, dark, or system default) from the
                // SettingsController to display the correct theme.
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                
                // themeMode: settingsController.themeMode,
                themeMode: ThemeMode.light,
              
              
              
                // Define a function to handle named routes in order to support
                // Flutter web url navigation and deep linking.
               
                home: FutureBuilder(
                  future: SharedPreferences.getInstance(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      final prefs = snapshot.data as SharedPreferences;
                      final accessToken = prefs.getString('accessToken');
                      if (accessToken != null) {
                        return CustomNavigationBar();
                      } else {
                        return LoginScreen();
                      }
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
