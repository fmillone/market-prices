import 'package:flutter/material.dart';
import 'package:market_prices/main.dart';
import 'package:market_prices/settings.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SettingsWidget();
  }
}

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  List<Widget> getOptionList(List<Setting> op) {
    List<Widget> list = [];
    var index = 0;
    return op
        .map((elem) => CheckboxListTile(
              key: Key(elem.key),
              onChanged: (bool? b) {
                setState(() {
                  elem.value = b ?? false;
                });
              },
              value: elem.value,
              title: ReorderableDragStartListener(
                index: index++,
                child: Text(elem.key),
              ),
            ))
        .toList();
    return list;
  }

  @override
  void initState() {
    super.initState();
    final curr = Provider.of<SettingsStore>(context, listen: false);
    curr.loadTickers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final curr = Provider.of<SettingsStore>(context, listen: false);
            curr.saveTickers();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MyHomePage()));
          },
        ),
      ),
      body: Center(
        child: Consumer<SettingsStore>(
          builder: (ctx, store, _) => ReorderableListView(
            buildDefaultDragHandles: false,
            onReorder: (int oldIndex, int newIndex) {
              store.reorderTickers(oldIndex, newIndex);
            },
            children: getOptionList(store.tickers),
          ),
        ),
      ),
    );
  }
}
