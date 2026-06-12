import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class MasterDataPage extends StatelessWidget {
  const MasterDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> listMenu = [
      _buildMenuCard(
        context,
        'Jenis Buku',
        'Kelola kategori dan klasifikasi buku',
        Icons.category,
        () => context.push('/admin/categories'),
      ),
      _buildMenuCard(
        context,
        'Penulis Buku',
        'Kelola data penulis dan biografi',
        Icons.draw,
        () => context.push('/admin/authors'),
      ),
      _buildMenuCard(
        context,
        'Penerbit Buku',
        'Kelola kontak dan alamat penerbit',
        Icons.business,
        () => context.push('/admin/publishers'),
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Master Data')),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return listMenu[index];
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(thickness: 0.3);
        },
        itemCount: listMenu.length,
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.secondary),
            ],
          ),
        ),
      ),
    );
  }
}
