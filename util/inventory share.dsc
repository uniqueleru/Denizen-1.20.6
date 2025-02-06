inventory_share_init:
    type: world
    debug: false
    events:
        on scripts loaded:
        - if !<server.has_flag[inventory_share]>:
            - flag server inventory_share:<&c>비활성화됨

main_gui_item_inventory_share:
    type: item
    material: ender_chest
    display name: <&e>인벤토리 공유
    lore:
    - <&f>
    - <&f> - <&7>플레이어 간 인벤토리를 공유합니다.
    - <&f> - <&7>현재 상태: <server.flag[inventory_share]>
    - <&f>

inventory_share_world:
    type: world
    debug: false
    events:
        after player picks up item:
        - run inventory_share_copy def.origin:<player>
        after player clicks in inventory:
        - run inventory_share_copy def.origin:<player>
        after player drops item:
        - run inventory_share_copy def.origin:<player>
        after player dies:
        - run inventory_share_clear def.origin:<player>


inventory_share_clear:
    type: task
    definitions: origin
    debug: false
    script:
    - if <server.flag[inventory_share]> == <server.flag[text_disabled]>:
        - stop
    - foreach <server.online_players> as:target:
        - if <[origin]> == <[target]>:
            - foreach next
        - else:
            - repeat 27 as:count:
                - define slot <[count]>
                - define slot:+:9
                - inventory set d:<[target].inventory> slot:<[slot]> o:air

inventory_share_copy:
    type: task
    definitions: origin
    debug: false
    script:
    - if <server.flag[inventory_share]> == <server.flag[text_disabled]>:
        - stop
    - foreach <server.online_players> as:target:
        - if <[origin]> == <[target]>:
            - foreach next
        - else:
            - repeat 27 as:count:
                - define slot <[count]>
                - define slot:+:9
                - inventory set d:<[target].inventory> slot:<[slot]> o:<[origin].inventory.slot[<[slot]>]>