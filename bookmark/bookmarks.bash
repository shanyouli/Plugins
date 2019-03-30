#!/usr/bin/env bash

# 在 shell 中快速跳转到常用目录

[[ -z $MARKPATH ]] && export MARKPATH=~/.cache/bash/bookmark

_mark_find_file() { find "$MARKPATH" -type l -exec ls -l {} \; ; }

_exist_fzf_peco_percol() {
    local cmd=(fzf
               peco
               percol)
    local i

    for i in "${cmd[@]}" ; do
        if command -v "$i" >/dev/null; then
            echo "$i"
            return
        fi
    done
}

mark() {
    local marksname # Existing bookmarks
    local dir_name # Prepare a global path as a bookmark
    local current_name # bookmarks name
    local exist_name # Existing bookmarks name

     [[ -d "$MARKPATH" ]] || mkdir -p "$MARKPATH"

     marksname=$(_mark_find_file | sed 's/  / /g' | cut -d' ' -f11)
    for markname in $marksname ; do
        [[ "$PWD" == "$markname" ]] && {
            printf "[%s] has been set as a bookmark!!!\n" "$PWD"
            return 1
        }
    done

    if [[ -z "$1" ]]; then
        dir_name=$(pwd)
        current_name=${dir_name##*/}
        [[ $current_name = \.* ]] && current_name=${current_name#.}
    else
        current_name="$1"
    fi

    for exist_name in "$MARKPATH"/* ; do
        [[ -e "$exist_name" ]] || break
        exist_name=${exist_name##*/}
        [[ "$exist_name" == "$current_name" ]] && {
            echo -n "Bookmark [$current_name] already exists! Peplace it? "
            while read -r replace; do
                if [[ $replace = "y" ]]; then
                    # Delete existing bookmark
                    rm -rf "${MARKPATH:?}/$exist_name"
                    break
                else
                    echo "Please enter other name!"
                    return 1
                fi
            done
        }
    done

    ln -s "$(pwd)" "$MARKPATH/$current_name"
}

_bookmark_jump_exist_fzf() {
    local jump_pwd
    jump_pwd=$(find "$MARKPATH" -type l | eval "$(_exist_fzf_peco_percol)")

    [[ -n "$jump_pwd" ]] && {
        cd -P "$jump_pwd" || return 1
    }
}

jump() {
    if [[  -z $(_exist_fzf_peco_percol) ]]; then
        [[ -n "$1" ]] && {
            cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
        }
    else
        _bookmark_jump_exist_fzf
    fi
}

unmark() {
    if [[ -d $MARKPATH ]]; then
        rm -i "$MARKPATH/$1"
    else
        echo "Not created $MARKPATH, Please add a bookmark first!"
        echo
        echo "Enter mark!"
    fi
}

marks() {
    [[ ! -d $MARKPATH ]] && {
        echo "Not created $MARKPATH, Please add a bookmark first!"
        echo
        echo "Enter mark!"
        return 1
    }
    if [[ -z "$1" ]]; then
        _mark_find_file | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
    else
        _mark_find_file | cut -d' ' -f9-  | grep "$1" && echo
    fi
}
