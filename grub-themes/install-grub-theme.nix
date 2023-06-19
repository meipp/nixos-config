{pkgs, ...}:

{
  src,
  background ? null,
  packageName ? "grub-theme",
  installPhase ? "mkdir $out; cp -r * $out;",
}:

"${pkgs.stdenv.mkDerivation {
  src = src;
  name = packageName;
  installPhase = installPhase + (if background != null then "cp ${background} $out/background.png" else "");
}}"
