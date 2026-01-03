# Native Test Harness

This is a [**React Native**](https://reactnative.dev) test harness for validating the **html-renderer** library across iOS and Android platforms. The project is bootstrapped using [`@react-native-community/cli`](https://github.com/react-native-community/cli) and includes native test infrastructure (Swift, Kotlin) alongside JavaScript tests.

# Getting Started

> **Note**: Make sure you have completed the [Set Up Your Environment](https://reactnative.dev/docs/set-up-your-environment) guide before proceeding.

## Step 1: Start Metro

First, you will need to run **Metro**, the JavaScript build tool for React Native.

To start the Metro dev server, run the following command from the root of your React Native project:

```sh
# Using npm
npm start

# OR using Yarn
yarn start
```

## Step 2: Build and run your app

With Metro running, open a new terminal window/pane from the root of your React Native project, and use one of the following commands to build and run your Android or iOS app:

### Android

```sh
# Using npm
npm run android

# OR using Yarn
yarn android
```

### iOS

For iOS, remember to install CocoaPods dependencies (this only needs to be run on first clone or after updating native deps).

The first time you create a new project, run the Ruby bundler to install CocoaPods itself:

```sh
bundle install
```

Then, and every time you update your native dependencies, run:

```sh
bundle exec pod install
```

For more information, please visit [CocoaPods Getting Started guide](https://guides.cocoapods.org/using/getting-started.html).

```sh
# Using npm
npm run ios

# OR using Yarn
yarn ios
```

If everything is set up correctly, you should see your new app running in the Android Emulator, iOS Simulator, or your connected device.

This is one way to run your app — you can also build it directly from Android Studio or Xcode.

## Step 2b: Run Tests

To run the Jest test suite:

```sh
npm test
```

## Step 3: Adding & Modifying Tests

### JavaScript Tests

JavaScript tests are located in `__tests__/`. Use [Jest](https://jestjs.io) and [React Testing Library](https://testing-library.com/react) to write behavior-focused tests.

### Native Tests

- **iOS**: Swift test files are in `ios/NativeTestHarness/`. Run with parent library's `yarn test:ios`.
- **Android**: Kotlin/Java test files are in `android/app/src/test/`. Run with parent library's `yarn test:android`.

### Debugging

To debug tests or the harness in development:
- Use `npm start` to run Metro with live reload
- Check console output for test failures
- Use Xcode or Android Studio for native debugging

# Troubleshooting

If you're having issues getting the above steps to work, see the [Troubleshooting](https://reactnative.dev/docs/troubleshooting) page.

# Learn More

To learn more about React Native, take a look at the following resources:

- [React Native Website](https://reactnative.dev) - learn more about React Native.
- [Getting Started](https://reactnative.dev/docs/environment-setup) - an **overview** of React Native and how to set up your environment.
- [Learn the Basics](https://reactnative.dev/docs/getting-started) - a **guided tour** of the React Native **basics**.
- [Blog](https://reactnative.dev/blog) - read the latest official React Native **Blog** posts.
- [`@facebook/react-native`](https://github.com/facebook/react-native) - the Open Source; GitHub **repository** for React Native.

For html-renderer-specific information:

- [html-renderer Documentation](../../README.md) - learn about the html-renderer library and its API.
