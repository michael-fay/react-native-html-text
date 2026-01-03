#!/usr/bin/env ruby
# frozen_string_literal: true

# This script configures the NativeTestHarness Xcode project to:
# 1. Create a test target (NativeTestHarnessTests)
# 2. Add test files to the test target
#
# NOTE: Source files and codegen are provided by the FabricHtmlText pod via autolinking.
# Do NOT add them directly to avoid duplicate symbols.
#
# Run from native-tests/ios directory after `pod install`

require 'xcodeproj'
require 'fileutils'

PROJECT_PATH = 'NativeTestHarness.xcodeproj'
MAIN_TARGET_NAME = 'NativeTestHarness'
TEST_TARGET_NAME = 'NativeTestHarnessTests'

# Test files relative to native-tests/ios
TEST_DIR = '../../ios/Tests'
TEST_FILES = [
  'FabricHTMLSanitizerTests.swift',
  'FabricHTMLParserTests.mm',
  'FabricHTMLFragmentParserTests.mm',
]

# Files that should NOT be in the main target (they come from the FabricHtmlText pod)
STALE_SOURCE_PATTERNS = [
  /HTMLSanitizer\.swift/,
  /HTMLAttributedStringBuilder\.swift/,
  /HTMLTextRenderer\.swift/,
  /HTMLNativeView\.(h|mm)/,
  /Props\.cpp/,
  /ComponentDescriptors\.cpp/,
  /EventEmitters\.cpp/,
  /ShadowNodes\.cpp/,
  /States\.cpp/,
  /HTMLNativeViewSpec-generated\.mm/,
  /HTMLNativeViewSpecJSI-generated\.cpp/,
]

def main
  puts "Opening project: #{PROJECT_PATH}"
  project = Xcodeproj::Project.open(PROJECT_PATH)

  main_target = project.targets.find { |t| t.name == MAIN_TARGET_NAME }
  raise "Main target '#{MAIN_TARGET_NAME}' not found" unless main_target

  # Remove stale source files from main target that come from the FabricHtmlText pod
  puts "\nRemoving stale source files from #{MAIN_TARGET_NAME}:"
  main_target.source_build_phase.files.dup.each do |build_file|
    next unless build_file.file_ref

    file_path = build_file.file_ref.path.to_s
    if STALE_SOURCE_PATTERNS.any? { |pattern| file_path =~ pattern }
      puts "  - #{file_path} (removed)"
      build_file.remove_from_project
    end
  end

  # Create or find test target
  test_target = project.targets.find { |t| t.name == TEST_TARGET_NAME }

  if test_target.nil?
    puts "\nCreating test target: #{TEST_TARGET_NAME}"
    test_target = project.new_target(:unit_test_bundle, TEST_TARGET_NAME, :ios, '15.1')

    # Configure test target
    test_target.build_configurations.each do |config|
      config.build_settings['PRODUCT_NAME'] = '$(TARGET_NAME)'
      config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = 'io.michaelfay.fabrichtmltext.NativeTestHarnessTests'
      config.build_settings['TEST_HOST'] = '$(BUILT_PRODUCTS_DIR)/NativeTestHarness.app/$(BUNDLE_EXECUTABLE_FOLDER_PATH)/NativeTestHarness'
      config.build_settings['BUNDLE_LOADER'] = '$(TEST_HOST)'
      config.build_settings['SWIFT_VERSION'] = '5.0'
      config.build_settings['INFOPLIST_FILE'] = 'NativeTestHarnessTests/Info.plist'
      config.build_settings['CODE_SIGN_STYLE'] = 'Automatic'
      config.build_settings['CLANG_ENABLE_MODULES'] = 'YES'
      # Add bridging header for ObjC++ interop
      config.build_settings['SWIFT_OBJC_BRIDGING_HEADER'] = 'NativeTestHarness/NativeTestHarness-Bridging-Header.h'
    end

    # Add test target dependency on main target
    test_target.add_dependency(main_target)
  else
    puts "\nTest target already exists: #{TEST_TARGET_NAME}"
  end

  # Create Tests group
  tests_group = project.main_group.find_subpath('FabricHtmlTextTests', true)
  tests_group.set_source_tree('<group>')
  tests_group.set_path(TEST_DIR)

  # Add test files to test target
  puts "\nAdding test files to #{TEST_TARGET_NAME}:"
  TEST_FILES.each do |filename|
    existing = tests_group.files.find { |f| f.path == filename }
    if existing
      puts "  - #{filename} (already exists)"
      next
    end

    file_ref = tests_group.new_reference(filename)
    file_ref.set_source_tree('<group>')
    test_target.source_build_phase.add_file_reference(file_ref)
    puts "  + #{filename}"
  end

  # Create test Info.plist if it doesn't exist
  plist_dir = 'NativeTestHarnessTests'
  plist_path = File.join(plist_dir, 'Info.plist')
  unless File.exist?(plist_path)
    FileUtils.mkdir_p(plist_dir)
    File.write(plist_path, <<~PLIST)
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleDevelopmentRegion</key>
        <string>$(DEVELOPMENT_LANGUAGE)</string>
        <key>CFBundleExecutable</key>
        <string>$(EXECUTABLE_NAME)</string>
        <key>CFBundleIdentifier</key>
        <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
        <key>CFBundleInfoDictionaryVersion</key>
        <string>6.0</string>
        <key>CFBundleName</key>
        <string>$(PRODUCT_NAME)</string>
        <key>CFBundlePackageType</key>
        <string>$(PRODUCT_BUNDLE_TYPE)</string>
        <key>CFBundleShortVersionString</key>
        <string>1.0</string>
        <key>CFBundleVersion</key>
        <string>1</string>
      </dict>
      </plist>
    PLIST
    puts "\nCreated: #{plist_path}"
  end

  # NOTE: Header search paths and codegen files are handled by the FabricHtmlText pod.
  # Do NOT add them here to avoid duplicate symbols.

  # Save project
  project.save
  puts "\nProject saved successfully!"
  puts "\nNext steps:"
  puts "  1. Run 'bundle exec pod install'"
  puts "  2. Open NativeTestHarness.xcworkspace"
  puts "  3. Run tests with Cmd+U or 'xcodebuild test'"
end

main
