test_prints_clean_for_each_clean_branch() {
  workspace=$(mktemp_workspace cmd_status)
  git clone "$CLONE_SOURCE" "${workspace}/project" &>/dev/null
  git -C "${workspace}/project" checkout -b foo &>/dev/null
  cp "${workspace}"/project/.git/refs/{heads/foo,remotes/origin/foo}
  echo "project | ${CLONE_SOURCE}" > "${workspace}"/.projects.gws

  cd "$workspace"
  expected="project:
    foo :                     Clean
    master :                  Clean"
  assertEquals "$expected" "$("$GWS" status)"
}

test_prints_nothing_with_only_changes_option_if_all_branches_are_clean() {
  workspace=$(mktemp_workspace cmd_status)
  git clone "$CLONE_SOURCE" "${workspace}/project" &>/dev/null
  git -C "${workspace}/project" checkout -b foo &>/dev/null
  cp "${workspace}"/project/.git/refs/{heads/foo,remotes/origin/foo}
  echo "project | ${CLONE_SOURCE}" > "${workspace}"/.projects.gws

  cd "$workspace"
  expected=""
  assertEquals "$expected" "$("$GWS" status --only-changes)"
}

test_prints_dirty_for_branch_with_untracked_files() {
  workspace=$(mktemp_workspace cmd_status)
  git clone "$CLONE_SOURCE" "${workspace}/project" &>/dev/null
  echo "project | ${CLONE_SOURCE}" > "${workspace}"/.projects.gws
  mktemp --tmpdir="${workspace}/project/" &>/dev/null

  cd "$workspace"
  expected="project:
    master :                  Dirty (Untracked files) "
  assertEquals "$expected" "$("$GWS" status)"
}

test_prints_dirty_for_branch_with_unstaged_changes() {
  workspace=$(mktemp_workspace cmd_status)
  git clone "$CLONE_SOURCE" "${workspace}/project" &>/dev/null
  echo "project | ${CLONE_SOURCE}" > "${workspace}"/.projects.gws
  rm "${workspace}"/project/README.md

  cd "$workspace"
  expected="project:
    master :                  Dirty (Uncached changes) "
  assertEquals "$expected" "$("$GWS" status)"
}

test_prints_dirty_for_branch_ahead_of_upstream() {
  workspace=$(mktemp_workspace cmd_status)
  git clone "$CLONE_SOURCE" "${workspace}/project" &>/dev/null
  echo "project | ${CLONE_SOURCE}" > "${workspace}"/.projects.gws
  mktemp --tmpdir="${workspace}/project/" &>/dev/null
  git -C "${workspace}/project" add . &>/dev/null
  git -C "${workspace}/project" commit -m "Add a new file" &>/dev/null

  cd "$workspace"
  expected="project:
    master :                  Not in sync with origin/master"
  assertEquals "$expected" "$("$GWS" status)"
}

test_does_not_print_clean_branches_with_changes_only_option_even_if_some_branch_is_not_clean() {
  workspace=$(mktemp_workspace cmd_status)
  git clone "$CLONE_SOURCE" "${workspace}/project" &>/dev/null
  git -C "${workspace}/project" checkout -b foo &>/dev/null
  cp "${workspace}"/project/.git/refs/{heads/foo,remotes/origin/foo}
  echo "project | ${CLONE_SOURCE}" > "${workspace}"/.projects.gws
  git -C "${workspace}/project" checkout master &>/dev/null
  git -C "${workspace}/project" reset --hard HEAD~ &>/dev/null

  cd "$workspace"
  expected="project:
    master :                  Not in sync with origin/master"
  assertEquals "$expected" "$("$GWS" status --only-changes)"
}
