[[Versão em Português](README-pt-br.md)] [[Versión en Español](README-es.md)]

# State Management in Flutter

State management is a fundamental topic in Flutter app development, with many packages and approaches available. However, all state management relies on three essential principles: state representation, storage, and distribution (reactivity).

State representation defines how states are structured, state storage deals with the effective management of these states, and state distribution ensures consistent updates across the user interface.

## Bloc is Not Just bloc

It is common for developers to mistake state management patterns for their package implementations. The Bloc pattern is a prime example of this confusion, with some developers believing that an application only adheres to the Bloc pattern if it utilizes the bloc package.

## Bloc with ValueNotifier

When managing the state of an app, I prefer utilizing the Bloc pattern and following established naming conventions, as outlined in [bloc naming conventions](https://bloclibrary.dev/#/blocnamingconventions). However, I prioritize utilizing ValueNotifier as it is a built-in state management solution within Flutter. I also implement a modified version of Cubit using ValueNotifier and am open to transitioning to the bloc package if necessary.

However, the bloc package offers valuable tools that I want to use with ValueNotifier. For screens with both data and action states, such as loading or error messages, tools like [`BlocListener`](https://pub.dev/documentation/flutter_bloc/latest/flutter_bloc/BlocListener-class.html) and [BlocConsumer](https://pub.dev/documentation/flutter_bloc/latest/flutter_bloc/BlocConsumer-class.html) are handy. They allow me to control which state is executed in the builder and take other necessary actions on the screen.

In this project, I created the [`ValueNotifierConsumer`](lib/shared/value_notifier/value_notifier_consumer.dart) class, inspired by bloc's `BlocConsumer`. In the project example, I utilized the `buildWhen` property to manage the `builder` trigger. 

The `builder` in this case is responsible for presenting the result of `state.success`.

Action states (loading and error) should overlay the data, and `listenWhen` determines when the `listener` triggers.

```dart
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
```

![Alt Text](docs/value_notifier_consumer.gif)
