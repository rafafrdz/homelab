{ pkgs, lib, ... }:
{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    mouse = true;
    keyMode = "vi";
    historyLimit = 20000;
    prefix = "M-a";

    extraConfig = ''
        ### Prefijo personalizado: Alt-a
        unbind C-b
        set-option -g prefix M-a
        bind-key M-a send-prefix

        ### Tiempo de escape más rápido
        set-option -s escape-time 0

        ### Activar mouse (clic, redimensionar, scroll)
        set -g mouse on

        ### Estilo de navegación vi
        set-option -g status-keys vi
        set-option -g mode-keys vi

        ### Estilo de la barra de estado
        set-option -g status-style bg=black,fg=green
        setw -g window-status-current-style bg=green,fg=black

        ### Recargar configuración con Alt-a + r
        bind r source-file ~/.tmux.conf \; display-message "¡Configuración recargada!"

        ### Dividir paneles
        bind + split-window -h    # Alt-a + + → dividir verticalmente (lado a lado)
        bind - split-window -v    # Alt-a + - → dividir horizontalmente (una encima de otra)

        ### Cerrar panel sin confirmación
        bind * kill-pane

        ### Navegar entre paneles con Alt + flechas
        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D

        ### Cambiar entre ventanas con Alt-n / Alt-p
        bind-key -n M-n next-window
        bind-key -n M-p previous-window

        ### Copiar texto al portapapeles del sistema (Wayland)
        bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "wl-copy"

        ### Comando por defecto (usa tu shell actual)
        set-option -g default-command "${SHELL}"

        # Linux fallback (wl-copy if available, else xclip)
        bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "wl-copy || xclip -selection clipboard"
    ''
    );
  };
}
