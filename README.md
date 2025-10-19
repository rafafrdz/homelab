# NixOS Configuration

Una configuración modular y flexible de NixOS/Nix que funciona tanto en **NixOS** como en **Arch Linux con nix standalone**. La configuración está centralizada en el `flake.nix` y se adapta dinámicamente según el hostname.

## 📋 Tabla de contenidos

- [Estructura del proyecto](#estructura-del-proyecto)
- [Requisitos](REQUISITES.md)
- [Instalación](#instalación)
- [Uso básico](#uso-básico)
- [Cambiar hostname](#cambiar-hostname)
- [Agregar nuevo hostname](#agregar-nuevo-hostname)
- [Agregar módulos](#agregar-módulos)
- [Personalización](#personalización)

## 🏗️ Estructura del proyecto

```text
.
├── flake.nix                          # Punto de entrada principal (define hostname aquí)
├── hosts/
│   └── server/                        # Configuración específica del hostname "server"
│       ├── configuration.nix          # Configuración del sistema NixOS
│       └── hardware-configuration.nix # Configuración de hardware
│   └── other/                         # Configuración específica del hostname "other"
├── home/
│   ├── default.nix                    # Módulos comunes (importado por todos)
│   ├── server.nix                     # Módulos específicos del hostname "server"
│   ├── other.nix                      # Módulos específicos del hostname "other"
│   ├── common/                        # Módulos comunes reutilizables
│   │   ├── base.nix                   # Configuración base
│   │   ├── users.nix                  # Definición de usuarios
│   │   ├── locale.nix                 # Idioma y zona horaria
│   │   └── networking.nix             # Configuración de red
│   └── modules/                       # Módulos específicos (git, shell, mise, k3s, etc.)
│       ├── git.nix
│       ├── ...
```

## 🚀 Instalación

### En NixOS

1. **Clona el repositorio en `/etc/nixos`:**

   ```bash
   sudo git clone <tu-repo> /etc/nixos
   cd /etc/nixos
   ```

2. **Actualiza tu hostname en `flake.nix`** (si es diferente a "server"):

   ```nix
   hostname = "tu-hostname";
   ```

3. **Aplica la configuración:**

   ```bash
   sudo nixos-rebuild switch --flake .#tu-hostname
   ```

### En Arch Linux con nix standalone

1. **Instala nix (si no lo tienes):**

   ```bash
   curl -L https://nixos.org/nix/install | sh
   ```

2. **Clona el repositorio:**

   ```bash
   git clone <tu-repo> ~/nix-config
   cd ~/nix-config
   ```

3. **Actualiza tu hostname y el resto de variables en `USER CONFIGURATION` en `flake.nix`:**

   ```nix
   hostname = "tu-hostname";
   ...
   primaryUser = "tu-user";
   gitUserName = "git-username";
   gitUserEmail = "git-email";
   gitHubUser = "github-username";
   ```

4. **Aplica la configuración de Home Manager:**

   ```bash
   nix flake update
   home-manager switch --flake .#tu-hostname
   ```

## 💡 Uso básico

### Ver la configuración actual

```bash
# En NixOS
sudo nixos-rebuild dry-run --flake .#tu-hostname

# En Arch con nix
home-manager build --flake .#tu-hostname
```

### Aplicar cambios

```bash
# En NixOS (requiere sudo)
sudo nixos-rebuild switch --flake .#tu-hostname

# En Arch con nix (sin sudo)
home-manager switch --flake .#tu-hostname
```

### Revertir a la generación anterior

```bash
# En NixOS
sudo nixos-rebuild switch --rollback

# En Arch con nix
home-manager switch --rollback
```

## 🔄 Cambiar hostname

El hostname es la **variable central** que controla toda la configuración. Para cambiar el hostname:

1. **Edita `flake.nix`:**

   ```nix
   # Línea 2 aproximadamente
   hostname = "nuevo-hostname";  # Cambiar aquí
   ```

2. **Asegúrate de que exista el directorio:**

   ```bash
   # Debe existir: hosts/nuevo-hostname/
   # Debe existir: home/nuevo-hostname.nix
   ```

3. **Aplica los cambios:**

   ```bash
   # En NixOS
   sudo nixos-rebuild switch --flake .#nuevo-hostname

   # En Arch con nix
   home-manager switch --flake .#nuevo-hostname
   ```

## ➕ Agregar nuevo hostname

Para crear una nueva configuración para un hostname diferente:

### 1. Crea la estructura de directorios

```bash
# Crear directorio del host
mkdir -p hosts/laptop

# Crear archivo de configuración del hostname
touch home/laptop.nix
```

### 2. Copia la configuración base

```bash
# Copiar configuración de hardware y sistema
cp hosts/server/configuration.nix hosts/laptop/configuration.nix
cp hosts/server/hardware-configuration.nix hosts/laptop/hardware-configuration.nix
```

### 3. Crea `home/laptop.nix`

```nix
# home/laptop.nix
{ config, pkgs, ... }:

{
  # Importar módulos comunes
  imports = [
    ./default.nix
    # Importar solo los módulos específicos para laptop
    ./modules/git.nix
    ./modules/shell.nix
  ];

  # Configuración específica del laptop
  home.username = "usuario";
  home.homeDirectory = "/home/usuario";
}
