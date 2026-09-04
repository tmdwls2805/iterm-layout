#!/usr/bin/env bash
# swift build 결과물을 macOS .app 번들로 감싼다.
# SwiftUI 앱은 번들 안에서 실행되어야 창이 뜬다.
set -e
cd "$(dirname "$0")"
swift build -c release
BIN=.build/release/MyTerm
APP=.build/release/MyTerm.app
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS"
cp "$BIN" "$APP/Contents/MacOS/MyTerm"
cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleName</key><string>MyTerm</string>
  <key>CFBundleDisplayName</key><string>MyTerm</string>
  <key>CFBundleIdentifier</key><string>com.silverslab.myterm</string>
  <key>CFBundleExecutable</key><string>MyTerm</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>0.1.0</string>
  <key>CFBundleVersion</key><string>1</string>
  <key>LSMinimumSystemVersion</key><string>14.0</string>
  <key>NSHighResolutionCapable</key><true/>
</dict>
</plist>
PLIST
echo "번들 생성 완료: $(pwd)/$APP"
echo "실행: open '$(pwd)/$APP' --args --layout 4,3"
