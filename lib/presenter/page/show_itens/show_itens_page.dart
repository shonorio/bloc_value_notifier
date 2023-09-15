import 'package:bloc_value_notifier/shared/widget/loading_widget.dart';
import 'package:bloc_value_notifier/shared/widget/show_generic_dialog.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/item_entity.dart';
import '../../../domain/repositories/get_list_repository.dart';
import '../../../shared/value_notifier/value_notifier_consumer.dart';
import '../../bloc/app_state.dart';
import 'show_itens_page_controller.dart';

class ShowItens extends StatefulWidget {
  const ShowItens({Key? key}) : super(key: key);

  @override
  State<ShowItens> createState() => _ShowItensState();
}

class _ShowItensState extends State<ShowItens> {
  final controller = ShowItensPageController(repository: GetListRepository());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second page'),
        actions: [_ReloadAction(controller: controller)],
      ),
      body: ValueNotifierConsumer<AppState>(
        valueListenable: controller,
        listenWhen: _isListenableState,
        listener: _executeListener,
        buildWhen: _isBuildableState,
        builder: (BuildContext context, AppState state, Widget? child) {
          LoadingWidget.instance().hide();

          return state.maybeMap(
            success: (v) => _ShowItemsListWidget(items: v.elements),
            orElse: () => Container(color: Colors.black26),
          );
        },
      ),
    );
  }

  bool _isBuildableState(AppState current) {
    return current.maybeMap(
      loading: (_) => false,
      failure: (_) => false,
      orElse: () => true,
    );
  }

  void _executeListener(BuildContext context, AppState state) {
    LoadingWidget.instance().hide();

    state.maybeMap(
      failure: (failure) async {
        await showGenericDialog(
            context: context,
            title: 'Ocorreu um erro',
            content: failure.message,
            optionBuilder: () => {'Ok': true});

        await controller.load();
      },
      loading: (_) =>
          LoadingWidget.instance().show(context: context, text: 'Loading...'),
      orElse: () {},
    );
  }

  bool _isListenableState(AppState current) {
    return current.maybeMap(
      loading: (_) => true,
      failure: (_) => true,
      orElse: () => false,
    );
  }
}

class _ReloadAction extends StatelessWidget {
  const _ReloadAction({
    super.key,
    required this.controller,
  });

  final ShowItensPageController controller;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => controller.load(),
      icon: const Icon(Icons.replay),
    );
  }
}

class _ShowItemsListWidget extends StatelessWidget {
  const _ShowItemsListWidget({
    Key? key,
    required Iterable<ItemEntity> items,
  })  : _itemList = items,
        super(key: key);

  final Iterable<ItemEntity> _itemList;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _itemList.length,
      separatorBuilder: (BuildContext context, int index) {
        return Container(height: 8, color: Colors.grey);
      },
      itemBuilder: (BuildContext context, int index) {
        final item = _itemList.elementAt(index);

        return ListTile(title: Text(item.title));
      },
    );
  }
}
