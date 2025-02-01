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
    display name: <&b>몬스터 소형화
    lore:
    - <&f>
    - <&f> - <&7>몬스터가 소형화됩니다.
    - <&f> - <&7>현재 상태: <server.flag[mob_downscale]>
    - <&f>

mob_downscale_world:
    type: world
    debug: false
    events:
        after entity spawns:
        # 소환되는 몬스터 scale 조정
        - if <server.flag[mob_downscale]> == <server.flag[text_disabled]>:
            - stop
        - if ( <context.entity.is_monster> && <context.entity.has_attribute[generic_scale]> ):
                        - adjust <context.entity> attribute_base_values:[generic_scale=0.1]

mob_downscale_toggle_task:
    type: task
    definitions: toggle
    debug: false
    script:
    - if <[toggle]> == on:
        # 서버의 모든 몬스터 scale 값 0.1로 설정
        - foreach <server.worlds> as:world:
            - foreach <[world].entities> as:entity:
                    - if ( <[entity].is_monster> && <[entity].has_attribute[generic_scale]> ):
                        - adjust <[entity]> attribute_base_values:[generic_scale=0.1]
    - else if <[toggle]> == off:
        # 서버의 모든 몬스터 scale 값 초기화
        - foreach <server.worlds> as:world:
            - foreach <[world].entities> as:entity:
                    - if ( <[entity].is_monster> && <[entity].has_attribute[generic_scale]> ):
                        - define default <[entity].attribute_default_value[generic_scale]>
                        - adjust <[entity]> attribute_base_values:[generic_scale=<[default]>]