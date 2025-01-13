# GUI 부분 /optiongui 인게임 커맨드로 옵션 토글 메뉴 오픈
# 초기 실행시 각 옵션은 비활성화 상태입니다.

option_menu_command:
    type: command
    name: optiongui
    description: 메인메뉴
    usage: /optiongui
    debug: false
    script:
    - inventory open d:main_gui_inventory

main_gui_toggle_task:
    type: task
    definitions: option|player
    debug: false
    script:
    - define enabled <server.flag[text_enabled]>
    - define disabled <server.flag[text_disabled]>
    - if <server.flag[<[option]>]> == <[disabled]>:
        - flag server <[option]>:<[enabled]>
    - else:
        - flag server <[option]>:<[disabled]>
    - playsound <[player]> sound:ENTITY_EXPERIENCE_ORB_PICKUP pitch:1

main_gui_inventory:
    type: inventory
    inventory: CHEST
    title: 월드 옵션 토글
    size: 54
    gui: true
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [main_gui_item_damage_share] [] [main_gui_item_inventory_share] [] [main_gui_item_random_damage] [] [main_gui_item_mob_downscale] []
    - [] [main_gui_item_mob_speedup] [] [main_gui_item_weakness] [] [main_gui_item_chain] [] [main_gui_item_one_inventory] []
    - [] [main_gui_item_block_mob] [] [main_gui_item_invisible_mob] [] [main_gui_item_hpshow] [] [main_gui_item_random_pickup] []
    - [] [main_gui_item_jump_share] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []

main_gui_world:
    type: world
    debug: true
    events:
        on player clicks in main_gui_inventory:
        - choose <context.item.script.name>:
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
            - case main_gui_item_block_mob:
                - define item block_mob
            - case main_gui_item_invisible_mob:
                - define item invisible_mob
            - case main_gui_item_hpshow:
                - define item tablist_hp_show
            - case main_gui_item_random_pickup:
                - define item random_pickup
            - case main_gui_item_jump_share:
                - define item jump_share
        - run main_gui_toggle_task def.option:<[item]> def.player:<player>
        - inventory open d:main_gui_inventory


main_gui_item_hpshow:
    type: item
    material: golden_apple
    display name: <&a>탭 리스트 HP 표시
    lore:
    - <&f>
    - <&f> - <&7>탭 리스트 HP 표시 여부를 결정합니다.
    - <&f> - <&7>현재 상태: <&f><server.flag[tablist_hp_show]>
    - <&f>

main_gui_item_invisible_mob:
    type: item
    material: potion
    display name: <&b>몹 투명화
    lore:
    - <&f>
    - <&f> - <&7>몹 투명화
    - <&f> - <&7>현재 상태: <&f><server.flag[invisible_mob]>
    - <&f>