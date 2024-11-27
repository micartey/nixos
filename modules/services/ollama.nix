{
  services.ollama = {
    enable = true;
    acceleration = "cuda"; # TODO: use false if nvidia is disabled
  };
}
