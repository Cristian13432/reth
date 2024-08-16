#!/usr/bin/env bash
set -eo pipefail

# List of no-std packages to build
no_std_packages=(
#   reth-codecs
#   reth-consensus
#   reth-db
#   reth-errors
#   reth-ethereum-forks
#   reth-evm
#   reth-evm-ethereum
#   reth-network-peers
#   reth-primitives
#   reth-primitives-traits
#   reth-revm
)

# Loop through each package and build it
for package in "${no_std_packages[@]}"; do
  cmd="cargo +stable build -p $package --target riscv32imac-unknown-none-elf --no-default-features"

  # Output command for CI or local environment
  if [ -n "$CI" ]; then
    echo "::group::$cmd"
  else
    printf "\n%s:\n  %s\n" "$package" "$cmd"
  fi

  # Execute the build command
  if ! $cmd; then
    echo "Build failed for package: $package" >&2
    exit 1
  fi

  # Close CI group if in CI environment
  if [ -n "$CI" ]; then
    echo "::endgroup::"
  fi
done
