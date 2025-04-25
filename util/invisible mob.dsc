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
    display name: <&f>몹 투명화
    mechanisms:
        potion_effects:
            base_type: invisibility
        hides: ALL
    lore:
    - <&f>
    - <&f> - <&7>모든 몹이 투명 효과를 갖게 됩니다.
    - <&f> - <&7>현재 상태: <&f><server.flag[invisible_mob]>
    - <&f>

invisible_mob_toggle_task:
    type: task
    definitions: toggle
    debug: false
    script:
    - if <[toggle]> == off:
        - foreach <server.worlds> as:world:
            - foreach <[world].entities> as:entity:
                - if ( <[entity].is_living> && !<[entity].is_player> ):
                    - cast invisibility remove <[entity]>

invisible_mob_world:
    type: world
    debug: false
    events:
        on tick every:5:
        - if <server.flag[invisible_mob]> == <server.flag[text_disabled]>:
            - stop
        - foreach <server.worlds> as:world:
            - foreach <[world].entities> as:entity:
                - if ( <[entity].is_living> && !<[entity].is_player> ):
                    - cast invisibility duration:infinite amplifier:0 <[entity]> hide_particles