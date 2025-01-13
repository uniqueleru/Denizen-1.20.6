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