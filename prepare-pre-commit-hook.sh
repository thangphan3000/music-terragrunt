#!/bin/bash

PRE_COMMIT_HOOK_FILE=".git/hooks/pre-commit"

function add_pre_commit_hook_logic() {
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash

echo "Running terraform fmt..."
terraform fmt -recursive .

echo "Running terragrunt fmt..."
terragrunt hcl fmt

echo "Formatting complete!"
EOF
}

function grant_file_execution_permission() {
  local file
  file=$1
  chmod u+x "$file"
}

function prepare_pre_commit_hook() {
  echo "Setting up pre-commit hook..."

  if [ ! -f "$PRE_COMMIT_HOOK_FILE" ]; then
    add_pre_commit_hook_logic
    grant_file_execution_permission $PRE_COMMIT_HOOK_FILE
    echo "Pre-commit hook installed successfully!"

    return
  fi

  echo "Skip preparing hook pre-commit cuz it is already exists."
}

prepare_pre_commit_hook
