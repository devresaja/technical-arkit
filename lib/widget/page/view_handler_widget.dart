import 'package:technical_artkit/core/theme/app_color.dart';
import 'package:technical_artkit/constant/divider.dart';
import 'package:technical_artkit/utils/view_utils.dart';
import 'package:technical_artkit/widget/button/custom_button.dart';
import 'package:technical_artkit/widget/image/svg_ui.dart';
import 'package:technical_artkit/widget/text/text_widget.dart';
import 'package:flutter/material.dart';

enum ViewMode { loading, loaded, empty, error, loadMore, loadMax }

class ViewHandlerWidget extends StatefulWidget {
  final ViewMode viewMode;
  final Widget child;
  final Function()? onTapError;
  final Widget? customLoading, customEmpty, customFailed;
  const ViewHandlerWidget({
    required this.child,
    super.key,
    this.viewMode = ViewMode.loading,
    this.onTapError,
    this.customEmpty,
    this.customFailed,
    this.customLoading,
  });

  @override
  State<ViewHandlerWidget> createState() => _ViewHandlerWidgetState();
}

class _ViewHandlerWidgetState extends State<ViewHandlerWidget> {
  @override
  Widget build(BuildContext context) {
    switch (widget.viewMode) {
      case ViewMode.loading:
        return widget.customLoading ?? loading();
      case ViewMode.loaded || ViewMode.loadMore || ViewMode.loadMax:
        print('masuk sini');
        return widget.child;
      case ViewMode.empty:
        return Center(
          child:
              widget.customEmpty ??
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgUI('ic_empty.svg', size: 100),
                  divide24,
                  TextWidget('Not Found', fontSize: 16),
                  divide28,
                ],
              ),
        );
      case ViewMode.error:
        return Center(
          child:
              widget.customFailed ??
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgUI('ic_error.svg', size: 100),
                  TextWidget('Something wrong', color: AppColor.errorText),
                  if (widget.onTapError != null) ...[
                    divide20,
                    SizedBox(
                      width: 200,
                      child: CustomButton(
                        text: 'Refresh',
                        onTap: widget.onTapError!,
                      ),
                    ),
                  ],
                ],
              ),
        );
    }
  }
}
