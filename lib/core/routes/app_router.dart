import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perpusku_app/core/routes/route_guard.dart';
import '../../data/models/author_model.dart';
import '../../data/models/fine_model.dart';
import '../../data/models/publisher_model.dart';
import '../../features/authors/pages/author_add_page.dart';
import '../../features/authors/pages/author_edit_page.dart';
import '../../features/authors/pages/authors_page.dart';
import '../../features/fines/pages/fine_add_page.dart';
import '../../features/fines/pages/fine_edit_page.dart';
import '../../features/publishers/pages/publisher_add_page.dart';
import '../../features/publishers/pages/publisher_edit_page.dart';
import '../../features/publishers/pages/publishers_page.dart';
import '../di/service_locator.dart';
import '../../data/models/book_model.dart';
import '../../features/auth/cubit/auth_cubit.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/books/pages/book_detail_page.dart';
import '../../features/books/pages/books_page.dart';
import '../../features/borrowing/pages/borrowing_page.dart';
import '../../features/dashboard/pages/main_layout_page.dart';
import '../../features/dashboard/pages/master_data_page.dart';
import '../../features/fines/pages/fines_page.dart';
import '../../data/models/book_category_model.dart';
import '../../data/models/borrowing_detail_model.dart';
import '../../features/book_categories/pages/book_categories_page.dart';
import '../../features/book_categories/pages/book_category_add_page.dart';
import '../../features/book_categories/pages/book_categpry_edit_page.dart';
import '../../features/borrowing/pages/borrowing_add_page.dart';
import '../../features/borrowing/pages/borrowing_detail_page.dart';
import '../../features/borrowing/pages/borrowing_edit_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

class AppRouter {
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',

    // Menerapkan Route Guard
    redirect: (context, state) {
      final authState = sl<AuthCubit>().state;
      return RouteGuard.redirect(context, state, authState);
    },

    routes: [
      GoRoute(path: '/', builder: (context, state) => const BooksPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),

      // SHELL ROUTE (ADMIN MODE DENGAN BOTTOM NAV BAR)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainLayoutPage(navigationShell: navigationShell);
        },
        branches: [
          // TAB 1: BERANDA
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const BooksPage(),
              ),
            ],
          ),
          // TAB 2: PEMINJAMAN
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/borrowing',
                builder: (context, state) => const BorrowingPage(),
              ),
            ],
          ),
          // TAB 3: DENDA
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/fines',
                builder: (context, state) => const FinesPage(),
              ),
            ],
          ),
          // TAB 4: MASTER DATA
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/master',
                builder: (context, state) => const MasterDataPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/book-detail',
        builder: (context, state) {
          final book = state.extra as BookModel;
          return BookDetailPage(book: book);
        },
      ),

      // --- PENULIS ---
      GoRoute(
        path: '/admin/authors',
        builder: (context, state) => const AuthorsPage(),
      ),
      GoRoute(
        path: '/admin/authors/add',
        builder: (context, state) => const AuthorAddPage(),
      ),
      GoRoute(
        path: '/admin/authors/edit',
        builder: (context, state) {
          final author = state.extra as AuthorModel;
          return AuthorEditPage(author: author);
        },
      ),

      // --- PEMINJAMAN ---
      GoRoute(
        path: '/admin/borrowing',
        builder: (context, state) => const BorrowingPage(),
      ),
      GoRoute(
        path: '/admin/borrowing/add',
        builder: (context, state) => const BorrowingAddPage(),
      ),
      GoRoute(
        path: '/admin/borrowing/detail/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return BorrowingDetailPage(borrowingId: id);
        },
      ),
      GoRoute(
        path: '/admin/borrowing/edit',
        builder: (context, state) {
          final detail = state.extra as BorrowingDetailModel;
          return BorrowingEditPage(detail: detail);
        },
      ),

      // --- JENIS BUKU ---
      GoRoute(
        path: '/admin/categories',
        builder: (context, state) => const BookCategoriesPage(),
      ),
      GoRoute(
        path: '/admin/categories/add',
        builder: (context, state) => const BookCategoryAddPage(),
      ),
      GoRoute(
        path: '/admin/categories/edit',
        builder: (context, state) {
          final category = state.extra as BookCategoryModel;
          return BookCategoryEditPage(category: category);
        },
      ),

      // --- ROUTES UNTUK DATA MASTER: PENERBIT BUKU ---
      GoRoute(
        path: '/admin/publishers',
        builder: (context, state) => const PublishersPage(),
      ),
      GoRoute(
        path: '/admin/publishers/add',
        builder: (context, state) => const PublisherAddPage(),
      ),
      GoRoute(
        path: '/admin/publishers/edit',
        builder: (context, state) {
          final publisher = state.extra as PublisherModel;
          return PublisherEditPage(publisher: publisher);
        },
      ),

      // --- ROUTES UNTUK DATA MASTER: DENDA ---
      GoRoute(
        path: '/admin/fines/add',
        builder: (context, state) => const FineAddPage(),
      ),
      GoRoute(
        path: '/admin/fines/edit',
        builder: (context, state) {
          final fine = state.extra as FineModel;
          return FineEditPage(fine: fine);
        },
      ),
    ],
  );
}
