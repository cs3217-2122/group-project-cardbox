export PATH="$PATH:/opt/homebrew/bin"
if which swiftlint >/dev/null; then
  swiftlint autocorrect --config .swiftlint.yml && swiftlint --config .swiftlint.yml
else
  echo \"warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint\"
fi

