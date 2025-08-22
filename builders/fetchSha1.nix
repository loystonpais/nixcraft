{pkgs, ...}: {
  url,
  sha1,
  fetchurl ? pkgs.fetchurl,
  ...
}:
fetchurl {
  inherit url;
  inherit sha1;
}
