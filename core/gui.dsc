option_menu_command:
    type: command
    name: optiongui
    description: 메인메뉴
    usage: /optiongui
    script:
    - inventory open d:main_gui_inventory

main_gui_world:
    type: world
    events:
        on player clicks in main_gui_inventory:
        - if <context.item> == <item[main_gui_item_share_damage]>:
            - run main_gui_toggle_task def.option:share_damage def.player:<player>
        - if <context.item> == <item[main_gui_item_hpshow]>:
            - run main_gui_toggle_task def.option:tablist_hp_show def.player:<player>
        - if <context.item> == <item[main_gui_item_share_inventory]>:
            - run main_gui_toggle_task def.option:share_inventory def.player:<player>
        - if <context.item> == <item[main_gui_item_random_pickup]>:
            - run main_gui_toggle_task def.option:random_pickup def.player:<player>
        - if <context.item> == <item[main_gui_item_jump_share]>:
            - run main_gui_toggle_task def.option:jump_share def.player:<player>
        - if <context.item> == <item[main_gui_item_random_damage]>:
            - run main_gui_toggle_task def.option:random_damage def.player:<player>
        - if <context.item> == <item[main_gui_item_mob_downscale]>:
            - run main_gui_toggle_task def.option:mob_downscale def.player:<player>
        - inventory open d:main_gui_inventory

main_gui_toggle_task:
    type: task
    definitions: option|player
    script:
    - define enabled <server.flag[text_enabled]>
    - define disabled <server.flag[text_disabled]>
    - playsound <[player]> sound:ENTITY_EXPERIENCE_ORB_PICKUP pitch:1
    - if !<server.has_flag[<[option]>]>:
        - flag server <[option]>:<[disabled]>
    - else:
        - if <server.flag[<[option]>]> == <[disabled]>:
            - flag server <[option]>:<[enabled]>
        - else:
            - flag server <[option]>:<[disabled]>

main_gui_inventory:
    type: inventory
    inventory: CHEST
    title: 월드 옵션 토글
    size: 45
    gui: true
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [main_gui_item_share_damage] [] [main_gui_item_hpshow] [] [main_gui_item_share_inventory] [] [main_gui_item_random_pickup] []
    - [] [] [] [] [] [] [] [] []
    - [] [main_gui_item_jump_share] [] [main_gui_item_random_damage] [] [main_gui_item_mob_downscale] [] [] []
    - [] [] [] [] [] [] [] [] []

main_gui_item_share_damage:
    type: item
    material: iron_sword
    display name: <&c>데미지 공유
    lore:
    - <&f>
    - <&f> - <&7>플레이어간 데미지 공유 여부를 결정합니다.
    - <&f> - <&7>현재 상태: <&f><server.flag[share_damage]>
    - <&f>

main_gui_item_hpshow:
    type: item
    material: golden_apple
    display name: <&a>탭 리스트 HP 표시
    lore:
    - <&f>
    - <&f> - <&7>탭 리스트 HP 표시 여부를 결정합니다.
    - <&f> - <&7>현재 상태: <&f><server.flag[tablist_hp_show]>
    - <&f>

main_gui_item_share_inventory:
    type: item
    material: chest
    display name: <&e>인벤토리 공유
    lore:
    - <&f>
    - <&f> - <&7>플레이어간 인벤토리 여부를 결정합니다.
    - <&f> - <&7>현재 상태: <&f><server.flag[share_inventory]>
    - <&f>

main_gui_item_random_pickup:
    type: item
    material: diamond
    display name: <&6>아이템 랜덤 줍기
    lore:
    - <&f>
    - <&f> - <&7>아이템 랜덤 줍기 여부를 결정합니다.
    - <&f> - <&7>현재 상태: <&f><server.flag[random_pickup]>
    - <&f>

main_gui_item_jump_share:
    type: item
    material: slime_block
    display name: <&3>점프 공유
    lore:
    - <&f>
    - <&f> - <&7>점프 공유 여부를 결정합니다.
    - <&f> - <&7>현재 상태: <&f><server.flag[jump_share]>
    - <&f>

main_gui_item_random_damage:
    type: item
    material: diamond_sword
    display name: <&5>랜덤 데미지
    lore:
    - <&f>
    - <&f> - <&7>랜덤 데미지 여부를 결정합니다.
    - <&f> - <&7>현재 상태: <&f><server.flag[random_damage]>
    - <&f>

main_gui_item_mob_downscale:
    type: item
    material: slime_ball
    display name: <&b>몹 소형화
    lore:
    - <&f>
    - <&f> - <&7>몬스터의 소형화 여부를 결정합니다
    - <&f> - <&7>현재 상태: <&f><server.flag[mob_downscale]>
    - <&f>