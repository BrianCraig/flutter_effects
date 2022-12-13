## Steps to Reproduce

1. Execute `flutter run` on the code sample

**Expected results:** 

2. No Error output or better information.

**Actual results:** <!-- what did you see? -->

2. too bland error output `Unhandled Exception: Exception: Asset 'assets/red.frag' does not contain valid shader data.` not enough

<details>
<summary>Code sample</summary>

`red.frag`
```glsl
precision highp float;

out vec4 fragColor;

void main() {
  fragColor = vec4(1.0, 0.0, 0.0, 1.0);
}
```

```dart
import 'dart:ui';

void main() {
  FragmentProgram.fromAsset('assets/red.frag');
}
```
</details>

<details>
  <summary>Logs</summary>

```
Launching lib/main.dart on Linux in debug mode...
Connecting to VM Service at ws://127.0.0.1:40129/WRR5ORo7bF8=/ws
[ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: Exception: Asset 'assets/red.frag' does not contain valid shader data.
#0      new FragmentProgram._fromAsset (dart:ui/painting.dart:4162:7)
#1      FragmentProgram.fromAsset.<anonymous closure> (dart:ui/painting.dart:4190:55)
#2      new Future.microtask.<anonymous closure> (dart:async/future.dart:277:37)
#3      _microtaskLoop (dart:async/schedule_microtask.dart:40:21)
#4      _startMicrotaskLoop (dart:async/schedule_microtask.dart:49:5)
```

<!-- Finally, paste the output of running `flutter doctor -v` here. -->

```
[✓] Flutter (Channel master, 3.6.0-7.0.pre.52, on Ubuntu 22.10 5.19.0-23-generic, locale en_US.UTF-8)
    • Flutter version 3.6.0-7.0.pre.52 on channel master at /home/bri/sdk/flutter
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision ff59250dbe (20 hours ago), 2022-11-24 18:08:30 -0500
    • Engine revision 7665ae5184
    • Dart version 2.19.0 (build 2.19.0-429.0.dev)
    • DevTools version 2.19.0

[✓] Android toolchain - develop for Android devices (Android SDK version 32.1.0-rc1)
    • Android SDK at /home/bri/Android/Sdk
    • Platform android-32, build-tools 32.1.0-rc1
    • Java binary at: /home/bri/app/android-studio/jre/bin/java
    • Java version Java(TM) SE Runtime Environment (build 17.0.1+12-LTS-39)
    • All Android licenses accepted.

[✓] Chrome - develop for the web
    • Chrome at google-chrome

[✓] Linux toolchain - develop for Linux desktop
    • Ubuntu clang version 15.0.2-1
    • cmake version 3.24.2
    • ninja version 1.11.0
    • pkg-config version 0.29.2

[✓] Android Studio (version 2021.2)
    • Android Studio at /home/bri/app/android-studio
    • Flutter plugin version 70.2.2
    • Dart plugin version 212.5744
    • Java version Java(TM) SE Runtime Environment (build 17.0.1+12-LTS-39)

[✓] VS Code (version 1.72.2)
    • VS Code at /usr/share/code
    • Flutter extension version 3.52.0

[✓] Connected device (2 available)
    • Linux (desktop) • linux  • linux-x64      • Ubuntu 22.10 5.19.0-23-generic
    • Chrome (web)    • chrome • web-javascript • Google Chrome 107.0.5304.87

[✓] HTTP Host Availability
    • All required HTTP hosts are available

• No issues found!
```

</details>