import 'package:get_it/get_it.dart';
import '../../features/questions/data/datasources/local/questions_local_db.dart';
import '../../features/questions/data/datasources/remote/questions_api_service.dart';
import '../../features/questions/data/repos/question_repository_impl.dart';
import '../../features/questions/domain/repositories/question_repository.dart';
import '../../features/questions/domain/usecases/get_questions_usecase.dart';
import '../../features/questions/presentation/manager/question/question_cubit.dart';
import '../../features/questions/presentation/manager/questionDetails/question_details_cubit.dart';
import '../services/dio_client.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Services
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // Data Sources
  getIt.registerLazySingleton<QuestionsLocalDb>(() => QuestionsLocalDb());
  getIt.registerLazySingleton<QuestionsApiService>(() => QuestionsApiService(getIt()));

  // Repository
  getIt.registerLazySingleton<QuestionRepository>(
    () => QuestionRepositoryImpl(getIt(), getIt()),
  );

  // Use Cases
  getIt.registerLazySingleton<GetQuestionsUseCase>(() => GetQuestionsUseCase(getIt()));

  // Blocs/Cubits
  getIt.registerFactory<QuestionCubit>(() => QuestionCubit(getIt()));
  getIt.registerFactory<QuestionDetailsCubit>(() => QuestionDetailsCubit(getIt()));
}