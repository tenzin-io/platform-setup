# README
The `config.toml` was generated using `containerd config default`.  The important change is in the below block, where `SystemdCgroup` is set to `true`.

The `config-nvidia.toml` was configured from the `config.toml` and then making modifications using instructions from <https://github.com/NVIDIA/k8s-device-plugin#configure-containerd>.
