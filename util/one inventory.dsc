one_inventory_init:
    type: world
    debug: false
    events:
        on scripts loaded:
        - if !<server.has_flag[one_inventory]>:
            - flag server one_inventory:<&c>비활성화됨

main_gui_item_one_inventory:
    type: item
    material: chest
    display name: <&c>인벤토리 한칸
    lore:
    - <&f>
    - <&f> - <&7>인벤토리가 한칸이 됩니다.
    - <&f> - <&7>현재 상태: <server.flag[one_inventory]>
    - <&f>

one_inventory_world:
    type: world
    debug: false
    events:
        on player dies:
        - if <server.flag[one_inventory]> == <server.flag[text_disabled]>:
            - stop
        - define saved <player.inventory.slot[5]>
        - drop <[saved]> <player.location>
        - foreach <player.equipment> as:equip:
            - drop <[equip]> <player.location>
        - determine NO_DROPS
        after player dies:
        - if <server.flag[one_inventory]> == <server.flag[text_disabled]>:
            - stop
        - run fill_slot_task def.target:<player>
        on player swaps items:
        - if <server.flag[one_inventory]> == <server.flag[text_disabled]>:
            - stop
        - determine cancelled
        on player drops empty_slot:
        - if <server.flag[one_inventory]> == <server.flag[text_disabled]>:
            - stop
        - determine cancelled
        on player clicks empty_slot in inventory:
        - if <server.flag[one_inventory]> == <server.flag[text_disabled]>:
            - stop
        - determine cancelled
        on player drags empty_slot in inventory:
        - if <server.flag[one_inventory]> == <server.flag[text_disabled]>:
            - stop
        - determine cancelled
        on player places empty_slot:
        - if <server.flag[one_inventory]> == <server.flag[text_disabled]>:
            - stop
        - determine cancelled

one_inventory_toggle_task:
    type: task
    definitions: toggle
    debug: false
    script:
    - if <[toggle]> == on:
        - foreach <server.online_players> as:players:
                - run fill_slot_task def.target:<[players]>
    - else if <[toggle]> == off:
        - foreach <server.online_players> as:players:
                - repeat 36 as:count:
                    - if <[count]> != 5:
                        - inventory set d:<[players].inventory> slot:<[count]> o:air

fill_slot_task:
    type: task
    definitions: target
    script:
    - repeat 36 as:count:
        - if <[count]> != 5:
            - define saved <[target].inventory.slot[<[count]>]>
            - drop <[saved]> <[target].location>
            - inventory set d:<[target].inventory> slot:<[count]> o:empty_slot
    - drop <[target].item_in_offhand> <[target].location>
    - adjust <[target]> item_in_offhand:air

empty_slot:
    type: item
    material: light_gray_stained_glass_pane
    display name: ' '