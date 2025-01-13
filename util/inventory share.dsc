inventory_share_init:
    type: world
    events:
        on scripts loaded:
        - if !<server.has_flag[inventory_share]>:
            - flag server inventory_share:<server.flag[text_disabled]>

main_gui_item_inventory_share:
    type: item
    material: chest
    display name: <&e>인벤토리 공유
    lore:
    - <&f>
    - <&f> - <&7>플레이어간 인벤토리를 공유합니다.
    - <&f> - <&7>현재 상태: <server.flag[inventory_share]>
    - <&f>

inventory_share_event_handler:
    type: world
    debug: false
    events:
        after player picks up item:
        - run copy_inventory_data def.origin:<player>
        after player clicks in inventory:
        - run copy_inventory_data def.origin:<player>
        after player drops item:
        - run copy_inventory_data def.origin:<player>
        after player dies:
        - run delete_inventory_on_death def.origin:<player>


delete_inventory_on_death:
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

copy_inventory_data:
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