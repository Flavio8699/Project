#!/bin/bash

# Define folder paths
frontend_dir="frontend"
html_dir="${frontend_dir}/html"
news_dir="${frontend_dir}/news"

# Check if folders exist, and create them if they don't
if [ ! -d "$frontend_dir" ]; then
  mkdir -p "$frontend_dir"
else
  # If the folder exists, remove its contents
  rm -r "$frontend_dir"/*
fi

if [ ! -d "$html_dir" ]; then
  mkdir -p "$html_dir"
fi

if [ ! -d "$news_dir" ]; then
  mkdir -p "$news_dir"
fi

# Give permissions
chmod 755 "$frontend_dir"
chmod 755 "$html_dir"
chmod 755 "$news_dir"
