import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref
                .read(SettingsStore.provider)
                .saveTickers()
                .then((value) => Navigator.pop(context, true));
          },
        ),
      ),
      body: const SettingsWidget(),
    );
  }
}

class SettingsWidget extends ConsumerWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(SettingsStore.provider);
    return Center(
      child: ReorderableListView(
        buildDefaultDragHandles: false,
        onReorder: (int oldIndex, int newIndex) {
          store.reorderTickers(oldIndex, newIndex);
        },
        children: getOptionList(store),
      ),
    );
  }

  List<Widget> getOptionList(SettingsStore store) {
    var index = 0;
    return store.tickers
        .map((elem) => CheckboxListTile(
              key: Key(elem.key),
              onChanged: (bool? b) {
                store.setTickerValue(elem.key, b ?? false);
              },
              value: elem.value,
              title: ReorderableDragStartListener(
                index: index++,
                child: Text(elem.key),
              ),
            ))
        .toList();
  }
}
