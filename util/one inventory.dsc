fill_inventory:
    type: task
    definitions: origin
    script:
    - if <server.flag[one_inventory]> == <server.flag[text_disabled]>:
        - stop
    - repeat 36 as:count:
        - if <[count]> != 5:
            - inventory set d:<[origin].inventory> slot:<[count]> o:light_gray_stained_glass_pane

one_inventory_click_world:
    type: world
    events:
        on player places block:
        - if <server.flag[one_inventory]> == <server.flag[text_disabled]>:
            - stop
        - if <context.material.name> == light_gray_stained_glass_pane:
            - narrate "<&7>너무나 당연하게도 이건 설치할 수 없다"
            - determine cancelled
        on player death:
        - if <server.flag[one_inventory]> == <server.flag[text_disabled]>:
            - stop
        - foreach <context.entity.equipment> as:item:
            - drop <[item]> <context.entity.location>
        - drop <context.entity.inventory.slot[5]> <context.entity.location>
        on player drops item:
        - if <server.flag[one_inventory]> == <server.flag[text_disabled]>:
            - stop
        - if <context.item.material.name> == light_gray_stained_glass_pane:
            - narrate "<&7>그건 상우의 영혼이 깃들어 버릴 수 없는 물건이다"
            - determine cancelled
        after player respawns:
        - if <server.flag[one_inventory]> == <server.flag[text_disabled]>:
            - stop
        - inventory clear d:<context.player>
        - run fill_inventory def.origin:<context.player>
        on player clicks in inventory:
        - if <server.flag[one_inventory]> == <server.flag[text_disabled]>:
            - stop
        - run fill_inventory def.origin:<player>
        - if <context.raw_slot> >= 10 && <context.raw_slot> != 41:
            - determine cancelled
        on player swaps items:
        - if <server.flag[one_inventory]> == <server.flag[text_disabled]>:
            - stop
        - determine cancelled

