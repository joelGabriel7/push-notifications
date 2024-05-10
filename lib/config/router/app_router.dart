import 'package:go_router/go_router.dart';
import 'package:push_app/presentation/screens.dart';

final appRouter = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (_, __) => const HomeScreen(),
  ),
  GoRoute(
    path: '/push-details/:messagesId',
    builder: (context, state) =>  DetailScreen(pushMessageId: state.pathParameters['messagesId'] ?? '404',),
  ),
]);
