set -gx EDITOR nvim
set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/gcr/ssh
set -gx USE_GKE_GCLOUD_AUTH_PLUGIN True

if type -q google-chrome-stable
    set -gx CHROME_EXECUTABLE (which google-chrome-stable)
end
