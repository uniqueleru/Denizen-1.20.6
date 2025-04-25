# Script written by 어라랍(https://github.com/KDY05)

random_item_init:
    type: world
    debug: false
    events:
        on scripts loaded:
        - if !<server.has_flag[random_item]>:
            - flag server random_item:<&c>비활성화됨
        - flag server random_item_running:false

main_gui_item_random_item:
    type: item
    material: command_block
    display name: <&5>랜덤 아이템 지급
    lore:
    - <&f>
    - <&f> - <&7>일정 시간마다 랜덤 아이템이 지급됩니다.
    - <&f> - <&7>현재 상태: <server.flag[random_item]>
    - <&f>

random_item_toggle_task:
    type: task
    definitions: toggle
    debug: false
    script:
    - if <[toggle]> == on:
        - if !<server.flag[random_item_running]>:
            - run random_item_periodic_task

random_item_task:
    type: task
    definitions: player
    debug: false
    script:
    - define material <server.material_types.random>
    - while !<[material].is_item>:
        - define material <server.material_types.random>
    - give <[material].item> to:<[player].inventory>

random_item_periodic_task:
    type: task
    debug: false
    script:
    - flag server random_item_running:true
    - wait 5t
    - bossbar random_item players:<server.online_players> "title:<&c>랜덤 아이템 타이머" progress:0.0 color:white style:solid
    - while <server.flag[random_item]> == <server.flag[text_enabled]>:
        - repeat 140 as:time:
                - wait 1t
                - bossbar update random_item progress:<[time].div[140]>
                - if <server.flag[random_item]> == <server.flag[text_disabled]>:
                    - while stop
        - foreach <server.online_players> as:player:
            - run random_item_task def.player:<[player]>
    - bossbar remove random_item
    - flag server random_item_running:false
