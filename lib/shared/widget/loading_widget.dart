import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'loading_widget_controller.dart';

class LoadingWidget {
  LoadingWidget._sharedInstance();
  static late final LoadingWidget _shared = LoadingWidget._sharedInstance();
  factory LoadingWidget.instance() => _shared;

  LoadingWidgetController? _controller;

  void show({
    required BuildContext context,
    required String text,
  }) {
    if (_controller?.update(text) ?? false) {
      return;
    }

    _controller = _showOverlay(context: context, text: text);
  }

  void hide() {
    _controller?.close();
    _controller = null;
  }

  LoadingWidgetController _showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final messageStream = StreamController<String>();
    messageStream.add(text);

    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      StreamBuilder<String>(
                        stream: messageStream.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data!,
                              textAlign: TextAlign.center,
                            );
                          } else {
                            return Container();
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    state.insert(overlay);

    return LoadingWidgetController(close: () {
      messageStream.close();
      overlay.remove();
      return true;
    }, update: (text) {
      messageStream.add(text);
      return true;
    });
  }
}
