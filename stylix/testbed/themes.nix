{
  images,
  tinted-schemes,
  vanilla-dmz,
}:
{
  light = {
    enable = true;
    image = images.light;
    base16Scheme = "${tinted-schemes}/base16/catppuccin-latte.yaml";
    polarity = "light";
    cursor = {
      name = "Vanilla-DMZ";
      package = vanilla-dmz;
      size = 32;
    };
  };
  dark = {
    enable = true;
    image = images.dark;
    base16Scheme = "${tinted-schemes}/base16/catppuccin-macchiato.yaml";
    polarity = "dark";
    cursor = {
      name = "Vanilla-DMZ";
      package = vanilla-dmz;
      size = 32;
    };
  };
  imageless = {
    enable = true;
    base16Scheme = "${tinted-schemes}/base16/catppuccin-macchiato.yaml";
    polarity = "dark";
    cursor = {
      name = "Vanilla-DMZ";
      package = vanilla-dmz;
      size = 32;
    };
  };
  schemeless = {
    enable = true;
    image = images.dark;
    polarity = "dark";
    cursor = {
      name = "Vanilla-DMZ";
      package = vanilla-dmz;
      size = 32;
    };
  };
  cursorless = {
    enable = true;
    image = images.dark;
    base16Scheme = "${tinted-schemes}/base16/catppuccin-macchiato.yaml";
    polarity = "dark";
  };
}
