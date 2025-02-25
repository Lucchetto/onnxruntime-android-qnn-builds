#!/bin/bash

# Ensure required environment variables are set
if [[ -z "$QNN_SDK_VERSION" || -z "$ANDROID_HOME" || -z "$ANDROID_NDK_VERSION" || -z "$ANDROID_MIN_SDK_VERSION" ]]; then
    echo "Missing required environment variables."
    exit 1
fi

# Ensure ANDROID_ABI argument is provided
if [[ -z "$1" ]]; then
    echo "Usage: $0 <ANDROID_ABI> [extra_args...]"
    echo "Example: $0 arm64-v8a --verbose"
    exit 1
fi

ANDROID_ABI="$1"
shift # Shift to remove ANDROID_ABI from arguments, so "$@" contains only extra args

python3 tools/ci_build/build.py --build_shared_lib --skip_submodule_sync --android \
    --config Release \
    --android_sdk_path "$ANDROID_HOME" \
    --android_ndk_path "$ANDROID_HOME/ndk/$ANDROID_NDK_VERSION" \
    --android_abi "$ANDROID_ABI" --android_api "$ANDROID_MIN_SDK_VERSION" \
    --cmake_generator Ninja --allow_running_as_root --use_cache \
    --build_dir "build/android/$ANDROID_ABI" "$@"
