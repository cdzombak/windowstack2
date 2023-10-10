#!/usr/bin/env bash
set -euo pipefail

if [ -z "$FORMULA_VERSION_NO_V" ]; then
  echo "missing FORUMLA_VERSION_NO_V"
  exit 1
fi
if [ -z "$FORMULA_TGZ_SHA256" ]; then
  echo "missing FORMULA_TGZ_SHA256"
  exit 1
fi

cat << EOF
# typed: true
# frozen_string_literal: true

# This file was automatically generated. DO NOT EDIT.
class WindowStack2 < Formula
  desc "Keep a log of frontmost macOS window titles in your terminal"
  homepage "https://github.com/cdzombak/windowstack2"
  url "https://github.com/cdzombak/windowstack2/releases/download/v${FORMULA_VERSION_NO_V}/windowstack2-${FORMULA_VERSION_NO_V}-all.tar.gz"
  sha256 "${FORMULA_TGZ_SHA256}"
  license "MIT"

  def install
    bin.install "windowstack2"
  end

  test do
    assert_match("${FORMULA_VERSION_NO_V}", shell_output("#{bin}/windowstack2 --version"))
  end
end
EOF
