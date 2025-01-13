mob_speedup_init:
    type: world
    debug: false
    events:
        on scripts loaded:
        - if !<server.has_flag[mob_speedup]>:
            - flag server mob_speedup:<&c>비활성화됨

main_gui_item_mob_speedup:
    type: item
    material: feather
    display name: <&6>몬스터 속도 증가
    lore:
    - <&f>
    - <&f> - <&7>몬스터의 속도가 크게 증가합니다.
    - <&f> - <&e>주의: 앞으로 소환되는 몬스터에만 적용되며,
    - <&f>   <&e>이미 속도가 증가된 몬스터는 되돌아오지 않습니다.
    - <&f> - <&7>현재 상태: <server.flag[mob_speedup]>
    - <&f>

mob_speedup:
    type: world
    debug: false
    events:
        after entity spawns:
        - if <server.flag[mob_speedup]> == <server.flag[text_disabled]>:
            - stop
        - adjust <context.entity> attribute_base_values:[generic.movement_speed=0.6]
        - adjust <context.entity> attribute_base_values:[generic.follow_range=128]