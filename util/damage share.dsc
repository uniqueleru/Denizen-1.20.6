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