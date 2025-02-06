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
    display name: <&2>인벤토리 한 칸
    lore:
    - <&f>
    - <&f> - <&7>인벤토리가 한 칸이 됩니다.
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
        - narrate "<&7>그건 상우의 영혼이 깃들어 버릴 수 없는 물건이다"
        - determine cancelled
        on player clicks empty_slot in inventory:
        - if <server.flag[one_inventory]> == <server.flag[text_disabled]>:
            - stop
        - determine cancelled
        on player clicks in inventory:
        - if <server.flag[one_inventory]> == <server.flag[text_disabled]>:
            - stop
        - if ( <context.inventory> == <player.inventory> && ( <context.raw_slot> == 46 ) ):
            - determine cancelled
        on player drags empty_slot in inventory:
        - if <server.flag[one_inventory]> == <server.flag[text_disabled]>:
            - stop
        - determine cancelled
        on player places empty_slot:
        - if <server.flag[one_inventory]> == <server.flag[text_disabled]>:
            - stop
        - narrate "<&7>너무나 당연하게도 이건 설치할 수 없다"
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
    debug: false
    script:
    - repeat 36 as:count:
        - if <[count]> != 5:
            - define saved <[target].inventory.slot[<[count]>]>
            - drop <[saved]> <[target].location>
            - inventory set d:<[target].inventory> slot:<[count]> o:empty_slot
    - drop <[target].item_in_offhand||null> <[target].location>
    - adjust <[target]> item_in_offhand:air

empty_slot:
    type: item
    material: light_gray_stained_glass_pane
    display name: ' '