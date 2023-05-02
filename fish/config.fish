set -gx EDITOR nvim
set -gx USE_GKE_GCLOUD_AUTH_PLUGIN True

if type -q google-chrome-stable
  set -gx CHROME_EXECUTABLE (which google-chrome-stable)
end 
