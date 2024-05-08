dmgshare_world:
    type: world
    events:
        on player dies:
        - flag <context.entity> death_count:+:1
        after player damaged:
        - if <server.flag[share_damage]> == <&c>비활성화됨:
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

dmgshare_reset_static:
    type: command
    name: resetdamage
    description: 데미지 통게 초기화
    usage: /resetdamage
    script:
    - foreach <server.players> as:target:
        - flag <[target]> damage_count:0
        - flag <[target]> death_count:0
    - foreach <server.online_players> as:target:
        - run dmgshare_update_sidebar def.player:<[target]>

dmgshare_update_sidebar:
    type: task
    definitions: player
    script:
    - sidebar remove players:<[player]>
    #- sidebar set title:<&6>통계 players:<[player]>
    #- sidebar add values:<&f> players:<[player]>
    #- foreach <server.online_players> as:target:
    #    - sidebar add "values:<&6>• <&f><[target].flag[tabname]> <&8>- <&f>받은 데미지: <&e><[target].flag[damage_count].round> <&f>죽음: <&c><[target].flag[death_count]>" players:<[player]>
    #- sidebar add values:<&f> players:<[player]>