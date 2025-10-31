import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:sketch_cloud/core/constants/app_strings.dart';
import 'package:sketch_cloud/core/widget/app_custom_appbar.dart';
import 'package:sketch_cloud/core/widget/app_scaffold.dart';
import 'package:sketch_cloud/data/models/drawing_point.dart';
import 'package:sketch_cloud/data/models/image_model.dart';
import 'package:sketch_cloud/data/services/navigation_service.dart';
import 'package:sketch_cloud/data/services/image_capture_service.dart';
import 'package:sketch_cloud/data/services/file_service.dart';
import 'package:sketch_cloud/features/drawing/bloc%20/drawing_bloc.dart';
import 'package:sketch_cloud/features/drawing/widgets/drawing_painter.dart';
import 'package:sketch_cloud/features/drawing/widgets/square_color_picker.dart';
import 'package:sketch_cloud/features/drawing/widgets/tool_panel.dart';
import 'package:sketch_cloud/features/drawing/widgets/exit_dialog.dart';

class DrawingScreen extends StatefulWidget {
  final ImageModel? image;
  final String userId;

  const DrawingScreen({super.key, this.image, required this.userId});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  final ImagePicker _imagePicker = ImagePicker();

  final List<DrawingPoint> _points = [];
  Color _currentColor = Colors.black;
  final double _strokeWidth = 3.0;
  bool _isEraser = false;
  ui.Image? _backgroundImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.image != null) {
      _loadBackgroundImageFromUrl(widget.image!.downloadUrl);
    }
  }

  Future<void> _loadBackgroundImageFromUrl(String imageUrl) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        await _decodeAndSetBackgroundImage(bytes);
      } else {
        throw Exception('Failed to load image: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Ошибка загрузки изображения: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _importImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 90,
      );

      if (image != null && mounted) {
        setState(() {
          _isLoading = true;
        });

        try {
          final bytes = await image.readAsBytes();
          await _decodeAndSetBackgroundImage(bytes);
        } catch (e) {
          _showError('Ошибка загрузки изображения: $e');
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      _showError('Ошибка выбора изображения: $e');
    }
  }

  Future<void> _decodeAndSetBackgroundImage(Uint8List bytes) async {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, (ui.Image image) {
      completer.complete(image);
    });

    final image = await completer.future;
    setState(() {
      _backgroundImage = image;
    });
  }

  void _showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (context) => SquareColorPicker(
        selectedColor: _currentColor,
        onColorChanged: (color) {
          setState(() {
            _currentColor = color;
            _isEraser = false;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _backgroundImage?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DrawingBloc, DrawingState>(
      listener: (context, state) {
        if (state is DrawingSaveSuccess) {
          Navigator.of(context).pop();
        } else if (state is DrawingError) {
          _showError(state.message);
        } else if (state is DrawingExportSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final isLoading = state is DrawingSaving;

        return Stack(
          children: [
            IgnorePointer(
              ignoring: isLoading,
              child: Opacity(
                opacity: isLoading ? 0.6 : 1.0,
                child: _buildDrawingContent(context),
              ),
            ),

            if (isLoading)
              const Positioned.fill(
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }

  Widget _buildDrawingContent(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(
        title: widget.image != null
            ? AppStrings.drawing.editTitle
            : AppStrings.drawing.newTitle,
        hasImages: true,
        leftIcon: Image.asset('assets/images/icons/arrowLeft.png'),
        rightIcon: Image.asset('assets/images/icons/check.png'),
        onLeftPressed: _showExitDialog,
        onRightPressed: _saveImage,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            ToolPanel(
              onExport: _exportImage,
              onImportFromGallery: _importImageFromGallery,
              onPencil: _activatePencil,
              onEraser: _activateEraser,
              onColorPicker: _showColorPickerDialog,
            ),
            if (_isLoading) const LinearProgressIndicator(),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 100),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[100],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: RepaintBoundary(
                    key: _repaintBoundaryKey,
                    child: GestureDetector(
                      onPanStart: (details) {
                        setState(() {
                          _points.add(
                            DrawingPoint(
                              offset: details.localPosition,
                              color: _isEraser ? Colors.white : _currentColor,
                              strokeWidth: _strokeWidth,
                            ),
                          );
                        });
                      },
                      onPanUpdate: (details) {
                        setState(() {
                          _points.add(
                            DrawingPoint(
                              offset: details.localPosition,
                              color: _isEraser ? Colors.white : _currentColor,
                              strokeWidth: _strokeWidth,
                            ),
                          );
                        });
                      },
                      onPanEnd: (details) {
                        setState(() {
                          _points.add(DrawingPoint.empty());
                        });
                      },
                      child: CustomPaint(
                        painter: DrawingPainter(
                          points: _points,
                          backgroundImage: _backgroundImage,
                        ),
                        size: Size.infinite,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _activatePencil() {
    setState(() {
      _isEraser = false;
    });
  }

  void _activateEraser() {
    setState(() {
      _isEraser = true;
    });
  }

  void _showExitDialog() {
    if (_points.length > 1) {
      showDialog(
        context: context,
        builder: (context) =>
            ExitDialog(onExitConfirmed: () => appNavigation.pop()),
      );
    } else {
      appNavigation.pop();
    }
  }

  void _saveImage() async {
    try {
      final imageBytes =
          await ImageCaptureService.captureImageFromRepaintBoundary(
            _repaintBoundaryKey,
          );
      if (imageBytes == null || imageBytes.isEmpty) {
        _showError('Не удалось создать изображение');
        return;
      }

      final file = await FileService.createTempImageFile(imageBytes);

      if (widget.image != null) {
        context.read<DrawingBloc>().add(DrawingUpdated(file, widget.image!.id));
      } else {
        context.read<DrawingBloc>().add(DrawingSaved(file));
      }
    } catch (e) {
      _showError('Ошибка сохранения: $e');
    }
  }

  Future<void> _exportImage() async {
    try {
      final imageBytes =
          await ImageCaptureService.captureImageFromRepaintBoundary(
            _repaintBoundaryKey,
          );
      if (imageBytes == null || imageBytes.isEmpty) {
        _showError('Не удалось создать изображение');
        return;
      }

      final file = await FileService.createTempImageFile(imageBytes);
      context.read<DrawingBloc>().add(DrawingExported(file));
    } catch (e) {
      _showError('Ошибка экспорта: $e');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
