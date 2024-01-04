#!/bin/bash

# Kiểm tra xem có thay đổi nào cần commit không
if ! git diff-index --quiet HEAD --; then
  # Thêm các thay đổi vào staging area
  git add .

  # Nhập commit message từ người dùng
  read -p "Nhập commit message: " commit_message

  # Thực hiện commit
  git commit -m "$commit_message"

  echo "Commit thành công!"
else
  echo "Không có thay đổi nào cần commit."
fi
