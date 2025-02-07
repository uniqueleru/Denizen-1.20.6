# util 부분은 다음의 양식에 맞추어 정렬되어 있습니다.
# 플래그 초기화 - GUI 아이콘 - command - world - task - 기타
# 가독성 및 호환성을 위해 각 컨테이너 이름은 해당 파일명으로 시작합니다.

util_init:
    type: world
    debug: false
    events:
        on scripts loaded:
        - flag server text_enabled:<&a>활성화됨
        - flag server text_disabled:<&c>비활성화됨
        - if !<server.has_flag[tablist_hp_show]>:
            - flag server tablist_hp_show:<&c>비활성화됨
        - if !<server.has_flag[keybind]>:
            - flag server keybind:false

main_gui_item_hpshow:
    type: item
    material: golden_apple
    display name: <&a>탭 리스트 HP 표시
    lore:
    - <&f>
    - <&f> - <&7>탭 리스트에 HP를 표시합니다.
    - <&f> - <&7>현재 상태: <server.flag[tablist_hp_show]>
    - <&f>

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
    - if <server.flag[tablist_hp_show]> == <server.flag[text_enabled]>:
        - adjust <[player]> "player_list_name:<[player].flag[tabname]> <[colorcode]>[ <[health]> ]"
    - else:
        - adjust <[player]> player_list_name:<[player].flag[tabname]>

util_empty_slot:
    type: item
    material: light_gray_stained_glass_pane
    display name: ' '