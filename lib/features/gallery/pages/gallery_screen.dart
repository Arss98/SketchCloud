import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sketch_cloud/core/constants/app_colors.dart';
import 'package:sketch_cloud/core/constants/app_routes.dart';
import 'package:sketch_cloud/core/constants/app_strings.dart';
import 'package:sketch_cloud/core/widget/app_custom_appbar.dart';
import 'package:sketch_cloud/core/widget/app_custom_button.dart';
import 'package:sketch_cloud/core/widget/app_scaffold.dart';
import 'package:sketch_cloud/data/models/image_model.dart';
import 'package:sketch_cloud/features/auth/bloc/auth_bloc.dart';
import 'package:sketch_cloud/features/gallery/bloc/gallery_bloc.dart';

final class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadImages();
  }

  void _loadImages() {
    if (mounted) {
      context.read<GalleryBloc>().add(GalleryLoadRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GalleryBloc, GalleryState>(
      listener: (context, state) {
        if (state is GalleryError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },

      builder: (context, state) {
        final hasImages = state is GalleryLoaded && state.images.isNotEmpty;

        return AppScaffold(
          appBar: CustomAppBar(
            title: AppStrings.common.galleryTitle,
            hasImages: hasImages,
            onLeftPressed: () {
              _showLogoutDialog(context);
            },
            onRightPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.drawing).then((_) {
                _loadImages();
              });
            },
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildBody(state),
                  if (!hasImages) _buildCreateButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(GalleryState state) {
    if (state is GalleryLoading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    if (state is GalleryLoaded) {
      return _buildImageGrid(state.images);
    }

    return const Expanded(child: SizedBox.shrink());
  }

  Widget _buildImageGrid(List<ImageModel> images) {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.only(top: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          final image = images[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(
                context,
              ).pushNamed(AppRoutes.drawing, arguments: image).then((_) {
                _loadImages();
              });
            },
            onLongPress: () {
              _showDeleteDialog(context, image.id);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(image.downloadUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCreateButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppCustomButton(
        text: AppStrings.common.create,
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.drawing).then((_) {
            _loadImages();
          });
        },
        gradient: LinearGradient(
          colors: [AppColors.appGradientMain, AppColors.appGradientSecondary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.dialogs.logoutTitle),
        content: Text(AppStrings.dialogs.logoutMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppStrings.common.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthBloc>().add(SignOutRequested());
            },
            child: Text(AppStrings.dialogs.logout),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String imageId) {
    final galleryBloc = context.read<GalleryBloc>();

    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: galleryBloc,
        child: AlertDialog(
          title: Text(AppStrings.dialogs.deleteTitle),
          content: Text(AppStrings.dialogs.deleteMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppStrings.common.cancel),
            ),
            TextButton(
              onPressed: () {
                galleryBloc.add(GalleryImageDeleted(imageId));
                Navigator.of(context).pop();
              },
              child: Text(AppStrings.dialogs.delete),
            ),
          ],
        ),
      ),
    );
  }
}
