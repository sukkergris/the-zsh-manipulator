#!/usr/bin/env bash
# shellcheck shell=bash

Describe 'greet'
  Include ./koll.zsh

  It 'greets the given name'
    When call greet "World"
    The output should equal "YO, World!"
  End
End
