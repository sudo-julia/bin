#!/usr/bin/env bash
# manage todo list

todo_dir="${HOME}/lib/todo"

case "$1" in
-n | --new)
  mv -- "${todo_dir}/TODO.md" "$(date -I).md" &&
    \ echo -e "# TODO\n\n## Reminders\n\n## Complete\n\n" >"${todo_dir}/TODO.md"
  ;;
*)
  nvim +3 -- "${todo_dir}/TODO.md"
  ;;
esac
