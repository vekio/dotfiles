{ config, pkgs, ... }:

{
  programs.brave = {
    enable = true;
    extensions = [
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # dark-reader
      { id = "ghmbeldphafepmbegfdlkpapadhbakde"; } # proton-pass
      { id = "jplgfhpmjnbigmhklmmbgecoobifkmpa"; } # proton-vpn
      { id = "occjjkgifpmdgodlplnacmkejpdionan"; } # auto-scroll
    ];
    # commandLineArgs = [
    #   "--disable-features=PasswordManagerEnable"
    #   "--disable-features=AutofillEnableAccountWalletStorage"
    # ];
  };
}
