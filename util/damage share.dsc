damage_share_init:
    type: world
    debug: false
    events:
        on scripts loaded:
        - if !<server.has_flag[damage_share]>:
            - flag server damage_share:<&c>비활성화됨

main_gui_item_damage_share:
    type: item
    material: iron_sword
    display name: <&c>데미지 공유
    lore:
    - <&f>
    - <&f> - <&7>플레이어 간 데미지가 공유됩니다.
    - <&f> - <&7>현재 상태: <server.flag[damage_share]>
    - <&f>

damage_share_world:
    type: world
    debug: false
    events:
        on player dies:
        - if <server.flag[damage_share]> == <server.flag[text_disabled]>:
            - stop
        - flag <context.entity> death_count:+:1

        after player damaged:
        - if <server.flag[damage_share]> == <server.flag[text_disabled]>:
            - stop
        - define victim <context.entity>
        - define cause <context.cause>
        - define damage <context.damage>
        - if <[cause]> != CUSTOM:
            - flag <[victim]> damage_count:+:<[damage]>
            - actionbar "<&f>누군가가 <&c>데미지를 <&7>입고 있습니다!" targets:<server.online_players>
            - foreach <server.online_players> as:target:
                - if <[victim]> == <[target]>:
                    - foreach next
                - else:
                    - hurt <[damage]> <[target]> cause:CUSTOM

damage_share_reset_static:
    type: command
    name: resetdamage
    description: 데미지 통계 초기화
    usage: /resetdamage
    debug: false
    script:
    - foreach <server.players> as:target:
        - flag <[target]> damage_count:0
        - flag <[target]> death_count:0
    - foreach <server.online_players> as:target:
        - run damage_share_update_sidebar def.player:<[target]>

damage_share_update_sidebar:
    type: task
    definitions: player
    debug: false
    script:
    - sidebar remove players:<[player]>
    #- sidebar set title:<&6>통계 players:<[player]>
    #- sidebar add values:<&f> players:<[player]>
    #- foreach <server.online_players> as:target:
    #    - sidebar add "values:<&6>• <&f><[target].flag[tabname]> <&8>- <&f>받은 데미지: <&e><[target].flag[damage_count].round> <&f>죽음: <&c><[target].flag[death_count]>" players:<[player]>
    #- sidebar add values:<&f> players:<[player]>