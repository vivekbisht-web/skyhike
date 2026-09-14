import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class CategoryItem {
  final String title;
  final String slug;
  final IconData icon;
  final String count;
  final Color color;

  const CategoryItem({
    required this.title,
    required this.slug,
    required this.icon,
    required this.count,
    required this.color,
  });
}

class CategoriesScreen extends StatefulWidget {
  final Function(String url) onSelectCategory;

  const CategoriesScreen({
    super.key,
    required this.onSelectCategory,
  });

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<CategoryItem> _allCategories = const [
    CategoryItem(
      title: 'IT & Software Solutions',
      slug: 'information-technology',
      icon: Icons.code_rounded,
      count: '42+ Partners',
      color: Color(0xFF2563EB),
    ),
    CategoryItem(
      title: 'Digital Marketing & SEO',
      slug: 'digital-marketing',
      icon: Icons.campaign_rounded,
      count: '38+ Partners',
      color: Color(0xFF7C3AED),
    ),
    CategoryItem(
      title: 'Corporate Legal & Advisory',
      slug: 'legal-services',
      icon: Icons.gavel_rounded,
      count: '24+ Partners',
      color: Color(0xFFD97706),
    ),
    CategoryItem(
      title: 'Cloud & AI Infrastructure',
      slug: 'cloud-infrastructure',
      icon: Icons.cloud_done_rounded,
      count: '19+ Partners',
      color: Color(0xFF0284C7),
    ),
    CategoryItem(
      title: 'Creative Design & Branding',
      slug: 'design-branding',
      icon: Icons.palette_rounded,
      count: '31+ Partners',
      color: Color(0xFFE11D48),
    ),
    CategoryItem(
      title: 'Finance, Tax & Audit',
      slug: 'finance-tax',
      icon: Icons.account_balance_rounded,
      count: '29+ Partners',
      color: Color(0xFF059669),
    ),
    CategoryItem(
      title: 'B2B Logistics & Supply Chain',
      slug: 'logistics',
      icon: Icons.local_shipping_rounded,
      count: '22+ Partners',
      color: Color(0xFFEA580C),
    ),
    CategoryItem(
      title: 'HR & Talent Recruitment',
      slug: 'hr-recruitment',
      icon: Icons.groups_rounded,
      count: '26+ Partners',
      color: Color(0xFF4F46E5),
    ),
    CategoryItem(
      title: 'Enterprise ERP & CRM',
      slug: 'enterprise-solutions',
      icon: Icons.hub_rounded,
      count: '18+ Partners',
      color: Color(0xFF0D9488),
    ),
  ];

  List<CategoryItem> get _filteredCategories {
    if (_searchQuery.isEmpty) return _allCategories;
    return _allCategories
        .where((cat) => cat.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // Header Search
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            color: AppTheme.surface,
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search service industries & categories...',
                hintStyle: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMuted),
                prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textMuted, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppTheme.surfaceSecondary,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.accentBlue),
                ),
              ),
            ),
          ),

          // Categories Grid
          Expanded(
            child: _filteredCategories.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off_rounded, size: 48, color: AppTheme.textMuted),
                        const SizedBox(height: 12),
                        Text(
                          'No categories found matching "$_searchQuery"',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredCategories.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = _filteredCategories[index];
                      return Material(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            widget.onSelectCategory(
                              'https://marketplace.pearlorganisation.in/products?category=${item.slug}',
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppTheme.border),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: item.color.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(item.icon, color: item.color, size: 22),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: GoogleFonts.ibmPlexSans(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        item.count,
                                        style: GoogleFonts.jetBrainsMono(
                                          fontSize: 11.5,
                                          color: AppTheme.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 14,
                                  color: AppTheme.textMuted,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
