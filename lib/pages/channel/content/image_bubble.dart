// Copyright 2023 FluffyChat.
// This file is part of FluffyChat

// Licensed under the AGPL;
//
// https://gitlab.com/famedly/fluffychat
//

import 'package:asyou_app/utils/screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:matrix/matrix.dart';

import '../../../components/mxc_image.dart';
import '../../../store/theme.dart';
import '../../image_viewer/image_viewer.dart';

class ImageBubble extends StatelessWidget {
  final Event event;
  final bool tapToView;
  final BoxFit fit;
  final bool maxSize;
  final Color? backgroundColor;
  final bool thumbnailOnly;
  final bool animated;
  final double width;
  final double height;
  final void Function()? onTap;

  const ImageBubble(
    this.event, {
    this.tapToView = true,
    this.maxSize = true,
    this.backgroundColor,
    this.fit = BoxFit.cover,
    this.thumbnailOnly = true,
    this.width = 400,
    this.height = 300,
    this.animated = false,
    this.onTap,
    Key? key,
  }) : super(key: key);

  Widget _buildPlaceholder(BuildContext context) {
    if (event.messageType == MessageTypes.Sticker) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
    final String blurHashString = event.infoMap['xyz.amorgan.blurhash'] is String
        ? event.infoMap['xyz.amorgan.blurhash']
        : 'LEHV6nWB2yk8pyo0adR*.7kCMdnj';
    final ratio =
        event.infoMap['w'] is int && event.infoMap['h'] is int ? event.infoMap['w'] / event.infoMap['h'] : 1.0;
    var width = 32;
    var height = 32;
    if (ratio > 1.0) {
      height = (width / ratio).round();
    } else {
      width = (height * ratio).round();
    }
    return SizedBox(
      width: this.width,
      height: this.height,
      child: BlurHash(
        hash: blurHashString,
        decodingWidth: width,
        decodingHeight: height,
        imageFit: fit,
      ),
    );
  }

  void _onTap(BuildContext context) {
    if (onTap != null) {
      onTap!();
      return;
    }
    if (!tapToView) return;
    showDialog(
      context: context,
      useRootNavigator: false,
      builder: (_) => ImageViewer(event),
    );
  }

  @override
  Widget build(BuildContext context) {
    final constTheme = Theme.of(context).extension<ExtColors>()!;
    return InkWell(
      onTap: () => _onTap(context),
      child: Hero(
        tag: event.eventId,
        child: AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          child: Container(
            constraints: maxSize
                ? BoxConstraints(
                    maxWidth: width,
                    maxHeight: height,
                  )
                : null,
            decoration:
                BoxDecoration(border: Border.all(width: 4.w, color: constTheme.centerChannelColor.withOpacity(0.1))),
            child: MxcImage(
              event: event,
              width: width,
              height: height,
              fit: fit,
              animated: animated,
              isThumbnail: thumbnailOnly,
              placeholder: _buildPlaceholder,
            ),
          ),
        ),
      ),
    );
  }
}
