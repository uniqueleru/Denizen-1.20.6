invisible_mob_init:
    type: world
    debug: false
    events:
        on scripts loaded:
        - if !<server.has_flag[invisible_mob]>:
            - flag server invisible_mob:<&c>비활성화됨

main_gui_item_invisible_mob:
    type: item
    material: potion
    display name: <&b>몹 투명화
    lore:
    - <&f>
    - <&f> - <&7>몹 투명화
    - <&f> - <&7>현재 상태: <&f><server.flag[invisible_mob]>
    - <&f>
