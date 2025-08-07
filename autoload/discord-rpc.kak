# This is free and unencumbered software released into the public domain.

# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.

# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

provide-module discord-rpc %~
    ## begin public options
    declare-option bool discord_rpc_autostart true
    declare-option str discord_rpc_description "i just be writing text and editing it"
    declare-option str discord_rpc_image_description "i just be editing text!!!"
    ## end public options

    define-command -docstring %{
        Begins a discord-rpc-cli process if none exists.
    } start-discord-rpc %{
        nop %sh{
            # only one process should exist globally
            lock="/tmp/kak-discord"
            if [ ! -f "$lock" ]; then
                # spawn in detached session
                {
                discord-rpc-cli -c '1397337509393989713' -N kak \
                    -d "$kak_opt_discord_rpc_description" \
                    -I "$kak_opt_discord_rpc_image_description"
                } >/dev/null 2>&1 </dev/null &
                # save the pid for killing later
                pid="$!"
                echo "$pid">"$lock"
            fi
        }
    }
    define-command -docstring %{
        Stop the discord-rpc-cli process if it exists.
    } stop-discord-rpc %{
        nop %sh{
            # only one process globally
            lock="/tmp/kak-discord"
            # if it exists, kill it
            if [ -f "$lock" ]; then
                kill "$(cat "$lock")"
                rm "$lock"
            fi
        }
    }
    define-command -docstring %{
        Restart the discord-rpc-cli process.
    } restart-discord-rpc %{
        stop-discord-rpc
        start-discord-rpc
        }
    hook -once global KakBegin .* %{
        evaluate-commands %sh{
            if [ "$kak_opt_discord_rpc_autostart" = "true" ]; then
                echo "start-discord-rpc"
            fi
        }
    }
    hook -once -always global KakEnd .* %{
        evaluate-commands %sh{
            # kill if this is the last kak session
            count="$(kak -l | grep -v '(dead)' | wc -l)"
            if [ ${count} -le 1 ]; then
                echo "stop-discord-rpc"
            fi
        }
    }
~
