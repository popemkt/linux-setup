#!/bin/bash

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --theme) theme="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

if [ "$theme" == "dark" ]; then
    color_scheme="prefer-dark"
    theme_name="Fluent-red-Dark"
    cursor_theme="Fluent-dark-cursors"
elif [ "$theme" == "light" ]; then
    color_scheme="prefer-light"
    theme_name="Fluent-teal"
    cursor_theme="Fluent-cursors"
else
    echo "Invalid theme variant. Please specify 'dark' or 'light'."
    exit 1
fi

THEME_SOURCE_DIR="$HOME/.themes/$theme_name/gtk-4.0"
GTK_CONFIG_DIR="$HOME/.config/gtk-4.0"

dconf write /org/gnome/shell/extensions/user-theme/name "$theme_name"
gsettings set org.gnome.desktop.interface color-scheme "$color_scheme"
gsettings set org.gnome.desktop.interface cursor-theme "$cursor_theme"

# Relink fluent themes to gtk config dir
rm -f "${GTK_CONFIG_DIR}"/gtk.css
ln -sf "${THEME_SOURCE_DIR}/gtk-${theme}.css" "${GTK_CONFIG_DIR}/gtk.css"
