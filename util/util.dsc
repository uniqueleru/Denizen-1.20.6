init_prefix:
    type: world
    debug: false
    events:
        on scripts loaded:
        - flag server text_enabled:<&a>활성화됨
        - flag server text_disabled:<&c>비활성화됨
        - if !<server.has_flag[tablist_hp_show]>:
            - flag server tablist_hp_show:<server.flag[text_disabled]>
        - if !<server.has_flag[invisible_mob]>:
            - flag server invisible_mob:<server.flag[text_disabled]>

command_edit_name:
    type: command
    name: displayname
    description: 이름 변경
    usage: /displayname change|reset player name
    aliases:
    - dname
    tab completions:
        1: change|reset
        2: <server.online_players.parse[name]>
    script:
    - choose <context.args.first>:
        - case change:
            - define playerName <context.args.get[2]>
            - define player <server.match_player[<[playerName]>]>
            - define dname <context.args.get[3]>
            - flag <[player]> tabname:<[dname]>
        - case reset:
            - define playerName <context.args.get[2]>
            - define player <server.match_player[<[playerName]>]>
            - flag <[player]> tabname:<[player].name>

tablist_world:
    type: world
    debug: false
    events:
        on player joins:
        - run tablist_update_task def.player:<player> def.health:<player.health.round> delay:1t
        on player damaged:
        - define player <context.entity>
        - run tablist_update_task def.player:<[player]> def.health:<[player].health.round> delay:1t
        on player respawns:
        - run tablist_update_task def.player:<player> def.health:<player.health.round> delay:1t
        on player heals:
        - define player <context.entity>
        - run tablist_update_task def.player:<[player]> def.health:<[player].health.round> delay:1t

tablist_update_task:
    type: task
    definitions: player|health
    debug: false
    script:
    - define colorcode <&f>
    - if <[health]> >= 15:
        - define colorcode <&a>
    - else if <[health]> >= 5:
        - define colorcode <&e>
    - else:
        - define colorcode <&c>
    - if <server.flag[tablist_hp_show]> == <server.flag[text_enabled]>:
        - adjust <[player]> "player_list_name:<[player].flag[tabname]> <[colorcode]>[ <[health]> ]"
    - else:
        - adjust <[player]> player_list_name:<[player].flag[tabname]>

join_event:
    type: world
    debug: false
    events:
        on player joins:
        - if !<player.has_flag[tabname]>:
            - flag <player> tabname:<player.name>