init_prefix:
    type: world
    debug: false
    events:
        on scripts loaded:
        - flag server text_enabled:<&a>활성화됨
        - flag server text_disabled:<&c>비활성화됨
        - if !<server.has_flag[tablist_hp_show]>:
            - flag server tablist_hp_show:<&c>비활성화됨
        - if !<server.has_flag[invisible_mob]>:
            - flag server invisible_mob:<&c>비활성화됨

main_gui_item_hpshow:
    type: item
    material: golden_apple
    display name: <&a>탭 리스트 HP 표시
    lore:
    - <&f>
    - <&f> - <&7>탭 리스트에 HP를 표시합니다.
    - <&f> - <&e>주의: 재접속 시 반영됩니다.
    - <&f> - <&7>현재 상태: <server.flag[tablist_hp_show]>
    - <&f>

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
    debug: false
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