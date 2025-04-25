# GUI 부분 /optiongui 인게임 커맨드로 옵션 토글 메뉴 오픈
# 초기 실행시 각 옵션은 비활성화 상태입니다.

main_gui_command:
    type: command
    name: optiongui
    description: 메인메뉴
    usage: /optiongui
    debug: false
    script:
    - if !<player.is_op>:
        - narrate "<&e>운영자 권한이 필요합니다."
        - stop
    - inventory open d:main_gui_inventory_1

main_gui_toggle_task:
    type: task
    definitions: option|player
    debug: false
    script:
    - define enabled <server.flag[text_enabled]>
    - define disabled <server.flag[text_disabled]>
    - if <server.flag[<[option]>]> == <[disabled]>:
        - flag server <[option]>:<[enabled]>
        - run <[option]>_toggle_task def.toggle:on
    - else:
        - flag server <[option]>:<[disabled]>
        - run <[option]>_toggle_task def.toggle:off
    - playsound <[player]> sound:ENTITY_EXPERIENCE_ORB_PICKUP pitch:1

main_gui_inventory_1:
    type: inventory
    inventory: CHEST
    title: 월드 옵션 토글
    size: 54
    gui: true
    definitions:
        bar: main_gui_bar
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [main_gui_item_damage_share] [] [main_gui_item_inventory_share] [] [main_gui_item_random_damage] [] [main_gui_item_mob_downscale] []
    - [] [main_gui_item_mob_speedup] [] [main_gui_item_weakness] [] [main_gui_item_chain] [] [main_gui_item_one_inventory] []
    - [] [main_gui_item_mob_spawnlimit] [] [main_gui_item_fast_tick] [] [main_gui_item_block_mob] [] [main_gui_item_invisible_mob] []
    - [] [] [] [] [] [] [] [] []
    - [bar] [bar] [bar] [bar] [main_gui_page_1] [bar] [bar] [bar] [bar]

main_gui_inventory_2:
    type: inventory
    inventory: CHEST
    title: 월드 옵션 토글
    size: 54
    gui: true
    definitions:
        bar: main_gui_bar
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [main_gui_item_random_jump] [] [main_gui_item_zombie] [] [main_gui_item_jump_share] [] [main_gui_item_random_pickup] []
    - [] [main_gui_item_hpshow] [] [main_gui_item_random_item] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [bar] [bar] [bar] [bar] [main_gui_page_2] [bar] [bar] [bar] [bar]

main_gui_world:
    type: world
    debug: false
    events:
        on player clicks in main_gui_inventory_1:
        - define item null
        - choose <context.item.script.name||null>:
            - case main_gui_item_damage_share:
                - define item damage_share
            - case main_gui_item_inventory_share:
                - define item inventory_share
            - case main_gui_item_random_damage:
                - define item random_damage
            - case main_gui_item_mob_downscale:
                - define item mob_downscale
            - case main_gui_item_mob_speedup:
                - define item mob_speedup
            - case main_gui_item_weakness:
                - define item weakness
            - case main_gui_item_chain:
                - define item chain
            - case main_gui_item_one_inventory:
                - define item one_inventory
            - case main_gui_item_mob_spawnlimit:
                - define item mob_spawnlimit
            - case main_gui_item_fast_tick:
                - define item fast_tick
            - case main_gui_item_block_mob:
                - define item block_mob
            - case main_gui_item_invisible_mob:
                - define item invisible_mob

            - case main_gui_page_1:
                - inventory open d:main_gui_inventory_2

        - if <[item]> != null:
            - run main_gui_toggle_task def.option:<[item]> def.player:<player>
            - inventory open d:main_gui_inventory_1

        on player clicks in main_gui_inventory_2:
        - define item null
        - choose <context.item.script.name||null>:
            - case main_gui_item_random_jump:
                - define item random_jump
            - case main_gui_item_zombie:
                - define item zombie
            - case main_gui_item_random_pickup:
                - define item random_pickup
            - case main_gui_item_jump_share:
                - define item jump_share
            - case main_gui_item_hpshow:
                - define item hpshow
            - case main_gui_item_random_item:
                - define item random_item

            - case main_gui_page_2:
                - inventory open d:main_gui_inventory_1

        - if <[item]> != null:
            - run main_gui_toggle_task def.option:<[item]> def.player:<player>
            - inventory open d:main_gui_inventory_2

main_gui_page_1:
    type: item
    material: arrow
    display name: 페이지 [1/2]

main_gui_page_2:
    type: item
    material: arrow
    display name: 페이지 [2/2]

main_gui_bar:
    type: item
    material: gray_stained_glass_pane
    display name: ' '