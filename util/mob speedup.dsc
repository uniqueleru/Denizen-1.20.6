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
    display name: <&9>몬스터 속도 증가
    lore:
    - <&f>
    - <&f> - <&7>몬스터의 속도가 크게 증가합니다.
    - <&f> - <&7>현재 상태: <server.flag[mob_speedup]>
    - <&f>

mob_speedup:
    type: world
    debug: false
    events:
        after entity spawns:
        # 소환되는 몬스터 speed 조정
        - if <server.flag[mob_speedup]> == <server.flag[text_disabled]>:
            - stop
        - if ( <context.entity.is_monster> && <context.entity.has_attribute[generic_movement_speed]> && <context.entity.has_attribute[generic_follow_range]> ):
            - adjust <context.entity> attribute_base_values:[generic_movement_speed=0.6]
            - adjust <context.entity> attribute_base_values:[generic_follow_range=128]

mob_speedup_toggle_task:
    type: task
    definitions: toggle
    debug: false
    script:
    - if <[toggle]> == on:
        # 서버의 모든 몬스터 speed 값 조정
        - foreach <server.worlds> as:world:
            - foreach <[world].entities> as:entity:
                    - if ( <[entity].is_monster> && <[entity].has_attribute[generic_movement_speed]> && <[entity].has_attribute[generic_follow_range]> ):
                        - adjust <[entity]> attribute_base_values:[generic_movement_speed=0.6]
                        - adjust <[entity]> attribute_base_values:[generic_follow_range=128]
    - else if <[toggle]> == off:
        # 서버의 모든 몬스터 speed 값 초기화
        - foreach <server.worlds> as:world:
            - foreach <[world].entities> as:entity:
                    - if ( <[entity].is_monster> && <[entity].has_attribute[generic_movement_speed]> && <[entity].has_attribute[generic_follow_range]> ):
                        - adjust <[entity]> attribute_base_values:[generic_movement_speed=0.25]
                        - define default <[entity].attribute_default_value[generic_follow_range]>
                        - adjust <[entity]> attribute_base_values:[generic_follow_range=<[default]>]