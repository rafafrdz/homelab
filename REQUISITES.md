# ⚙️ Prerrequisitos

Antes de aplicar la configuración, asegúrate de cumplir con los siguientes requisitos según tu sistema operativo.

## 🐧 NixOS

**Requisitos previos:**

1. Tener una instalación funcional de **NixOS** (mínimo versión 23.11 recomendada).
2. Conectividad a internet (para descargar dependencias desde `nixpkgs`).
3. Acceso con privilegios de `sudo`.
4. Tener configurado Git:

```bash
   sudo nix-shell -p git --run 'git --version'
```

5. Espacio suficiente en `/nix/store` (se recomienda al menos 5 GB libres).

**Verificación rápida:**

```bash
nixos-version        # muestra la versión actual del sistema
sudo nix-env --version  # comprueba que Nix funciona correctamente
```

## 🧰 Arch Linux (sin Nix instalado)

**Requisitos previos:**

1. Tener una instalación funcional de **Arch Linux** actualizada:

```bash
   sudo pacman -Syu
```

2. Instalar herramientas básicas:

```bash
   sudo pacman -S git curl xz gcc
```

3. Instalar **Nix** (modo multiusuario recomendado):

```bash
   sh <(curl -L https://nixos.org/nix/install) --daemon
```

4. Activar características experimentales (flakes y nix-command):

```bash
   echo 'experimental-features = nix-command flakes' | sudo tee -a /etc/nix/nix.conf
   sudo systemctl restart nix-daemon.service
   exec $SHELL -l
```

5. Instalar **Home Manager** (para gestionar configuración de usuario):

```bash
   nix-shell -p home-manager
```

6. Verificar instalación:

```bash
   nix --version
   home-manager --version
```

**Consejo:** agrega tu usuario al grupo `nix-users` si no puedes acceder al daemon:

```bash
sudo usermod -aG nix-users $USER
newgrp nix-users
```

Con esto tendrás el entorno listo para aplicar la configuración modular en **Arch Linux** usando `home-manager switch --flake ...`.
