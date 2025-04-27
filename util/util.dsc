# util.dsc는 공용 flag를 정의하며, 탭리스트 수정과 keybind와 같은 편의성 기능을 포함합니다.

util_init:
    type: world
    debug: false
    events:
        on scripts loaded:
        - flag server text_enabled:<&a>활성화됨
        - flag server text_disabled:<&c>비활성화됨
        - if !<server.has_flag[keybind]>:
            - flag server keybind:false

util_tablist_command:
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
    - if !<player.is_op>:
        - narrate "<&e>운영자 권한이 필요합니다."
        - stop
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
    - run util_tablist_update def.player:<[player]> def.health:<[player].health.round_up> delay:1t

util_tablist_world:
    type: world
    debug: false
    events:
        after player joins:
        - if !<player.has_flag[tabname]>:
            - flag <player> tabname:<player.name>
        - run util_tablist_update def.player:<player> def.health:<player.health.round_up> delay:1t
        after player damaged:
        - define player <context.entity>
        - run util_tablist_update def.player:<[player]> def.health:<[player].health.round_up> delay:1t
        after player respawns:
        - run util_tablist_update def.player:<player> def.health:<player.health.round_up> delay:1t
        after player heals:
        - define player <context.entity>
        - run util_tablist_update def.player:<[player]> def.health:<[player].health.round_up> delay:1t

util_tablist_update:
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
    - if <server.flag[hpshow]> == <server.flag[text_enabled]>:
        - adjust <[player]> "player_list_name:<[player].flag[tabname]> <[colorcode]>[ <[health]> ]"
    - else:
        - adjust <[player]> player_list_name:<[player].flag[tabname]>

util_keybind_command:
    type: command
    name: keybind
    description: Shift + F로 열기
    usage: /keybind
    debug: false
    script:
    - if !<player.is_op>:
        - narrate "<&e>운영자 권한이 필요합니다."
        - stop
    - if <server.flag[keybind]>:
        - flag server keybind:false
    - else:
        - flag server keybind:true

util_keybind_world:
    type: world
    debug: false
    events:
        on player swaps items:
        - if !<server.flag[keybind]>:
            - stop
        - if <player.is_sneaking>:
            - execute as_player optiongui
            - determine cancelled