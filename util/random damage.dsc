random_damage_init:
    type: world
    debug: false
    events:
        on scripts loaded:
        - if !<server.has_flag[random_damage]>:
            - flag server random_damage:<&c>비활성화됨

main_gui_item_random_damage:
    type: item
    material: diamond_sword
    display name: <&5>랜덤 대미지
    mechanisms:
        hides: ALL
    lore:
    - <&f>
    - <&f> - <&7>플레이어가 대미지를 랜덤한 값으로 받습니다.
    - <&f> - <&7>현재 상태: <server.flag[random_damage]>
    - <&f>

random_damage_world:
    type: world
    debug: false
    events:
        on player damaged:
        - if <server.flag[random_damage]> == <server.flag[text_disabled]>:
            - stop
        - define origin_damage <context.damage>
        - define random_num <util.random.decimal[1].to[30]>
        - define cause <context.cause>
        - if <[cause]> != CUSTOM:
            - determine passively <[random_num]>
            - actionbar "<&7>입은 피해: <&c><[random_num].round>" targets:<context.entity>

random_damage_toggle_task:
    type: task
    definitions: toggle
    debug: false
    script:
    - stop