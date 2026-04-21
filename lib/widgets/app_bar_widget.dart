import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class MedCampAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final double elevation;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;

  const MedCampAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.elevation = 0,
    this.backgroundColor,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppTheme.surface,
      elevation: elevation,
      scrolledUnderElevation: 2,
      shadowColor: Colors.black.withAlpha(20),
      automaticallyImplyLeading: showBackButton,
      leading:
          leading ??
          (showBackButton && Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20,
                    color: AppTheme.primary,
                  ),
                  onPressed: () => Navigator.pop(context),
                )
              : null),
      title: Text(
        title,
        style: GoogleFonts.ibmPlexSans(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppTheme.textPrimary,
        ),
      ),
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}

class MedCampSliverAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? flexibleSpaceBackground;
  final double expandedHeight;

  const MedCampSliverAppBar({
    super.key,
    required this.title,
    this.actions,
    this.flexibleSpaceBackground,
    this.expandedHeight = 120,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: expandedHeight,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.surface,
      elevation: 0,
      scrolledUnderElevation: 2,
      shadowColor: Colors.black.withAlpha(20),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          title,
          style: GoogleFonts.ibmPlexSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        background:
            flexibleSpaceBackground ?? Container(color: AppTheme.background),
        titlePadding: const EdgeInsetsDirectional.only(start: 16, bottom: 14),
      ),
      actions: actions,
    );
  }
}
