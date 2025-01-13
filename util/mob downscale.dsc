mob_downscale_init:
    type: world
    debug: false
    events:
        on scripts loaded:
        - if !<server.has_flag[mob_downscale]>:
            - flag server mob_downscale:<&c>비활성화됨

main_gui_item_mob_downscale:
    type: item
    material: slime_ball
    display name: <&b>몹 소형화
    lore:
    - <&f>
    - <&f> - <&7>몬스터가 소형화됩니다.
    - <&f> - <&e>주의: 앞으로 소환되는 몬스터에만 적용되며,
    - <&f>   <&e>이미 소형화된 몬스터는 되돌아오지 않습니다.
    - <&f> - <&7>현재 상태: <server.flag[mob_downscale]>
    - <&f>

mob_downscale_world:
    type: world
    debug: false
    events:
        after entity spawns:
        - if <server.flag[mob_downscale]> == <server.flag[text_disabled]>:
            - stop
        - adjust <context.entity> attribute_base_values:[generic_scale=0.1]